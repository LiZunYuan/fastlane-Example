//
//  MIExchangeCoinApplyRequest.h
//  MiZheHD
//
//  Created by chenchao on 13-8-10.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIBaseRequest.h"

@interface MIExchangeCoinApplyRequest : MIBaseRequest

- (void)setGid:(NSInteger)gid;
- (void)setPay:(NSInteger)pay;
- (void)setcode: (NSString *) code;

@end
