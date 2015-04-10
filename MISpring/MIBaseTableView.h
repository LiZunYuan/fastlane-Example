//
//  MIBaseTableView.h
//  MISpring
//
//  Created by husor on 14-11-7.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MITuanTenGetModel.h"
#import "MITemaiGetModel.h"
#import "MIOverlayStatusView.h"
#import "MIPageBaseRequest.h"
#import "MIViewLifecycleDelegate.h"
#import "MITuanItemModel.h"
#import "MITuanItemView.h"
#import "MIGoTopView.h"

@interface MIBaseTableView : UIView<MIViewLifecycleDelegate,MIGoTopViewDelegate>
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
@property (nonatomic, assign) NSInteger totalCount;
@property (nonatomic, strong)MIOverlayStatusView *overlayView;
@property (nonatomic, strong) EGORefreshTableHeaderView *refreshTableView;
@property (nonatomic, strong) NSMutableArray *tuanHotItems;
@property (nonatomic, strong) NSString *tuanHotTag;
//刷新产品的cell
- (void)updateCellView:(MITuanItemView *)view tuanModel:(MITuanItemModel *)model;

- (void)finishLoadTableViewData:(id)model;
- (void)finishLoadTableViewData:(id)model needReload:(BOOL)needReload;
- (void)failLoadTableViewData;
- (void)reloadTableViewDataSource;
- (void)cancelRequest;
- (void)refreshData;

@end
