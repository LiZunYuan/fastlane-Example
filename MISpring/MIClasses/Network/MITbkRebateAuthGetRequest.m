//
//  MITbkRebateAuthGetRequest.m
//  MISpring
//
//  Created by 徐 裕健 on 13-12-10.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MITbkRebateAuthGetRequest.h"

@implementation MITbkRebateAuthGetRequest
- (void)setNumiids:(NSString *)numiids {
    [self.fields setObject:numiids forKey:@"num_iids"];
}

- (NSString *) getMethod {
    return @"mizhe.tbk.rebate.auth.get";
}
@end
