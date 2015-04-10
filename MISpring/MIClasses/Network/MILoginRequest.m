//
//  MILoginRequest.m
//  MISpring
//
//  Created by Yujian Xu on 13-3-18.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MILoginRequest.h"

@implementation MILoginRequest

- (void) setUserNameAndPassWord: (NSString *) userNameAndPassWord
{
    [self.fields setObject:userNameAndPassWord forKey:@"passport"];
}

- (NSString *) getMethod {
    return @"mizhe.user.auth";
}

@end
