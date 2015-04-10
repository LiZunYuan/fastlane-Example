//
//  BBUserPasswdUpdateRequest.m
//  BeiBeiAPP
//
//  Created by yujian on 14-10-23.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MIUserPasswdUpdateRequest.h"

@implementation MIUserPasswdUpdateRequest

- (NSString *) getMethod {
    return @"mizhe.user.passwd.update";
}
- (NSString *) getHttpType {
    return @"GET";
}

- (void)setKey:(NSString *)key
{
    [self.fields setObject:key forKey:@"passport"];
}

@end
