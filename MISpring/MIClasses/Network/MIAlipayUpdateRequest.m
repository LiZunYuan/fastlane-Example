//
//  MIAlipayUpdateRequest.m
//  MISpring
//
//  Created by Yujian Xu on 13-4-12.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIAlipayUpdateRequest.h"

@implementation MIAlipayUpdateRequest

- (void) setName: (NSString *) name
{
    [self.fields setObject:name forKey:@"real_name"];
}

- (void) setAlipay: (NSString *) alipay
{
    [self.fields setObject:alipay forKey:@"alipay"];
}

- (void) setPassword: (NSString *) password
{
    [self.fields setObject:password forKey:@"passwd"];
}

- (void) setCode:(NSString *)code
{
    [self.fields setObject:code forKey:@"code"];
}

- (NSString *) getMethod {
    return @"mizhe.user.alipay.update";
}

@end
