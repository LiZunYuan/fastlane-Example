//
//  MIBrandTomorrowRequest.m
//  MISpring
//
//  Created by 曲俊囡 on 14-6-17.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MIBrandTomorrowRequest.h"

@implementation MIBrandTomorrowRequest


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

- (NSString *) getMethod {
    return @"mizhe.brand.tomorrow.get";
}

- (NSString *) getType
{
    return @"static";
}
- (NSString *) getStaticURL
{
    return [NSString stringWithFormat:@"%@/brand/tomorrow/%@-%@-%@.html", [MIConfig globalConfig].staticApiURL, [self.fields objectForKey:@"cat"], [self.fields objectForKey:@"page"], [self.fields objectForKey:@"page_size"]];
}

@end
