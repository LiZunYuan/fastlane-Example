//
//  MIBrandBaseTableVIew.m
//  MISpring
//
//  Created by husor on 14-12-16.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MIBrandTableView.h"
#import "MIBrandItemModel.h"
#import "MIItemModel.h"
#import "MIBrandCell.h"
#import "MIBrandTuanItemCell.h"
#import "MIBrandViewController.h"
#import "MIBBBrandViewController.h"
#import "MIAdService.h"
#import "MITopAdView.h"

@interface MIBrandTableView()<UITableViewDataSource,UITableViewDelegate,MIOverlayStatusViewDelegate>
{
    NSInteger _tuanTenPageSize;
    UITableView *_tableView;
    NSInteger _currentPage;
    NSInteger _currentCount;
    float _buttomPullDistance;
    float _lastscrollViewOffset;
    NSInteger _newItemInteger;

}

@property (nonatomic, strong) MITopAdView *topAdView;
@end


@implementation MIBrandTableView
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
        
        _topAdView = [[MITopAdView alloc]initWithFrame:CGRectMake(0, 0, self.viewWidth, 50)];
        _topAdView.clickEventLabel = kBrandTopAds;
        _topAdView.hidden = YES;
        
        _modelArray = [[NSMutableArray alloc] init];
        
        _refreshTableView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, -104, self.viewWidth, 104)];
        _refreshTableView.delegate = self;
        [_tableView addSubview:_refreshTableView];
        
        //返回顶部
        self.goTopView = [[MIGoTopView alloc] initWithFrame:CGRectMake(self.viewWidth - 50, frame.size.height- 45, MISCROLL_TO_TOP_HEIGHT, MISCROLL_TO_TOP_HEIGHT)];
        self.goTopView.delegate = self;
        self.goTopView.hidden = YES;
        [self addSubview:self.goTopView];
        [self bringSubviewToFront:self.goTopView];
        
        __weak typeof(self) weakSelf = self;
        _request = [[MIPageBaseRequest alloc] init];
        _request.onCompletion = ^(MITuanBrandGetModel *model) {
            [weakSelf finishLoadTableViewData:model];
        };
        
        _request.onError = ^(MKNetworkOperation* completedOperation, MIError* error) {
            [weakSelf failLoadTableViewData];
        };        
    }
    return self;
}

- (void)finishLoadTableViewData:(id)model
{
    _model = model;
    [self.overlayView setOverlayStatus:MIOverlayStatusRemove labelText:nil];
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date]
                                              forKey:kLastUpdateBrandTime];
    [[NSUserDefaults standardUserDefaults] synchronize];

    if (self.loading) {
        self.loading = NO;
        [self finishLoadTableViewData];
    }
    
    NSInteger page = 0;
    NSInteger count = 0;
    NSArray *items = nil;
    
    MITuanBrandGetModel *getModel = (MITuanBrandGetModel *)model;
    page = getModel.page.integerValue;
    count = getModel.count.integerValue;
    items = getModel.brandItems;
    
    _currentPage = page;
    if (_currentPage == 1)
    {
        _hasMore = NO;
        [_modelArray removeAllObjects];
    }
    
    self.totalCount = count;
    [_modelArray addObjectsFromArray:items];
    [ self calculateRows:_modelArray];
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
    [self.tableView reloadData];
}

