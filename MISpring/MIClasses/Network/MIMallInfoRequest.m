//
//  MIMallGetInfoRequest.m
//  MISpring
//
//  Created by Mac Chow on 13-4-8.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIMallInfoRequest.h"

@implementation MIMallInfoRequest

- (void) setMallId: (NSString *) mallId
{
    [self.fields setObject:mallId forKey:@"mall_id"];
}

- (NSString *) getMethod {
    return @"mizhe.mall.info";
}

@end
