//
//  MILoginRequest.h
//  MISpring
//
//  Created by Yujian Xu on 13-3-18.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "MIBaseRequest.h"

@interface MILoginRequest : MIBaseRequest

- (void) setUserNameAndPassWord: (NSString *) userNameAndPassWord;

@end
