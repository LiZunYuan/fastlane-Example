//
//  MIUserOpenAppAuthRequest.m
//  MISpring
//
//  Created by yujian on 14-7-16.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MIUserOpenAppAuthRequest.h"

@implementation MIUserOpenAppAuthRequest

- (void)setSource:(NSString *)source
{
    [self.fields setObject:source forKey:@"source"];
}

- (void)setCode:(NSString *)code
{
    [self.fields setObject:code forKey:@"code"];
}

- (NSString *) getMethod
{
    return @"mizhe.user.open.app.auth";
}

- (NSString *) getHttpType {
    return @"GET";
}

@end
