//
//  yjfScore.h
//  yjfSDKDemo_beta1
//
//  Created by emaryjf on 13-4-9.
//  Copyright (c) 2013年 emaryjf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YJFIntegralWall.h"

@interface YJFScore : NSObject


+(void)getScore:(id<YJFIntegralWallDelegate>)_delegate;;//查询积分
+(void)consumptionScore:(int)_score delegate:(id<YJFIntegralWallDelegate>)_delegate;//消耗积分


@end
