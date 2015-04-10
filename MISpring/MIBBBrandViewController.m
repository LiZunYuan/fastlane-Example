//
//  MIBBBrandViewController.m
//  MISpring
//
//  Created by husor on 14-10-14.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MIBBBrandViewController.h"
#import "MIBBMarqueeView.h"
#import "MIMartshowItemModel.h"
#import "MIBBSpecialProductCell.h"
#import "MIBBTuanViewController.h"

@interface MIBBSpecialPerformanceShopView : UIView

@property (nonatomic, strong) NSString *relateId;
@property (nonatomic, strong) NSString *nick;
@property (nonatomic, strong) UIImageView *shopImageView;
@property (nonatomic, strong) UIImageView *timeImageView;
@property (nonatomic, strong) UILabel *shopNameLabel;
@property (nonatomic, strong) UILabel *shopTimeLabel;
@property (nonatomic, strong) NSTimer *shopTimer;
@property (nonatomic, assign) double gmtEnd;
@property (nonatomic, assign) double gmtBegin;
@property (nonatomic, strong) MIBBMarqueeView *mjPromotionLabel;
@property (nonatomic, strong) UIView *mjView;

- (id) initWithFrame:(CGRect)frame;
- (void)startTimer;
- (void)stopTimer;

@end


@implementation MIBBSpecialPerformanceShopView
@synthesize shopImageView,timeImageView,shopNameLabel,relateId,nick,shopTimeLabel,gmtBegin,gmtEnd;

- (id) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.mjView = [[UIView alloc] initWithFrame:CGRectMake(0,0, self.viewWidth, 20)];
        self.mjView.backgroundColor = [UIColor clearColor];
        UILabel *mjLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 4, 28, 15)];
        mjLabel.text = @"满减";
        mjLabel.textAlignment = UITextAlignmentCenter;
        mjLabel.textColor = [UIColor whiteColor];
        mjLabel.font = [UIFont systemFontOfSize:10.0];
        mjLabel.clipsToBounds = YES;
        mjLabel.layer.cornerRadius = 2.0;
        [self.mjView addSubview:mjLabel];
        mjLabel.backgroundColor = MIColorGreen;
        
        _mjPromotionLabel = [[MIBBMarqueeView alloc] initWithFrame:CGRectMake(40, 6, 200 - 47, 15)];
        _mjPromotionLabel.backgroundColor = [UIColor clearColor];
        _mjPromotionLabel.lable.font = [UIFont systemFontOfSize:10.0];
        _mjPromotionLabel.lable.textColor = [MIUtility colorWithHex:0x858585];
        [self.mjView addSubview:_mjPromotionLabel];
        [self addSubview:self.mjView];
        
        timeImageView = [[UIImageView alloc] initWithFrame: CGRectMake(170, 6, 12, 12)];
        timeImageView.image = [UIImage imageNamed:@"img_lefttime"];
        [self addSubview:timeImageView];
        
        shopTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(185, 4, 135, 16)];
        shopTimeLabel.backgroundColor = [UIColor clearColor];
        shopTimeLabel.font = [UIFont systemFontOfSize:10.0];
        shopTimeLabel.textColor = [MIUtility colorWithHex:0x858585];
        shopTimeLabel.textAlignment = NSTextAlignmentCenter;
        shopTimeLabel.userInteractionEnabled = YES;
        [self addSubview:shopTimeLabel];
    }
    
    return self;
}

- (void)startTimer
{
    [self stopTimer];
    self.shopTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(handleTimer:) userInfo:nil repeats:YES];
    [self.shopTimer fire];
}

- (void)stopTimer
{
    if (self.shopTimer) {
        [self.shopTimer invalidate];
        self.shopTimer = nil;
    }
}

