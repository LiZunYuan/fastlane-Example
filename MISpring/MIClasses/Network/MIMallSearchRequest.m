//
//  MIMallSearchRequest.m
//  MISpring
//
//  Created by Mac Chow on 13-3-21.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIMallSearchRequest.h"

@implementation MIMallSearchRequest

- (void) setQ: (NSString *) q {
    [self.fields setObject:q forKey:@"q"];
}

- (NSString *) getMethod {
    return @"mizhe.mall.get";
}

@end