- (void)willAppearView
{
    self.tableView.scrollsToTop = YES;
    if (_modelArray.count == 0) {
        self.loading = YES;
        [self.overlayView setOverlayStatus:MIOverlayStatusLoading labelText:nil];
        [self performSelector:@selector(refreshData) withObject:nil afterDelay:0.02];
    } else {
        [self.tableView reloadData];
    }
    
    __weak typeof(self) weakSelf = self;
    [[MIAdService sharedManager]loadAdWithType:@[@(Brand_Banners),@(Muying_Banners)] block:^(MIAdsModel *model) {
        
        if ([weakSelf.catId isEqualToString:@"muying"] ) {
            if (model.muyingBanners.count > 0) {
                _topAdView.adsArray = model.muyingBanners;
                _topAdView.hidden = NO;
                [_topAdView loadAds];
                weakSelf.tableView.tableHeaderView = _topAdView;
            }else{
                _topAdView.hidden = YES;
                weakSelf.tableView.tableHeaderView = nil;
            }
        } else if ([weakSelf.catId isEqualToString:@"all"] ) {
            if (model.brandBanners.count > 0) {
                _topAdView.adsArray = model.brandBanners;
                _topAdView.hidden = NO;
                [_topAdView loadAds];
                weakSelf.tableView.tableHeaderView = _topAdView;
            }else{
                _topAdView.hidden = YES;
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
    
    self.loading = YES;
    
    [_request setPage:1];
    [_request setPageSize:_tuanTenPageSize];
    [_request sendQuery];
    [self.overlayView setOverlayStatus:MIOverlayStatusLoading labelText:nil];
     [_tableView reloadData];
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
//    [_request setCat:self.cat];
    [_request setPageSize:_tuanTenPageSize];
    [_request sendQuery];
}

//松开上拉继续加载更多时调用的方法
- (void)loadingMoreTableViewDataSource:(BOOL)load
{
    if (load == YES) {
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
    return @"独家精选大牌，全场1折起";
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

- (void)calculateRows:(NSArray *)modelArray
{
    if (modelArray.count > 0) {
        _newItemInteger = 0;
        if (![self.cat isEqualToString:@"all"]) {
            _newItemInteger = modelArray.count;
            return;
        }
        
        MIBrandItemModel *model = [modelArray objectAtIndex:0];
        NSNumber *startTime1 = [NSNumber numberWithInteger:[model.startTime integerValue]];
    
        for (int i = 1; i < modelArray.count; i++)
        {
            MIBrandItemModel *brandModel = [modelArray objectAtIndex:i];
            NSNumber *startTime2 = [NSNumber numberWithInteger:[brandModel.startTime integerValue]];
            if(![startTime1  isSameDay: startTime2])
            {
                _newItemInteger = i;
                break;
            }
        }
        
        if (_newItemInteger == 0 ) {
            _newItemInteger = modelArray.count;
        }
        
        if (_newItemInteger < modelArray.count) {
            // 奇数个时，补齐
            if (_newItemInteger % 2 == 1) {
                _newItemInteger += 1;
            }
            
            // 最多上新样式显示50个
            if (_newItemInteger < 50) {
                _newItemInteger = (modelArray.count > 50 ? 50 : modelArray.count);
            }
        }
    }
}


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
    NSInteger rows = 0;
    if (self.modelArray.count > _newItemInteger)
    {
        rows = (self.modelArray.count - _newItemInteger  + 1) / 2;
    }
    NSInteger tableRows = rows + _newItemInteger;
    
    if (_hasMore == NO) {
        return tableRows;
    } else {
        //加1是因为还有显示更早上新row和加载更多row
        return tableRows + 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger count = [self.modelArray count];
    NSInteger rows = [self tableView:tableView numberOfRowsInSection:0] - 1;
    if (_hasMore && (indexPath.row == rows) && (count > 0))
    {
        return 50;
    }
    else
    {
        if (indexPath.row > _newItemInteger ) {
            return   ((SCREEN_WIDTH - 24) / 2) + 40 + 8;
        }
        if (indexPath.row == _newItemInteger) {
            return  40;
        }
        else{
            return ((SCREEN_WIDTH - 20) / 2) + 46.5 + 8;
        }
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger count = [_modelArray count];
    NSInteger rows = [self tableView:tableView numberOfRowsInSection:0] - 1;
    
    static NSString *brandIdentifier = @"brandCellReuseIdentifier";
    static NSString *LoadMoreIdentifier = @"LoadMoreCellReuseIdentifier";
    static NSString *oldBrandIdentifier = @"oldBrandIdentifier";
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
    }
    else
    {
        if (indexPath.row < _newItemInteger) {
            MIBrandCell *brandCell = [tableView dequeueReusableCellWithIdentifier:brandIdentifier];
            if (!brandCell)
            {
                brandCell = [[MIBrandCell alloc] initWithReuseIdentifier:brandIdentifier];
                brandCell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            if (self.modelArray.count > indexPath.row) {
                MIBrandItemModel *brandModel = (MIBrandItemModel *)[self.modelArray objectAtIndex:indexPath.row];
                brandCell.itemModel = brandModel;
                [brandCell.shopImageView sd_setImageWithURL:[NSURL URLWithString:brandModel.logo] placeholderImage:[UIImage imageNamed:@"mizhewang_logo"]];
                brandCell.shopNameLabel.text = brandModel.sellerNick;
                CGSize size = [brandCell.shopNameLabel.text sizeWithFont:brandCell.shopNameLabel.font];
                brandCell.shopNameLabel.viewWidth = size.width;
                brandCell.lastImageView.left = brandCell.shopNameLabel.right + 4;
                
                brandCell.discountLabel.text = [NSString stringWithFormat:@"%.1f 折起",brandModel.discount.intValue / 10.0];
                brandCell.retainNumLabel.text = [NSString stringWithFormat:@"共%d件",brandModel.goodsCount.intValue];
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:brandModel.startTime.doubleValue];
                if ([date compareWithToday2]) {
                    brandCell.lastImageView.hidden = NO;
                } else {
                    brandCell.lastImageView.hidden = YES;
                }
                
                if (brandModel.items.count > 2) {
                    MIItemModel *item0 = [brandModel.items objectAtIndex:0];
                    NSString *imgUrl0 = @"";
                    if (brandModel.type.integerValue == BBMartshowItem) {
                        imgUrl0 = [NSString stringWithFormat:@"%@!320x320.jpg",item0.img];
                    }else{
                        imgUrl0 = [NSString stringWithFormat:@"%@_310x310.jpg",item0.img];
                    }
                    [brandCell.leftView.imageView sd_setImageWithURL:[NSURL URLWithString:imgUrl0] placeholderImage:[UIImage imageNamed:@"img_loading_daily1"]];
                    brandCell.leftView.priceLabel.text = [NSString stringWithFormat:@"%@", item0.price.priceValue];
                    
                    MIItemModel *item1 = [brandModel.items objectAtIndex:1];
                    NSString *imgUrl1 = @"";
                    if (brandModel.type.integerValue == BBMartshowItem) {
                        imgUrl1 = [NSString stringWithFormat:@"%@!160x160.jpg",item1.img];
                    }else{
                        imgUrl1 = [NSString stringWithFormat:@"%@_310x310.jpg",item1.img];
                    }
                    [brandCell.rightView.imageView sd_setImageWithURL:[NSURL URLWithString:imgUrl1] placeholderImage:[UIImage imageNamed:@"img_loading_daily1"]];
                    brandCell.rightView.priceLabel.text = [NSString stringWithFormat:@"%@", item1.price.priceValue];
                    [brandCell startTimer];
                }
                
            }
            return brandCell;
        }
        else {
            MIBrandTuanItemCell *oldBrandCell = nil;
            if (indexPath.row == _newItemInteger) {
                oldBrandCell = [[MIBrandTuanItemCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"fengQiang"];
                oldBrandCell.selectionStyle = UITableViewCellSelectionStyleNone;
                oldBrandCell.backgroundColor = [UIColor clearColor];
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 18, SCREEN_WIDTH, 12)];
                label.textAlignment = UITextAlignmentCenter;
                label.font = [UIFont systemFontOfSize:12.0];
                label.text = @"最后疯抢倒计时";
                label.backgroundColor = [UIColor clearColor];
                [oldBrandCell addSubview:label];
                
                UIView *leftLine = [[UIView alloc] initWithFrame:CGRectMake(20, 24, 80, 1)];
                leftLine.backgroundColor = [MIUtility colorWithHex:0x999999];
                [oldBrandCell addSubview:leftLine];
                
                UIView *rightLine = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 20 - 80, 24, 80, 1)];
                rightLine.backgroundColor = [MIUtility colorWithHex:0x999999];
                [oldBrandCell addSubview:rightLine];
                
                oldBrandCell.itemView1.top = label.bottom;
                oldBrandCell.itemView2.top = label.bottom;
            }
            else{
                oldBrandCell = [tableView dequeueReusableCellWithIdentifier:oldBrandIdentifier];
                if (!oldBrandCell) {
                    oldBrandCell = [[MIBrandTuanItemCell alloc]initWithReuseIdentifier:oldBrandIdentifier];
                    oldBrandCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    oldBrandCell.backgroundColor = [UIColor clearColor];
                }
                NSInteger oldMartshowCount = indexPath.row - _newItemInteger -1;
                
                for (NSInteger i = oldMartshowCount*2; i < (oldMartshowCount + 1) * 2; i ++) {
                    @try {
                        MIBrandItemModel *brandModel = (MIBrandItemModel *)[self.modelArray objectAtIndex:i + _newItemInteger ];
                        if (i == oldMartshowCount*2) {
                            oldBrandCell.itemView1.hidden = NO;
                            oldBrandCell.itemView1.brandModel = brandModel;
                            [self updateCellView:oldBrandCell.itemView1 brandModel:brandModel];
                        } else {
                            oldBrandCell.itemView2.hidden = NO;
                            oldBrandCell.itemView2.brandModel = brandModel;
                            [self updateCellView:oldBrandCell.itemView2 brandModel:brandModel];
                        }
                    }
                    @catch (NSException *exception) {
                        if (i == oldMartshowCount*2) {
                            oldBrandCell.itemView1.hidden = YES;
                        } else {
                            oldBrandCell.itemView2.hidden = YES;
                        }
                    }
                }
            }
            return oldBrandCell;
        }
    }
}

-(void)updateCellView:(MIBrandTuanItemView *)itemView  brandModel:(MIBrandItemModel *)brandModel
{
    [itemView.brandLogo sd_setImageWithURL:[NSURL URLWithString:brandModel.logo] placeholderImage:[UIImage imageNamed:@"mizhewang_logo"]];
    itemView.brandTitle.text = brandModel.sellerNick;
    itemView.discountLabel.text = [NSString stringWithFormat:@"%.1f 折起",brandModel.discount.intValue / 10.0];
    CGSize size = [itemView.discountLabel.text sizeWithFont:[UIFont systemFontOfSize:10] constrainedToSize:CGSizeMake(70, 0)];
    itemView.discountLabel.viewWidth = size.width;
    
    if (brandModel.items.count > 0)
    {
        MIItemModel *item0 = [brandModel.items objectAtIndex:0];
        NSString *imgUrl0 = @"";
        if (brandModel.type.integerValue == BBMartshowItem) {
            imgUrl0 = [NSString stringWithFormat:@"%@!320x320.jpg",item0.img];
            itemView.temaiImgView.hidden = NO;
        }else{
            imgUrl0 = [NSString stringWithFormat:@"%@_310x310.jpg",item0.img];
        }
        [itemView.itemImgView sd_setImageWithURL:[NSURL URLWithString:imgUrl0] placeholderImage:[UIImage imageNamed:@"img_loading_daily1"]];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row != self.modelArray.count && indexPath.row < _newItemInteger && self.modelArray.count > indexPath.row) {
        MIBrandItemModel *brandModel = (MIBrandItemModel *)[self.modelArray objectAtIndex:indexPath.row];
        if (brandModel.type.integerValue == BBMartshowItem) {
            // 跳转贝贝品牌专场
//            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"beibeiapp://"]]) {
//                if (brandModel.iid) {
//                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"beibeiapp://action?target=martshow&mid=%@&iid=%@",brandModel.eventId,brandModel.iid]]];
//                }else{
//                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"beibeiapp://action?target=martshow&mid=%@",brandModel.eventId]]];
//                }
//            }else{
                MIBBBrandViewController *vc = [[MIBBBrandViewController alloc]initWithEventId:brandModel.eventId.integerValue];
                vc.shopNameString = brandModel.sellerNick;
                [[MINavigator navigator]openPushViewController:vc animated:YES];
//            }
        }else{
            MIBrandViewController *vc = [[MIBrandViewController alloc] initWithAid:brandModel.aid.intValue];
            vc.cat = self.cat;
            vc.origin = brandModel.origin.integerValue;
            [[MINavigator navigator] openPushViewController:vc animated:YES];
        }
    }
}


@end
