//
//  MITbkItemGetRequest.m
//  MISpring
//
//  Created by lsave on 13-3-18.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MITbkItemGetRequest.h"

@implementation MITbkItemGetRequest

- (void) setQ: (NSString *) q {
    [self.fields setObject:q forKey:@"q"];
}

- (void) setSort: (NSString *) sort {
    [self.fields setObject:sort forKey:@"sort"];
}

- (void) setIsTmall:(NSString *)isTmall {
    [self.fields setObject:isTmall forKey:@"isTmall"];
}

- (void) setPage: (NSInteger) page {
    [self.fields setObject:[NSString stringWithFormat:@"%ld", (long)page] forKey:@"page"];
}

- (void) setPageSize:(NSInteger)pageSize
{
    [self.fields setObject:[NSString stringWithFormat:@"%ld", (long)pageSize] forKey:@"page_size"];
}

- (void) setMinPrice:(NSString *)minPrice
{
    [self.fields setObject:minPrice forKey:@"min_pri"];
}

- (void) setMaxPrice:(NSString *)maxPrice
{
    [self.fields setObject:maxPrice forKey:@"max_pri"];
}

- (NSString *) getMethod {
    return @"mizhe.tbk.item.get";
}

@end
