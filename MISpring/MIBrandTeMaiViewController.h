//
//  MIBrandTeMaiViewController.h
//  MISpring
//
//  Created by husor on 14-12-16.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MIBaseViewController.h"
#import "MITuanBrandGetRequest.h"
#import "MIScreenView.h"
#import "MIScreenSelectedDelegate.h"
#import "MIMainScrollView.h"
#import "MITopScrollView.h"
#import "MIScreenView.h"
#import "MITopAdView.h"
#import "MIAdsModel.h"
#import "MIAdService.h"
//#import "MIGoTopView.h"

@interface MIBrandTeMaiViewController : MIBaseViewController<MIScreenSelectedDelegate,MITopScrollViewDelegate>
{
    MITopScrollView *_scrollTop;
    MIMainScrollView *_mainScrollView;
    NSMutableArray *_tableViews;
    UIView *_currentView;
    BOOL _isShowScreen;
    MITopAdView *_topAdView;
    
}
@property (nonatomic, strong) MIScreenView *screenView;
@property (nonatomic, strong) UIView *shadowView;
@property (nonatomic, strong) NSString *cat;
@property (nonatomic, strong) NSArray *cats;
@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, assign) NSInteger totalCount;
//@property (nonatomic, strong) MIGoTopView *goTopImageView;
@property (nonatomic, assign) BOOL isNavigationBar;
@end
