//
//  MICoinEarnHistoryGetRequest.m
//  MISpring
//
//  Created by 曲俊囡 on 14-5-26.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MICoinEarnHistoryGetRequest.h"

@implementation MICoinEarnHistoryGetRequest

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
    return @"mizhe.coin.earn.history.get";
}

@end
