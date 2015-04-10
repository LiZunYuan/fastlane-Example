//
//  MIExchangeGetRecordRequest.m
//  MiZheHD
//
//  Created by haozi on 13-8-8.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIExchangeGetRecordRequest.h"

@implementation MIExchangeGetRecordRequest
- (NSString *) getMethod
{
    return @"mizhe.exchange.get";
}

- (void) setType:(NSString *)type
{
    [self.fields setObject:type forKey:@"type"];
}

- (void) setPage:(NSInteger)page
{
    [self.fields setObject:[NSString stringWithFormat:@"%ld", (long)page] forKey:@"page"];
}
- (void) setPageSize:(NSInteger)pageSize
{
    [self.fields setObject:[NSString stringWithFormat:@"%ld", (long)pageSize] forKey:@"page_size"];
}
@end
