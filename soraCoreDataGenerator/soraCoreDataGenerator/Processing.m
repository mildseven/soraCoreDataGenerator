//
//  Processing.m
//  soraCoreDataGenerator
//
//  Created by Kiyoshi Nagahama on 9/28/14.
//  Copyright (c) 2014 Digital Bytes Inc. All rights reserved.
//

#import "Processing.h"
#import "Book.h"
#import "BookToAuthors.h"
#import "Author.h"

@interface Processing()

@property(nonatomic, strong) CHCSVParser *p;
@property(nonatomic, strong) NSMutableArray *lines;
@property(nonatomic, strong) NSMutableArray *currentLine;
@property(nonatomic, strong) NSMutableArray *bookIDStoreArray;
@property int totalBookNumber;
@property int totalAuthorNumber;

@end

@implementation Processing

- (id)initWithFilepath:(NSString *)filepath persistentStoreCoordinator:(NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    self = [super init];
    if (self) {
        _moc = [[NSManagedObjectContext alloc] init];
        [_moc setPersistentStoreCoordinator:persistentStoreCoordinator];
        NSStringEncoding encoding = 0;
        NSInputStream *stream = [NSInputStream inputStreamWithFileAtPath:filepath];
        _p = [[CHCSVParser alloc] initWithInputStream:stream usedEncoding:&encoding delimiter:','];
        _p.sanitizesFields = YES;
        _p.delegate = self;
        _totalBookNumber = 0;
        _totalAuthorNumber = 0;
    }
    return self;
}

- (void)startProcess
{
    [_p parse];
}

- (void)parserDidBeginDocument:(CHCSVParser *)parser
{
    NSLog(@"Start Parse");
    _lines = [[NSMutableArray alloc] init];
}
- (void)parser:(CHCSVParser *)parser didBeginLine:(NSUInteger)recordNumber
{
    _currentLine = [[NSMutableArray alloc] init];
}
- (void)parser:(CHCSVParser *)parser didReadField:(NSString *)field atIndex:(NSInteger)fieldIndex
{
    [_currentLine addObject:field];
    
}
- (void)parser:(CHCSVParser *)parser didEndLine:(NSUInteger)recordNumber
{
    if (![[_currentLine objectAtIndex:0] isEqualToString:@"作品ID"]) {
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        NSNumber *bookIDNumber = [numberFormatter numberFromString:[_currentLine objectAtIndex:0]];
        NSNumber *authorIDNumber = [numberFormatter numberFromString:[_currentLine objectAtIndex:14]];
        
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
            book.title = [_currentLine objectAtIndex:1];
            book.yomi = [_currentLine objectAtIndex:2];
            book.yomiSort = [_currentLine objectAtIndex:3];
            book.subTitle = [_currentLine objectAtIndex:4];
            book.subTitleYomi = [_currentLine objectAtIndex:5];
            book.characterKind = [_currentLine objectAtIndex:9];
            
            BOOL copyrightBool = NO;
            if ([[_currentLine objectAtIndex:10] isEqualTo:@"なし"]) {
                copyrightBool = YES;
            }
            
            NSNumber *copyrightBoolNum = [NSNumber numberWithBool:copyrightBool];
            [book setCopyright:copyrightBoolNum];
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            book.createdDate = [dateFormatter dateFromString:[_currentLine objectAtIndex:11]];
            book.modifiedDate = [dateFormatter dateFromString:[_currentLine objectAtIndex:12]];
            
            _totalBookNumber++;
            
        } else {
            NSLog(@"There is book object with same book ID ... %i", [bookIDNumber intValue]);
            book = [bookArray objectAtIndex:0];
        }
        
        BookToAuthors *bookToAuthors = [NSEntityDescription insertNewObjectForEntityForName:@"BookToAuthors" inManagedObjectContext:_moc];
        bookToAuthors.role = [_currentLine objectAtIndex:23];
        
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
            author.lastName = [_currentLine objectAtIndex:15];
            author.firstName = [_currentLine objectAtIndex:16];
            author.lastNameYomi = [_currentLine objectAtIndex:17];
            author.firstNameYomi = [_currentLine objectAtIndex:18];
            author.firstNameYomiSort = [_currentLine objectAtIndex:19];
            author.lastNameYomiSort = [_currentLine objectAtIndex:20];
            
            _totalAuthorNumber++;
            
        } else {
            author = [authorArray objectAtIndex:0];
        }
        
        [author addBooksObject:book];
        bookToAuthors.author = author;
        
        _currentLine = nil;
    }
}
- (void)parserDidEndDocument:(CHCSVParser *)parser {
    
    NSLog(@"Total Book Number is %i, Total Author Number is %i", _totalBookNumber, _totalAuthorNumber);
    
    NSError *error;
    if (![_moc save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
}
@end
