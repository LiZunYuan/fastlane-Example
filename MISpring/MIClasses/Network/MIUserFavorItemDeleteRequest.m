//
//  MIUserFavorItemDeleteRequest.m
//  MISpring
//
//  Created by yujian on 14-12-15.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MIUserFavorItemDeleteRequest.h"

@implementation MIUserFavorItemDeleteRequest

- (NSString *) getMethod
{
    return @"mizhe.user.favor.item.delete";
}
- (NSString *) getHttpType {
    return @"GET";
}

- (void)setIids:(NSString *)Iids
{
    [self.fields setObject:Iids forKey:@"iids"];
}

@end
