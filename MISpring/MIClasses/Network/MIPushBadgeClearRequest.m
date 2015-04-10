//
//  MIPushBadgeClearRequest.m
//  MISpring
//
//  Created by lsave on 13-4-16.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIPushBadgeClearRequest.h"

@implementation MIPushBadgeClearRequest

- (void) setTaoBaoOrders
{
    [self.fields setObject:@"tb_orders" forKey:@"field"];
}
- (void) setMallOrders
{
    [self.fields setObject:@"mall_orders" forKey:@"field"];
}
- (void) setPaysOrders
{
    [self.fields setObject:@"pays" forKey:@"field"];
}
- (void) setComments
{
    [self.fields setObject:@"comments" forKey:@"field"];
}
- (NSString *) getMethod {
    return @"mizhe.push.badge.clear";
}

@end
