//
//  MIMallUpdateRequest.m
//  MiZheHD
//
//  Created by haozi on 13-8-30.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIMallUpdateRequest.h"

@implementation MIMallUpdateRequest
- (NSString *) getMethod
{
    return @"mizhe.mall.update";
}

- (void) setIds:(NSString *)ids
{
  [self.fields setObject:ids forKey:@"mall_ids"];
}
@end
