//
//  MIMallReloadRequest.m
//  MISpring
//
//  Created by Mac Chow on 13-3-27.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIMallReloadRequest.h"

@implementation MIMallReloadRequest

//是否为移动商城，1表示移动商城，0表示pc商城
- (void) setType:(NSNumber *) type {
    [self.fields setObject:type forKey:@"type"];
}

//表示最后更新的商城，0表示获取所有的商城数据
- (void) setLast: (NSNumber *) data {
    [self.fields setObject:data forKey:@"last"];
}

//表示是否获取概要信息，1表示获取概要数据
- (void) setSummary: (NSNumber *) summary {
    [self.fields setObject:summary forKey:@"summary"];
}

- (NSString *) getMethod {
    return @"mizhe.mall.reload";
}

@end
