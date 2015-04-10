//
//  MITuanBaseViewController.h
//  MISpring
//
//  Created by 曲俊囡 on 14-7-22.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MIBaseViewController.h"
#import "SVTopScrollView.h"
#import "MIScreenView.h"
#import "MIScreenSelectedDelegate.h"
#import "MIGoTopView.h"

typedef enum {
    MITuanSegmentViewNormal,
    MITuanSegmentViewNone,
}SegmentType;

@interface MITuanBaseViewController : MIBaseViewController<MIScreenSelectedDelegate,MIGoTopViewDelegate>
{
    NSInteger _tuanTenPageSize;
    BOOL _hasMore;
    BOOL _isShowScreen;
}

//二维数组,按照时间将团购商品分类为今天、昨天、前天、更早上新
@property (nonatomic, assign) SegmentType segmentType;
@property (nonatomic, copy) NSString *navigationBarTitle;
@property (nonatomic, strong) MIScreenView *screenView;

@property (nonatomic, strong) UIView *shadowView;

@property (nonatomic, strong) SVTopScrollView *topScrollView;
@property (nonatomic, strong) NSMutableArray *tuanArray;

@property (nonatomic, assign) CGFloat lastscrollViewOffset;
@property (nonatomic, strong) NSMutableArray *datasCateIds;
@property (nonatomic, strong) NSMutableArray *datasCateNames;

@property (nonatomic, copy) NSString *cat;
@property (nonatomic, strong) NSArray *cats;
@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, copy) NSString *subject;
@property (nonatomic, assign) NSInteger totalCount;
@property (nonatomic, strong) MIGoTopView *goTopImageView;

- (void) setTopScrollCatArray:(NSArray *)cats;


@end
