//
//  MIBeiBeiTeMaiViewController.m
//  MISpring
//
//  Created by husor on 14-10-14.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MIBeiBeiTeMaiViewController.h"
#import "MIBeiBeiItemView.h"
#import "MIBeiBeiCell.h"
#import "MITuanItemModel.h"
@interface MIBeiBeiTeMaiViewController ()<MIScreenSelectedDelegate>

@end

@implementation MIBeiBeiTeMaiViewController

- (id)init
{
    self = [super init];
    if (self) {
        _hasMore = NO;
        _isShowScreen = NO;
        _tuanTenPageSize = 30;
        
        _datasCateNames = [[NSMutableArray alloc] initWithCapacity:10];
        _datasCateIds = [[NSMutableArray alloc] initWithCapacity:10];
        _tuanArray = [[NSMutableArray alloc] initWithCapacity:20];
        __weak typeof(self) weakSelf = self;
        _request = [[MIBeiBeiTeMaiGetRequest alloc] init];
        _request.onCompletion = ^(MIBeibeiTemaiGetModel *model) {
            [weakSelf finishLoadTableViewData:model];
        };
        _request.onError = ^(MKNetworkOperation* completedOperation, MIError* error) {
            [weakSelf failLoadTableViewData];
            MILog(@"error_msg=%@",error.description);
        };
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.needRefreshView = YES;
    [self.navigationBar setBarTitle:@"贝贝特卖"  textSize:20.0];
    [self.navigationBar setBarLeftButtonItem:self selector:@selector(showScreenView) imageKey:@"ic_category"];
    
    self.baseTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _baseTableView.frame = CGRectMake(0, self.navigationBarHeight, PHONE_SCREEN_SIZE.width, self.view.viewHeight-self.navigationBarHeight - TABBAR_HEIGHT);
    _baseTableView.frame = CGRectMake(0, self.navigationBarHeight, PHONE_SCREEN_SIZE.width, self.view.viewHeight - self.navigationBarHeight - TABBAR_HEIGHT);
    _baseTableView.backgroundColor = [UIColor clearColor];
    _baseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _baseTableView.showsVerticalScrollIndicator = NO;
    _baseTableView.backgroundView.alpha = 0;
    _baseTableView.dataSource = self;
    _baseTableView.delegate = self;
    _baseTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, PHONE_SCREEN_SIZE.width, 5)];
    
    _goTopImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.viewWidth - 50, self.view.viewHeight - TABBAR_HEIGHT - 45, 36, 36)];
    self.goTopImageView.image = [UIImage imageNamed:@"ic_scrollstotop"];
    self.goTopImageView.hidden = YES;
    self.goTopImageView.userInteractionEnabled = YES;
    [self.goTopImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToTopOfView)]];
    [self.view addSubview:self.goTopImageView];
    
    UIView *catView = [[UIView alloc] initWithFrame:CGRectMake(0, self.navigationBarHeight, PHONE_SCREEN_SIZE.width, 38)];
    catView.backgroundColor = [UIColor whiteColor];
    _topScrollView = [[SVTopScrollView alloc] init];
    _topScrollView.screenDelegate = self;
    [catView addSubview:_topScrollView];

    
    _shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, PHONE_SCREEN_SIZE.width, self.view.viewHeight)];
    self.shadowView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.35];
    self.shadowView.alpha = 0;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenScreenView)];
    [self.shadowView addGestureRecognizer:tap];
    [self.view addSubview:self.shadowView];
    [self.view bringSubviewToFront:self.navigationBar];
    
    [self loadTuanCatsData:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSDate *lastUpdateTuanTime = [[NSUserDefaults standardUserDefaults] objectForKey:kLastUpdateBeibeiTemaiTime];
    NSInteger interval = [lastUpdateTuanTime timeIntervalSinceNow];
    if (interval <= MIAPP_ONE_HOUR_INTERVAL && [[Reachability reachabilityForInternetConnection] isReachable]) {
        //如果超出一天，清空特卖缓存
        [self.tuanArray removeAllObjects];
        [self loadTuanCatsData:YES];
    }
    
    if (self.tuanArray.count == 0) {
        [self loadTenTuanData];
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


- (void)goToTopOfView
{
    [self.baseTableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    self.goTopImageView.hidden = YES;
}

- (void)hiddenScreenView
{
    _isShowScreen = NO;
    self.shadowView.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.screenView.frame = CGRectMake(0, -self.screenView.viewHeight - 20, self.screenView.viewWidth, self.screenView.viewHeight);
    }];
}

- (void)showScreenView
{
    if (self.screenView)
    {
        if (!_isShowScreen)
        {
            [UIView animateWithDuration:0.3 animations:^{
                self.shadowView.alpha = 1;
                self.screenView.frame = CGRectMake(0, self.navigationBarHeight, self.screenView.viewWidth, self.screenView.viewHeight);
            }];
            _isShowScreen = YES;
        }
        else
        {
            [UIView animateWithDuration:0.3 animations:^{
                self.shadowView.alpha = 0;
                self.screenView.frame = CGRectMake(0, -self.screenView.viewHeight - 20, self.screenView.viewWidth, self.screenView.viewHeight);
            }];
            _isShowScreen = NO;
        }
    }
}

- (void)selectedSelf
{
    [self hiddenScreenView];
}

- (void)selectedCatId:(NSString *)catId catName:(NSString *)catName;
{
    _cat = catId;
    if ([catName isEqualToString:@"全部"])
    {
        [self.navigationBar setBarTitle:@"贝贝特卖"  textSize:20.0];
    }
    else
    {
        [self.navigationBar setBarTitle:catName  textSize:20.0];
    }
    [self refreshData];
    [self hiddenScreenView];
}



#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = [_tuanArray count];
    if (count == 0) {
        return 0;
    }
    NSInteger number = count / 2 + count % 2;
    return number;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger count = [_tuanArray count];
    NSInteger rows = [self tableView:tableView numberOfRowsInSection:0] - 1;
    if (_hasMore && (indexPath.row == rows) && (count > 0)) {
        return 50;
    } else {
        return 205;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger count = [_tuanArray count];
    NSInteger rows = [self tableView:tableView numberOfRowsInSection:0] - 1;
    
    if (_hasMore && (count > 0) && (indexPath.row == rows) && !self.loading) {
        self.loading = YES;
        [_request setPage:(_currentPage + 1)];
        [_request setPageSize:_tuanTenPageSize];
        [_request setSort:@"new"];
        [_request setFilterSellout:0];
        [_request sendQuery];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger count = [_tuanArray count];
    NSInteger rows = [self tableView:tableView numberOfRowsInSection:0] - 1;
    
    static NSString *ContentIdentifier = @"BBCell";
    static NSString *LoadMoreIdentifier = @"LoadMoreCellReuseIdentifier";
    if (_hasMore && (count > 0) && (indexPath.row == rows)) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LoadMoreIdentifier];
        if(!cell){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LoadMoreIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            
            UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            indicatorView.center = CGPointMake(100, 25);
            indicatorView.tag = 9999;
            
            cell.textLabel.textAlignment = UITextAlignmentCenter;
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.textLabel.text = @"加载中...";
            [cell addSubview:indicatorView];
        }
        
        UIActivityIndicatorView *indicatorView = (UIActivityIndicatorView *)[cell viewWithTag:9999];
        [indicatorView startAnimating];
        
        return cell;
    } else {
        MIBeiBeiCell *beiBeiCell = [tableView dequeueReusableCellWithIdentifier:ContentIdentifier];
        if (!beiBeiCell) {
            beiBeiCell = [[MIBeiBeiCell alloc] initWithreuseIdentifier:ContentIdentifier];
            beiBeiCell.selectionStyle = UITableViewCellSelectionStyleNone;
            beiBeiCell.backgroundColor = [UIColor clearColor];
        }
        
        for (int i = indexPath.row*2; i < (indexPath.row + 1) * 2; i ++) {
            @try {
                id model = [_tuanArray objectAtIndex:i];
                if (i == indexPath.row*2) {
                    beiBeiCell.itemView1.hidden = NO;
                    [self updateCellView:beiBeiCell.itemView1 tuanModel:model];
                } else {
                    beiBeiCell.itemView2.hidden = NO;
                    [self updateCellView:beiBeiCell.itemView2 tuanModel:model];
                }
            }
            @catch (NSException *exception) {
                if (i == indexPath.row*2) {
                    beiBeiCell.itemView1.hidden = YES;
                } else {
                    beiBeiCell.itemView2.hidden = YES;
                }
            }
        }
        
        return beiBeiCell;
    }
}

