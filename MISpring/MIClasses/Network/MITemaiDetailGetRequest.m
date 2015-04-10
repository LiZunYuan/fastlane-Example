//
//  MITemaiDetailGetRequest.m
//  MISpring
//
//  Created by 曲俊囡 on 14-8-6.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MITemaiDetailGetRequest.h"

@implementation MITemaiDetailGetRequest

- (void)setType:(NSInteger)type
{
    [self.fields setObject:@(type) forKey:@"type"];
}
- (void)setTid:(NSInteger)tid
{
    [self.fields setObject:@(tid) forKey:@"tid"];
}
- (NSString *) getMethod
{
    return @"mizhe.temai.detail.get";
}
- (BOOL)getForceReload
{
    return YES;
}
- (NSString *) getHttpType {
    return @"GET";
}
- (NSString *) getType
{
    return @"static";
}
- (NSString *) getStaticURL
{
    return [NSString stringWithFormat:@"%@/temai/detail/%@-%@.html", [MIConfig globalConfig].staticApiURL, [self.fields objectForKey:@"type"], [self.fields objectForKey:@"tid"]];
}
@end
