//
//  MIBrandTuanViewController.m
//  MISpring
//
//  Created by 曲俊囡 on 14-7-4.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MIBrandTuanViewController.h"
#import "MIBrandViewController.h"
#import "MITuanBrandCatModel.h"
#import "MITuanBrandGetModel.h"
#import "MIBrandItemModel.h"
#import "MIItemModel.h"
#import "MIBrandCell.h"
#import "MIBrandTuanItemCell.h"

@interface MIBrandTuanViewController ()
{
     NSInteger _newItemInteger;
}
@end

@implementation MIBrandTuanViewController
@synthesize request = _request;
@synthesize datasCateIds = _datasCateIds;
@synthesize datasCateNames = _datasCateNames;
@synthesize lastscrollViewOffset = _lastscrollViewOffset;


- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        _hasMore = NO;
        _isShowScreen = NO;
        _tuanBrandPageSize = 10;
        
        _cat = @"";
        _tuanArray = [[NSMutableArray alloc] initWithCapacity:10];
        _datasCateNames = [[NSMutableArray alloc] initWithCapacity:10];
        _datasCateIds = [[NSMutableArray alloc] initWithCapacity:10];
        
        __weak typeof(self) weakSelf = self;
        _request = [[MITuanBrandGetRequest alloc] init];
        _request.onCompletion = ^(MITuanBrandGetModel *model) {
            [weakSelf finishLoadTableViewData:model];
        };
        
        _request.onError = ^(MKNetworkOperation* completedOperation, MIError* error) {
            [weakSelf failLoadTableViewData];
            MILog(@"error_msg=%@",error.description);
        };
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.needRefreshView = YES;
    [self.navigationBar setBarTitle:@"品牌特卖"];
    
    self.titleArray = [[NSMutableArray alloc] initWithCapacity:10];
    
    self.baseTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    if (self.isTabBar)
    {
        _baseTableView.frame = CGRectMake(0, self.navigationBarHeight, PHONE_SCREEN_SIZE.width, self.view.viewHeight-self.navigationBarHeight - TABBAR_HEIGHT);
        [self.navigationBar setBarLeftButtonItem:self selector:@selector(showScreenView) imageKey:@"ic_category"];
    }
    else
    {
        _baseTableView.frame = CGRectMake(0, self.navigationBarHeight + 38, PHONE_SCREEN_SIZE.width, self.view.viewHeight-self.navigationBarHeight - 38);
        //类目
        UIView *catView = [[UIView alloc] initWithFrame:CGRectMake(0, self.navigationBarHeight, PHONE_SCREEN_SIZE.width, 38)];
        catView.backgroundColor = [UIColor whiteColor];
        _topScrollView = [[SVTopScrollView alloc] init];
        _topScrollView.screenDelegate = self;
        [catView addSubview:_topScrollView];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor whiteColor];
        [button setImage:[UIImage imageNamed:@"bg_catbar_arrow"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(showScreenView) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(PHONE_SCREEN_SIZE.width - 38, 0, 38, 38);
        [catView addSubview:button];
        
        UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 37, PHONE_SCREEN_SIZE.width, 1)];
        bottomLine.backgroundColor = [UIColor colorWithWhite:0.75 alpha:0.45];
        [catView addSubview:bottomLine];
        [self.view addSubview:catView];
        
        [self.view insertSubview:self.screenView belowSubview:self.navigationBar];

    }
    _baseTableView.backgroundColor = [UIColor clearColor];
    _baseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _baseTableView.showsVerticalScrollIndicator = NO;
    _baseTableView.backgroundView.alpha = 0;
    _baseTableView.dataSource = self;
    _baseTableView.delegate = self;
    
    _baseTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, PHONE_SCREEN_SIZE.width, 5)];
    [self.view sendSubviewToBack:_baseTableView];
    
    _goTopImageView = [[MIGoTopView alloc] initWithFrame:CGRectMake(self.view.viewWidth - 50, _baseTableView.bottom - 45, MISCROLL_TO_TOP_HEIGHT, MISCROLL_TO_TOP_HEIGHT)];
    _goTopImageView.delegate = self;
    _goTopImageView.hidden = YES;
    [self.view addSubview:self.goTopImageView];
    
    
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
    
    [self hiddenScreenView];
    
    NSDate *lastUpdateTuanTime = [[NSUserDefaults standardUserDefaults] objectForKey:kLastUpdateBrandTime];
    NSInteger interval = [lastUpdateTuanTime timeIntervalSinceNow];
    if (interval <= MIAPP_ONE_HOUR_INTERVAL && [[Reachability reachabilityForInternetConnection] isReachable]) {
        //如果超出一小时，清空特卖缓存
        [self.tuanArray removeAllObjects];
        [self loadTuanCatsData:YES];
    }

    if (self.tuanArray.count == 0)
    {
        //重新请求数据
        [self refreshData];
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

- (void)selectedIndex:(NSInteger)index
{
    //顶部导航条刷新类目
    [_topScrollView setButtonUnSelect];
    _topScrollView.scrollViewSelectedChannelID = index+100;
    [_topScrollView setButtonSelect];
    //类目列表刷新类目
    [_screenView synButtonSelectWithIndex:index];
    
    if (_cats.count > index) {
        MITuanBrandCatModel *model = [_cats objectAtIndex:index];
        if (self.isTabBar)
        {
            [self.navigationBar setBarTitle:model.catName];
        }
        _cat = model.catId;
        [self refreshData];
        [self hiddenScreenView];
        [MobClick event:kBrandCatClicks label:model.catName];
    }
}


- (void)goTopViewClicked
{
    [self.baseTableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    self.goTopImageView.hidden = YES;
}

//- (void)selectedCatId:(NSString *)catId catName:(NSString *)catName
//{
//    if (self.isTabBar)
//    {
//        [self.navigationBar setBarTitle:catName];
//    }
//    _cat = catId;
//    [self refreshData];
//    [self hiddenScreenView];
//    [MobClick event:kTemaiCatClicks label:catName];
//}
- (void)selectedSelf
{
    [self hiddenScreenView];
}
- (void)hiddenScreenView
{
    if (self.screenView && _isShowScreen) {
        _isShowScreen = NO;
        self.shadowView.alpha = 0;
        [UIView animateWithDuration:0.3 animations:^{
            self.screenView.frame = CGRectMake(0, -self.screenView.viewHeight - 20, self.screenView.viewWidth, self.screenView.viewHeight);
        }];
    }
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

- (void) setTopScrollCatArray:(NSArray *)cats
{
    self.titleArray = [[NSMutableArray alloc] initWithCapacity:0];;
    for (NSInteger i = 0; i < cats.count; i++)
    {
        MITuanBrandCatModel *model = [cats objectAtIndex:i];
        [self.titleArray addObject:model.catName];
    }
    self.topScrollView.catArray = self.titleArray;
    [self.topScrollView initWithNameButtons];
}


//得到类目cat的数据
- (void)loadTuanCatsData:(BOOL)reload
{
    _cat = @"";
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
                   {
                       NSArray *cats = [MIConfig getBrandCategory];
                       dispatch_async(dispatch_get_main_queue(), ^
                                      {
                                          if (!self.screenView) {
                                              _cats = cats;
                                              [self setTopScrollCatArray:cats];
                                              _screenView = [[MIScreenView alloc] initWithArray:self.titleArray];
                                              self.screenView.delegate = self;
                                              [self.view addSubview:self.screenView];
                                              [self.view bringSubviewToFront:self.navigationBar];
                                          } else {
                                              [self.screenView reloadContenWithCats:self.titleArray];
                                          }
                                          
                                          //初始化参数为全部
                                          _cat = @"";
                                          _isShowScreen = NO;
                                          self.screenView.frame = CGRectMake(0, -self.screenView.viewHeight - 20, self.screenView.viewWidth, self.screenView.viewHeight);
                                      });
                   });
}

- (void) refreshData
{
    _hasMore = NO;
    [_request cancelRequest];
      _currentBrandCount = 0;
    
    self.loading = YES;
    [_request setCat:_cat];
    [_request setPage:1];
    [_request setPageSize:_tuanBrandPageSize];
    [_request sendQuery];
    [self setOverlayStatus:EOverlayStatusLoading labelText:nil];
}

#pragma mark - EGOPullFresh methods
-(NSString *)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView *)view
{
    return @"独家精选大牌，全场1折起";
}

//下拉刷新
#pragma mark - EGOPullFresh methods
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
    [_request sendQuery];
}

