//
//  AuthorListViewController.m
//  soraCoreDataGenerator
//
//  Created by Kiyoshi Nagahama on 10/3/14.
//  Copyright (c) 2014 Digital Bytes Inc. All rights reserved.
//

#import "AuthorListViewController.h"
#import "Author.h"
#import "Book.h"
#import "BookModel.h"

@interface AuthorListViewController ()

@property (weak) IBOutlet NSTableView *authorTableView;
@property (weak) IBOutlet NSTableView *bookTableView;

@end

@implementation AuthorListViewController

- (void)tableViewSelectionDidChange:(NSNotification *)aNotification
{
    Author *author = [[_authorArrayController arrangedObjects] objectAtIndex:[_authorTableView selectedRow]];
    [self updateWithAuthor:author];
}

- (void)updateWithAuthor:(Author *)author
{
    NSRange range = NSMakeRange(0, [[_bookArrayController arrangedObjects] count]);
    [_bookArrayController removeObjectsAtArrangedObjectIndexes:[NSIndexSet indexSetWithIndexesInRange:range]];
    
    
    NSMutableArray *bookModels = [[NSMutableArray alloc] init];
    for (Book *book in author.books) {
        BookModel *bookModel = [[BookModel alloc] initWithBook:book];
        [bookModels addObject:bookModel];
    }
    
    [_bookArrayController addObjects:bookModels];
    
    [_bookTableView deselectAll:nil];
}


@end