- (void)handleTimer: (NSTimer *) timer
{
    double nowInterval = [[NSDate date] timeIntervalSince1970] + [MIConfig globalConfig].timeOffset;
    if (gmtEnd <= nowInterval) {
        shopTimeLabel.textColor = [MIUtility colorWithHex:0x858585];
        shopTimeLabel.text = @"已结束";
        self.timeImageView.image = [UIImage imageNamed:@"img_lefttime"];
        [self stopTimer];
    } else {
        if (gmtBegin > nowInterval)
        {
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:gmtBegin];
            NSString *startString = [date stringForTimeline3];
            NSString *hourString = [startString substringToIndex:2];
            NSString *minuteString = [startString substringWithRange:NSMakeRange(3, 2)];
            NSString *secondString = [startString substringWithRange:NSMakeRange(6, 2)];
            if ([hourString integerValue] == 0 && ([minuteString integerValue] || [secondString integerValue]))//非整点
            {
                self.shopTimeLabel.text = @"即将开抢";
            } else//整点
            {
                self.shopTimeLabel.text = [NSString stringWithFormat:@"%ld点开抢",(long)[hourString integerValue]];
            }
            
            self.shopTimeLabel.textColor = MIColorGreen;
            self.timeImageView.image = [UIImage imageNamed:@"img_lefttime_green"];

        }
        else
        {
            NSInteger left = gmtEnd - nowInterval;
            NSInteger day = left / 60 / 60 / 24;
            NSInteger hour = left%(60 * 60 * 24)/60/60;
            NSInteger minute = left%(60*60)/60;
            NSInteger second = left%60;
            self.shopTimeLabel.text = [NSString stringWithFormat:@"剩%ld天%ld时%ld分%ld秒",(long)day,(long)hour,(long)minute,(long)second];
        }
    }

    CGSize constraintSize= CGSizeMake(self.viewWidth, shopTimeLabel.viewHeight);
    CGSize expectedSize = [shopTimeLabel.text sizeWithFont:[UIFont systemFontOfSize:10.0] constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
    shopTimeLabel.viewWidth = expectedSize.width + 10;
    shopTimeLabel.left = self.viewWidth - expectedSize.width - 13;
    timeImageView.right = shopTimeLabel.left;
}

@end


@interface MIBBBrandViewController ()
{
}
@end
#define MICATS_VIEW_HEIGHT 40

static NSString *hotFilter = @"hot";
static NSString *priceFilter = @"price";
static NSString *discountFilter =@"discount";

@implementation MIBBBrandViewController

- (id)initWithEventId:(NSInteger)eventId
{
    self = [super init];
    if (self) {
        // Custom initialization
        _eventId = eventId;
        _currentCount = 0;
        _hasMore = NO;
        _pageSize = 40;
        _modelArray = [[NSMutableArray alloc] initWithCapacity:10];
    }
    return self;
}

