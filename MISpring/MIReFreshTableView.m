//
//  BBFreshTableView.m
//  BeiBeiAPP
//
//  Created by yujian on 14-11-19.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MIReFreshTableView.h"

@interface MIReFreshTableView()<EGORefreshTableHeaderDelegate>
{
    NSInteger _currentPage;
    NSInteger _currentCount;
    float _buttomPullDistance;
}

@end

@implementation MIReFreshTableView

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.backgroundColor = [MIUtility colorWithHex:0xf2f2f2];
        _overlayView = [[MIOverlayStatusView alloc] initWithFrame:CGRectMake(0, 0, self.viewWidth, self.viewHeight)];
        _overlayView.delegate = self;
        [self addSubview:_overlayView];
        _buttomPullDistance = 50.0;
        _modelArray = [[NSMutableArray alloc] init];
        _refreshTableView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, -104, self.viewWidth, 104)];
        _refreshTableView.delegate = self;
         [self addSubview:_refreshTableView];
        self.loading = NO;
        
        UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.viewWidth, 5)];
        footView.backgroundColor = [MIUtility colorWithHex:0xf2f2f2];
        self.tableFooterView = footView;
    }
    return self;
}

- (void)reloadTableViewDataSource:(MIOverlayStatusView *)overView
{
    [self reloadTableViewDataSource];
}

//开始重新加载时调用的方法
- (void)reloadTableViewDataSource
{
    
    self.loading = YES;
    if (_modelArray.count > 0) {
        [self.overlayView setOverlayStatus:EOverlayStatusRemove labelText:nil];
    } else {
        [self.overlayView setOverlayStatus:EOverlayStatusLoading labelText:nil];
    }

    if (_freshDelegate && [_freshDelegate respondsToSelector:@selector(sendFirstPageRequest)])
    {
        [_freshDelegate sendFirstPageRequest];
    }
}

//松开上拉继续加载更多时调用的方法
- (void)loadingMoreTableViewDataSource:(BOOL)load
{
    // 子类实现
    
}
//上拉继续加载更多时调用的方法
- (void)loadMoreTableViewDataSource
{
    // 子类实现
    
}

//完成加载时调用的方法
- (void)finishLoadTableViewData:(NSInteger)currentPage dataSource:(NSArray *)dataSource totalCount:(NSNumber *)totalCount
{
    [self.overlayView setOverlayStatus:EOverlayStatusRemove labelText:nil];
    if (self.loading) {
        self.loading = NO;
    }
    self.currentPage = currentPage;
    if (self.currentPage == 1)
    {
        self.hasMore = NO;
        [self.modelArray removeAllObjects];
    }
    
    self.currentCount += dataSource.count;
    [self.modelArray addObjectsFromArray:dataSource];
    if (self.modelArray.count != 0) {
        if (totalCount.integerValue > self.currentCount)
        {
            self.hasMore = YES;
        }
        else
        {
            self.hasMore = NO;
        }
        self.alpha = 1;
        [self reloadData];
    }
    else
    {
        self.alpha = 0;
        [self.overlayView setOverlayStatus:EOverlayStatusEmpty labelText:nil];
    }

}

- (void)failLoadTableViewData
{
    [_refreshTableView egoRefreshScrollViewDataSourceDidFinishedLoading:self];
    [self.overlayView setOverlayStatus:EOverlayStatusRemove labelText:nil];
    
    if (self.loading) {
        self.loading = NO;
    }
    
    if (_modelArray.count == 0) {
        [self.overlayView setOverlayStatus:EOverlayStatusReload labelText:nil];
    }
}

//下拉刷新
#pragma mark - EGOPullFresh methods
-(NSString *)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView *)view
{
    //子类可重载
    return [NSString stringWithFormat:@"最后更新: %@", [[NSDate date] stringForSectionTitle3]];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_refreshTableView egoRefreshScrollViewDidScroll:scrollView];
    
    //上拉刷新
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.bounds;
    CGSize size = scrollView.contentSize;
    UIEdgeInsets inset = scrollView.contentInset;
    float y = offset.y + bounds.size.height - inset.bottom;
    if((y > size.height + _buttomPullDistance) && !_loading) {
        [self loadingMoreTableViewDataSource:YES];
    } else {
        [self loadingMoreTableViewDataSource:NO];
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_refreshTableView egoRefreshScrollViewDidEndDragging:scrollView];
    
    //上拉刷新
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.bounds;
    CGSize size = scrollView.contentSize;
    UIEdgeInsets inset = scrollView.contentInset;
    float y = offset.y + bounds.size.height - inset.bottom;
    if((y > size.height + _buttomPullDistance) && !_loading) {
        [self loadMoreTableViewDataSource];
    }
}

#pragma mark - EGORefreshTableHeaderDelegate Methods
//下拉被触发调用的委托方法
-(void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view
{
    [self reloadTableViewDataSource];
}

//返回当前是刷新还是无刷新状态
-(BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView *)view
{
    return _loading;
}

#pragma mark - UITableViewDataSource

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger count = self.modelArray.count;
    NSInteger rows = [self tableView:tableView numberOfRowsInSection:0] - 1;
    
    if (_hasMore && (count > 0) && (indexPath.row == rows) && !self.loading) {
        self.loading = YES;
        if (self.freshDelegate && [self.freshDelegate respondsToSelector:@selector(sendNextPageRequest)])
        {
            [_freshDelegate sendNextPageRequest];
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //子类重载
    return self.modelArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *LoadMoreIdentifier = @"LoadMoreCellReuseIdentifier";
    NSInteger rows = [self tableView:tableView numberOfRowsInSection:0] - 1;
    if (self.hasMore && (self.modelArray.count > 0) && (indexPath.row == rows)) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LoadMoreIdentifier];
        if(!cell){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LoadMoreIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            
            UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            indicatorView.center = CGPointMake(100, 25);
            indicatorView.tag = 999;
            
            cell.textLabel.textAlignment = UITextAlignmentCenter;
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.textLabel.text = @"加载中...";
            [cell addSubview:indicatorView];
        }
        
        UIActivityIndicatorView *indicatorView = (UIActivityIndicatorView *)[cell viewWithTag:999];
        [indicatorView startAnimating];
        
        return cell;
    }
    return nil;
}

- (void)showSimpleHUD:(NSString *)tip afterDelay:(NSTimeInterval)delay{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = tip;
    hud.margin = 10.f;
    hud.yOffset = -100.f;
    hud.removeFromSuperViewOnHide = YES;
    
    [hud hide:YES afterDelay:delay];
}

@end
