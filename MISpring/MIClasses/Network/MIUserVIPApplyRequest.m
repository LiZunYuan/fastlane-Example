//
//  MIUserVIPApplyRequest.m
//  MISpring
//
//  Created by 曲俊囡 on 13-11-21.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIUserVIPApplyRequest.h"

@implementation MIUserVIPApplyRequest

- (void)setVipLevel:(NSInteger)vipLevel
{
    [self.fields setObject:@(vipLevel) forKey:@"vip_level"];
}
- (NSString *) getMethod
{
    return @"mizhe.user.vip.apply";
}
@end
