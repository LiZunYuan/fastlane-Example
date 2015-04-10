//
//  MIBrandTuanViewController.h
//  MISpring
//
//  Created by 曲俊囡 on 14-7-4.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MIBaseViewController.h"
#import "MITuanBrandGetRequest.h"
#import "MIScreenView.h"
#import "MIScreenSelectedDelegate.h"
#import "SVTopScrollView.h"
#import "MIGoTopView.h"

@interface MIBrandTuanViewController : MIBaseViewController<MIScreenSelectedDelegate,MIGoTopViewDelegate>
{
    NSInteger _tuanBrandPageSize;
    NSInteger _currentBrandCount;
    NSInteger _currentPage;
    BOOL _hasMore;
    BOOL _isShowScreen;
}

@property (nonatomic, assign) BOOL isTabBar;
@property (nonatomic, strong) MIScreenView *screenView;
@property (nonatomic, strong) UIView *shadowView;
@property (nonatomic, strong) SVTopScrollView *topScrollView;

//二维数组,按照时间将团购商品分类为今天、昨天、前天、更早上新
@property (nonatomic, strong) NSMutableArray *tuanArray;

@property (nonatomic, assign) CGFloat lastscrollViewOffset;
@property (nonatomic, strong) NSMutableArray *datasCateIds;
@property (nonatomic, strong) NSMutableArray *datasCateNames;

@property (nonatomic, strong) MITuanBrandGetRequest *request;
@property (nonatomic, strong) NSString *cat;
@property (nonatomic, strong) NSArray *cats;
@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, assign) NSInteger totalCount;
@property (nonatomic, strong) MIGoTopView *goTopImageView;


@end
