//
//  MICategoryViewController.m
//  MISpring
//
//  Created by XU YUJIAN on 13-1-25.
//  Copyright (c) 2013年 Husor Inc.. All rights reserved.
//

#import "MIZhiMainViewController.h"
#import "MIZhiCatModel.h"
#import "MIZhiItemsGetModel.h"
#import "MIZhiItemModel.h"
#import "MIZhiItemCell.h"
#import "MIZhiHotsGetModel.h"
#import "MIZhiActivitiesGetModel.h"
#import "MITuanTenCatModel.h"
#import "MISVTopObject.h"

#define MIZhiPageSize  20

@implementation MIZhiMainViewController

@synthesize request = _request;

@synthesize zhiItems = _zhiItems;
@synthesize datasCates = _datasCates;
@synthesize datasCateIds = _datasCateIds;
@synthesize datasCateNames = _datasCateNames;

@synthesize lastscrollViewOffset = _lastscrollViewOffset;

- (id)initWithTag:(NSString *)tag;
{
    self = [super init];
    if (self) {
        // Custom initialization
        _cat = @"";
        _tag = tag;
        _currentIndex = 0;
        _isShowScreen = NO;
    }
    return self;
}

- (void)goToTopOfView
{
    [self.baseTableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    self.goTopImageView.hidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.needRefreshView = YES;
    [self.navigationBar setBarLeftButtonItem:self selector:@selector(showScreenView) imageKey:@"ic_category"];
    
    self.zhiItems = [[NSMutableArray alloc] initWithCapacity:20];
    self.datasCates = [[NSMutableArray alloc] initWithCapacity:10];
    self.datasCateNames = [[NSMutableArray alloc] initWithCapacity:10];
    self.datasCateIds = [[NSMutableArray alloc] initWithCapacity:10];
    
    self.baseTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _baseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _baseTableView.backgroundColor = [UIColor clearColor];
    _baseTableView.backgroundView.alpha = 0;
    _baseTableView.delegate = self;
    _baseTableView.dataSource = self;
    
    _goTopImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.viewWidth - 50, self.view.bottom - 45, 36, 36)];
    self.goTopImageView.image = [UIImage imageNamed:@"ic_scrollstotop"];
    self.goTopImageView.hidden = YES;
    self.goTopImageView.userInteractionEnabled = YES;
    [self.goTopImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToTopOfView)]];
    [self.view addSubview:self.goTopImageView];
    
    if (_tag) {
        [self.navigationBar setBarTitle:_tag textSize:20.0];
        _baseTableView.frame = CGRectMake(0, self.navigationBarHeight, SCREEN_WIDTH, self.view.viewHeight - self.navigationBarHeight);
        [self.view bringSubviewToFront:self.navigationBar];
    } else {
        [self.navigationBar setBarTitle:@"超值爆料"  textSize:20.0];
        _baseTableView.frame = CGRectMake(0, self.navigationBarHeight + 38, SCREEN_WIDTH, self.view.viewHeight - self.navigationBarHeight - 38);
        _baseTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, PHONE_SCREEN_SIZE.width, 3)];
        
        _shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, PHONE_SCREEN_SIZE.width, self.view.viewHeight)];
        self.shadowView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.35];
        self.shadowView.alpha = 0;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenScreenView)];
        [self.shadowView addGestureRecognizer:tap];
        [self.view addSubview:self.shadowView];
        [self.view bringSubviewToFront:self.navigationBar];
        
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
        
        [self loadCatsData:YES];
        
        [self.view insertSubview:self.screenView belowSubview:self.navigationBar];
    }
    
    __weak typeof(self) weakSelf = self;
    _request = [[MIZhiItemsGetRequest alloc] init];
    _request.onCompletion = ^(MIZhiItemsGetModel *model) {
        [weakSelf finishLoadTableViewData:model];
    };
    _request.onError = ^(MKNetworkOperation* completedOperation, MIError* error) {
        [weakSelf failLoadTableViewData];
        MILog(@"error_msg=%@",error.description);
    };
    
    _activityRequest = [[MIZhiActivitiesGetRequest alloc] init];
    _activityRequest.onCompletion = ^(MIZhiActivitiesGetModel *model) {
        if (model.zhiItems.count > 0) {
            
            if (weakSelf.loading) {
                weakSelf.loading = NO;
                [super finishLoadTableViewData];
            }
            [weakSelf setOverlayStatus:EOverlayStatusRemove labelText:nil];
            [weakSelf.zhiItems removeAllObjects];
            [weakSelf.zhiItems addObjectsFromArray:model.zhiItems];
            weakSelf.hasMore = NO;
            [weakSelf.baseTableView reloadData];
        }
    };
    
    _activityRequest.onError = ^(MKNetworkOperation* completedOperation, MIError* error) {
        MILog(@"error_msg=%@",error.description);
        [weakSelf setOverlayStatus:EOverlayStatusError labelText:nil];
    };
    
    _hotRequest = [[MIZhiHotGetRequest alloc] init];
    _hotRequest.onCompletion = ^(MIZhiHotsGetModel *model) {
        if (model.zhiItems.count > 0) {
            if (weakSelf.loading) {
                weakSelf.loading = NO;
                [super finishLoadTableViewData];
            }
            [weakSelf setOverlayStatus:EOverlayStatusRemove labelText:nil];
            [weakSelf.zhiItems removeAllObjects];
            [weakSelf.zhiItems addObjectsFromArray:model.zhiItems];
            weakSelf.hasMore = NO;
            [weakSelf.baseTableView reloadData];
        }
    };
    
    _hotRequest.onError = ^(MKNetworkOperation* completedOperation, MIError* error) {
        MILog(@"error_msg=%@",error.description);
        [weakSelf setOverlayStatus:EOverlayStatusError labelText:nil];
    };
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.zhiItems.count == 0) {
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
    [_hotRequest cancelRequest];
    [_activityRequest cancelRequest];
}

