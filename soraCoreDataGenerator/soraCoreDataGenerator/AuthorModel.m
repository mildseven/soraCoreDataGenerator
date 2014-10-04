//
//  authorModel.m
//  soraCoreDataGenerator
//
//  Created by Kiyoshi Nagahama on 10/2/14.
//  Copyright (c) 2014 Digital Bytes Inc. All rights reserved.
//

#import "AuthorModel.h"

@implementation AuthorModel

- (instancetype)initWithAuthorDic:(NSDictionary*)authorDic
{
    self = [super init];
    if (self) {
        _name = [[NSString alloc] initWithFormat:@"%@ %@", [authorDic objectForKey:@"Last Name"], [authorDic objectForKey:@"First Name"]];
        _role = [[NSString alloc] initWithString:[authorDic objectForKey:@"Role"]];
    }
    return self;
}

@end
