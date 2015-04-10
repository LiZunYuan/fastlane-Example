//
//  MIZhiItemDetailGetRequest.m
//  MISpring
//
//  Created by 徐 裕健 on 13-10-23.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIZhiItemDetailGetRequest.h"

@implementation MIZhiItemDetailGetRequest
- (void)setZid:(NSString *)zid
{
    [self.fields setObject:zid forKey:@"zid"];
}
- (NSString *) getMethod
{
    return @"mizhe.zhi.item.detail.get";
}
- (BOOL)getForceReload
{
    return YES;
}
- (NSString *) getType
{
    return @"static";
}
- (NSString *) getStaticURL
{
    return [NSString stringWithFormat:@"%@/zhi/detail/%@.html", [MIConfig globalConfig].staticApiURL, [self.fields objectForKey:@"zid"]];
}
@end
