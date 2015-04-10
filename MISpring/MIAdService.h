//
//  MIAdService.h
//  MISpring
//
//  Created by husor on 14-11-12.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIAdsModel.h"

typedef void (^LoadSuccessBlock)(MIAdsModel *model);

typedef enum {
    All_Ads,
    Ads,                        // 轮播banner
    Splash_Ads,                 // 闪屏广告
    MI_Shortcuts,               // icon区域快捷入口
    Recommend_Header,
    Promotion_Shortcuts,        // 推广区域快捷入口
    Square_Shortcuts,
    Brand_Banners,
    TenYuan_Banners,
    YouPin_Banners,
    Middle_Banners,
    Dialog_Ads,                 // 弹出式广告(由于android bug, 此广告位停用)
    Popup_Ads,
    Topbar_Ads,                 //首页顶部navi广告
    Nvzhuang_Cat_Shortcuts,     //女装分类banner
    Temai_Header_Banners,   //商品主推位banner
    Tenyuan_Shortcuts,//10元购首页快捷入口
    Youpin_Shortcuts,//优品惠首页快捷入口
    Muying_Banners,
    AdsTypeMax
}AdsType;

@interface MIAdService : NSObject

@property(nonatomic, retain) NSArray *adKeys;
@property(nonatomic, assign) BOOL hasSplashAds;

+ (instancetype)sharedManager;
- (void)loadAdWithType:(NSArray *)adsTypeArray block:(LoadSuccessBlock)block;
- (void)clearCache;

@end
