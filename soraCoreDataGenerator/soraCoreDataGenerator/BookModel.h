//
//  BookModel.h
//  soraCoreDataGenerator
//
//  Created by Kiyoshi Nagahama on 10/3/14.
//  Copyright (c) 2014 Digital Bytes Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Book;

@interface BookModel : NSObject

@property(nonatomic, strong) NSString *role;

- (instancetype)initWithBook:(Book*)book;

@end