- (void)selectedIndex:(int)index
{
    //顶部导航条刷新类目
    [_topScrollView setButtonUnSelect];
    _topScrollView.scrollViewSelectedChannelID = index+100;
    [_topScrollView setButtonSelect];
    //类目列表刷新类目
    [_screenView synButtonSelectWithIndex:index];
}

- (void)selectedCatId:(NSString *)catId catName:(NSString *)catName
{
    _cat = catId;
    [self.navigationBar setBarTitle:@"超值爆料"  textSize:20.0];
    //获取热门活动，热门爆料的静态接口
    if ([_cat isEqualToString:@"action"])
    {
        [_activityRequest sendQuery];
        [self setOverlayStatus:EOverlayStatusLoading labelText:nil];
    }
    else if ([_cat isEqualToString:@"hotBaoLiao"])
    {
        [_hotRequest sendQuery];
        [self setOverlayStatus:EOverlayStatusLoading labelText:nil];
    }
    else
    {
        [self refreshData];
    }
    [self hiddenScreenView];
    [MobClick event:kZhiCatClicks label:catName];
}

- (void)selectedSelf
{
    [self hiddenScreenView];
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
- (void) refreshData {
    
    _hasMore = NO;
    [_request cancelRequest];
    [_zhiItems removeAllObjects];
    [_baseTableView reloadData];
    
    self.loading = YES;
    [_request setPage:1];
    [_request setPageSize:MIZhiPageSize];
    [_request setCat:_cat];
    if (_tag)
    {
        [_request setTag:_tag];
    } else {
        [_request setTag:@""];
    }
    [_request sendQuery];
    [self setOverlayStatus:EOverlayStatusLoading labelText:nil];
}

- (void) setTopScrollCatArray:(NSArray *)cats
{
    NSMutableArray *catArray = [[NSMutableArray alloc] initWithCapacity:0];;
    for (int i = 0; i < cats.count; i++)
    {
        MIZhiCatModel *model = [cats objectAtIndex:i];
        MISVTopObject *object = [[MISVTopObject alloc] init];
        object.catId = model.catKey;
        object.catName = model.catName;
        [catArray addObject:object];
    }
    self.topScrollView.catArray = catArray;
    [self.topScrollView initWithNameButtons];
}

- (void)loadCatsData:(BOOL)reload
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
                   {
                       NSMutableArray *cats = [[MIConfig getZhiCategory] mutableCopy];
                       MIZhiCatModel *zhiCat1 = [[MIZhiCatModel alloc] init];
                       zhiCat1.catKey = @"action";
                       zhiCat1.catName = @"精选活动";
                       [cats insertObject:zhiCat1 atIndex:1];
                       MIZhiCatModel *zhiCat2 = [[MIZhiCatModel alloc] init];
                       zhiCat2.catKey = @"hotBaoLiao";
                       zhiCat2.catName = @"热门爆料";
                       [cats insertObject:zhiCat2 atIndex:2];
                       

                       dispatch_async(dispatch_get_main_queue(), ^
                                      {
                                          [self setTopScrollCatArray:cats];
                                          if (!self.screenView) {
                                              _screenView = [[MIScreenView alloc] initWithArray:cats];
                                              self.screenView.delegate = self;
                                              [self.view addSubview:self.screenView];
                                              [self.view bringSubviewToFront:self.navigationBar];
                                          } else {
                                              [self.screenView reloadContenWithCats:cats];
                                          }
                                          
                                          _isShowScreen = NO;
                                          self.screenView.frame = CGRectMake(0, -self.screenView.viewHeight - 20, self.screenView.viewWidth, self.screenView.viewHeight);
                                          if (self.cat && self.cat.length) {
                                              for (MIZhiCatModel *cat in cats)
                                              {
                                                  if ([self.cat isEqualToString:cat.catKey])
                                                  {
                                                      [self selectedIndex:[cats indexOfObject:cat]];
                                                      break;
                                                  }
                                              }
                                          } else {
                                              self.cat = @"all";
                                          }
                                      });
                   });
}

