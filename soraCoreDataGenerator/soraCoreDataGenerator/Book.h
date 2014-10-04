//
//  Book.h
//  soraCoreDataGenerator
//
//  Created by Kiyoshi Nagahama on 9/29/14.
//  Copyright (c) 2014 Digital Bytes Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BookToAuthors;

@interface Book : NSManagedObject

@property (nonatomic, retain) NSNumber * bookID;
@property (nonatomic, retain) NSNumber * copyright;
@property (nonatomic, retain) NSDate * createdDate;
@property (nonatomic, retain) NSDate * modifiedDate;
@property (nonatomic, retain) NSString * subTitle;
@property (nonatomic, retain) NSString * subTitleYomi;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * yomi;
@property (nonatomic, retain) NSString * yomiSort;
@property (nonatomic, retain) NSString * characterKind;
@property (nonatomic, retain) NSSet *bookToAuthors;
@end

@interface Book (CoreDataGeneratedAccessors)

- (void)addBookToAuthorsObject:(BookToAuthors *)value;
- (void)removeBookToAuthorsObject:(BookToAuthors *)value;
- (void)addBookToAuthors:(NSSet *)values;
- (void)removeBookToAuthors:(NSSet *)values;

@end
