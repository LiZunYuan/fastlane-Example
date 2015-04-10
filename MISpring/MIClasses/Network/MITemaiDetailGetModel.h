//
//  MITemaiDetailGetModel.h
//  MISpring
//
//  Created by 曲俊囡 on 14-8-6.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MITemaiDetailGetModel : NSObject

@property (nonatomic, copy)  NSString *shopShuo;
@property (nonatomic, strong) NSNumber *discount;
@property (nonatomic, strong) NSNumber *tuanId;
@property (nonatomic, strong) NSString *img;
@property (nonatomic, strong) NSNumber *numIid;
@property (nonatomic, strong) NSNumber *origin;       //1:淘宝 2:天猫
@property (nonatomic, strong) NSNumber *startTime;
@property (nonatomic, strong) NSNumber *endTime;
@property (nonatomic, strong) NSNumber *status;
@property (nonatomic, strong) NSNumber *postageType;
@property (nonatomic, strong) NSNumber *cid;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSNumber *views;
@property (nonatomic, strong) NSNumber *volumn;
@property (nonatomic, strong) NSString *tip;
@property (nonatomic, strong) NSString *labelImg;
@property (nonatomic, strong) NSNumber *clicks;
@property (nonatomic, strong) NSNumber *price;
@property (nonatomic, strong) NSNumber *priceOri;
@property (nonatomic, strong) NSString *encryptTid;//加密的商品id，用于分享
@property (nonatomic, strong) NSString *encryptAid;//加密的特卖商品id，用于分享
@property (nonatomic, strong) NSString *encryptBid;//加密的特卖专场id，用于分享

@property (nonatomic, strong)  NSArray *tuanItems;///数据类型为MITuanItemModel
@property (nonatomic, strong) NSArray *tuanItemsRecs;

@property (nonatomic, strong) NSNumber *aid;
@property (nonatomic, strong) NSNumber *type;
@property (nonatomic, strong) NSNumber *brandId;
@property (nonatomic, strong) NSNumber *stock;
@property (nonatomic, strong) NSString *brandDesc;
@property (nonatomic, strong)  NSArray *brandRecs;//数据类型为MIBrandRecModel
@property (nonatomic, strong) NSArray *brandItemsRecs;

@property (nonatomic, strong)  NSNumber *shuoHeight;

@end
