//
//  MIBrandViewController.m
//  MISpring
//
//  Created by 曲俊囡 on 13-12-6.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIBrandViewController.h"
#import "MIBrandShopView.h"
#import "MIProductTuanCell.h"
#import "MIAppDelegate.h"
#import "MIUserFavorViewController.h"
#import "MITomorrowBrandHeaderView.h"

@interface MIBrandViewController()<MITomorrowBrandHeaderViewDelegate>

@property (nonatomic, strong) MIBrandShopView *shopCell;

@end

@implementation MIBrandViewController

- (id)initWithAid:(NSInteger)aid
{
    self = [super init];
    if (self) {
        // Custom initialization
        _hasMore = NO;
        self.aid = aid;
        _tuanArray = [[NSMutableArray alloc] initWithCapacity:10];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.brandModel) {
        [self addTabelHeaderViewWithBrandModel:self.brandModel];
    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.loading) {
        self.loading = NO;
        [super finishLoadTableViewData];
    }
    if (self.timer != nil) {
        [self.timer invalidate];
        self.timer = nil;
    }
    
    UIView *header = (UIView *) self.baseTableView.tableHeaderView;
    if ([header isKindOfClass:[MITomorrowBrandHeaderView class]] && header != nil) {
        MITomorrowBrandHeaderView *shopCell = (MITomorrowBrandHeaderView *)header;
        [shopCell stopTimer];
    }
    
    [_request cancelRequest];
    [self setOverlayStatus:EOverlayStatusRemove labelText:nil];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.navigationBar setBarTitle:@"品牌特卖专场"];
    self.needRefreshView = YES;
    
    self.baseTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _baseTableView.frame = CGRectMake(0, self.navigationBarHeight, PHONE_SCREEN_SIZE.width, self.view.viewHeight-self.navigationBarHeight);
    _baseTableView.backgroundColor = [UIColor clearColor];
    _baseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _baseTableView.showsVerticalScrollIndicator = NO;
    _baseTableView.backgroundView.alpha = 0;
    _baseTableView.dataSource = self;
    _baseTableView.delegate = self;
    
    _baseTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, PHONE_SCREEN_SIZE.width, 5)];
    [self.view sendSubviewToBack:_baseTableView];
    
    _shopCell = [[MIBrandShopView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 42)];
    
    __weak typeof(self) weakSelf = self;
    _pageSize = 40;
    _request = [[MITuanBrandDetailGetRequest alloc] init];
    _request.onCompletion = ^(MITuanBrandDetailGetModel *model) {
        [weakSelf finishLoadTableViewData:model];
    };
    _request.onError = ^(MKNetworkOperation* completedOperation, MIError* error) {
        MILog(@"error_msg=%@",error.description);
        [weakSelf failLoadTableViewData];
    };
    [_request setAid:self.aid];
    [_request setPage:1];
    [_request setPageSize:_pageSize];
    [_request sendQuery];
    [self setOverlayStatus:EOverlayStatusLoading labelText:nil];
    
    _brandAddRequest = [[MIUserFavorBrandAddRequest alloc] init];
    _brandAddRequest.onCompletion = ^(MIUserFavorBrandAddModel *model) {
        if (model.success.boolValue)
        {
            [MobClick event:kFavorBrandClick];
            [weakSelf showSimpleHUD:@"添加开抢提醒成功" afterDelay:1];
            [weakSelf.brandFavorArray addObject:@(weakSelf.aid)];
            [[NSUserDefaults standardUserDefaults] setObject:weakSelf.brandFavorArray forKey:kBrandFavorListDefaults];
            [[NSUserDefaults standardUserDefaults] synchronize];
            MITomorrowBrandHeaderView *headerView = (MITomorrowBrandHeaderView *)weakSelf.baseTableView.tableHeaderView;
            headerView.isRemindBrand = YES;
            NSNumber *alertTime = [[NSUserDefaults standardUserDefaults] objectForKey: kBrandFavorBeginTimeDefaults];
            double nowInterval = [[NSDate date] timeIntervalSince1970] + [MIConfig globalConfig].timeOffset;
            if (weakSelf.startTime > nowInterval && (alertTime.integerValue > weakSelf.startTime || alertTime == nil))
            {
                [MIUtility setLocalNotificationWithType:APP_LOCAL_NOTIFY_ACTION_MARTSHOW_START_ALARM alertBody:@"你的开抢提醒专场已经开抢了" at:weakSelf.startTime];
                [[NSUserDefaults standardUserDefaults] setObject:@(weakSelf.startTime) forKey:kBrandFavorBeginTimeDefaults];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        }
        else if(![model.data isEqual:[NSNull null]] && [model.data isEqualToString:@"out_of_limit"])
        {
            MITomorrowBrandHeaderView *headerView = (MITomorrowBrandHeaderView *)weakSelf.baseTableView.tableHeaderView;
            headerView.isRemindBrand = NO;
            MIButtonItem *affirmItem = [MIButtonItem itemWithLabel:@"整理开抢提醒"];
            affirmItem.action = ^{
                MIUserFavorViewController *vc = [[MIUserFavorViewController alloc] init];
                vc.type = BrandType;
                [[MINavigator navigator] openPushViewController:vc animated:YES];
            };
            MIButtonItem *affirmItem2 = [MIButtonItem itemWithLabel:@"取消"];
            affirmItem2.action = ^{
            };
            [[[UIAlertView alloc] initWithTitle:@"提示" message:model.message cancelButtonItem:affirmItem2 otherButtonItems:affirmItem, nil] show];
        }
        else
        {
            MITomorrowBrandHeaderView *headerView = (MITomorrowBrandHeaderView *)weakSelf.baseTableView.tableHeaderView;
            headerView.isRemindBrand = NO;
            [weakSelf showSimpleHUD:model.message afterDelay:1];
        }
    };
    
    _brandAddRequest.onError = ^(MKNetworkOperation* completedOperation, MIError* error) {
    MILog(@"error_msg=%@",error.description);
    };
    
    _brandDeleteRequest = [[MIUserFavorBrandDeleteRequest alloc] init];
    _brandDeleteRequest.onCompletion = ^(MIUserFavorBrandDeleteModel *model) {
        if (model.success.boolValue)
        {
            [weakSelf showSimpleHUD:@"取消开抢提醒成功" afterDelay:1];
            [weakSelf.brandFavorArray removeObject:@(weakSelf.aid)];
            [[NSUserDefaults standardUserDefaults] setObject:weakSelf.brandFavorArray forKey:kBrandFavorListDefaults];
            [[NSUserDefaults standardUserDefaults] synchronize];
            MITomorrowBrandHeaderView *headerView = (MITomorrowBrandHeaderView *)weakSelf.baseTableView.tableHeaderView;
            headerView.isRemindBrand = NO;
        }
        else
        {
            MITomorrowBrandHeaderView *headerView = (MITomorrowBrandHeaderView *)weakSelf.baseTableView.tableHeaderView;
            headerView.isRemindBrand = YES;
            [weakSelf showSimpleHUD:@"取消开抢提醒失败" afterDelay:1];
        }
    };
    
    _brandDeleteRequest.onError = ^(MKNetworkOperation* completedOperation, MIError* error) {
        MILog(@"error_msg=%@",error.description);
    };

    
}

