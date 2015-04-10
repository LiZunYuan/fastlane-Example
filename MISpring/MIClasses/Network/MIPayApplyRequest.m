//
//  MIPayApplyRequest.m
//  MISpring
//
//  Created by Yujian Xu on 13-4-12.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIPayApplyRequest.h"

@implementation MIPayApplyRequest

- (void) setAmount:(NSString *)amount
{
    [self.fields setObject:amount forKey:@"money"];
}

- (void) setPassword: (NSString *) password
{
    [self.fields setObject:password forKey:@"passwd"];
}

- (void) setCode: (NSString *) code
{
    [self.fields setObject:code forKey:@"code"];
}

- (NSString *) getMethod {
    return @"mizhe.pay.apply";
}

@end
