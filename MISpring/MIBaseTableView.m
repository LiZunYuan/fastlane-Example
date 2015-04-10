//
//  MIBaseTableView.m
//  MISpring
//
//  Created by husor on 14-11-7.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MIBaseTableView.h"
#import "MITuanItemModel.h"
#import "MITuanItemsCell.h"
#import "MITuanTenGetModel.h"
#import "MIAdService.h"
#import "MITuanHeaderView.h"

@interface MIBaseTableView()<UITableViewDataSource,UITableViewDelegate,EGORefreshTableHeaderDelegate,MIOverlayStatusViewDelegate>
{
    NSInteger _tuanTenPageSize;
    NSInteger _currentPage;
    NSInteger _currentCount;
    float _buttomPullDistance;
    float _lastscrollViewOffset;
    
    MITuanHeaderView *_tuanHeaderView;
    MITopAdView *_topAdView;
}

@end

@implementation MIBaseTableView

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    _tableView.frame = CGRectMake(0, 0, self.viewWidth, self.viewHeight);
    _goTopView.top = frame.size.height - 45;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        _buttomPullDistance = 50.0;
        _tuanTenPageSize = 20;
        _lastscrollViewOffset = 0;
        _overlayView = [[MIOverlayStatusView alloc] initWithFrame:CGRectMake(0, 0, self.viewWidth, self.viewHeight)];
        _overlayView.delegate = self;
        [self addSubview:_overlayView];
        
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.viewWidth, self.viewHeight) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self addSubview:_tableView];
        _tableView.alpha = 0;
        
        _tuanHotItems = [[NSMutableArray alloc] init];
        _modelArray = [[NSMutableArray alloc] init];
        
        _refreshTableView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, -104, self.viewWidth, 104)];
        _refreshTableView.delegate = self;
        [_tableView addSubview:_refreshTableView];
        
        //返回顶部
        self.goTopView = [[MIGoTopView alloc] initWithFrame:CGRectMake(self.viewWidth - 50, frame.size.height- 45, MISCROLL_TO_TOP_HEIGHT, MISCROLL_TO_TOP_HEIGHT)];
        self.goTopView.delegate = self;
        self.goTopView.hidden = YES;;
        [self addSubview:self.goTopView];
        [self bringSubviewToFront:self.goTopView];
        
        _tuanHeaderView = [[MITuanHeaderView alloc]initWithFrame:CGRectMake(0, 0, self.viewWidth, 50 + 206 + 87)];
        _tuanHeaderView.clipsToBounds = YES;
    }

    return self;
}
- (void)finishLoadTableViewData:(id)model
{
    [self finishLoadTableViewData:model needReload:YES];
}

- (void)finishLoadTableViewData:(id)model needReload:(BOOL)needReload
{
    _model = model;
    [self.overlayView setOverlayStatus:MIOverlayStatusRemove labelText:nil];
    if (self.loading) {
        self.loading = NO;
        [self finishLoadTableViewData];
    }
    
    NSInteger page = 0;
    NSInteger count = 0;
    NSArray *items = nil;
    
    if ([model isKindOfClass:[MITuanTenGetModel class]])
    {
        MITuanTenGetModel *getModel = (MITuanTenGetModel *)model;
        page = getModel.page.integerValue;
        count = getModel.count.integerValue;
        items = getModel.tuanItems;
        [_tuanHotItems removeAllObjects];
        [_tuanHotItems addObjectsFromArray:getModel.tuanHotItems];
        _tuanHotTag = getModel.tuanHotTag;
    }
    else
    {
        MITemaiGetModel *getModel = (MITemaiGetModel *)model;
        page = getModel.page.integerValue;
        count = getModel.count.integerValue;
        items = getModel.tuanItems;
    }
    
    _currentPage = page;
    if (_currentPage == 1)
    {
        _hasMore = NO;
        [_modelArray removeAllObjects];
    }
    
    self.totalCount = count;
    [_modelArray addObjectsFromArray:items];
    if (_modelArray.count != 0) {
        if (count > _modelArray.count && items.count)
        {
            _hasMore = YES;
        }
        else
        {
            _hasMore = NO;
        }
        _tableView.alpha = 1;
    }
    else {
        [self.overlayView setOverlayStatus:EOverlayStatusEmpty labelText:nil];
        _tableView.alpha = 0;
    }
    if (needReload) {
        [self.tableView reloadData];
    }
}