#pragma mark - EGOPullFresh methods
- (void)reloadTableViewDataSource
{
    if (self.loading) {
        [_request cancelRequest];
    }
    
    self.loading = YES;
    [self setOverlayStatus:EOverlayStatusRemove labelText:nil];
    
    [_request setAid:self.aid];
    [_request setPage:1];
    [_request setPageSize:_pageSize];
    [_request sendQuery];
}

- (void)finishLoadTableViewData:(MITuanBrandDetailGetModel *)model
{
    [self setOverlayStatus:EOverlayStatusRemove labelText:nil];
    
    if (self.loading) {
        self.loading = NO;
        [super finishLoadTableViewData];
    }
    
    if (model.page.integerValue == 1)
    {
        if (model.sellerNick) {
            [self.navigationBar setBarTitle:model.sellerNick];
        }
        
        [self.tuanArray removeAllObjects];
        [self addTabelHeaderViewWithBrandModel:model];
    }
    
    for (MIItemModel *item in model.items)
    {
        item.startTime = model.startTime;
        item.endTime = model.endTime;
        item.recomWords = model.recomWords;
        item.origin = @(self.origin);
        if (self.numIid && [self.numIid isEqualToString:item.numIid.stringValue])
        {
            [self.tuanArray insertObject:item atIndex:0];
        } else {
            [self.tuanArray addObject:item];
        }
    }
    
    if (self.tuanArray.count < model.count.integerValue)
    {
        _hasMore = YES;
    }
    else
    {
        _hasMore = NO;
    }
    [self.baseTableView reloadData];
    [self.navigationBar setBarRightButtonItem:self selector:@selector(goShareAction) imageKey:@"mi_navbar_share_img"];
    double startTime = model.startTime.doubleValue;
    self.startTime = startTime;
}

