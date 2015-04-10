//
//  MIRefreshBaseTableView.m
//  MISpring
//
//  Created by 曲俊囡 on 15/3/27.
//  Copyright (c) 2015年 Husor Inc. All rights reserved.
//

#import "MIRefreshBaseTableView.h"
#import "EGORefreshTableHeaderView.h"

#define MICATS_VIEW_HEIGHT 40

@interface MIRefreshBaseTableView()<EGORefreshTableHeaderDelegate,MIOverlayStatusViewDelegate>
{
    NSInteger _pageSize;
    UITableView *_tableView;
    NSInteger _currentPage;
    NSInteger _currentCount;
    float _buttomPullDistance;
    float _lastscrollViewOffset;
}
@end

@implementation MIRefreshBaseTableView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _pageSize = 30;
        _currentPage = 1;
        _buttomPullDistance = 50.0;

        _overlayView = [[MIOverlayStatusView alloc] initWithFrame:CGRectMake(0, 0, self.viewWidth, self.viewHeight)];
        _overlayView.delegate = self;
        [self addSubview:_overlayView];
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.viewWidth, self.viewHeight) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self addSubview:_tableView];
        _tableView.alpha = 0;
        
        _modelArray = [[NSMutableArray alloc] init];
        
        _refreshTableView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, -104, self.viewWidth, 104)];
        _refreshTableView.delegate = self;
        [_tableView addSubview:_refreshTableView];
        
        
        //返回顶部
        self.goTopView = [[MIGoTopView alloc] initWithFrame:CGRectMake(self.viewWidth - 50, _tableView.bottom - 10 - 40, 40, 40)];
        self.goTopView.hidden = YES;
        self.goTopView.delegate = self;
        [self addSubview:_goTopView];
        
        self.tableView.backgroundColor = MINormalBackgroundColor;
    }
    return self;
}

- (void)willAppearView
{
    self.tableView.scrollsToTop = YES;
}

- (void)willDisappearView
{
    self.tableView.scrollsToTop = NO;
}

- (void)cancelRequest
{
    
}

- (void)reloadTableViewDataSource:(MIOverlayView *)overView
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
    
    if (_refreshDelegate && [_refreshDelegate respondsToSelector:@selector(sendFirstPageRequest)])
    {
        [_refreshDelegate sendFirstPageRequest];
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

- (void)finishLoadTableViewData:(NSInteger)currentPage dataSource:(NSArray *)dataSource totalCount:(NSNumber *)totalCount reloadData:(BOOL)needReload
{
    [self.refreshTableView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
    [self.overlayView setOverlayStatus:EOverlayStatusRemove labelText:nil];
    if (self.loading) {
        self.loading = NO;
    }
    
    if (currentPage == 1)
    {
        self.hasMore = YES;
        self.currentCount = 0;
        [self.modelArray removeAllObjects];
    }
    
    if (dataSource.count > 0 && [dataSource isKindOfClass:[NSArray class]]) {
        id<NSObject> dataFirst = [dataSource objectAtIndex:0];
        id<NSObject> dataLast = [self.modelArray lastObject];
        if (dataLast && [dataFirst isEqual:dataLast]) {
            // 去除相邻两个重复的情况
            [self.modelArray removeLastObject];
            [self.modelArray addObjectsFromArray:dataSource];
            self.currentCount += dataSource.count - 1;
        } else {
            self.currentCount += dataSource.count;
            [self.modelArray addObjectsFromArray:dataSource];
        }
        
        self.currentPage = currentPage;
    } else {
        _hasMore = NO;
    }
    
    if (self.modelArray.count != 0) {
        if (totalCount.integerValue > self.currentCount && dataSource.count > 0)
        {
            self.hasMore = YES;
        }
        else
        {
            self.hasMore = NO;
        }
        self.tableView.alpha = 1;
        if (needReload) {
            [self.tableView reloadData];
        }
    }
    else
    {
        self.tableView.alpha = 0;
        [self.overlayView setOverlayStatus:EOverlayStatusEmpty labelText:self.emptyDesc];
    }
}

//完成加载时调用的方法
- (void)finishLoadTableViewData:(NSInteger)currentPage dataSource:(NSArray *)dataSource totalCount:(NSNumber *)totalCount
{
    [self finishLoadTableViewData:currentPage dataSource:dataSource totalCount:totalCount reloadData:YES];
}

//完成加载时调用的方法
- (void)finishLoadTableViewData
{
    [_refreshTableView egoRefreshScrollViewDataSourceDidFinishedLoading:_tableView];
}

- (void)failLoadTableViewData
{
    [_refreshTableView egoRefreshScrollViewDataSourceDidFinishedLoading:_tableView];
    [self.overlayView setOverlayStatus:EOverlayStatusRemove labelText:nil];
    
    if (self.loading) {
        self.loading = NO;
    }
    
    if (_modelArray.count == 0) {
        [self.overlayView setOverlayStatus:EOverlayStatusReload labelText:nil];
    }
}

//下拉刷新MINormalBackgroundColor
#pragma mark - EGOPullFresh methMINormalBackgroundColorods
//-(NSString *)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView *)view
//{
//    //子类可重载
//    NSString *header;
//    NSInteger random = arc4random();
//    if (random % 2) {
//        header = @"特卖天天有，下单就包邮";
//    } else {
//        header = @"限时特卖，每天十点上新";
//    }
//    return header;
//}

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
        if (self.refreshDelegate && [self.refreshDelegate respondsToSelector:@selector(sendNextPageRequest)])
        {
            [_refreshDelegate sendNextPageRequest];
        }
    }
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

#pragma mark - UIScrollViewDelegate Methods
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
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
    
    [self makeGoTopView:scrollView];
}

- (void)goTopViewClicked
{
    [_tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    self.goTopView.hidden= YES;
}

- (void)makeGoTopView:(UIScrollView *)scrollView
{
    CGFloat y = scrollView.contentOffset.y;
    if (y < _lastscrollViewOffset - 15 || y <= 38) {
        [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
            if (y > self.viewHeight - 45)
            {
                self.goTopView.hidden= NO;
            }
            else
            {
                self.goTopView.hidden= YES;
            }
        } completion:^(BOOL finished){
        }];
    } else if (y > _lastscrollViewOffset + 5 && y > 0){
        [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.goTopView.hidden= YES;
        } completion:^(BOOL finished){
        }];
    }
    
    if (y < _lastscrollViewOffset - 15) {
        [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
            if (y > self.viewHeight - 45)
            {
                self.goTopView.hidden= NO;
            }
            else
            {
                self.goTopView.hidden= YES;
            }
        } completion:^(BOOL finished){
        }];
    }
    
    _lastscrollViewOffset = y;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
