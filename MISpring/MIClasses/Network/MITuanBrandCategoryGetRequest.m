//
//  MITuanBrandCategoryGetRequest.m
//  MISpring
//
//  Created by 曲俊囡 on 13-12-7.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MITuanBrandCategoryGetRequest.h"

@implementation MITuanBrandCategoryGetRequest

- (NSString *) getMethod
{
    return @"mizhe.tuan.brand.category.get";
}



- (NSString *) getType
{
    return @"static";
}

- (NSString *) getStaticURL
{
    return [NSString stringWithFormat:@"%@/brand/category.html", [MIConfig globalConfig].staticApiURL];
}

@end
