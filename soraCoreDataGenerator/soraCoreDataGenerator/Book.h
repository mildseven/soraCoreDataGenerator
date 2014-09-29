//
//  Book.h
//  soraCoreDataGenerator
//
//  Created by Kiyoshi Nagahama on 9/28/14.
//  Copyright (c) 2014 Digital Bytes Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Book : NSManagedObject

@property (nonatomic, retain) NSNumber * bookID;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * yomi;
@property (nonatomic, retain) NSString * yomiSort;
@property (nonatomic, retain) NSString * subTitle;
@property (nonatomic, retain) NSString * subTitleYomi;
@property (nonatomic, retain) NSNumber * authorID;
@property (nonatomic, retain) NSNumber * copyright;
@property (nonatomic, retain) NSDate * createdDate;
@property (nonatomic, retain) NSDate * modifiedDate;

@end
