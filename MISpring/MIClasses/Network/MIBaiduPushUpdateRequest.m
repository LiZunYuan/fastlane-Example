//
//  MIBaiduPushUpdateRequest.m
//  MiZheHD
//
//  Created by 徐 裕健 on 13-8-27.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIBaiduPushUpdateRequest.h"

@implementation MIBaiduPushUpdateRequest
- (void)setChannelId:(NSString *) channelId
{
    [self.fields setObject:channelId forKey:@"channel_id"];
}
- (void)setUserId:(NSString *) baiduUserId
{
    [self.fields setObject:baiduUserId forKey:@"user_id"];
}
- (NSString *) getMethod
{
    return @"mizhe.baidu.push.update";
}

@end
