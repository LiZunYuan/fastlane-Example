//
//  MITbkItemClickRequest.m
//  MISpring
//
//  Created by 徐 裕健 on 13-12-17.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MITbkItemClickRequest.h"

@implementation MITbkItemClickRequest
- (void)setIids:(NSString *)iids
{
    [self.fields setObject:iids forKey:@"iids"];
}
- (void)setTimes:(NSString *)times
{
    [self.fields setObject:times forKey:@"times"];
}
- (NSString *) getMethod {
    return @"mizhe.tbk.item.click";
}
@end
