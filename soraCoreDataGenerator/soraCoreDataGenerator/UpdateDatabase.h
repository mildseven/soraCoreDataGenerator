//
//  UpdateDatabase.h
//  soraCoreDataGenerator
//
//  Created by Kiyoshi Nagahama on 10/6/14.
//  Copyright (c) 2014 Digital Bytes Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

@protocol UpdateDatabaseProtocol <NSObject>

- (void)updateDoneWithBookArray:(NSMutableArray*)bookArray authorArray:(NSMutableArray*)authorArray;

@end

@interface UpdateDatabase : NSObject<NSURLConnectionDataDelegate>

@property (nonatomic, weak) id<UpdateDatabaseProtocol> delegate;

- (instancetype)initWithDate:(NSDate*)date;
- (void)downloadItems;

@end
