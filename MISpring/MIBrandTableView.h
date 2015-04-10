//
//  MIBrandBaseTableVIew.h
//  MISpring
//
//  Created by husor on 14-12-16.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MITuanBrandGetRequest.h"
#import "MITuanBrandGetModel.h"
#import "MIOverlayStatusView.h"
#import "MIPageBaseRequest.h"
#import "MIGoTopView.h"

@interface MIBrandTableView : UIView<MIGoTopViewDelegate,EGORefreshTableHeaderDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) id model;
@property (nonatomic, strong) NSMutableArray *modelArray;
@property (nonatomic, strong) MIPageBaseRequest *request;
@property (nonatomic, assign) BOOL hasMore;
@property (nonatomic, assign) BOOL loading;
@property (nonatomic, strong) NSString *cat;
@property (nonatomic, strong) NSString *catId;
@property (nonatomic, copy) NSString *subject;
@property (nonatomic, strong) MIGoTopView *goTopView;
@property (nonatomic, strong) EGORefreshTableHeaderView *refreshTableView;
@property (nonatomic, assign) NSInteger totalCount;
@property (nonatomic, strong)MIOverlayStatusView *overlayView;

- (void)reloadTableViewDataSource;

- (void)cancelRequest;
- (void)willAppearView;
- (void)willDisappearView;
- (void)finishLoadTableViewData:(id)model;
- (void)failLoadTableViewData;

@end