#pragma mark - EGOPullFresh methods
- (void)reloadTableViewDataSource
{
    if ([_cat isEqualToString:@"action"])
    {
        if (self.loading) {
            [_activityRequest cancelRequest];
        }
        [_activityRequest sendQuery];

    }
    else if ([_cat isEqualToString:@"hotBaoLiao"])
    {
        if (self.loading) {
            [_hotRequest cancelRequest];
        }
        [_hotRequest sendQuery];
    }
    else
    {
        if (self.loading) {
            [_request cancelRequest];
        }
        
        [_request setPage:1];
        [_request sendQuery];
    }
    self.loading = YES;
    if (self.zhiItems.count > 0) {
        [self setOverlayStatus:EOverlayStatusRemove labelText:nil];
    } else {
        [self setOverlayStatus:EOverlayStatusLoading labelText:nil];
    }
}

- (void)finishLoadTableViewData:(MIZhiItemsGetModel *)model
{
    [self setOverlayStatus:EOverlayStatusRemove labelText:nil];
    if (self.loading) {
        self.loading = NO;
        [super finishLoadTableViewData];
    }
    
    if (model.page.integerValue == 1) {
        [_zhiItems removeAllObjects];
    }
    
    if (model.zhiItems.count != 0) {
        [self.zhiItems addObjectsFromArray:(NSMutableArray *)model.zhiItems];
    }
    if (self.zhiItems.count != 0) {
        if (model.count.integerValue > self.zhiItems.count && model.zhiItems.count) {
            _hasMore = YES;
        } else {
            _hasMore = NO;
        }
        
        [_baseTableView reloadData];
    } else {
        [self setOverlayStatus:EOverlayStatusEmpty labelText:nil];
        [self.view insertSubview:self.overlayView belowSubview:self.screenView];
    }
}