- (void)willAppearView
{
    self.tableView.scrollsToTop = YES;
    if (_modelArray.count == 0) {
        self.loading = YES;
        [self.overlayView setOverlayStatus:MIOverlayStatusLoading labelText:nil];
        [self performSelector:@selector(refreshData) withObject:nil afterDelay:0.02];
    } else {
        _tableView.alpha = 1;
        [self.tableView reloadData];
    }
    
    __weak typeof(self) weakSelf = self;
    [[MIAdService sharedManager]loadAdWithType:@[@(TenYuan_Banners),@(YouPin_Banners),@(Tenyuan_Shortcuts),@(Youpin_Shortcuts),@(Muying_Banners)] block:^(MIAdsModel *model) {
        
        if ([weakSelf.catId isEqualToString:@"all"]) {
            // 顶通 & 快捷入口
            if ([weakSelf.subject isEqualToString:@"10yuan"]) {
                _tuanHeaderView.adsArray = model.tenyuanBanners;
                _tuanHeaderView.topAdView.clickEventLabel = k10YuanTopAds;
                _tuanHeaderView.baokuanLabel.text = @"今日爆款";
                _tuanHeaderView.shortcuts = model.tenyuanShortcuts;
            } else if ([weakSelf.subject isEqualToString:@"youpin"]) {
                _tuanHeaderView.adsArray = model.youpinBanners;
                _tuanHeaderView.topAdView.clickEventLabel = kYoupinTopAds;
                _tuanHeaderView.baokuanLabel.text = @"今日必抢";
                _tuanHeaderView.shortcuts = model.youpinShortcuts;
            }
            
            // 爆款推荐
            _tuanHeaderView.tuanHotTag = weakSelf.tuanHotTag;
            _tuanHeaderView.hotItems = weakSelf.tuanHotItems;
            
            [_tuanHeaderView refreshViews];
            
            if (_tuanHeaderView.viewHeight > 0) {
                weakSelf.tableView.tableHeaderView = _tuanHeaderView;
            } else{
                weakSelf.tableView.tableHeaderView = nil;
            }
        } else if ([weakSelf.catId isEqualToString:@"muying"]) {
            if (model.muyingBanners.count > 0) {
                if (_topAdView == nil) {
                    _topAdView = [[MITopAdView alloc]initWithFrame:CGRectMake(0, 0, weakSelf.viewWidth, 50 * model.muyingBanners.count)];
                    _topAdView.adsArray = model.muyingBanners;
                    [_topAdView loadAds];
                }

                weakSelf.tableView.tableHeaderView = _topAdView;
            }else{
                weakSelf.tableView.tableHeaderView = nil;
            }

        }
    }];
}

