//
//  AuthorListViewController.h
//  soraCoreDataGenerator
//
//  Created by Kiyoshi Nagahama on 10/3/14.
//  Copyright (c) 2014 Digital Bytes Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface BookListViewController : NSViewController<NSTableViewDelegate, NSTableViewDataSource>

@property (weak) IBOutlet NSArrayController *bookArrayController;
@property (weak) IBOutlet NSArrayController *authorArrayController;
@property (weak) IBOutlet NSTableView *bookTableView;

@end
