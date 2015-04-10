//
//  MIAdsModel.h
//  MISpring
//
//  Created by husor on 14-11-12.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MIAdsModel : NSObject

//@property (nonatomic, strong) NSMutableArray *all;
@property (nonatomic, strong) NSArray *ads;
@property (nonatomic, strong) NSArray *splashAds;
@property (nonatomic, strong) NSArray *mizheShortcuts;
@property (nonatomic, strong) NSArray *recommendHeader;
@property (nonatomic, strong) NSArray *promotionShortcuts;
@property (nonatomic, strong) NSArray *squareShortcuts;
@property (nonatomic, strong) NSArray *brandBanners;
@property (nonatomic, strong) NSArray *tenyuanBanners;
@property (nonatomic, strong) NSArray *youpinBanners;
@property (nonatomic, strong) NSArray *middleBanners;
@property (nonatomic, strong) NSArray *dialogAds; // deprecated
@property (nonatomic, strong) NSArray *popupAds;
@property (nonatomic, strong) NSArray *topbarAds;
@property (nonatomic, strong) NSArray *nvzhuangCatShortcuts;
@property (nonatomic, strong) NSArray *temaiHeaderBanners;
@property (nonatomic, strong) NSArray *tenyuanShortcuts;
@property (nonatomic, strong) NSArray *youpinShortcuts;
@property (nonatomic, strong) NSArray *muyingBanners;

@property (nonatomic, strong) NSNumber *latestConfigTime;

- (NSDictionary *)toJsonObject;

@end
