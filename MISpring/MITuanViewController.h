//
//  MITuanViewController.h
//  MISpring
//
//  Created by husor on 14-12-17.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MIBaseViewController.h"
#import "MIMainScrollView.h"
#import "MITuanTenGetRequest.h"
#import "MITopScrollView.h"
#import "MIScreenView.h"
#import "MIAdService.h"
#import "MIAdsModel.h"

@interface MITuanViewController : MIBaseViewController<MITopScrollViewDelegate,MIScreenSelectedDelegate>
{
    MITopScrollView *_scrollTop;
    MIMainScrollView *_mainScrollView;
    NSMutableArray *_tableViews;
    UIView *_currentView;
    BOOL _isShowScreen;
}

@property (nonatomic, strong) MIScreenView *screenView;
@property (nonatomic, strong) UIView *shadowView;
@property (nonatomic, strong) NSString *cat;
@property (nonatomic, strong) NSMutableArray *cats;
@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, assign) NSInteger totalCount;
@property (nonatomic, strong) UIImageView *goTopImageView;
@property (nonatomic, copy) NSString *subject;
@property (nonatomic, assign) BOOL isNavigationBar;

@end
