//
//  NSNumber+NSNumberExt.h
//  BeiBeiAPP
//
//  Created by 徐 裕健 on 14/7/1.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNumber (NSNumberExt)

- (NSString *)priceValue;
- (NSString *)discountValue;
- (NSString *)pointValue;
- (BOOL)isSameDay:(NSNumber *)unixTime;
- (NSInteger)unixTimeCompare:(NSNumber *)unixTime;
@end
