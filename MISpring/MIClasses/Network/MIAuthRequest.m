//
//  MIAuthRequest.m
//  MISpring
//
//  Created by Yujian Xu on 13-4-3.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIAuthRequest.h"

@implementation MIAuthRequest

- (void) setToken: (NSString *) token
{
    [self.fields setObject:token forKey:@"token"];
}

- (NSString *) getMethod {
    return @"mizhe.user.open.auth";
}

@end
