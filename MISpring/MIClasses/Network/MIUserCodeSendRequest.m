//
//  BBUserCodeSendRequest.m
//  BeiBeiAPP
//
//  Created by yujian on 14-9-10.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MIUserCodeSendRequest.h"

@implementation MIUserCodeSendRequest

- (void) setKey:(NSString *)key
{
    [self.fields setObject:key forKey:@"key"];
}

- (void)setTel:(NSString *)tel
{
    [self.fields setObject:tel forKey:@"tel"];
}

- (NSString *) getMethod {
    return @"mizhe.user.code.send";
}
- (NSString *) getHttpType {
    return @"GET";
}

@end
