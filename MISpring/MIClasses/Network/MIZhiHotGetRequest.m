//
//  MIZhiHotGetRequest.m
//  MISpring
//
//  Created by 曲俊囡 on 14-6-11.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MIZhiHotGetRequest.h"

@implementation MIZhiHotGetRequest

- (NSString *) getMethod {
    return @"mizhe.zhi.hots.get";
}

- (NSString *) getType
{
    return @"static";
}
- (NSString *) getStaticURL
{
    return [NSString stringWithFormat:@"%@/zhi/hot_discloses.html", [MIConfig globalConfig].staticApiURL];
}

@end
