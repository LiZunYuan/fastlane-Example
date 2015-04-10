//
//  MIQuickJoinRequest.m
//  MISpring
//
//  Created by lsave on 13-4-15.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIQuickJoinRequest.h"

@implementation MIQuickJoinRequest

- (void) setToken: (NSString *) token
{
    if (token)
    {
        [self.fields setObject:token forKey:@"token"];
    }
}

- (void) setUserNameAndPassWord: (NSString *) userNameAndPassWord
{
    [self.fields setObject:userNameAndPassWord forKey:@"passport"];
}

- (NSString *) getMethod {
    return @"mizhe.user.quick.join";
}

@end
