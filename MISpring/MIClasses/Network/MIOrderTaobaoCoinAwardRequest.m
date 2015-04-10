//
//  MIOrderTaobaoCoinAwardRequest.m
//  MISpring
//
//  Created by Yujian Xu on 13-4-13.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

/**
 *	@brief	领取淘宝返利订单的米币奖励
 */
#import "MIOrderTaobaoCoinAwardRequest.h"

@implementation MIOrderTaobaoCoinAwardRequest

- (void) setCoin:(NSString *)coin
{
    [self.fields setObject:coin forKey:@"oid"];
}

- (NSString *) getMethod {
    return @"mizhe.order.taobao.coin.award";
}


@end
