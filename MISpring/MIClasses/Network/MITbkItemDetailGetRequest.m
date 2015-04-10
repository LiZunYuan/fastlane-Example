//
//  MITbkItemDetailGetRequest.m
//  MISpring
//
//  Created by 徐 裕健 on 13-12-10.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MITbkItemDetailGetRequest.h"

@implementation MITbkItemDetailGetRequest
- (void)setNumiid:(NSString *)numiid {
    [self.fields setObject:numiid forKey:@"num_iid"];
}

- (NSString *) getMethod {
    return @"mizhe.tbk.item.detail.get";
}
@end
