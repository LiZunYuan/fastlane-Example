//
//  MIYoupinRecommendViewController.m
//  MISpring
//
//  Created by husor on 15-3-26.
//  Copyright (c) 2015年 Husor Inc. All rights reserved.
//

#import "MIYoupinRecommendViewController.h"
#import "MITuanActivityGetModel.h"
#import "MIPreviousTuanItemModel.h"
#import "MITuanItemsCell.h"
#import "MITuanDetailViewController.h"

@interface MIYoupinRecommendViewController ()

@end

@implementation MIYoupinRecommendViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationBar setBarTitle:@"优品推荐"];
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.frame = CGRectMake(0, self.navigationBar.bottom + 1, PHONE_SCREEN_SIZE.width, self.view.viewHeight-self.navigationBar.bottom - 1);
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 8, 0);
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.backgroundView.alpha = 0;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    _tuanItems = [[NSMutableArray alloc]initWithCapacity:0];
    _previousTuanItems = [[NSMutableArray alloc]initWithCapacity:0];
        
    __weak typeof(self) weakSelf = self;
    _pageSize = 20;
    _request = [[MITuanActivityGetRequest alloc]init];
    _request.onCompletion = ^(MITuanActivityGetModel *model){
        [weakSelf finishLoadTableViewData:model];
    };
    _request.onError = ^(MKNetworkOperation *operation,MIError *error){
        [weakSelf failLoadTableViewData];
        MILog(@"error_mes=%@",error.description)
    };
    
    _lastscrollViewOffset = 0;
    
    _refreshTableView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, -104, self.view.viewWidth, 104)];
    _refreshTableView.delegate = self;
    [_tableView addSubview:_refreshTableView];
    
    //返回顶部
    self.goTopView = [[MIGoTopView alloc] initWithFrame:CGRectMake(self.view.viewWidth - 50, self.view.viewHeight- 45, MISCROLL_TO_TOP_HEIGHT, MISCROLL_TO_TOP_HEIGHT)];
    self.goTopView.delegate = self;
    self.goTopView.hidden = YES;;
    [self.view addSubview:self.goTopView];
    [self.view bringSubviewToFront:self.goTopView];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_tuanItems.count == 0 && _previousTuanItems.count == 0) {
        [_request setCat:self.data];
        [_request setPage:1];
        [_request setPageSize:_pageSize];
        [_request sendQuery];
        [self setOverlayStatus:EOverlayStatusLoading labelText:nil];
    }

}

-(void)addHeaderView
{
    if (_tuanItems.count > 0) {
        UIView *headerBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.viewWidth, 400)];
        headerBgView.backgroundColor = [UIColor clearColor];
        UIImageView *youpinTop = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"youpin_top"]];
        youpinTop.backgroundColor = [UIColor clearColor];
        youpinTop.frame = CGRectMake(0, 0, self.view.viewWidth, 32);
        [headerBgView addSubview:youpinTop];
        
        NSInteger bgHeight = 0;
        CGFloat lastViewHeight = youpinTop.bottom + 8;
        for (int i = 0; i < _tuanItems.count; i ++) {
            MIYoupinHeaderView *view = [[MIYoupinHeaderView alloc]initWithFrame:CGRectMake(0, lastViewHeight, self.view.viewWidth, 100)];
            view.clipsToBounds = YES;
            view.backgroundColor = [UIColor clearColor];
            MITuanItemModel *model = [_tuanItems objectAtIndex:i];
            [view.imageView sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:[UIImage imageNamed:@"img_loading_daily1"]];
            view.priceLabel.text = [NSString stringWithFormat:@"￥%.1f",model.price.floatValue / 100.0];
            view.titleLabel.text = model.title;
            view.subTitleLabel.text = model.recomWord;
            NSInteger height = view.subTitleLabel.bottom;
            view.bgView.viewHeight = height + 16;
            view.tag = 6666 + i;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goHeaderDetail:)];
            [view addGestureRecognizer:tap];
            [headerBgView addSubview:view];
            
            CGFloat viewHeight = [view getViewHeight];
            view.frame = CGRectMake(0, lastViewHeight, self.view.viewWidth, viewHeight);
            lastViewHeight += viewHeight + 8;
            
            if (i == _tuanItems.count - 1 ) {
                bgHeight = view.bottom;
                if (_previousTuanItems.count > 0) {
                    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(8, view.bottom + 27, self.view.viewWidth - 16, 0.5)];
                    line.backgroundColor = [MIUtility colorWithHex:0x999999];
                    [headerBgView addSubview:line];
                    
                    UILabel *label = [[UILabel alloc]init];
                    label.backgroundColor = MINormalBackgroundColor;
                    label.bounds = CGRectMake(0, 0, 100, 14);
                    label.textAlignment = NSTextAlignmentCenter;
                    label.text = @"往期推荐";
                    label.textColor = [MIUtility colorWithHex:0x333333];
                    label.font = [UIFont systemFontOfSize:14];
                    CGSize size = [label.text sizeWithFont:label.font];
                    label.viewWidth = size.width + 20;
                    label.viewHeight = size.height;
                    label.center = line.center;
                    [headerBgView addSubview:label];
                    bgHeight = label.bottom + 8;
                }
            }
        }
        headerBgView.frame = CGRectMake(0, 0, self.view.viewWidth, bgHeight);
        _tableView.tableHeaderView = headerBgView;
    }else{
        _tableView.tableHeaderView = nil;
    }

}