- (void)finishLoadTableViewData:(MITuanBrandGetModel *)model
{
    [self setOverlayStatus:EOverlayStatusRemove labelText:nil];
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date]
                                              forKey:kLastUpdateBrandTime];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if (self.loading) {
        self.loading = NO;
        [super finishLoadTableViewData];
    }
    
    _currentPage = model.page.integerValue;
    if (model.page.integerValue == 1) {
        _currentBrandCount = 0;
        [_tuanArray removeAllObjects];
    }
    
    _totalCount = model.count.integerValue;
    _currentBrandCount += model.brandItems.count;
    
    [self.tuanArray addObjectsFromArray:model.brandItems];
    
     [self calculateRows:self.tuanArray];
    
    if (_tuanArray.count != 0) {
        if (model.count.integerValue > _currentBrandCount) {
            _hasMore = YES;
        } else {
            _hasMore = NO;
        }
        
        [_baseTableView reloadData];
    } else {
        [self setOverlayStatus:EOverlayStatusEmpty labelText:nil];
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
        [self setOverlayStatus:EOverlayStatusReload labelText:nil];
    }
}

- (void)reloadTableViewForSale
{
    [_baseTableView reloadData];
    MILog(@"timer is fired for sale");
}

#pragma mark - Table view data source

- (void)calculateRows:(NSArray *)modelArray
{
    if (modelArray.count > 0) {
        _newItemInteger = 0;
        if (!([self.cat isEqualToString:@"all"] || [self.cat isEqualToString:@""])) {
            _newItemInteger = modelArray.count;
            return;
        }
        
    if (modelArray.count > 0) {
        MIBrandItemModel *model = [modelArray objectAtIndex:0];
        NSNumber *startTime1 = [NSNumber numberWithInteger:[model.startTime integerValue]];
        _newItemInteger = 0;

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
    }
  }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = 0;
    if (self.tuanArray.count > _newItemInteger)
    {
        rows = (self.tuanArray.count - _newItemInteger  + 1) / 2;
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
    NSInteger count = [self.tuanArray count];
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

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger count = [_tuanArray count];
    NSInteger rows = [self tableView:tableView numberOfRowsInSection:0] - 1;
    
    if (_hasMore && (count > 0) && (indexPath.row == rows) && !self.loading) {
        self.loading = YES;
        [_request setPage:(_currentPage + 1)];
        [_request setPageSize:_tuanBrandPageSize];
        [_request sendQuery];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger count = [_tuanArray count];
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
            
            if (self.tuanArray.count > indexPath.row) {
                MIBrandItemModel *brandModel = (MIBrandItemModel *)[self.tuanArray objectAtIndex:indexPath.row];
                brandCell.itemModel = brandModel;
                brandCell.retainNumLabel.text = [NSString stringWithFormat:@"共%d件",brandModel.goodsCount.intValue];

                [brandCell.shopImageView sd_setImageWithURL:[NSURL URLWithString:brandModel.logo] placeholderImage:[UIImage imageNamed:@"mizhewang_logo"]];
                brandCell.shopNameLabel.text = brandModel.sellerNick;
                CGSize size = [brandCell.shopNameLabel.text sizeWithFont:brandCell.shopNameLabel.font];
                brandCell.shopNameLabel.viewWidth = size.width;
                brandCell.lastImageView.left = brandCell.shopNameLabel.right + 4;
                
                brandCell.discountLabel.text = [NSString stringWithFormat:@"%.1f 折起",brandModel.discount.intValue / 10.0];
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:brandModel.startTime.doubleValue];
                if ([date compareWithToday2]) {
                    brandCell.lastImageView.hidden = NO;
                } else {
                    brandCell.lastImageView.hidden = YES;
                }
                
                if (brandModel.items.count > 2) {
                    MIItemModel *item0 = [brandModel.items objectAtIndex:0];
                    NSString *imgUrl0 = [NSString stringWithFormat:@"%@_310x310.jpg",item0.img];
                    [brandCell.leftView.imageView sd_setImageWithURL:[NSURL URLWithString:imgUrl0] placeholderImage:[UIImage imageNamed:@"img_loading_daily1"]];
                    brandCell.leftView.priceLabel.text = [NSString stringWithFormat:@"%@", item0.price.priceValue];
                    
                    MIItemModel *item1 = [brandModel.items objectAtIndex:1];
                    NSString *imgUrl1 = [NSString stringWithFormat:@"%@_310x310.jpg",item1.img];
                    [brandCell.rightView.imageView sd_setImageWithURL:[NSURL URLWithString:imgUrl1] placeholderImage:[UIImage imageNamed:@"img_loading_small"]];
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
                        MIBrandItemModel *brandModel = (MIBrandItemModel *)[self.tuanArray objectAtIndex:i + _newItemInteger ];
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
    
    if (brandModel.items.count > 0) {
        MIItemModel *item0 = [brandModel.items objectAtIndex:0];
        NSString *imgUrl0 = [NSString stringWithFormat:@"%@_310x310.jpg",item0.img];
        [itemView.itemImgView sd_setImageWithURL:[NSURL URLWithString:imgUrl0] placeholderImage:[UIImage imageNamed:@"img_loading_daily1"]];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row != self.tuanArray.count && indexPath.row < _newItemInteger && self.tuanArray.count > indexPath.row) {
        MIBrandItemModel *brandModel = (MIBrandItemModel *)[self.tuanArray objectAtIndex:indexPath.row];
        MIBrandViewController *vc = [[MIBrandViewController alloc] initWithAid:brandModel.aid.intValue];
        vc.cat = self.cat;
        vc.origin = brandModel.origin.integerValue;
        [[MINavigator navigator] openPushViewController:vc animated:YES];
    }
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
