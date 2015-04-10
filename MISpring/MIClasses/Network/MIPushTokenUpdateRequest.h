//
//  MIPushTokenUpdateRequest.h
//  MISpring
//
//  Created by lsave on 13-4-15.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIBaseRequest.h"

@interface MIPushTokenUpdateRequest : MIBaseRequest

- (void)setPushSrc:(NSString *)pushSrc;
- (void)setToken:(NSString *)token;
- (void)setEnable:(BOOL)enable;

@end
