//
//  MITuanTenCatRequest.m
//  MiZheHD
//
//  Created by haozi on 13-8-5.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MITuanTenCatRequest.h"

@implementation MITuanTenCatRequest
- (NSString *) getMethod
{
    return @"mizhe.tuan.ten.category.get";
}



- (NSString *) getType
{
    return @"static";
}

- (NSString *) getStaticURL
{
    return [NSString stringWithFormat:@"%@/tuan/category.html", [MIConfig globalConfig].staticApiURL];
}

@end
