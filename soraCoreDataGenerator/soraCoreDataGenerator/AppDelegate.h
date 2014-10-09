//
//  AppDelegate.h
//  soraCoreDataGenerator
//
//  Created by Kiyoshi Nagahama on 9/28/14.
//  Copyright (c) 2014 Digital Bytes Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "UpdateDatabase.h"

@interface AppDelegate : NSObject <NSApplicationDelegate, UpdateDatabaseProtocol>

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end

