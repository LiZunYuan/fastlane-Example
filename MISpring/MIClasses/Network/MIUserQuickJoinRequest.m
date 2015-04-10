//
//  BBUserQuickJoinRequest.m
//  BeiBeiAPP
//
//  Created by yujian on 14-6-13.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MIUserQuickJoinRequest.h"

@implementation MIUserQuickJoinRequest

- (void) setToken: (NSString *) token
{
    if (token)
    {
        [self.fields setObject:token forKey:@"token"];
    }
}

- (void)setEmailAndPwd:(NSString *)emailPwd
{
    [self.fields setObject:emailPwd forKey:@"passport"];
}

- (void)setBindType:(NSString *)bindType
{
    [self.fields setObject:bindType forKey:@"bind_type"];
}

- (NSString *) getMethod {
    return @"mizhe.user.quick.join";
}
- (NSString *) getHttpType {
    return @"GET";
}

@end
