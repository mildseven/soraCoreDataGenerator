//
//  UpdateDatabase.m
//  soraCoreDataGenerator
//
//  Created by Kiyoshi Nagahama on 10/6/14.
//  Copyright (c) 2014 Digital Bytes Inc. All rights reserved.
//

#import "UpdateDatabase.h"
#import "Book.h"
#import "BookToAuthors.h"
#import "Author.h"

@interface UpdateDatabase()
{
    NSMutableData *_downloadedData;
    NSURL *_jsonFileUrl;
    NSManagedObjectContext *_moc;
}

@end

@implementation UpdateDatabase

- (instancetype)initWithDate:(NSDate*)date
{
    self = [super init];
    if (self) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *dateStr = [dateFormatter stringFromDate:date];
        NSString *jasonFilePathStr = [NSString stringWithFormat:@"http://www.digitalbytes.tv/kiyoshi/test/json.php?date=%@", dateStr];
        _jsonFileUrl = [NSURL URLWithString:jasonFilePathStr];
        
        _moc = [[NSApp delegate] managedObjectContext];
    }
    return self;
}

- (void)downloadItems
{
    // Create the request
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:_jsonFileUrl];
    
    // Create the NSURLConnection
    [NSURLConnection connectionWithRequest:urlRequest delegate:self];
}

#pragma mark NSURLConnectionDataProtocol Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // Initialize the data object
    _downloadedData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append the newly downloaded data
    [_downloadedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // Parse the JSON that came in
    NSError *error;
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:_downloadedData options:NSJSONReadingAllowFragments error:&error];
    
    NSMutableArray *bookTempArray = [[NSMutableArray alloc] init];
    NSMutableArray *authorTempArray = [[NSMutableArray alloc] init];
    
    // Loop through Json objects, create question objects and add them to our questions array
    for (int i = 0; i < jsonArray.count; i++) {
        NSDictionary *jsonElement = jsonArray[i];
        
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        NSNumber *bookIDNumber = [numberFormatter numberFromString:jsonElement[@"Book_ID"]];
        NSNumber *authorIDNumber = [numberFormatter numberFromString:jsonElement[@"Author_ID"]];
        
        // Look for Book object with same bookID
        NSEntityDescription *bookEntityDescription = [NSEntityDescription entityForName:@"Book"
                                                                 inManagedObjectContext:_moc];
        
        NSFetchRequest *bookRequest = [[NSFetchRequest alloc] init];
        [bookRequest setEntity:bookEntityDescription];
        
        NSPredicate *bookPredicate = [NSPredicate predicateWithFormat:@"self.bookID == %@", bookIDNumber];
        
        [bookRequest setPredicate:bookPredicate];
        
        NSError *error;
        NSArray *bookArray = [_moc executeFetchRequest:bookRequest error:&error];
        
        Book *book = nil;
        
        if (bookArray.count == 0) {
            book  = [NSEntityDescription insertNewObjectForEntityForName:@"Book" inManagedObjectContext:_moc];
            
            book.bookID = bookIDNumber;
            book.title = jsonElement[@"Title"];
            book.yomi = jsonElement[@"Yomi"];
            book.yomiSort = jsonElement[@"Yomi_Sort"];
            book.subTitle = jsonElement[@"Sub_Title"];
            book.subTitleYomi = jsonElement[@"Sub_Title_Yomi"];
            book.characterKind = jsonElement[@"Character_Kind"];
            
            BOOL copyrightBool = NO;
            if ([jsonElement[@"Copyright"] isEqualTo:@"なし"]) {
                copyrightBool = YES;
            }
            
            NSNumber *copyrightBoolNum = [NSNumber numberWithBool:copyrightBool];
            [book setCopyright:copyrightBoolNum];
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            book.createdDate = [dateFormatter dateFromString:jsonElement[@"Created_Date"]];
            book.modifiedDate = [dateFormatter dateFromString:jsonElement[@"Modified_Date"]];
            [bookTempArray addObject:book];
        } else {
            NSLog(@"There is book object with same book ID ... %i", [bookIDNumber intValue]);
            book = [bookArray objectAtIndex:0];
        }
        
        BookToAuthors *bookToAuthors = [NSEntityDescription insertNewObjectForEntityForName:@"BookToAuthors" inManagedObjectContext:_moc];
        bookToAuthors.role = jsonElement[@"Role"];
        
        [book addBookToAuthorsObject:bookToAuthors];
        
        // Look for Author object with same authorID
        NSEntityDescription *authorEntityDescription = [NSEntityDescription entityForName:@"Author"
                                                                   inManagedObjectContext:_moc];
        
        NSFetchRequest *authorRequest = [[NSFetchRequest alloc] init];
        [authorRequest setEntity:authorEntityDescription];
        
        NSPredicate *authorPredicate = [NSPredicate predicateWithFormat:@"self.authorID == %@", authorIDNumber];
        
        [authorRequest setPredicate:authorPredicate];
        
        //NSError *error;
        NSArray *authorArray = [_moc executeFetchRequest:authorRequest error:&error];
        
        Author *author = nil;
        
        if(authorArray.count == 0) {
            author  = [NSEntityDescription insertNewObjectForEntityForName:@"Author" inManagedObjectContext:_moc];
            
            author.authorID = authorIDNumber;
            author.lastName = jsonElement[@"Last_Name"];
            author.firstName = jsonElement[@"First_Name"];
            author.lastNameYomi = jsonElement[@"Last_Name_Yomi"];
            author.firstNameYomi = jsonElement[@"First_Name_Yomi"];
            author.firstNameYomiSort = jsonElement[@"Last_Name_Yomi_Sort"];
            author.lastNameYomiSort = jsonElement[@"First_Name_Yomi_Sort"];
            
            [authorTempArray addObject:author];
            
        } else {
            author = [authorArray objectAtIndex:0];
        }
        
        [author addBooksObject:book];
        bookToAuthors.author = author;

        
    }
    NSError *mocError;
    if (![_moc save:&mocError]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    // Ready to notify delegate that data is ready and pass back items
    if (self.delegate) {
        [self.delegate updateDoneWithBookArray:bookTempArray authorArray:authorTempArray];
    }
}


@end
