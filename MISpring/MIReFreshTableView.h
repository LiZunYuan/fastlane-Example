//
//  BBFreshTableView.h
//  BeiBeiAPP
//
//  Created by yujian on 14-11-19.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MIOverlayStatusView.h"

@protocol MIReFreshTableViewDelegate <NSObject>

@optional
- (void)sendFirstPageRequest;
- (void)sendNextPageRequest;
- (void)deletePage:(NSString *)ids;

@end

@interface MIReFreshTableView : UITableView<EGORefreshTableHeaderDelegate,UITableViewDelegate,UITableViewDataSource,MIOverlayStatusViewDelegate>

@property (nonatomic, assign) BOOL isEditing;
@property (nonatomic, assign) BOOL hasMore;
@property (nonatomic, assign) BOOL loading;
@property (nonatomic, strong) NSMutableArray *modelArray;
@property (nonatomic, weak) id<MIReFreshTableViewDelegate> freshDelegate;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger currentCount;
@property (nonatomic, strong) MIOverlayStatusView *overlayView;
@property (nonatomic, strong) EGORefreshTableHeaderView *refreshTableView;

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)finishLoadTableViewData:(NSInteger)currentPage dataSource:(NSArray *)dataSource totalCount:(NSNumber *)totalCount;

- (void)showSimpleHUD:(NSString *)tip afterDelay:(NSTimeInterval)delay;

@end
