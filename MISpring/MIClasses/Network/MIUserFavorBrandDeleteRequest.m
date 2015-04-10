//
//  MIUserFavorBrandDeleteRequest.m
//  MISpring
//
//  Created by yujian on 14-12-15.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MIUserFavorBrandDeleteRequest.h"

@implementation MIUserFavorBrandDeleteRequest

- (NSString *) getMethod
{
    return @"mizhe.user.favor.brand.delete";
}
- (NSString *) getHttpType {
    return @"GET";
}

- (void)setAids:(NSString *)aids
{
    [self.fields setObject:aids forKey:@"aids"];
}

@end
