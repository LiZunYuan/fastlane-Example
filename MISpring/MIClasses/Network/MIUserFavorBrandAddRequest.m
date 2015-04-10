//
//  MIUserFavorBrandAddRequest.m
//  MISpring
//
//  Created by yujian on 14-12-15.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MIUserFavorBrandAddRequest.h"

@implementation MIUserFavorBrandAddRequest

- (NSString *) getMethod
{
    return @"mizhe.user.favor.brand.add";
}
- (NSString *) getHttpType {
    return @"GET";
}

- (void)setAid:(NSString *)aid
{
    [self.fields setObject:aid forKey:@"aid"];
}

@end
