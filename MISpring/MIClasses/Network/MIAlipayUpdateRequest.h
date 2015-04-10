//
//  MIAlipayUpdateRequest.h
//  MISpring
//
//  Created by Yujian Xu on 13-4-12.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIBaseRequest.h"

@interface MIAlipayUpdateRequest : MIBaseRequest

- (void) setName: (NSString *) name;

- (void) setAlipay: (NSString *) alipay;

- (void) setPassword: (NSString *) password;

- (void) setCode: (NSString *) code;

@end
