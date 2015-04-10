//
//  MIRegisterRequest.h
//  MISpring
//
//  Created by Yujian Xu on 13-3-25.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIBaseRequest.h"

@interface MIRegisterRequest : MIBaseRequest

- (void) setUserNameAndPassWord: (NSString *) userNameAndPassWord;
- (void) setChannelId: (NSString *)channelId;

@end
