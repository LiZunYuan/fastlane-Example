//
//  BBUserQuickJoinRequest.h
//  BeiBeiAPP
//
//  Created by yujian on 14-6-13.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MIBaseRequest.h"

@interface MIUserQuickJoinRequest : MIBaseRequest

- (void)setToken:(NSString *)token;
- (void)setEmailAndPwd:(NSString *)emailPwd;
- (void)setBindType:(NSString *)bindType;

@end
