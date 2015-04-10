//
//  MISMSSendRequest.m
//  MISpring
//
//  Created by Yujian Xu on 13-4-13.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MISMSSendRequest.h"

@implementation MISMSSendRequest

- (void) setText: (NSString *) text
{
    [self.fields setObject:text forKey:@"text"];
}

- (void) setTel: (NSString *) tel
{
    [self.fields setObject:tel forKey:@"tel"];
}

- (void) setType: (NSString *) type
{
    [self.fields setObject:type forKey:@"key"];
}

- (NSString *) getMethod {
    return @"mizhe.user.code.send";
}

@end
