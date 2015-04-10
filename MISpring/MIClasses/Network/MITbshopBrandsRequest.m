//
//  MITbshopBrandsRequest.m
//  MiZheHD
//
//  Created by haozi on 13-8-3.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MITbshopBrandsRequest.h"

@implementation MITbshopBrandsRequest
- (NSString *) getMethod
{
    return @"mizhe.tbshop.brands.get";
}

- (void) setCid: (NSString *) cid {
    [self.fields setObject:cid forKey:@"cat"];
}
@end
