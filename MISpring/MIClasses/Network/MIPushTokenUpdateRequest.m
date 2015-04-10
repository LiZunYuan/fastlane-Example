//
//  MIPushTokenUpdateRequest.m
//  MISpring
//
//  Created by lsave on 13-4-15.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIPushTokenUpdateRequest.h"

@implementation MIPushTokenUpdateRequest

- (void)setPushSrc:(NSString *)pushSrc
{
    [self.fields setObject:pushSrc forKey:@"push_src"];
}
- (void)setToken:(NSString *)token
{
    [self.fields setObject:token forKey:@"token"];
}
- (void)setEnable:(BOOL)enable
{
    [self.fields setObject:@(enable) forKey:@"enable"];
}

- (NSString *) getMethod {
    return @"mizhe.push.token.update";
}

@end
