//
//  MIUserForgetRequest.m
//  MISpring
//
//  Created by yujian on 14-5-27.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MIUserForgetRequest.h"

@implementation MIUserForgetRequest

- (void) setEmail: (NSString *)email
{
    [self.fields setObject:email forKey:@"email"];
}

- (NSString *) getMethod {
    return @"mizhe.user.forget";
}
- (NSString *) getHttpType {
    return @"GET";
}

@end
