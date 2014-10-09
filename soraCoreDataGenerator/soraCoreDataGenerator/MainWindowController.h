//
//  MainWindowController.h
//  soraCoreDataGenerator
//
//  Created by Kiyoshi Nagahama on 10/4/14.
//  Copyright (c) 2014 Digital Bytes Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class BookListViewController;
@class AuthorListViewController;

@interface MainWindowController : NSWindowController

@property (weak) IBOutlet BookListViewController *bookListViewController;
@property (weak) IBOutlet AuthorListViewController *authorListViewController;

@end
