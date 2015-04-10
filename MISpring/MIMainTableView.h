//
//  MIMainTableView.h
//  MISpring
//
//  Created by yujian on 14-12-11.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//  上新页面的首页，有广告和快捷入口

#import "MIBaseTableView.h"
#import "MIMainShortView.h"
#import "MIAdView.h"
#import "MIAdsModel.h"
#import "MIMainAdsView.h"
#import "MISquareAdsView.h"
#import "MITopAdView.h"

@interface MIMainTableView : MIBaseTableView

@property (nonatomic, strong) MIMainShortView *shortView;
@property (nonatomic, strong) MIAdView *adBox;
@property (nonatomic, strong) MIAdsModel *adsModel;
@property (nonatomic, strong) MIMainAdsView *bigAdsView;
@property (nonatomic, strong) MISquareAdsView *squareAdsView;
@property (nonatomic, strong) MITopAdView *middleAdsView;

- (void)loadMainAdsView;

-(void)showDailogAds;

@end