- (void)willDisappearView
{
    self.tableView.scrollsToTop = NO;
    if (self.loading) {
        self.loading = NO;
        [self finishLoadTableViewData];
        [self.overlayView setOverlayStatus:MIOverlayStatusRemove labelText:nil];
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

- (void)reloadTableViewDataSource:(MIOverlayView *)overView
{
    [self reloadTableViewDataSource];
}

- (void)refreshData {
    _hasMore = NO;
    [_request cancelRequest];
    [self.modelArray removeAllObjects];
    [_tableView reloadData];
    
    self.loading = YES;

    [_request setPage:1];
    [_request setPageSize:_tuanTenPageSize];
    [_request sendQuery];
    [self.overlayView setOverlayStatus:MIOverlayStatusLoading labelText:nil];
}

#pragma mark - Data Source Loading / loading Methods
//开始重新加载时调用的方法
- (void)reloadTableViewDataSource
{
    if (self.loading) {
        [_request cancelRequest];
    }
    
    self.loading = YES;
    if (_modelArray.count > 0) {
        [self.overlayView setOverlayStatus:EOverlayStatusRemove labelText:nil];
    } else {
        [self.overlayView setOverlayStatus:EOverlayStatusLoading labelText:nil];
    }
    
    [_request setPage:1];
    [_request setPageSize:_tuanTenPageSize];
    [_request sendQuery];
}
//松开上拉继续加载更多时调用的方法
- (void)loadingMoreTableViewDataSource:(BOOL)load
{
    if (load ==YES) {
        [self loadMoreTableViewDataSource];
    }
    
}
//上拉继续加载更多时调用的方法
- (void)loadMoreTableViewDataSource
{
    if (([_modelArray count] != 0) && _hasMore) {
        //只有当前有数据的前提下才会触发加载更多
        self.loading = YES;
        [_request setPage:++_currentPage];
        [_request sendQuery];
        [_tableView reloadData];
    }
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

//下拉刷新
#pragma mark - EGOPullFresh methods
-(NSString *)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView *)view
{
    //子类可重载
    NSString *header;
    NSInteger random = arc4random();
    if (random % 2) {
        header = @"特卖天天有，10元就购了";
    } else {
        header = @"限时特卖，每天十点上新";
    }
    return header;
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
    NSInteger count = _modelArray.count;
    NSInteger rows = [self tableView:tableView numberOfRowsInSection:0] - 1;
    
    
    if (_hasMore && (count > 0) && (indexPath.row == rows) && !self.loading) {
        self.loading = YES;
        [_request setPage:(self.modelArray.count / _tuanTenPageSize + 1)];
        [_request setPageSize:_tuanTenPageSize];
        [_request sendQuery];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = [_modelArray count];
    if (count == 0) {
        return 0;
    }
    
    NSInteger number = count / 2 + count % 2;
    return number;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger count = [_modelArray count];
    NSInteger rows = [self tableView:tableView numberOfRowsInSection:0] - 1;
    
    if (_hasMore && (indexPath.row == rows) && (count > 0)) {
        return 50;
    } else {
        return 196 + 8;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger count = [_modelArray count];
    NSInteger rows = [self tableView:tableView numberOfRowsInSection:0] - 1;
    
    static NSString *ContentIdentifier = @"TuanItemsCellReuseIdentifier";
    static NSString *LoadMoreIdentifier = @"LoadMoreCellReuseIdentifier";
    if (_hasMore && (count > 0) && (indexPath.row == rows)) {
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
    } else {
        MITuanItemsCell *tuanItemsCell = [tableView dequeueReusableCellWithIdentifier:ContentIdentifier];
        if (!tuanItemsCell) {
            tuanItemsCell = [[MITuanItemsCell alloc] initWithreuseIdentifier:ContentIdentifier];
            tuanItemsCell.selectionStyle = UITableViewCellSelectionStyleNone;
            tuanItemsCell.backgroundColor = [UIColor clearColor];
        }
        
        for (NSInteger i = indexPath.row*2; i < (indexPath.row + 1) * 2; i ++) {
            @try {
                id model = [_modelArray objectAtIndex:i];
                if (i == indexPath.row*2) {
                    tuanItemsCell.itemView1.hidden = NO;
                    tuanItemsCell.itemView1.type = MITuanNormal;
                    [self updateCellView:tuanItemsCell.itemView1 tuanModel:model];
                } else {
                    tuanItemsCell.itemView2.hidden = NO;
                    tuanItemsCell.itemView2.type = MITuanNormal;
                    [self updateCellView:tuanItemsCell.itemView2 tuanModel:model];
                }
            }
            @catch (NSException *exception) {
                if (i == indexPath.row*2) {
                    tuanItemsCell.itemView1.hidden = YES;
                } else {
                    tuanItemsCell.itemView2.hidden = YES;
                }
            }
        }
        
        return tuanItemsCell;
    }
}

//刷新产品的cell
- (void)updateCellView:(MITuanItemView *)view tuanModel:(MITuanItemModel *)model
{
    static BOOL timerIsFired = NO;
    
    view.item = model;
    view.cat = self.cat;
    [view.indicatorView startAnimating];
    
    //是否新品
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:model.startTime.doubleValue];
    if (0 == [date compareWithToday])
    {
        view.icNewImgView.hidden = NO;
        view.description.left = view.icNewImgView.right + 4;
        view.description.viewWidth = view.viewWidth - view.icNewImgView.right - 4 - 8;
    }
    else
    {
        view.icNewImgView.hidden = YES;
        view.description.left = 8;
        view.description.viewWidth = view.viewWidth - 16;
    }
    
    if (model.type.integerValue == BBMartshow || model.type.integerValue == BBTuan) {
        NSMutableString *imgUrl = [NSMutableString stringWithString:model.img];
        [imgUrl appendString:@"!320x320.jpg"];
        [view.itemImage sd_setImageWithURL:[NSURL URLWithString:imgUrl]];
    }else{
        NSMutableString *imgUrl = [NSMutableString stringWithString:model.img];
        [imgUrl appendString:@"_310x310.jpg"];
        [view.itemImage sd_setImageWithURL:[NSURL URLWithString:imgUrl]];
    }
    
    if (model.type.integerValue == MIBrand)
    {
        view.temaiImageView.hidden = NO;
        view.temaiImageView.image = [UIImage imageNamed:@"ic_frompinpai"];
        view.viewsInfo.text = model.discount.discountValue;
        view.viewsInfo.textColor = [MIUtility colorWithHex:0x999999];
        view.statusImage.hidden = YES;
        view.price.textColor = [MIUtility colorWithHex:0xff3d00];
    } else {
        if (model.type.integerValue == BBTuan || model.type.integerValue == BBMartshow) {
            view.temaiImageView.hidden = NO;
            view.temaiImageView.image = [UIImage imageNamed:@"img_mark_beibei"];
        }else{
            view.temaiImageView.hidden = YES;
        }
        double nowInterval = [[NSDate date] timeIntervalSince1970] + [MIConfig globalConfig].timeOffset;
        double interval = model.startTime.doubleValue - nowInterval;
        if (interval > 0) {
            view.statusImage.hidden = YES;
            view.price.textColor = [MIUtility colorWithHex:0xff3d00];
            view.viewsInfo.textColor = [MIUtility colorWithHex:0x8dbb1a];
            view.viewsInfo.text = [[NSDate dateWithTimeIntervalSince1970:model.startTime.doubleValue] stringForTimeTips2];
            if (timerIsFired == NO) {
                [NSTimer scheduledTimerWithTimeInterval:++interval target:self selector:@selector(reloadTableViewForSale) userInfo:nil repeats:NO];
                timerIsFired = YES;
            }
        } else {
            NSDate *endTime = [NSDate dateWithTimeIntervalSince1970:model.endTime.doubleValue];
            NSInteger intervalEndTime = [endTime timeIntervalSinceNow];
            if (intervalEndTime <= 0) {
                view.viewsInfo.text = @"已结束";
                view.viewsInfo.textColor = [UIColor grayColor];
                view.price.textColor = [MIUtility colorWithHex:0x999999];
                view.statusImage.hidden = NO;
                view.statusImage.image = [UIImage imageNamed:@"ic_timeout"];
            } else {
                if (model.status.integerValue != 1) {
                    //商品已售空
                    view.viewsInfo.text = @"抢光了";
                    view.viewsInfo.textColor = [MIUtility colorWithHex:0x999999];
                    view.price.textColor = [MIUtility colorWithHex:0x999999];
                    view.statusImage.hidden = NO;
                    view.statusImage.image = [UIImage imageNamed:@"ic_sellout"];
                } else {
                    NSString *clickColumn;
                    float clicksVolumn = model.clicks.floatValue + model.volumn.floatValue;
                    if (clicksVolumn >= 10000.0) {
                        clickColumn = [[NSString alloc] initWithFormat:@"%.1f万人在抢", clicksVolumn / 10000.0];
                    } else {
                        clickColumn = [[NSString alloc] initWithFormat:@"%.f人在抢", clicksVolumn];
                    }
                    view.viewsInfo.text = clickColumn;
                    view.viewsInfo.textColor = [MIUtility colorWithHex:0x999999];
                    view.statusImage.hidden = YES;
                    view.price.textColor = [MIUtility colorWithHex:0xff3d00];
                }
            }
        }
    }
    
    NSString *decimal = model.price.pointValue;
    view.price.text = [[NSString alloc] initWithFormat:@"<font size=12.0>￥</font><font size=15.0>%ld</font><font size=12.0>%@</font>", (long)model.price.integerValue / 100, decimal];
    NSString *desc = [model.title stringByReplacingOccurrencesOfString:@"【" withString:@"["];
    desc = [desc stringByReplacingOccurrencesOfString:@"，" withString:@","];
    view.description.text = [desc stringByReplacingOccurrencesOfString:@"】" withString:@"]"];
    
    if (model.labelImg)
    {
        view.labelImageView.hidden = NO;
        [view.labelImageView sd_setImageWithURL:[NSURL URLWithString:model.labelImg]];
    }
    else
    {
        view.labelImageView.hidden = YES;
    }
    
}

- (void)reloadTableViewForSale
{
    [_tableView reloadData];
    MILog(@"timer is fired for sale");
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
