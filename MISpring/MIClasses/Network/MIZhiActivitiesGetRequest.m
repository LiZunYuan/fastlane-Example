//
//  MIZhiActivitiesGetRequest.m
//  MISpring
//
//  Created by 曲俊囡 on 14-6-11.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MIZhiActivitiesGetRequest.h"

@implementation MIZhiActivitiesGetRequest

- (NSString *) getMethod {
    return @"mizhe.zhi.activities.get";
}

- (NSString *) getType
{
    return @"static";
}
- (NSString *) getStaticURL
{
    return [NSString stringWithFormat:@"%@/zhi/activities.html", [MIConfig globalConfig].staticApiURL];
}

@end
