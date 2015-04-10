//
//  MITomorrowTuanViewController.h
//  MISpring
//
//  Created by 曲俊囡 on 14-7-31.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MIBaseViewController.h"
#import "MITuanTomorrowRequest.h"
#import "MIGoTopView.h"
#import "MITomorrowHeaderView.h"
#import "MITomorrowFooterView.h"

@interface MITomorrowTuanViewController : MIBaseViewController<MIGoTopViewDelegate>
{
    MIGoTopView *_goTopImageView;
    NSInteger _tuanTenPageSize;
    BOOL _hasMore;
}

@property (nonatomic, copy) NSString *subject;
@property (nonatomic, strong) MIGoTopView *goTopImageView;
@property (nonatomic, strong) NSMutableArray *tuanArray;
@property (nonatomic, assign) NSInteger catIndex;
@property (nonatomic, strong) MITomorrowHeaderView *headerView;
@property (nonatomic, strong) MITomorrowFooterView *footerView;
@property (nonatomic, strong) NSMutableArray *tuanItems;
@property (nonatomic, strong) NSMutableArray *recomItems;

@property (nonatomic, assign) CGFloat lastscrollViewOffset;

@property (nonatomic, strong) MITuanTomorrowRequest *request;

@end
