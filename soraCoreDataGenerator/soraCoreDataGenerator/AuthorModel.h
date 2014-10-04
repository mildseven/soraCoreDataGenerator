//
//  authorModel.h
//  soraCoreDataGenerator
//
//  Created by Kiyoshi Nagahama on 10/2/14.
//  Copyright (c) 2014 Digital Bytes Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AuthorModel : NSObject

@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *role;

- (instancetype)initWithAuthorDic:(NSDictionary*)authorDic;

@end