//得到类目cat的数据
- (void)loadTuanCatsData:(BOOL)reload
{
    _cat = @"";
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
                   {
                       NSArray *cats = [MIConfig getBeiBeiCategory];
                       dispatch_async(dispatch_get_main_queue(), ^
                                      {
                                          if (!self.screenView) {
                                              _screenView = [[MIScreenView alloc] initWithArray:cats];
                                              self.screenView.delegate = self;
                                              [self.view addSubview:self.screenView];
                                              [self.view bringSubviewToFront:self.navigationBar];
                                          } else {
                                              [self.screenView reloadContenWithCats:cats];
                                          }
                                          
                                          //初始化参数为全部
                                          _cat = @"";
                                          _isShowScreen = NO;
                                          self.screenView.frame = CGRectMake(0, -self.screenView.viewHeight - 20, self.screenView.viewWidth, self.screenView.viewHeight);
                                      });
                   });
}

- (void) refreshData {
    
    _hasMore = NO;
    [_request cancelRequest];
    [_tuanArray removeAllObjects];
    [_baseTableView reloadData];
    
    self.loading = YES;
    [_request setCatId:_cat];
    [_request setPage:1];
    [_request setPageSize:_tuanTenPageSize];
    [_request setSort:@"new"];
    [_request setFilterSellout:0];
    [_request sendQuery];
    [self setOverlayStatus:EOverlayStatusLoading labelText:nil];
}

