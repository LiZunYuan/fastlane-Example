//
//  MITemaiCategoryRequest.m
//  MISpring
//
//  Created by 徐 裕健 on 14/9/2.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MITemaiCategoryRequest.h"

@implementation MITemaiCategoryRequest
- (NSString *) getMethod
{
    return @"mizhe.temai.category.get";
}



- (NSString *) getType
{
    return @"static";
}

- (NSString *) getStaticURL
{
    return [NSString stringWithFormat:@"%@/temai/category.html", [MIConfig globalConfig].staticApiURL];
}
@end
