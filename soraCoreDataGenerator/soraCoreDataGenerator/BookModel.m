//
//  BookModel.m
//  soraCoreDataGenerator
//
//  Created by Kiyoshi Nagahama on 10/3/14.
//  Copyright (c) 2014 Digital Bytes Inc. All rights reserved.
//

#import "BookModel.h"
#import "Book.h"

@interface BookModel()

@property(nonatomic, strong) NSNumber *bookID;
@property(nonatomic, strong) NSString *title;

@end

@implementation BookModel

- (instancetype)initWithBook:(Book*)book
{
    self = [super init];
    if (self) {
        _bookID = book.bookID;
        _title = [NSString stringWithFormat:@"%@   %@",book.title ,book.subTitle];
    }
    return self;
}

@end