//下拉刷新
#pragma mark - EGOPullFresh methods
-(NSString *)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView *)view
{
    NSString *header;
    NSInteger random = arc4random();
    if (random % 2) {
        header = @"千家母婴品牌，1折起售";
    } else {
        header = @"限时抢购，每天十点上新";
    }
    return header;
}

- (void)reloadTableViewDataSource
{
    if (self.loading) {
        [_request cancelRequest];
    }
    
    self.loading = YES;
    if (self.tuanArray.count > 0) {
        [self setOverlayStatus:EOverlayStatusRemove labelText:nil];
    } else {
        [self setOverlayStatus:EOverlayStatusLoading labelText:nil];
    }
    
    [_request setPage:1];
    [_request setSort:@"new"];
    [_request setFilterSellout:0];
    [_request sendQuery];
}

- (void)finishLoadTableViewData:(MIBeibeiTemaiGetModel *)model
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:kLastUpdateBeibeiTemaiTime];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self setOverlayStatus:EOverlayStatusRemove labelText:nil];
    
    if (self.loading) {
        self.loading = NO;
        [super finishLoadTableViewData];
    }
    
    _currentPage = model.page.integerValue;
    if (model.page.integerValue == 1) {
        [_tuanArray removeAllObjects];
    }
    
    [_tuanArray addObjectsFromArray:model.tuanItems];
    
    if (_tuanArray.count != 0) {
        if (model.tuanItems.count < _tuanTenPageSize) {
            _hasMore = NO;
        } else {
            _hasMore = YES;
        }
    }
    else {
        [self setOverlayStatus:EOverlayStatusEmpty labelText:nil];
    }
    
    [_baseTableView reloadData];
}

- (void)failLoadTableViewData
{
    [self setOverlayStatus:EOverlayStatusRemove labelText:nil];
    
    if (self.loading) {
        self.loading = NO;
        [super failLoadTableViewData];
    }
    
    if ([_tuanArray count] == 0) {
        [self setOverlayStatus:EOverlayStatusReload labelText:nil];
    }
}

- (void)loadTenTuanData
{
    if (self.loading) {
        [_request cancelRequest];
    }
    if (self.tuanArray.count == 0) {
        //重新请求数据
        [self refreshData];
    } else {
        self.loading = YES;
        [_request setPage:1];
        [_request setSort:@"new"];
        [_request setFilterSellout:0];
        [_request sendQuery];
    }
}

