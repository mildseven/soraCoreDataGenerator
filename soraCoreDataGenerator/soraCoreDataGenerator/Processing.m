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

@implementation Processing

- (id)initWithFilepath:(NSString *)filepath managedObjectContext:(NSManagedObjectContext *)moc
{
    self = [super init];
    if (self) {
        _moc = moc;
        NSStringEncoding encoding = 0;
        NSInputStream *stream = [NSInputStream inputStreamWithFileAtPath:filepath];
        _p = [[CHCSVParser alloc] initWithInputStream:stream usedEncoding:&encoding delimiter:','];
        _p.sanitizesFields = YES;
        _p.delegate = self;
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
    NSEntityDescription *bookEntity = [NSEntityDescription insertNewObjectForEntityForName:@"Book" inManagedObjectContext:_moc];
    
    Book *newBook = [[Book alloc] initWithEntity:bookEntity insertIntoManagedObjectContext:_moc];
    
    NSNumberFormatter *bookIDNumberFormatter = [[NSNumberFormatter alloc] init];
    NSNumber *bookIDNumber = [bookIDNumberFormatter numberFromString:[_currentLine objectAtIndex:0]];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //NSDate *dateFromString = [[NSDate alloc] init];
    //dateFromString = [dateFormatter dateFromString:[_currentLine objectAtIndex:11]];
    
    [newBook setBookID:bookIDNumber];
    [newBook setTitle:[_currentLine objectAtIndex:1]];
    //[newBook setYomi:[_currentLine objectAtIndex:2]];
    //[newBook setYomiSort:[_currentLine objectAtIndex:3]];
    [newBook setSubTitle:[_currentLine objectAtIndex:4]];
    //[newBook setSubTitleYomi:[_currentLine objectAtIndex:5]];
    //[newBook setCopyright:[_currentLine objectAtIndex:6]];
    [newBook setCreatedDate:[NSDate date]];//[dateFormatter dateFromString:[_currentLine objectAtIndex:11]]];
    
    NSLog(@"Book ID ... %@, Title ... %@, 公開日 ... %@", bookIDNumber, [_currentLine objectAtIndex:1], [_currentLine objectAtIndex:11]);
    //[_lines addObject:_currentLine];
    _currentLine = nil;
}
- (void)parserDidEndDocument:(CHCSVParser *)parser {
    //	NSLog(@"parser ended: %@", csvFile);
}
@end
