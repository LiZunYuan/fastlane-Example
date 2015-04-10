//
//  MITomorrowTenViewController.h
//  MISpring
//
//  Created by 曲俊囡 on 14-6-17.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MIBaseViewController.h"
#import "MITuanTomorrowRequest.h"

@interface MITomorrowTenViewController : MIBaseViewController
{
    UIImageView *_goTopImageView;
    NSInteger _tuanTenPageSize;
    BOOL _hasMore;
}

@property (nonatomic, copy) NSString *subject;
@property (nonatomic, strong) UILabel *emptyLabel;
@property (nonatomic, strong) UIImageView *goTopImageView;
//二维数组,按照时间将团购商品分类为今天、昨天、前天、更早上新
@property (nonatomic, strong) NSMutableArray *tuanArray;
@property (nonatomic, assign) NSInteger catIndex;

@property (nonatomic, assign) CGFloat lastscrollViewOffset;

@property (nonatomic, strong) MITuanTomorrowRequest *request;

//点击segment进入十元购的时候，调用此方法。
- (void)reLoadTableViewData;

@end
