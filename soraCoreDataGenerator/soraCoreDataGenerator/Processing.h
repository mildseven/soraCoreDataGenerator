//
//  Processing.h
//  soraCoreDataGenerator
//
//  Created by Kiyoshi Nagahama on 9/28/14.
//  Copyright (c) 2014 Digital Bytes Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CHCSVParser.h"

@interface Processing : NSObject <CHCSVParserDelegate>

@property(nonatomic, strong) CHCSVParser *p;
@property(nonatomic, strong) NSMutableArray *lines;
@property(nonatomic, strong) NSMutableArray *currentLine;

@property(nonatomic, strong) NSManagedObjectContext *moc;

- (id)initWithFilepath:(NSString *)filepath managedObjectContext:(NSManagedObjectContext *)moc;

- (void)startProcess;

@end
