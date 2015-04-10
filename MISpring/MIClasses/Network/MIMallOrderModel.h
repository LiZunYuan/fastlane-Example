//
//  MIMallOrderModel.h
//  MISpring
//
//  Created by Yujian Xu on 13-4-3.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MIMallOrderModel : NSObject

@property(nonatomic, strong) NSString *billTime;
@property(nonatomic, strong) NSNumber *coin;
@property(nonatomic, strong) NSNumber *commission;
@property(nonatomic, strong) NSNumber *commissionMode;
@property(nonatomic, strong) NSNumber *mallId;
@property(nonatomic, strong) NSString *mallName;
@property(nonatomic, strong) NSString *orderId;
@property(nonatomic, strong) NSNumber *status;
@property(nonatomic, strong) NSNumber *tradeMoney;
@property(nonatomic, strong) NSString *tradeTime;
@property(nonatomic, strong) NSString *logo;
@property(nonatomic, strong) NSNumber *coinAward;
@property(nonatomic, strong) NSNumber *oid;
@property(nonatomic, strong) NSNumber *expectTime;
@property(nonatomic, strong) NSNumber *isMobile;

@end
