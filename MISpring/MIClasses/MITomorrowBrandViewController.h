//
//  MITomorrowBrandViewController.h
//  MISpring
//
//  Created by 曲俊囡 on 14-6-17.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MIBaseViewController.h"
#import "MIBrandTomorrowRequest.h"
#import "MIGoTopView.h"
#import "MITomorrowHeaderView.h"
#import "MITomorrowFooterView.h"

@interface MITomorrowBrandViewController : MIBaseViewController<MIGoTopViewDelegate>
{
    NSInteger _tuanBrandPageSize;
    NSInteger _currentBrandCount;
    NSInteger _currentPage;
    BOOL _hasMore;
}

@property (nonatomic, strong) UILabel *emptyLabel;
@property (nonatomic, strong) MIGoTopView *goTopImageView;
@property (nonatomic, strong) NSMutableArray *tuanArray;
@property (nonatomic, assign) NSInteger catIndex;
@property (nonatomic, strong) MITomorrowHeaderView *headerView;
@property (nonatomic, strong) MITomorrowFooterView *footerView;
@property (nonatomic, assign) CGFloat lastscrollViewOffset;
@property (nonatomic, strong) NSMutableArray *datasCateIds;
@property (nonatomic, strong) NSMutableArray *datasCateNames;

@property (nonatomic, strong) NSMutableArray *tuanItems;
@property (nonatomic, strong) NSMutableArray *recomItems;


@property (nonatomic, strong) MIBrandTomorrowRequest *request;

@end
