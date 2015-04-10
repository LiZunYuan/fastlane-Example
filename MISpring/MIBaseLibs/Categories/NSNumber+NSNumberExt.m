//
//  NSNumber+NSNumberExt.m
//  BeiBeiAPP
//
//  Created by 徐 裕健 on 14/7/1.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "NSNumber+NSNumberExt.h"

@implementation NSNumber (NSNumberExt)

- (NSString *)priceValue
{
    NSString *price;
    if (self.integerValue % 100 != 0) {
        if (self.integerValue % 10 != 0) {
            price = [[NSString alloc] initWithFormat:@"%.2f", self.floatValue / 100.0];
        } else {
            price = [[NSString alloc] initWithFormat:@"%.1f", self.floatValue / 100.0];
        }
    } else
    {
        price = [[NSString alloc] initWithFormat:@"%ld", (long)self.integerValue / 100];
    }
    
    return price;
}

- (NSString *)discountValue
{
    NSString *discount;
    if (self.integerValue % 10 != 0) {
        discount = [NSString stringWithFormat:@"%.1f折", self.floatValue / 10.0];
    } else
    {
        discount = [NSString stringWithFormat:@"%ld折", (long)self.integerValue / 10];
    }
    
    return discount;
}

- (NSString *)pointValue
{
    NSString *decimal = @"";
    NSInteger point = self.integerValue % 100;
    if (point != 0) {
        if (point % 10 != 0) {
            decimal = [[NSString alloc] initWithFormat:@".%ld", (long)point];
        } else {
            decimal = [[NSString alloc] initWithFormat:@".%ld", (long)point / 10];
        }
    }
    
    return decimal;
}

/**
 * 同一天逻辑以北京时区为准(GMT + 8)
 */
- (BOOL)isSameDay:(NSNumber *)unixTime
{
    NSInteger unixDayDiff1 = (self.integerValue + 8 * 3600) / (24 * 60 *60);
    NSInteger unixDayDiff2 = (unixTime.integerValue + 8 * 3600) / (24 * 60 *60);
    
    return unixDayDiff1 == unixDayDiff2;
}

- (NSInteger)unixTimeCompare:(NSNumber *)unixTime
{
    NSInteger unixDayDiff1 = (self.integerValue + 8 * 3600) / (24 * 60 *60);
    NSInteger unixDayDiff2 = (unixTime.integerValue + 8 * 3600) / (24 * 60 *60);
    return unixDayDiff1 - unixDayDiff2;
}

@end