//刷新产品的cell
- (void)updateCellView:(MIBeiBeiItemView *)view tuanModel:(MITuanItemModel *)model
{

    view.item = model;
    view.cat = self.cat;
    [view.indicatorView startAnimating];
    NSString *imgUrl = [NSString stringWithFormat:@"%@%@",model.img,@"!320x320.jpg"];
    [view.itemImage sd_setImageWithURL:[NSURL URLWithString:imgUrl]];
    view.bottomBg1.hidden = NO;
    if ([model.eventType isEqualToString:@"tuan"]) {
        view.description.text = model.title;
        view.temaiImageView.hidden = YES;
    }
    else{
        view.description.text = [NSString stringWithFormat:@"%@特卖专场",model.brand];
        view.temaiImageView.hidden = NO;
    }
    NSString *decimal;
    decimal = [[NSString alloc] initWithFormat:@"%d",(model.price.integerValue%100)/10];
    view.price.text = [[NSString alloc] initWithFormat:@"<font size=12.0>￥</font><font size=24.0>%d</font><font size=14.0>.%@</font>", model.price.integerValue / 100, decimal];
    view.price.textAlignment = NSTextAlignmentLeft;
    NSString *str = [NSString stringWithFormat:@"%d",model.price.integerValue / 100];
    CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:24.0] constrainedToSize:CGSizeMake(100, view.price.viewHeight)];
    view.price.viewWidth = size.width + 25;
        
        
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:model.gmtBegin.doubleValue];
    if (0 == [date compareWithToday]) {
        view.icNewImgView1.hidden = NO;
        view.description.frame = CGRectMake(25, 3, 120, 16);
        
    }
    else if([date compareWithToday]<0)
    {
        view.icNewImgView1.hidden = YES;
        view.description.left = view.bottomBg1.left + 2;
        view.description.frame = CGRectMake(5, 3, 140, 16);
    }
    
    double nowInterval = [[NSDate date] timeIntervalSince1970] + [MIConfig globalConfig].timeOffset;
    double interval = model.gmtBegin.doubleValue - nowInterval;
    if (interval > 0) {
        view.price.textColor = [MIUtility colorWithHex:0xff0000];
        view.viewsInfo.textColor = [MIUtility colorWithHex:0x8dbb1a];
        view.viewsInfo.text = [[NSDate dateWithTimeIntervalSince1970:model.gmtBegin.doubleValue] stringForTimeTips2];

    }
    else if (model.gmtEnd.floatValue < nowInterval){
        view.viewsInfo.text = @"已结束";
        view.viewsInfo.textColor = [UIColor grayColor];
        view.statusImage.hidden = NO;
        view.statusImage.image = [UIImage imageNamed:@"ic_timeout"];
        view.price.textColor = [UIColor grayColor];
         }
    else{
        if ([model.eventType isEqualToString:@"show"]) {
            view.viewsInfo.text = [NSString stringWithFormat:@"%1.f折起",model.discount.floatValue/10];
        }
        else if (model.stock >0){
                view.statusImage.hidden = YES;
                view.price.textColor = [MIUtility colorWithHex:0xff0000];
                NSString *clickColumn;
                float clicksVolumn = model.clickNum.floatValue;
                if (clicksVolumn >= 10000.0) {
                    clickColumn = [[NSString alloc] initWithFormat:@"%.1f万人在抢", clicksVolumn / 10000.0];
                } else {
                    clickColumn = [[NSString alloc] initWithFormat:@"%.f人在抢", clicksVolumn];
                }
                view.viewsInfo.text = clickColumn;
        }
        
        else{
            view.statusImage.hidden = NO;
            view.statusImage.image = [UIImage imageNamed:@"ic_sellout"];
            view.viewsInfo.text = @"抢光了";
            view.price.textColor = [UIColor grayColor];

        }
        view.viewsInfo.textColor = [UIColor grayColor];
    }
         
    CGSize viewInfoSize = [view.viewsInfo.text sizeWithFont:[UIFont systemFontOfSize:11]];
    view.viewsInfo.viewWidth = viewInfoSize.width;
    view.viewsInfo.right = view.bottomBg1.right - 7;
}
- (void)reloadTableViewForSale
{
    [self.baseTableView reloadData];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [super scrollViewDidScroll:scrollView];
    
    CGFloat y = scrollView.contentOffset.y;
    if (y < _lastscrollViewOffset - 15 || y <= 0) {
        [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
            if (y > self.view.viewHeight - TABBAR_HEIGHT)
            {
                self.goTopImageView.hidden = NO;
            }
            else
            {
                self.goTopImageView.hidden = YES;
            }
        } completion:^(BOOL finished){
        }];
    } else if (y > _lastscrollViewOffset + 5 && y > 0 && _tuanArray.count > 0){
        [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.goTopImageView.hidden = YES;
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
