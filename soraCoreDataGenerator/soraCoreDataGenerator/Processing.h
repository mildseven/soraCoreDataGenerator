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

@property(nonatomic, strong) NSManagedObjectContext *moc;

- (id)initWithFilepath:(NSString *)filepath persistentStoreCoordinator:(NSPersistentStoreCoordinator *)persistentStoreCoordinator;

- (void)startProcess;

@end