- (void)failLoadTableViewData
{
    if (self.loading) {
        self.loading = NO;
        [super failLoadTableViewData];
    }
    
    [self setOverlayStatus:EOverlayStatusRemove labelText:nil];
    if ([self.zhiItems count] == 0) {
        [self setOverlayStatus:EOverlayStatusReload labelText:nil];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [super scrollViewDidScroll:scrollView];
    
    CGFloat y = scrollView.contentOffset.y;
    if (y < _lastscrollViewOffset - 15 || y <= 0) {
        [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
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
    } else if (y > _lastscrollViewOffset + 5 && y > 0 && _zhiItems.count > 0){
        [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.goTopImageView.hidden = YES;
        } completion:^(BOOL finished){
        }];
    }
    _lastscrollViewOffset = y;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = [self.zhiItems count];
    
    if (rows > 0 && _hasMore) {
        rows++;
    }
    return rows;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat heiht = 0.0;
    if (_hasMore && (self.zhiItems.count == indexPath.row)) {
        heiht = 50; //加载更多的cell高度
    } else {
        heiht = 120;
    }
    return heiht;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger count = [self.zhiItems count];
    if (_hasMore && (count > 0) && (indexPath.row == count) && !self.loading) {
        self.loading = YES;
        [_request setPage:(self.zhiItems.count / MIZhiPageSize + 1)];
        [_request sendQuery];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ContentIdentifier = @"ZhiCellReuseIdentifier";
    static NSString *LoadMoreIdentifier = @"LoadMoreCellReuseIdentifier";
    if (_hasMore && (self.zhiItems.count == indexPath.row)) {
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
        MIZhiItemCell *zhiCell = [tableView dequeueReusableCellWithIdentifier:ContentIdentifier];
        if (!zhiCell) {
            zhiCell = [[MIZhiItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ContentIdentifier];
        }

        MIZhiItemModel *model = [self.zhiItems objectAtIndex:indexPath.row];
        zhiCell.itemModel = model;
        zhiCell.cat = self.cat;
        NSString *imgUrl = [[NSString alloc] initWithFormat:@"%@!150x150.jpg", model.img];
        [zhiCell.itemImage sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"default_avatar_img"]];
        //title,promotion
        zhiCell.itemTitle.text = [NSString stringWithFormat:@"%@  <font color='#bb1800'>%@</font>",model.title,model.promotion];
        //source,date
        NSString *dateString = [[NSDate dateWithTimeIntervalSince1970:model.createTime.doubleValue] stringForTimeRelative];
        zhiCell.timeLabel.text = dateString;
        if (model.source && model.source.length > 0) {
            zhiCell.timeLabel.text = [dateString stringByAppendingFormat:@"   来自%@",model.source];
        } else {
            zhiCell.timeLabel.text = [dateString stringByAppendingString:@"   来自其它"];
        }
        //vote
        if (model.voteCount.integerValue > 0) {
            if (model.voteCount.integerValue > 999) {
                zhiCell.voteLabel.text = @"999+";
            } else {
                zhiCell.voteLabel.text = model.voteCount.stringValue;
            }
        } else {
            zhiCell.voteLabel.text = @"值";
        }
        //comment
        if (model.commentCount.integerValue > 0) {
            if (model.commentCount.integerValue > 999) {
                zhiCell.commentLabel.text = @"999+";
            } else {
                zhiCell.commentLabel.text = model.commentCount.stringValue;
            }
        } else {
            zhiCell.commentLabel.text = @"评论";
        }
        
        if (model.vote.boolValue) {
            zhiCell.voteImageView.image = [UIImage imageNamed:@"ic_zan_middle"];
        } else {
            zhiCell.voteImageView.image = [UIImage imageNamed:@"ic_zan_small"];
        }
        
        if (model.status.integerValue == 2)
        {
            zhiCell.statusImage.image = [UIImage imageNamed:@"ic_zhi_soldout"];
            zhiCell.statusImage.hidden = NO;
        }
        else if (model.status.integerValue == 4)
        {
            zhiCell.statusImage.image = [UIImage imageNamed:@"ic_zhi_outoftime"];
            zhiCell.statusImage.hidden = NO;
        }
        else {
            zhiCell.statusImage.hidden = YES;
        }
        return zhiCell;
    }
}

@end
