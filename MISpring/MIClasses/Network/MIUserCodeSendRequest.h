//
//  BBUserCodeSendRequest.h
//  BeiBeiAPP
//
//  Created by yujian on 14-9-10.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MIBaseRequest.h"

@interface MIUserCodeSendRequest : MIBaseRequest

//此key目前有bind_alipay与withdraw两个字段
- (void) setKey:(NSString *)key;

//此参数可以不设置；
- (void)setTel:(NSString *)tel;

@end
