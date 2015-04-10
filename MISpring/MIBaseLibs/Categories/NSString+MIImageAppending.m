//
//  NSString+BBImageAppending.m
//  BeiBeiAPP
//
//  Created by 曲俊囡 on 14-4-11.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "NSString+MIImageAppending.h"

@implementation NSString (MIImageAppending)

- (NSString *)miImageAppendingWithSizeString:(NSString *)aSizeString
{
    NSString *string = [NSString stringWithFormat:@"%@!%@.jpg",self,aSizeString];
    return string;
}
@end
