//
//  MIRefreshBaseTableView.h
//  MISpring
//
//  Created by 曲俊囡 on 15/3/27.
//  Copyright (c) 2015年 Husor Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MIGoTopView.h"
#import "MIOverlayStatusView.h"

@protocol MIRefreshBaseTableViewDelegate <NSObject>

@required
- (void)sendFirstPageRequest;
- (void)sendNextPageRequest;

@end


@interface MIRefreshBaseTableView : UIView<UITableViewDelegate,UITableViewDataSource,MIGoTopViewDelegate>


@property (nonatomic, assign) BOOL hasMore;
@property (nonatomic, assign) BOOL loading;
@property (nonatomic, strong) MIGoTopView *goTopView;
@property (nonatomic, strong) NSMutableArray *modelArray;
@property (nonatomic, weak) id<MIRefreshBaseTableViewDelegate> refreshDelegate;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger currentCount;
@property (nonatomic, strong) MIOverlayStatusView *overlayView;
@property (nonatomic, strong) EGORefreshTableHeaderView *refreshTableView;
@property (nonatomic, strong) UITableView   *tableView;
@property (nonatomic, assign) NSInteger     pageSize;
@property (nonatomic, strong) NSString      *emptyDesc;


- (void)willAppearView;
- (void)willDisappearView;
- (void)cancelRequest;

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)finishLoadTableViewData:(NSInteger)currentPage dataSource:(NSArray *)dataSource totalCount:(NSNumber *)totalCount;
- (void)finishLoadTableViewData:(NSInteger)currentPage dataSource:(NSArray *)dataSource totalCount:(NSNumber *)totalCount reloadData:(BOOL)needReload;
- (void)failLoadTableViewData;
- (void)finishLoadTableViewData;
- (void)reloadTableViewDataSource;

- (void)showSimpleHUD:(NSString *)tip afterDelay:(NSTimeInterval)delay;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;


@end