- (void)refreshRemindTag:(BOOL)isRemindBrand
{
    if (isRemindBrand)
    {
        [_brandAddRequest setAid:[NSString stringWithFormat:@"%ld",(long)self.aid]];
        [_brandAddRequest sendQuery];
    }
    else
    {
        [_brandDeleteRequest setAids:[NSString stringWithFormat:@"%ld",(long)self.aid]];
        [_brandDeleteRequest sendQuery];
    }
}

- (void)failLoadTableViewData
{
    [self setOverlayStatus:EOverlayStatusRemove labelText:nil];
    
    if (self.loading) {
        self.loading = NO;
        [super failLoadTableViewData];
    }
    
    if ([_tuanArray count] == 0) {
        [self setOverlayStatus:EOverlayStatusError labelText:nil];
    }
}
- (void)goShareAction
{
    [MobClick event:kTaobaoDetailShareClicks];
    if (self.tuanArray.count > 0) {
        MIItemModel *item = [self.tuanArray objectAtIndex:0];
        NSString *url = [NSString stringWithFormat:@"http://brand.mizhe.com/shop/%@.html", item.encryptAid];
        NSString *title = [NSString stringWithFormat:@"米折品牌特卖－%@", self.brandModel.sellerNick];
        
        NSString *desc = @"刚在@米折网 上发现的品牌，好喜欢，价格特别实惠，还全场包邮！快去瞧瞧吧！";
        NSString *comment = @"刚在@米折网 上发现的品牌，好喜欢，价格特别实惠，还全场包邮！快去瞧瞧吧！";
        NSString *smallImg = self.brandModel.logo;
        NSString *largeImg = self.brandModel.banner;
        [MINavigator showShareActionSheetWithUrl:url title:title desc:desc comment:comment image:_shopCell.shopImageView smallImg:smallImg largeImg:largeImg inView:self.view platform:@"qq_qzone_weixin_timeline_weibo_copy"];
    }
}


- (void)addTabelHeaderViewWithBrandModel:(MITuanBrandDetailGetModel *)brandModel
{
    self.brandModel = brandModel;
    [self reloadShopCell:brandModel];
    double nowInterval = [[NSDate date] timeIntervalSince1970] + [MIConfig globalConfig].timeOffset;
    
    if (self.baseTableView.tableHeaderView == nil) {
        MITomorrowBrandHeaderView *headerView = [[MITomorrowBrandHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 42)];
        headerView.delegate = self;
        [headerView setCurBeginTime:@(brandModel.startTime.integerValue)];
        headerView.endTime = @(brandModel.endTime.integerValue);
        self.baseTableView.tableHeaderView = headerView;
        
        if (brandModel.startTime.integerValue > nowInterval)
        {
            headerView.type = TomorrowType;
            NSArray *favorArray = [[NSUserDefaults standardUserDefaults] objectForKey:kBrandFavorListDefaults];
            _brandFavorArray = [[NSMutableArray alloc] initWithArray:favorArray];
            if ([_brandFavorArray containsObject:@(self.aid)])
            {
                headerView.isRemindBrand = YES;
            }
            else
            {
                headerView.isRemindBrand = NO;
            }
        }
        else
        {
            headerView.type = TodayType;
        }
    } else {
        MITomorrowBrandHeaderView *headerView = (MITomorrowBrandHeaderView *) self.baseTableView.tableHeaderView;
        [headerView startTimer];
    }
}

