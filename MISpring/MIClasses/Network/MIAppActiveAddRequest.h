//
//  MIAppActiveAddRequest.h
//  MISpring
//
//  Created by 徐 裕健 on 13-11-26.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIBaseRequest.h"

@interface MIAppActiveAddRequest : MIBaseRequest
- (void)setMac:(NSString *)mac;
- (void)setIdfa:(NSString *)idfa;
- (void)setBd:(NSString *)bd;
@end
