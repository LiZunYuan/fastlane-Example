//
//  MIUserFavorItemAddRequest.m
//  MISpring
//
//  Created by yujian on 14-12-15.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MIUserFavorItemAddRequest.h"

@implementation MIUserFavorItemAddRequest

- (NSString *) getMethod
{
    return @"mizhe.user.favor.item.add";
}

- (NSString *) getHttpType {
    return @"GET";
}

- (void)setIid:(NSNumber *)iid
{
    [self.fields setObject:iid forKey:@"iid"];
}


@end