- (void)reloadShopCell:(MITuanBrandDetailGetModel *)brandModel
{
    _shopCell.relateId = brandModel.sid.stringValue;
    _shopCell.nick = brandModel.sellerNick;
    [_shopCell.shopImageView sd_setImageWithURL:[NSURL URLWithString:brandModel.logo] placeholderImage:[UIImage imageNamed:@"mizhewang_logo"]];
    _shopCell.shopNameLabel.text = brandModel.sellerNick;
    
    double nowInterval = [[NSDate date] timeIntervalSince1970] + [MIConfig globalConfig].timeOffset;
    double interval = brandModel.startTime.doubleValue - nowInterval;
    if (interval > 0) {
        NSString *startString = [[NSDate dateWithTimeIntervalSince1970:brandModel.startTime.doubleValue] stringForTimeline3];
        NSString *hourString = [startString substringToIndex:2];
        NSString *minuteString = [startString substringWithRange:NSMakeRange(3, 2)];
        NSString *secondString = [startString substringWithRange:NSMakeRange(6, 2)];
        if ([hourString integerValue] == 0 && ([minuteString integerValue] || [secondString integerValue]))//非整点
        {
            _shopCell.shopTimeLabel.text = @"即将开抢";
        } else//整点
        {
            _shopCell.shopTimeLabel.text = [NSString stringWithFormat:@"%ld点开抢",(long)[hourString integerValue]];
        }
        _shopCell.shopTimeLabel.textColor = [MIUtility colorWithHex:0x8dbb1a];
        _shopCell.timeImageView.image = [UIImage imageNamed:@"img_lefttime_green"];
        if (self.timer != nil) {
            [self.timer invalidate];
            self.timer = nil;
        }
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:++interval target:self selector:@selector(reloadTableViewForSale) userInfo:nil repeats:NO];
    } else {
        _shopCell.shopEndTime = brandModel.endTime;
        _shopCell.shopTimeLabel.textColor = [UIColor lightGrayColor];
        _shopCell.timeImageView.image = [UIImage imageNamed:@"img_lefttime"];
        [_shopCell startTimer];
    }

}

- (void)reloadTableViewForSale
{
    UIView *header = (UIView *) self.baseTableView.tableHeaderView;
    if ([header isKindOfClass:[MIBrandShopView class] ] && header != nil) {
        MIBrandShopView *shopCell = (MIBrandShopView *)header;
        shopCell.shopEndTime = self.brandModel.endTime;
        shopCell.shopTimeLabel.textColor = [UIColor lightGrayColor];
        [shopCell startTimer];
    }
    
    [_baseTableView reloadData];
    MILog(@"timer is fired for sale");
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows;
    if (self.tuanArray.count%2 == 0) {
        rows = self.tuanArray.count/2;
    } else {
        rows = self.tuanArray.count/2 + 1;
    }
    
    if (_hasMore == NO) {
        return rows;
    } else {
        //加1是因为还有显示加载更多row
        return rows + 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger count = [_tuanArray count];
    NSInteger rows = [self tableView:tableView numberOfRowsInSection:0] - 1;
    if (_hasMore && (indexPath.row == rows) && (count > 0)) {
        return 50;
    }
    else//product
    {
        return 201;
    }
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger count = [_tuanArray count];
    NSInteger rows = [self tableView:tableView numberOfRowsInSection:0] - 1;
    if (_hasMore && (count > 0) && (indexPath.row == rows) && !self.loading) {
        self.loading = YES;
        [_request setPage:(count / _pageSize + 1)];
        [_request setPageSize:_pageSize];
        [_request sendQuery];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger rows = [self tableView:tableView numberOfRowsInSection:0] - 1;
    
    static NSString *ProductIdentifier = @"BrandProductCellReuseIdentifier";
    static NSString *LoadMoreIdentifier = @"LoadMoreCellReuseIdentifier";
    if (_hasMore && (self.tuanArray.count > 0) && (indexPath.row == rows)) {
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
    else//product
    {
        MIProductTuanCell *productCell = [tableView dequeueReusableCellWithIdentifier:ProductIdentifier];
        if (!productCell) {
            productCell = [[MIProductTuanCell alloc] initWithReuseIdentifier:ProductIdentifier];
            productCell.selectionStyle = UITableViewCellSelectionStyleNone;
			productCell.backgroundColor = [UIColor clearColor];
        }
        for (NSInteger i = indexPath.row*2; i < (indexPath.row + 1) * 2; i ++) {
            @try {
                MIItemModel *model = [_tuanArray objectAtIndex:i];
                productCell.cat = self.cat;
                if (i == indexPath.row*2) {
                    productCell.itemView1.hidden = NO;
                    [productCell updateCellView:productCell.itemView1 tuanModel:model];
                } else {
                    productCell.itemView2.hidden = NO;
                    [productCell updateCellView:productCell.itemView2 tuanModel:model];
                }
            }
            @catch (NSException *exception) {
                if (i == indexPath.row*2) {
                    productCell.itemView1.hidden = YES;
                } else {
                    productCell.itemView2.hidden = YES;
                }
            }
        }
        
        return productCell;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
