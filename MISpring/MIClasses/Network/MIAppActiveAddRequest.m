//
//  MIAppActiveAddRequest.m
//  MISpring
//
//  Created by 徐 裕健 on 13-11-26.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIAppActiveAddRequest.h"

@implementation MIAppActiveAddRequest

- (void)setMac:(NSString *)mac
{
    [self.fields setObject:mac forKey:@"mac"];
}
- (void)setIdfa:(NSString *)idfa
{
    [self.fields setObject:idfa forKey:@"idfa"];
}
- (void)setBd:(NSString *)bd
{
    [self.fields setObject:bd forKey:@"bd"];
}
- (NSString *) getMethod
{
    return @"mizhe.app.active.add";
}

@end
