//
//  BookToAuthors.h
//  soraCoreDataGenerator
//
//  Created by Kiyoshi Nagahama on 9/29/14.
//  Copyright (c) 2014 Digital Bytes Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Author;

@interface BookToAuthors : NSManagedObject

@property (nonatomic, retain) NSString *role;
@property (nonatomic, retain) Author *author;

@end
