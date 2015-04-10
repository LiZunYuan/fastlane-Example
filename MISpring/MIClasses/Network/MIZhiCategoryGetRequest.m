//
//  MIZhiCategoryGetRequest.m
//  MISpring
//
//  Created by 徐 裕健 on 13-10-23.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIZhiCategoryGetRequest.h"

@implementation MIZhiCategoryGetRequest
- (NSString *) getMethod
{
    return @"mizhe.zhi.category.get";
}

- (NSString *) getType
{
    return @"static";
}
- (NSString *) getStaticURL
{
    return [NSString stringWithFormat:@"%@/zhi/category.html", [MIConfig globalConfig].staticApiURL];
}
@end
