//
//  MITuanHeaderView.h
//  MISpring
//
//  Created by husor on 15-3-18.
//  Copyright (c) 2015年 Husor Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MITopAdView.h"

@interface MITuanHeaderView : UIView<UIScrollViewDelegate>
@property (nonatomic, strong) UIView *adBgView;
@property (nonatomic, strong) MITopAdView *topAdView;
@property (nonatomic, strong) UIScrollView * tuanHeaderScroll;
@property (nonatomic, strong) UIPageControl * pageControl;
@property (nonatomic, assign) NSInteger pages;
@property (nonatomic, strong) UIView *recommendBgView;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) NSString *tuanHotTag;
@property (nonatomic, assign) NSInteger currentHeight;
@property (nonatomic, assign) BOOL tenFlag;//标志十元或者优品
@property (nonatomic, strong) UIView *imageBgView;
@property (nonatomic, strong) UILabel *baokuanLabel;

// 广告，爆款推荐 和 快捷入口
@property (nonatomic, strong) NSArray *adsArray;
@property (nonatomic, strong) NSArray *hotItems;
@property (nonatomic, strong) NSArray *shortcuts;

- (void)refreshViews;
@end
