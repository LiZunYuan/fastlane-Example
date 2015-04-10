//
//  MIExchangeCoinApplyRequest.m
//  MiZheHD
//
//  Created by chenchao on 13-8-10.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIExchangeCoinApplyRequest.h"

@implementation MIExchangeCoinApplyRequest
- (void) setGid:(NSInteger)gid
{
    [self.fields setObject:[NSString stringWithFormat:@"%ld", (long)gid] forKey:@"gid"];
}
- (void) setPay:(NSInteger)pay
{
    [self.fields setObject:[NSString stringWithFormat:@"%ld", (long)pay] forKey:@"pay"];
}

- (void)setcode:(NSString *)code
{
    [self.fields setObject:code forKey:@"code"];
}
- (NSString *) getMethod
{
    return @"mizhe.exchange.coin.apply";
}
@end