- (void)goTopViewClicked
{
    [self.baseTableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    self.goTopImageView.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationBar setBarTitle:@"今日特卖"];

    if (self.shopNameString.length)
    {
        NSString *title = [NSString stringWithFormat:@"%@专场", self.shopNameString];
        [self.navigationBar setBarTitle:title];
    } else {
        [self.navigationBar setBarTitle:@"品牌特卖专场"];
    }
    
    self.baseTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _baseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _baseTableView.backgroundColor = [UIColor clearColor];
    _baseTableView.delegate = self;
    _baseTableView.dataSource = self;
    
    
    __weak typeof(self) weakSelf = self;
    self.segment = [[MIBBMartshowSegment alloc] initWithFrame:CGRectMake(0, self.navigationBar.bottom, PHONE_SCREEN_SIZE.width, 40)];
    [self.segment initWithSubViews];
    [self.segment setSelectedBlock:^(MIBBMartsShowSegmentStatus *status) {
        [weakSelf updateTableView:status];
    }];
    self.segment.hidden = YES;
    [self.view addSubview:self.segment];
    [self.view insertSubview: self.segment belowSubview:self.navigationBar];
    [self.view sendSubviewToBack:_baseTableView];
    
    _baseTableView.frame = CGRectMake(0, self.navigationBar.bottom+40, PHONE_SCREEN_SIZE.width, self.view.viewHeight - self.navigationBarHeight);
    _baseTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 5)];
    
    MIBBSpecialPerformanceShopView *shopView = [[MIBBSpecialPerformanceShopView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    shopView.backgroundColor = [UIColor clearColor];
    self.baseTableView.tableHeaderView = shopView;
   
    //返回顶部
    _goTopImageView = [[MIGoTopView alloc] initWithFrame:CGRectMake(self.view.viewWidth - 50, self.view.viewHeight - 45, MISCROLL_TO_TOP_HEIGHT, MISCROLL_TO_TOP_HEIGHT)];
    _goTopImageView.delegate = self;
    _goTopImageView.hidden = YES;
    [self.view addSubview:self.goTopImageView];
    
    [self addTabelHeaderView:nil];
    
    _request = [[MIBBMartshowItemGetRequest alloc] init];
    _request.onCompletion = ^(MIBeibeiMartshowItemGetModel *model) {
        [weakSelf finishLoadTableViewData:model];
    };
    
    _request.onError = ^(MKNetworkOperation* completedOperation, MIError* error) {
        [weakSelf failLoadTableViewData];
        MILog(@"error_msg=%@",error.description);
    };
    [_request setEventId:_eventId];
    [_request setPage:1];
    [_request setPageSize:_pageSize];
    self.baseTableView.tableHeaderView.hidden = YES;
    [self setOverlayStatus:EOverlayStatusLoading labelText:nil];
    
}

- (void)updateTableView:(MIBBMartsShowSegmentStatus *)status
{
    [self.request cancelRequest];
    [self.request setIsSellOut:status.filterStatus];
    NSInteger index = status.inStockStatus.intValue;
    [_request setPage:1];
    if(index == 0)
    {
        [self.request setFielter:hotFilter];
    }
    else if(index == 1)
    {
        [self.request setFielter:priceFilter];
    }
    else
    {
        [self.request setFielter:discountFilter];
    }
    
    [self.request sendQuery];
    [self showProgressHUD:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([_modelArray count] == 0) {
        [_request sendQuery];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.loading) {
        self.loading = NO;
        [super finishLoadTableViewData];
    }
    [_request cancelRequest];
    [self setOverlayStatus:EOverlayStatusRemove labelText:nil];
}

//下拉刷新，重新请求数据
- (void)reloadTableViewDataSource
{
    if (self.loading) {
        [_request cancelRequest];
    }
    
    self.loading = YES;
    [self setOverlayStatus:EOverlayStatusRemove labelText:nil];
    
    [_request setPage:1];
    [_request sendQuery];
}

- (void)finishLoadTableViewData:(MIBeibeiMartshowItemGetModel *)model
{
    [self hideProgressHUD];
    [self setOverlayStatus:EOverlayStatusRemove labelText:nil];
    if (self.loading) {
        self.loading = NO;
        [super finishLoadTableViewData];
    }
    if (model.logo && model.logo.length)
    {
        self.shopTitleString = model.title;
        self.shopImageString = model.logo;
        self.gmtBegin = model.gmtBegin.intValue;
        self.gmtEnd = model.gmtEnd.intValue;
        self.totalCount = @(model.totalCount.intValue - model.count.intValue);
        [self.navigationBar setBarRightButtonItem:self selector:@selector(goShare) imageKey:@"navbar_tool_share_img"];
        [self addTabelHeaderView:model];
    }
    
    if(model.sort && model.filterSellout)
    {
        NSMutableArray *array = [self itemIndexArray:model.filterSellout sort:model.sort];
        [self.segment setSelectedItems:array];
    }
    _currentPage = model.page.integerValue;
    if (_currentPage == 1)
    {
        _currentCount = 0;
        [self.modelArray removeAllObjects];
    }
    _currentCount += model.martshowItems.count;
    [self.modelArray addObjectsFromArray:model.martshowItems];
    if (self.iid && _currentPage == 1) {
        for (MIMartshowItemModel *model in self.modelArray) {
            if (model.iid.integerValue == self.iid) {
                [self.modelArray removeObject:model];
                [self.modelArray insertObject:model atIndex:0];
                break;
            }
        }
    }
    
    if (_modelArray.count != 0) {
        if (model.count.integerValue > _currentCount)
        {
            _hasMore = YES;
        }
        else
        {
            _hasMore = NO;
        }
        self.segment.hidden = NO;
        self.baseTableView.tableHeaderView.hidden = NO;
        [self.baseTableView reloadData];
        [self.navigationBar setBarRightButtonItem:self selector:@selector(goShare) imageKey:@"mi_navbar_share_img"];
    }
    else {
        [self setOverlayStatus:EOverlayStatusEmpty labelText:nil];
    }
}

- (NSMutableArray *)itemIndexArray:(NSNumber *)sellOut sort:(NSString *)sort
{
    NSMutableArray *itemIndex = [[NSMutableArray alloc] initWithCapacity:2];
    if (sellOut.boolValue)
    {
        [itemIndex addObject:@(3)];
    }
    if ([sort isEqualToString:hotFilter])
    {
        [itemIndex addObject:@(0)];
    }
    else if([sort isEqualToString:priceFilter])
    {
        [itemIndex addObject:@(1)];
    }
    else if([sort isEqualToString:discountFilter])
    {
        [itemIndex addObject:@(2)];
    }
    return itemIndex;
}

- (void)failLoadTableViewData
{
    [self setOverlayStatus:EOverlayStatusRemove labelText:nil];
    if (self.loading) {
        self.loading = NO;
        [super failLoadTableViewData];
    }
    
    if ([_modelArray count] == 0) {
        self.baseTableView.tableHeaderView.hidden = YES;
        [self setOverlayStatus:EOverlayStatusReload labelText:nil];
    }
}

- (void)addTabelHeaderView:(MIBeibeiMartshowItemGetModel *)model
{
    if (!self.shopImageString && !self.shopTitleString) {
        return;
    }
    
    MIBBSpecialPerformanceShopView *shopCell;
    if (self.baseTableView.tableHeaderView == nil)
    {
        shopCell = [[MIBBSpecialPerformanceShopView alloc] init];
        self.baseTableView.tableHeaderView = shopCell;
    } else {
        shopCell = (MIBBSpecialPerformanceShopView *) self.baseTableView.tableHeaderView;
    }
    if (model == nil || model.mjPromotion == nil || [model.mjPromotion isEqualToString:@""])
    {
        shopCell.mjView.hidden = YES;
        
    }
    else
    {
        shopCell.mjView.hidden = NO;
    }
    shopCell.frame = CGRectMake(0, 0, SCREEN_WIDTH, 20);
    [shopCell.shopImageView sd_setImageWithURL:[NSURL URLWithString:self.shopImageString]];
    shopCell.shopNameLabel.text = self.shopTitleString;
    shopCell.gmtBegin = self.gmtBegin;
    shopCell.gmtEnd = self.gmtEnd;
    [shopCell.mjPromotionLabel setLabelText:model.mjPromotion];
    [shopCell.mjPromotionLabel startTimer];
    [shopCell startTimer];
    self.baseTableView.tableHeaderView = shopCell;
    
    if (model == nil) {
        self.baseTableView.tableHeaderView.hidden = YES;
    }
}



//- (void)addTabelHeaderView:(MIBeibeiMartshowItemGetModel *)model
//{
//    if (!self.shopImageString && !self.shopTitleString) {
//        return;
//    }
//    
//    if (model == nil) {
//        self.baseTableView.tableHeaderView.hidden = YES;
//    }
//}

- (void)goShare
{
    NSString *title = self.shopTitleString;
    NSString *desc = @"贝贝网（beibei.com），一家深受中国妈妈信赖的国内领先的婴童特卖网站！";
    NSString *comment = [NSString stringWithFormat:@"【分享%@】这是我在贝贝网发现的品牌特卖，超划算，而且全场包邮！",self.shopTitleString];
    NSString *url = [NSString stringWithFormat:@"http://www.beibei.com/martshow/%ld.html", (long)self.eventId];
    UIImageView *itemImageView = [[UIImageView alloc] init];
    [itemImageView sd_setImageWithURL:[NSURL URLWithString:self.shopImageString] placeholderImage:[UIImage imageNamed:@"app_share_pic"]];
    [MINavigator showShareActionSheetWithUrl:url title:title desc:desc comment:comment image:itemImageView smallImg:self.shopImageString largeImg:self.shopImageString inView:self.view platform:@"qq_qzone_weixin_timeline_weibo_copy"];
}

#pragma  mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows;
    if (self.modelArray.count%2 == 0) {
        rows = self.modelArray.count/2;
    } else {
        rows = self.modelArray.count/2 + 1;
    }
    if (_hasMore == NO) {
        return rows;
    } else {
        //加1是因为要显示加载更多row
        return rows + 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger count = self.modelArray.count;
    NSInteger rows = [self tableView:tableView numberOfRowsInSection:0] - 1;
    
    if (_hasMore && (indexPath.row == rows) && (count > 0))
    {
        return 50;
    }
    else
    {
        return 204;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger count = self.modelArray.count;
    NSInteger rows = [self tableView:tableView numberOfRowsInSection:0] - 1;
    
    if (_hasMore && (count > 0) && (indexPath.row == rows) && !self.loading) {
        self.loading = YES;
        [_request setPage:(_currentPage + 1)];
        [_request setPageSize:_pageSize];
        [_request sendQuery];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger rows = [self tableView:tableView numberOfRowsInSection:0] - 1;
    
    static NSString *identifier = @"specialProductCellIdentifier";
    static NSString *LoadMoreIdentifier = @"LoadMoreCellReuseIdentifier";
    if (_hasMore && (self.modelArray.count > 0) && (indexPath.row == rows)) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LoadMoreIdentifier];
        if(!cell){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LoadMoreIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            
            UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            indicatorView.center = CGPointMake(100, 25);
            indicatorView.tag = 999;
            
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
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
        MIBBSpecialProductCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell)
        {
            cell = [[MIBBSpecialProductCell alloc] initWithreuseIdentifier:identifier];
        }
        
        for (NSInteger i = indexPath.row*2; i < (indexPath.row + 1) * 2; i ++) {
            @try {
                MIMartshowItemModel *model = (MIMartshowItemModel *)[self.modelArray objectAtIndex:i];
                if (i == indexPath.row*2) {
                    cell.itemView1.hidden = NO;
                    [cell updateCellView:cell.itemView1 tuanModel:model];
                    [cell.itemView1 setSelectedBlock:^{
                        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@detail.html?iid=%@", [MIConfig globalConfig].beibeiURL, model.iid]];
                        MIBBTuanViewController *vc = [[MIBBTuanViewController alloc] initWithURL:url];
                        vc.webTitle = @"贝贝特卖";
                        [[MINavigator navigator] openPushViewController:vc animated:YES];
                    }];
                } else {
                    cell.itemView2.hidden = NO;
                    [cell.itemView2 setSelectedBlock:^{
                        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@detail.html?iid=%@", [MIConfig globalConfig].beibeiURL, model.iid]];
                        MIBBTuanViewController *vc = [[MIBBTuanViewController alloc] initWithURL:url];
                        vc.webTitle = @"贝贝特卖";
                        [[MINavigator navigator] openPushViewController:vc animated:YES];
                    }];
                    [cell updateCellView:cell.itemView2 tuanModel:model];
                }
            }
            @catch (NSException *exception) {
                if (i == indexPath.row*2) {
                    cell.itemView1.hidden = YES;
                } else {
                    cell.itemView2.hidden = YES;
                }
            }
        }
        
        return cell;
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [super scrollViewDidScroll:scrollView];
    
    CGFloat y = scrollView.contentOffset.y;
    
    if (y < _lastscrollViewOffset - 15 || y <= MICATS_VIEW_HEIGHT) {
        [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.segment.top = self.navigationBarHeight;
            self.baseTableView.top = self.segment.bottom;
            if (y > self.view.viewHeight - self.navigationBarHeight - TABBAR_HEIGHT)
            {
                self.goTopImageView.hidden = NO;
            }
            else
            {
                self.goTopImageView.hidden = YES;
            }
        } completion:^(BOOL finished){
        }];
    } else if (y > _lastscrollViewOffset + 5 && y > 0){
        [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.segment.top = self.navigationBarHeight - MICATS_VIEW_HEIGHT;
            self.baseTableView.top = self.navigationBar.bottom;
            self.goTopImageView.hidden = YES;
        } completion:^(BOOL finished){
        }];
    }
    
    if (y < _lastscrollViewOffset - 15) {
        [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
            if (y > self.view.viewHeight - self.navigationBarHeight)
            {
                self.goTopImageView.hidden = NO;
            }
            else
            {
                self.goTopImageView.hidden = YES;
            }
        } completion:^(BOOL finished){
        }];
    }
    
    _lastscrollViewOffset = y;
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
