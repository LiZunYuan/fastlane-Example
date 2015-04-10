//
//  MITbOrderModel.h
//  MISpring
//
//  Created by Yujian Xu on 13-3-18.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MITbOrderModel : NSObject

@property (nonatomic, strong) NSNumber *uid;
@property (nonatomic, strong) NSNumber *oid;
@property (nonatomic, strong) NSNumber *commission;
@property (nonatomic, strong) NSString *tradeId;
@property (nonatomic, strong) NSNumber *tradeMoney;
@property (nonatomic, strong) NSNumber *status;      //订单到账状态，0表示已返利，1表示预返利
@property (nonatomic, strong) NSNumber *expectTime;  //预计返利时间
@property (nonatomic, strong) NSString *payTime;     //跟单时间
@property (nonatomic, strong) NSString *tradeTime;   //交易时间
@property (nonatomic, strong) NSString *itemId;
@property (nonatomic, strong) NSString *itemTitle;
@property (nonatomic, strong) NSString *itemPic;
@property (nonatomic, strong) NSString *itemNum;
@property (nonatomic, strong) NSString *shopNick;
@property (nonatomic, strong) NSNumber *coin;
@property (nonatomic, strong) NSNumber *coinAward;
@property (nonatomic, strong) NSNumber *isMobile;

@end
