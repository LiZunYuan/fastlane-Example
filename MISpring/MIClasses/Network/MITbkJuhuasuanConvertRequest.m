//
//  MITbkJuhuasuanConvertRequest.m
//  MISpring
//
//  Created by lsave on 13-4-7.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MITbkJuhuasuanConvertRequest.h"

@implementation MITbkJuhuasuanConvertRequest

- (void) setNumIid: (NSString *) numIid
{
    [self.fields setObject:numIid forKey:@"num_iid"];
}

- (void) setCommissionRate:(NSString *)commissionRate
{
    [self.fields setObject:commissionRate forKey:@"commission_rate"];
}

- (NSString *) getMethod {
    return @"mizhe.tbk.juhuasuan.convert";
}

@end
