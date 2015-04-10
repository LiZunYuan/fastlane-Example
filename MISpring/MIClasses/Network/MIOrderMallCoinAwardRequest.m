//
//  MIOrderMallCoinAwardRequest.m
//  MISpring
//
//  Created by Yujian Xu on 13-4-13.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

/**
 *	@brief	领取商城返利订单的米币奖励
 */
#import "MIOrderMallCoinAwardRequest.h"

@implementation MIOrderMallCoinAwardRequest

- (void) setCoin:(NSString *)coin
{
    [self.fields setObject:coin forKey:@"oid"];
}

- (NSString *) getMethod {
    return @"mizhe.order.mall.coin.award";
}

@end
