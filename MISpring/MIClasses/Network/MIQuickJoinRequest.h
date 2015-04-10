//
//  MIQuickJoinRequest.h
//  MISpring
//
//  Created by lsave on 13-4-15.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIBaseRequest.h"

@interface MIQuickJoinRequest : MIBaseRequest

- (void) setUserNameAndPassWord: (NSString *) userNameAndPassWord;
- (void) setToken: (NSString *) token;

@end
