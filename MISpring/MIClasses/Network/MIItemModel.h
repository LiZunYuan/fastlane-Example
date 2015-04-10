//
//  MIItemModel.h
//  MISpring
//
//  Created by 曲俊囡 on 13-12-7.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MIItemModel : NSObject

@property (nonatomic, strong) NSNumber *status;
@property (nonatomic, strong) NSNumber *gmtCreat;
@property (nonatomic, strong) NSNumber *tuanId;
@property (nonatomic, strong) NSNumber *postageType;
@property (nonatomic, strong) NSString *img;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *tag;
@property (nonatomic, strong) NSString *tip;
@property (nonatomic, strong) NSNumber *origin;
@property (nonatomic, strong) NSNumber *views;
@property (nonatomic, strong) NSString *sellerNick;
@property (nonatomic, strong) NSNumber *priceOri;
@property (nonatomic, strong) NSNumber *numIid;
@property (nonatomic, strong) NSNumber *gmtModified;
@property (nonatomic, strong) NSNumber *price;
@property (nonatomic, strong) NSNumber *clicks;
@property (nonatomic, strong) NSNumber *discount;
@property (nonatomic, strong) NSNumber *cid;
@property (nonatomic, strong) NSNumber *todayClicks;
@property (nonatomic, strong) NSNumber *position;
@property (nonatomic, strong) NSNumber *aid;
@property (nonatomic, strong) NSNumber *stock;
@property (nonatomic, strong) NSNumber *brandId;
@property (nonatomic, strong) NSString *labelImg; //标签类型，不为空则需要加载显示

@property (nonatomic, strong) NSString *encryptAid;//加密的特卖商品id，用于分享
@property (nonatomic, strong) NSString *encryptBid;//加密的特卖专场id，用于分享
//手动添加
@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, strong) NSString *endTime;
@property (nonatomic, strong) NSString *recomWords;

//任务明细的model
@property (nonatomic, strong) NSString *appName;
@property (nonatomic, strong) NSNumber *coin;
@property (nonatomic, strong) NSNumber *time;
/*
 1 = li mei
 2 = you mi
 3 = yi ji fen
 */
 
@property (nonatomic, strong) NSNumber *channel;
/*
 1 = android
 2 = ios
 */
@property (nonatomic, strong) NSNumber *platform;

@end
