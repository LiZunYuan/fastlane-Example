//
//  MIRowTableView.m
//  MISpring
//
//  Created by 曲俊囡 on 15/3/27.
//  Copyright (c) 2015年 Husor Inc. All rights reserved.
//

#import "MIRowTableView.h"
#import "MITuanItemModel.h"
#import "MIRowTableViewCell.h"
#import "MITuanDetailViewController.h"
//#import "MIProductViewController.h"

@implementation MIRowTableView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.refreshDelegate = self;
        
        UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.viewWidth, 4)];
        header.backgroundColor = MINormalBackgroundColor;
        self.tableView.tableHeaderView = header;
    }
    return self;
}

- (void)finishHotLoadTableViewData:(MITuanHotGetModel *)model
{
    self.hotGetModel = model;
    [self finishLoadTableViewData:model.page.integerValue dataSource:model.tuanItems totalCount:model.count];
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:kLastTuanHotTime];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)finishActivityLoadTableViewData:(MITuanActivityGetModel *)model
{
    self.activityGetModel = model;
    [self finishLoadTableViewData:model.page.integerValue dataSource:model.tuanItems totalCount:model.count];
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:kLastTuanHotTime];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)willAppearView
{
    [super willAppearView];
    if (self.modelArray.count == 0) {
        self.loading = YES;
        [self.overlayView setOverlayStatus:EOverlayStatusLoading labelText:nil];
        [self performSelector:@selector(sendFirstPageRequest) withObject:nil afterDelay:0.2];
    } else {
        // 最后疯抢和今日上新每30分钟自动刷新一次
        NSDate *lastUpdate = [[NSUserDefaults standardUserDefaults] objectForKey:kLastTuanHotTime];
        
        if ([lastUpdate timeIntervalSinceNow] <= MIAPP_HALF_HOUR_INTERVAL && [[Reachability reachabilityForInternetConnection] isReachable]){
            //每隔半小时强制刷新列表数据
            [self reloadTableViewDataSource];
        } else {
            [self.tableView reloadData];
        }
    }
}

- (void)willDisappearView
{
    [super willDisappearView];
    if (self.loading) {
        self.loading = NO;
        [self finishLoadTableViewData];
        [self.overlayView setOverlayStatus:EOverlayStatusRemove labelText:nil];
    }
    
    if (_request.operation.isExecuting) {
        [_request cancelRequest];
    }
}

- (void)cancelRequest
{
    if (_request.operation.isExecuting) {
        [_request cancelRequest];
    }
}

- (void)sendFirstPageRequest
{
    self.loading = YES;
    [_request setPage:1];
    [_request setPageSize:self.pageSize];
    [_request sendQuery];
    [self.overlayView setOverlayStatus:EOverlayStatusLoading labelText:nil];
}

- (void)sendNextPageRequest
{
    self.loading = YES;
    [_request setPage:(self.currentPage + 1)];
    [_request setPageSize:self.pageSize];
    [_request sendQuery];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.hasMore == NO) {
        return self.modelArray.count;
    } else {
        //加1是因为要显示加载更多row
        return self.modelArray.count + 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    if (cell)
    {
        return cell;
    }
    MIRowTableViewCell *itemCell = [tableView dequeueReusableCellWithIdentifier:@"MIRowTableViewCell"];
    if (!itemCell)
    {
        itemCell = [[[NSBundle mainBundle]loadNibNamed:@"MIRowTableViewCell" owner:self options:nil]objectAtIndex:0];
        itemCell.selectionStyle = UITableViewCellSelectionStyleNone;
        itemCell.contentView.backgroundColor = [UIColor whiteColor];
    }
    
    @try {
        MITuanItemModel *model = (MITuanItemModel *)[self.modelArray objectAtIndex:indexPath.row];
        [itemCell updateCellView:model];
    }
    @catch (NSException *exception) {
        MILog(@"index out of range!!!");
    }
    return itemCell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger count = self.modelArray.count;
    NSInteger rows = [self tableView:tableView numberOfRowsInSection:0] - 1;
    if (self.hasMore && (indexPath.row == rows) && (count > 0))
    {
        return 50;
    }
    return 132;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.modelArray.count > indexPath.row)
    {
        MITuanItemModel *model = (MITuanItemModel *)[self.modelArray objectAtIndex:indexPath.row];
        [self goToProductViewController:model];
//        [HusorClick event:ET_HOME_TUAN_CLICK arg1:model.iid.description];
    }
}

- (void)goToProductViewController:(MITuanItemModel *)model
{
//    [MobClick event:@"kLimitProductsClicks"];
    MITuanDetailViewController *vc = [[MITuanDetailViewController alloc]initWithItem:model placeholderImage:nil];
    [vc.detailGetRequest setType:model.type.intValue];
    [vc.detailGetRequest setTid:model.tuanId.intValue];
    [[MINavigator navigator]openPushViewController:vc animated:YES];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
