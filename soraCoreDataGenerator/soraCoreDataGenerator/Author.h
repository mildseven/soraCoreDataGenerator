//
//  Author.h
//  soraCoreDataGenerator
//
//  Created by Kiyoshi Nagahama on 9/29/14.
//  Copyright (c) 2014 Digital Bytes Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Book;

@interface Author : NSManagedObject

@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastNameYomi;
@property (nonatomic, retain) NSString * firstNameYomi;
@property (nonatomic, retain) NSString * lastNameYomiSort;
@property (nonatomic, retain) NSString * firstNameYomiSort;
@property (nonatomic, retain) NSNumber * authorID;
@property (nonatomic, retain) NSSet *books;
@end

@interface Author (CoreDataGeneratedAccessors)

- (void)addBooksObject:(Book *)value;
- (void)removeBooksObject:(Book *)value;
- (void)addBooks:(NSSet *)values;
- (void)removeBooks:(NSSet *)values;

@end
