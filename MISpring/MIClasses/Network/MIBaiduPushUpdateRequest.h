//
//  MIBaiduPushUpdateRequest.h
//  MiZheHD
//
//  Created by 徐 裕健 on 13-8-27.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIBaseRequest.h"

@interface MIBaiduPushUpdateRequest : MIBaseRequest
- (void)setChannelId:(NSString *) channelId;
- (void)setUserId:(NSString *) baiduUserId;

@end
