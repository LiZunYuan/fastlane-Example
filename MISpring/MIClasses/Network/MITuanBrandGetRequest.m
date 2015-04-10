//
//  MITuanBrandGetRequest.m
//  MISpring
//
//  Created by 曲俊囡 on 13-12-7.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//  品牌特卖列表

#import "MITuanBrandGetRequest.h"

@implementation MITuanBrandGetRequest
- (void)setCat:(NSString *)cat
{
    [self.fields setObject:cat forKey:@"cat"];
}

- (void)setPage:(NSInteger)page
{
    [self.fields setObject:@(page) forKey:@"page"];
}

- (void)setPageSize:(NSInteger)pageSize
{
    [self.fields setObject:@(pageSize) forKey:@"page_size"];
}

- (NSString *) getMethod
{
    return @"mizhe.tuan.brand.get";
}

- (NSString *) getType
{
    return @"static";
}

- (NSString *) getStaticURL
{
    return [NSString stringWithFormat:@"%@/brand/%@-%@-%@.html", [MIConfig globalConfig].staticApiURL, [self.fields objectForKey:@"cat"], [self.fields objectForKey:@"page"], [self.fields objectForKey:@"page_size"]];
}

@end
