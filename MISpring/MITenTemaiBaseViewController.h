//
//  MITenTemaiBaseViewController.h
//  MISpring
//
//  Created by husor on 14-12-4.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MIBaseViewController.h"
#import "MITopScrollView.h"
#import "MIScreenView.h"
#import "MITuanTenCatModel.h"
#import "MITuanTenGetRequest.h"
#import "MITuanTenGetModel.h"
#import "MIMainScrollView.h"
#import "MIPageBaseRequest.h"
//#import "MIGoTopView.h"
#define TABBAR_HEIGHT     48

@interface MITenTemaiBaseViewController : MIBaseViewController<MIScreenSelectedDelegate>

@property (nonatomic, copy) NSString *navigationBarTitle;
@property (nonatomic, strong) MITopScrollView *topScrollView;
@property (nonatomic, strong) NSArray *cats;
@property (nonatomic, strong) UIView *shadowView;
@property (nonatomic, strong) MIScreenView *screenView;
@property (nonatomic, copy) NSString *cat;
@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong)NSMutableArray * tableArr;
//@property (nonatomic, strong) MIGoTopView *goTopImageView;
@property (nonatomic, strong) UIView *currentView;
@property (nonatomic, strong)   MIMainScrollView *scroll;
@property (nonatomic, assign)   BOOL isShowScreen;
@property (nonatomic, assign)   CGFloat lastscrollViewOffset;
@property (nonatomic, assign)  NSInteger tuanTenPageSize;
@property (nonatomic, strong) MIPageBaseRequest *request;

- (void)tableWillAppear;
- (void) setTopScrollCatArray:(NSArray *)cats;
- (void)finishLoadTableViewData:(id)model;

@end
