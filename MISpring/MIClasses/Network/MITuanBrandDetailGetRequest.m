//
//  MITuanBrandDetailGetRequest.m
//  MISpring
//
//  Created by 曲俊囡 on 13-12-7.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//  品牌特卖的指定店铺

#import "MITuanBrandDetailGetRequest.h"

@implementation MITuanBrandDetailGetRequest

- (void)setAid:(NSInteger)aid
{
    [self.fields setObject:@(aid) forKey:@"aid"];
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
    return @"mizhe.tuan.brand.detail.get";
}

- (NSString *) getType
{
    return @"static";
}

- (NSString *) getStaticURL
{
    return [NSString stringWithFormat:@"%@/brand/detail/%@-%@-%@.html", [MIConfig globalConfig].staticApiURL, [self.fields objectForKey:@"aid"], [self.fields objectForKey:@"page"], [self.fields objectForKey:@"page_size"]];
}

@end
