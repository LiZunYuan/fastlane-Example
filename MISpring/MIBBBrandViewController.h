//
//  MIBBBrandViewController.h
//  MISpring
//
//  Created by husor on 14-10-14.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MIBaseViewController.h"
#import "MIBeibeiMartshowItemGetModel.h"
#import "MIBBMartshowItemGetRequest.h"
#import "MIBBMartshowSegment.h"
#import "MIGoTopView.h"

@interface MIBBBrandViewController : MIBaseViewController<MIGoTopViewDelegate>
{
    NSInteger _pageSize;
    BOOL _hasMore;
    NSInteger _currentPage;
    NSInteger _currentCount;

}

@property (nonatomic, strong) NSMutableArray *modelArray;
@property (nonatomic, strong) NSString *mjPromotion;
@property (nonatomic, assign) NSInteger eventId;
@property (nonatomic, assign) NSInteger iid;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, copy) NSString *shopNameString;
@property (nonatomic, copy) NSString *shopTitleString;
@property (nonatomic, copy) NSString *shopImageString;
@property (nonatomic, assign) double gmtBegin;
@property (nonatomic, assign) double gmtEnd;
@property (nonatomic, strong) NSNumber *totalCount;
@property (nonatomic, strong) MIGoTopView *goTopImageView;
@property (nonatomic, assign) CGFloat lastscrollViewOffset;
@property (nonatomic, strong) MIBBMartshowItemGetRequest *request;
@property (nonatomic, assign) BOOL isCategoryMartshow;
@property (nonatomic, strong) MIBBMartshowSegment *segment;
- (id)initWithEventId:(NSInteger)eventId;
@end
