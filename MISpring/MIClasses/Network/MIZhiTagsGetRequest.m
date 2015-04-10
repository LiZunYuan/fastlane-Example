//
//  MIZhiTagsGetRequest.m
//  MIZheZhi
//
//  Created by 曲俊囡 on 14-2-17.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MIZhiTagsGetRequest.h"

@implementation MIZhiTagsGetRequest

- (NSString *) getMethod {
    return @"mizhe.zhi.tags.get";
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
    return [NSString stringWithFormat:@"%@/zhi/tags.html", [MIConfig globalConfig].staticApiURL];
}
@end