-(void)goHeaderDetail:(UIGestureRecognizer *)gesture
{
    MIYoupinHeaderView *view = (MIYoupinHeaderView *)gesture.view;
    NSInteger index = view.tag - 6666;
    MITuanItemModel *model = [_tuanItems objectAtIndex:index];
    MITuanDetailViewController *vc = [[MITuanDetailViewController alloc]initWithItem:model placeholderImage:[UIImage imageNamed:@"img_loading_daily1"]];
    [vc.detailGetRequest setType:model.type.intValue];
    [vc.detailGetRequest setTid:model.tuanId.intValue];
    [[MINavigator navigator] openPushViewController:vc animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.loading) {
        self.loading = NO;
        [self finishLoadTableViewData];
        [self setOverlayStatus:EOverlayStatusRemove labelText:nil];
    }
    
    if (_request.operation.isExecuting) {
        [_request cancelRequest];
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_refreshTableView egoRefreshScrollViewDidEndDragging:scrollView];
}

- (void)refreshData {
    [_request cancelRequest];
    [self.previousTuanItems removeAllObjects];
    
    self.loading = YES;
    
    [_request setPage:1];
    [_request setPageSize:_pageSize];
    [_request sendQuery];

    [self setOverlayStatus:EOverlayStatusLoading labelText:nil];
}

-(void)finishLoadTableViewData:(MITuanActivityGetModel *)model
{
    [self setOverlayStatus:EOverlayStatusRemove labelText:nil];
    if (self.loading) {
        self.loading = NO;
        [self finishLoadTableViewData];
    }
    if (model.page.integerValue == 1) {
        [_tuanItems removeAllObjects];
        [_previousTuanItems removeAllObjects];
    }
    [_tuanItems addObjectsFromArray:model.tuanItems];
    [_previousTuanItems addObjectsFromArray:model.previousTuanItems ];
    _hasMore = model.hasMore.boolValue;
    if (_tuanItems.count == 0 && _previousTuanItems.count == 0) {
        [self setOverlayStatus:EOverlayStatusEmpty labelText:nil];
    }else{
        [self setOverlayStatus:EOverlayStatusRemove labelText:nil];
    }
    [self addHeaderView];
    [self.tableView reloadData];
}

-(void)failLoadTableViewData
{
    [_refreshTableView egoRefreshScrollViewDataSourceDidFinishedLoading:_tableView];
    [self setOverlayStatus:EOverlayStatusRemove labelText:nil];
    if (_tuanItems.count == 0 && _previousTuanItems.count == 0) {
         [self setOverlayStatus:EOverlayStatusReload labelText:nil];
    }
    if (self.loading) {
        self.loading = NO;
    }
}


//开始重新加载时调用的方法
- (void)reloadTableViewDataSource
{
    if (self.loading) {
        [_request cancelRequest];
    }
    
    self.loading = YES;
    [_request setPage:1];
    [_request setPageSize:_pageSize];
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
    if (([_previousTuanItems count] != 0) && _hasMore) {
        //只有当前有数据的前提下才会触发加载更多
        self.loading = YES;
        [_request setPage:++_currentPage];
        [_request sendQuery];
    }
}

//完成加载时调用的方法
- (void)finishLoadTableViewData
{
    [_refreshTableView egoRefreshScrollViewDataSourceDidFinishedLoading:_tableView];
    
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


- (void)goTopViewClicked
{
    [_tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    self.goTopView.hidden= YES;
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
    if(y > size.height && !_loading) {
        [self loadingMoreTableViewDataSource:YES];
    } else {
        [self loadingMoreTableViewDataSource:NO];
    }
    
    [self makeGoTopView:scrollView];
}


- (void)makeGoTopView:(UIScrollView *)scrollView
{
    CGFloat y = scrollView.contentOffset.y;
    if (y < _lastscrollViewOffset - 15 || y <= 38) {
        [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
            if (y > self.view.viewHeight - 45)
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
            if (y > self.view.viewHeight - 45)
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

#pragma mark - UITableViewDataSource

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger count = _previousTuanItems.count;
    NSInteger rows = [self tableView:tableView numberOfRowsInSection:0] - 1;
    
    
    if (_hasMore && (count > 0) && (indexPath.row == rows) && !self.loading) {
        self.loading = YES;
        [_request setPage:(self.previousTuanItems.count / _pageSize + 1)];
        [_request setPageSize:_pageSize];
        [_request sendQuery];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = [_previousTuanItems count];
    if (count == 0) {
        return 0;
    }
    
    NSInteger number = count / 2 + count % 2;
    return number;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger count = [_previousTuanItems count];
    NSInteger rows = [self tableView:tableView numberOfRowsInSection:0] - 1;
    
    if (_hasMore && (indexPath.row == rows) && (count > 0)) {
        return 50;
    } else {
        return (SCREEN_WIDTH - 24) / 2 + 48 + 8;//196 + 8;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger count = [_previousTuanItems count];
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
            tuanItemsCell = [[MITuanItemsCell alloc]initWithreuseIdentifier:ContentIdentifier];
            tuanItemsCell.selectionStyle = UITableViewCellSelectionStyleNone;
            tuanItemsCell.backgroundColor = [UIColor clearColor];
        }
        
        for (NSInteger i = indexPath.row*2; i < (indexPath.row + 1) * 2; i ++) {
            @try {
                id model = [_previousTuanItems objectAtIndex:i];
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
- (void)updateCellView:(MITuanItemView *)view tuanModel:(MIPreviousTuanItemModel *)model
{
    static BOOL timerIsFired = NO;
    
    view.item = model;
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
