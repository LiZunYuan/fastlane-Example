//
//  MIBeiBeiTeMaiViewController.h
//  MISpring
//
//  Created by husor on 14-10-14.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MIBaseViewController.h"
#import "MIBeiBeiTeMaiGetRequest.h"
#import "MIBeibeiTemaiGetModel.h"
#import "MIScreenView.h"
#import "MIMainShortView.h"
#import "SVTopScrollView.h"

@interface MIBeiBeiTeMaiViewController : MIBaseViewController
{
    NSInteger _currentPage;
    NSInteger _tuanTenPageSize;
    BOOL _hasMore;
    BOOL _isShowScreen;
}
@property (nonatomic, assign) BOOL isTabBar;
@property (nonatomic, strong) SVTopScrollView *topScrollView;
@property (nonatomic, strong) MIScreenView *screenView;
@property (nonatomic, strong) UIView *shadowView;
@property (nonatomic, strong) NSMutableArray *tuanArray;
@property (nonatomic, assign) CGFloat lastscrollViewOffset;
@property (nonatomic, strong) NSMutableArray *datasCateIds;
@property (nonatomic, strong) NSMutableArray *datasCateNames;
@property (nonatomic, strong) MIBeiBeiTeMaiGetRequest *request;
@property (nonatomic, strong) NSString *cat;
@property (nonatomic, strong) UIImageView *goTopImageView;
@property (nonatomic, copy) NSString *subject;
@property (nonatomic, copy) NSString *navigationBarTitle;

@end
