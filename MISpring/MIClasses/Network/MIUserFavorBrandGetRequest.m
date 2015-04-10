//
//  MIUserFavorBrandGetRequest.m
//  MISpring
//
//  Created by yujian on 14-12-15.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MIUserFavorBrandGetRequest.h"

@implementation MIUserFavorBrandGetRequest

- (NSString *) getMethod
{
    return @"mizhe.user.favor.brand.get";
}
- (NSString *) getHttpType {
    return @"GET";
}

- (void) setPage:(NSInteger)page
{
    [self.fields setObject:@(page) forKey:@"page"];
}

- (void) setPageSize:(NSInteger)pageSize
{
    [self.fields setObject:@(pageSize) forKey:@"page_size"];
}

@end
