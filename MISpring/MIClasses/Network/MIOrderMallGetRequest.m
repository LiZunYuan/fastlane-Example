//
//  MIOrderMallGetRequest.m
//  MISpring
//
//  Created by Yujian Xu on 13-4-3.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIOrderMallGetRequest.h"

@implementation MIOrderMallGetRequest

- (id) init
{
    self = [super init];

    return self;
}
- (void) setStatus:(NSInteger)status
{
    [self.fields setObject:[NSString stringWithFormat:@"%d", status] forKey:@"status"];
}
- (void) setPage:(NSInteger)page
{
    [self.fields setObject:[NSString stringWithFormat:@"%d", page] forKey:@"page"];
}
- (void) setPageSize:(NSInteger)pageSize
{
    [self.fields setObject:[NSString stringWithFormat:@"%d", pageSize] forKey:@"page_size"];
}
- (NSString *) getMethod
{
    return @"mizhe.order.mall.get";
}

@end
