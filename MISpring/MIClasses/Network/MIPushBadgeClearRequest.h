//
//  MIPushBadgeClearRequest.h
//  MISpring
//
//  Created by lsave on 13-4-16.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIBaseRequest.h"

@interface MIPushBadgeClearRequest : MIBaseRequest

- (void) setTaoBaoOrders;
- (void) setMallOrders;
- (void) setPaysOrders;
- (void) setComments;

@end
