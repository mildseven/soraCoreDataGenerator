//
//  Processing.m
//  soraCoreDataGenerator
//
//  Created by Kiyoshi Nagahama on 9/28/14.
//  Copyright (c) 2014 Digital Bytes Inc. All rights reserved.
//

#import "Processing.h"
#import "AppDelegate.h"
#import "Book.h"

@interface Processing()

@property(nonatomic, strong) CHCSVParser *p;
@property(nonatomic, strong) NSMutableArray *lines;
@property(nonatomic, strong) NSMutableArray *currentLine;
@property(nonatomic, strong) NSMutableArray *bookIDStoreArray;
@property int totalBookNumber;

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
    //NSLog(@"%@", field);
    
}
- (void)parser:(CHCSVParser *)parser didEndLine:(NSUInteger)recordNumber
{
    NSNumberFormatter *bookIDNumberFormatter = [[NSNumberFormatter alloc] init];
    NSNumber *bookIDNumber = [bookIDNumberFormatter numberFromString:[_currentLine objectAtIndex:0]];
    
    // Look for Book object with same bookID
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Book"
                                                         inManagedObjectContext:_moc];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.bookID == %@", bookIDNumber];
    
    [request setPredicate:predicate];
    
    NSError *error;
    NSArray *array = [_moc executeFetchRequest:request error:&error];
    
    if (array.count == 0) {
        Book *newBook  = [NSEntityDescription insertNewObjectForEntityForName:@"Book" inManagedObjectContext:_moc];
        
        [newBook setBookID:bookIDNumber];
        [newBook setTitle:[_currentLine objectAtIndex:1]];
        [newBook setYomi:[_currentLine objectAtIndex:2]];
        [newBook setYomiSort:[_currentLine objectAtIndex:3]];
        [newBook setSubTitle:[_currentLine objectAtIndex:4]];
        [newBook setSubTitleYomi:[_currentLine objectAtIndex:5]];
        
        BOOL copyrightBool = NO;
        if ([[_currentLine objectAtIndex:10] isEqualTo:@"なし"]) {
            copyrightBool = YES;
        }
        
        NSNumber *copyrightBoolNum = [NSNumber numberWithBool:copyrightBool];
        [newBook setCopyright:copyrightBoolNum];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        
        NSDate *createdDate = [[NSDate alloc] init];
        createdDate = [dateFormatter dateFromString:[_currentLine objectAtIndex:11]];
        [newBook setCreatedDate:createdDate];
        
        NSDate *modifiedDate = [[NSDate alloc] init];
        modifiedDate = [dateFormatter dateFromString:[_currentLine objectAtIndex:12]];
        [newBook setModifiedDate:modifiedDate];
        
        _totalBookNumber++;
    } else {
        NSLog(@"There is book object with same book ID ... %i", [bookIDNumber intValue]);
    }
    
    
    _currentLine = nil;
}
- (void)parserDidEndDocument:(CHCSVParser *)parser {
    
    NSLog(@"Total Book Number is %i", _totalBookNumber);
    
    NSError *error;
    if (![_moc save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
}
@end
