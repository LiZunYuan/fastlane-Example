//
//  MITuanItemModel.h
//  MISpring
//
//  Created by Yujian Xu on 13-3-26.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, type){
    MITenYuan = 1,
    MIYouPin = 2,
    MIBrand = 3,
    BBMartshow = 5,
    BBTuan = 6,
};

@interface MITuanItemModel : NSObject
//10元购
@property (nonatomic, strong) NSNumber *cid;
@property (nonatomic, strong) NSNumber *clicks;
@property (nonatomic, strong) NSNumber *discount;
@property (nonatomic, strong) NSNumber *tuanId;
@property (nonatomic, strong) NSString *img;
@property (nonatomic, strong) NSString *numIid;
@property (nonatomic, strong) NSNumber *origin;       //1:淘宝 2:天猫
@property (nonatomic, strong) NSNumber *postageType;
@property (nonatomic, strong) NSNumber *price;
@property (nonatomic, strong) NSNumber *priceOri;
@property (nonatomic, strong) NSNumber *startTime;
@property (nonatomic, strong) NSNumber *endTime;
@property (nonatomic, strong) NSNumber *status;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSNumber *views;
@property (nonatomic, strong) NSNumber *volumn;
@property (nonatomic, strong) NSString *tip;
@property (nonatomic, strong) NSString *labelImg; //商品标签类型，如果不为空则需要加载显示
@property (nonatomic, strong) NSString *encryptTid;//加密的商品id，用于分享
@property (nonatomic, strong) NSString *recomWord;
//@property (nonatomic, strong) NSString *encryptAid;//加密的特卖商品id，用于分享
//@property (nonatomic, strong) NSString *encryptBid;//加密的特卖专场id，用于分享

//品牌特卖
@property (nonatomic, strong) NSNumber *aid;
@property (nonatomic, strong) NSNumber *type;//1、10yuan 2、youpin 3、brand 5、beibei martshow 6、beibei tuan
@property (nonatomic, strong) NSString *eventType;//show 特卖  tuan 团购
@property (nonatomic, strong) NSNumber *stock;//库存
@property (nonatomic, strong) NSString *logo;
@property (nonatomic, strong) NSNumber *clickNum;
@property (nonatomic, strong) NSNumber *gmtBegin;
@property (nonatomic, strong) NSNumber *gmtEnd;
@property (nonatomic, strong) NSString *eventId;
@property (nonatomic, strong) NSNumber *saleTotalNum;
@property (nonatomic, strong) NSNumber *vid;
@property (nonatomic, strong) NSString *brand;
@property (nonatomic, strong) NSNumber *brandId;
@property (nonatomic, strong) NSNumber *iid;
@property (nonatomic, strong) NSNumber *sid;
@property (nonatomic, strong) NSArray *tags;

@end
