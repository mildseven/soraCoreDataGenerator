//
//  MainWindowController.m
//  soraCoreDataGenerator
//
//  Created by Kiyoshi Nagahama on 10/4/14.
//  Copyright (c) 2014 Digital Bytes Inc. All rights reserved.
//

#import "MainWindowController.h"
#import "BookListViewController.h"
#import "AuthorListViewController.h"

@interface MainWindowController ()

@property (weak) IBOutlet NSTabView *tabView;
@property BOOL bookArrayControllerBool;
@property BOOL authorArrayControllerBool;


@end

@implementation MainWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    
    _bookArrayControllerBool = TRUE;
    _authorArrayControllerBool = TRUE;
    
    [[_tabView tabViewItemAtIndex:0] setView:_bookListViewController.view];
    [[_tabView tabViewItemAtIndex:1] setView:_authorListViewController.view];
    
    [_bookListViewController.bookArrayController addObserver:self forKeyPath:@"arrangedObjects" options:0 context:nil];
    [_authorListViewController.authorArrayController addObserver:self forKeyPath:@"arrangedObjects" options:0 context:nil];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([object isEqual:_bookListViewController.bookArrayController]) {
        if ([keyPath isEqualToString:@"arrangedObjects"]) {
            if (_bookArrayControllerBool && ([[_bookListViewController.bookArrayController arrangedObjects] count] > 0)) {
                _bookArrayControllerBool = FALSE;
                NSLog(@"%li", [_bookListViewController.bookArrayController.content count]);
                NSString *bookTabViewItemLabelStr = [NSString stringWithFormat:@"作品リスト（%li）", [_bookListViewController.bookArrayController.content count]];
                [[_tabView.tabViewItems objectAtIndex:0] setLabel:bookTabViewItemLabelStr];
            }
        }
        
    } else if ([object isEqual:_authorListViewController.authorArrayController]) {
        if ([keyPath isEqualToString:@"arrangedObjects"]) {
            if (_authorArrayControllerBool && ([[_authorListViewController.authorArrayController arrangedObjects] count] > 0)) {
                _authorArrayControllerBool = FALSE;
                NSLog(@"%li", [_authorListViewController.authorArrayController.content count]);
                NSString *authorTabViewItemLabelStr = [NSString stringWithFormat:@"作家リスト（%li）", [_authorListViewController.authorArrayController.content count]];
                [[_tabView.tabViewItems objectAtIndex:1] setLabel:authorTabViewItemLabelStr];
            }
        
        }
    }
}

@end
