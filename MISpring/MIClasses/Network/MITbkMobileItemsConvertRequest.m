//
//  MITbkMobileItemsConvertRequest.m
//  MISpring
//
//  Created by 徐 裕健 on 13-12-10.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MITbkMobileItemsConvertRequest.h"

@implementation MITbkMobileItemsConvertRequest

- (void)setNumiids:(NSString *)numiids {
    [self.fields setObject:numiids forKey:@"num_iids"];
}
- (void)setType:(NSString *)type {
    [self.fields setObject:type forKey:@"type"];
}
- (NSString *) getMethod {
    return @"mizhe.tbk.mobile.items.convert";
}

@end
