//
//  AuthorListViewController.m
//  soraCoreDataGenerator
//
//  Created by Kiyoshi Nagahama on 10/3/14.
//  Copyright (c) 2014 Digital Bytes Inc. All rights reserved.
//

#import "BookListViewController.h"
#import "Book.h"
#import "BookToAuthors.h"
#import "Author.h"
#import "AuthorModel.h"

@interface BookListViewController ()

@property (weak) IBOutlet NSTableView *authorTableView;
@property (weak) IBOutlet NSTextField *bookIDLabel;
@property (weak) IBOutlet NSTextField *titleLabel;
@property (weak) IBOutlet NSTextField *titleYomiLabel;
@property (weak) IBOutlet NSTextField *characterKindLabel;
@property (strong) NSString *totalBookNumberStr;


@end

@implementation BookListViewController

- (void)tableViewSelectionDidChange:(NSNotification *)aNotification
{
    Book *book = [[_bookArrayController arrangedObjects] objectAtIndex:[_bookTableView selectedRow]];
    [self updateWithBook:book];
}
    
- (void)updateWithBook:(Book *)book
{
    NSRange range = NSMakeRange(0, [[_authorArrayController arrangedObjects] count]);
    [_authorArrayController removeObjectsAtArrangedObjectIndexes:[NSIndexSet indexSetWithIndexesInRange:range]];
    
    NSMutableArray *authorModels = [[NSMutableArray alloc] init];
    for (BookToAuthors  *bookToAuthors in book.bookToAuthors) {
        NSDictionary *authorDic = [NSDictionary dictionaryWithObjectsAndKeys:bookToAuthors.author.lastName, @"Last Name", bookToAuthors.author.firstName, @"First Name", bookToAuthors.role, @"Role", nil];
        AuthorModel *authorModel = [[AuthorModel alloc] initWithAuthorDic:authorDic];
        [authorModels addObject:authorModel];
    }
    
    [_authorArrayController addObjects:authorModels];
    
    [_authorTableView deselectAll:nil];
    
    _bookIDLabel.stringValue = [book.bookID stringValue];
    
    if ([book.subTitle isEqualToString:@""]) {
        _titleLabel.stringValue = book.title;
    } else {
        _titleLabel.stringValue = [NSString stringWithFormat:@"%@   %@", book.title, book.subTitle];
    }
    
    _titleYomiLabel.stringValue = book.yomi;
    
    _characterKindLabel.stringValue = book.characterKind;
}

@end
