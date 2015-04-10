//
//  MIMainViewController.h
//  MISpring
//
//  Created by XU YUJIAN on 13-1-17.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MITbSearchViewController.h"
#import "MIAdView.h"
#import "MITemaiGetRequest.h"
#import "MITemaiGetModel.h"
#import "MIScreenView.h"
#import "MIScreenSelectedDelegate.h"
#import "MIMainShortView.h"
#import "MIAdService.h"
#import "MIMainAdsView.h"

@interface MIMainViewController : MIBaseViewController<UIScrollViewDelegate,MIScreenSelectedDelegate>
{
    NSInteger _currentPage;
    NSInteger _tuanTenPageSize;
    BOOL _hasMore;
    BOOL _isShowScreen;
}
//二维数组,按照时间将团购商品分类为今天、昨天、前天、更早上新
//@property (nonatomic, strong) NSMutableArray *tuanArray;
@property (nonatomic, strong) MIScreenView *screenView;
@property (nonatomic, strong) UIView *shadowView;
@property (nonatomic, assign) CGFloat lastscrollViewOffset;
@property (nonatomic, strong) NSMutableArray *datasCateIds;
@property (nonatomic, strong) NSMutableArray *datasCateNames;
@property (nonatomic, copy) NSString *cat;
@property (nonatomic, strong) NSArray *cats;
@property (nonatomic, strong) NSMutableArray *titleArray;

@property (nonatomic, assign) BOOL appearFromTab;

+ (void)setRefreshFlag:(BOOL)flag;

@end
