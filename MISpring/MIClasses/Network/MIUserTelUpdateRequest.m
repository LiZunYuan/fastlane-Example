//
//  MIUserTelUpdateRequest.m
//  MISpring
//
//  Created by Yujian Xu on 13-4-13.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIUserTelUpdateRequest.h"

@implementation MIUserTelUpdateRequest

- (void) setTel: (NSString *) tel
{
    [self.fields setObject:tel forKey:@"tel"];
}

- (void) setCode:(NSString *)code
{
    [self.fields setObject:code forKey:@"code"];
}

- (NSString *) getMethod {
    return @"mizhe.user.tel.update";
}

@end
