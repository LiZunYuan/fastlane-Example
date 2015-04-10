//
//  MIUserOpenAppAuthRequest.h
//  MISpring
//
//  Created by yujian on 14-7-16.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MIBaseRequest.h"

@interface MIUserOpenAppAuthRequest : MIBaseRequest

- (void)setSource:(NSString *)source;

- (void)setCode:(NSString *)code;

@end
