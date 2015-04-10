//
//  MIBrandTeMaiViewController.m
//  MISpring
//
//  Created by husor on 14-12-16.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MIBrandTeMaiViewController.h"
#import "MIBrandViewController.h"
#import "MITuanBrandCatModel.h"
#import "MIBrandTableView.h"
#import "MIPageBaseRequest.h"
#import "MIBrandItemModel.h"

@interface MIBrandTeMaiViewController ()
{
    UIButton *_screenBtn;
    UIView  *_topBg;
    UIView *_statusBgView;
    UIView *_titleLabelBottomLine;
    UIView *_shadowLine;
}
@end

@implementation MIBrandTeMaiViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.needRefreshView = YES;
    _isShowScreen = NO;
    self.titleArray = [[NSMutableArray alloc] initWithCapacity:10];
    
    if (self.isNavigationBar) {
        _scrollTop = [[MITopScrollView alloc] initWithFrame:CGRectMake(0, self.navigationBarHeight, self.view.viewWidth - 33,33)];
    }else{
        _scrollTop = [[MITopScrollView alloc] initWithFrame:CGRectMake(0,IOS7_STATUS_BAR_HEGHT, self.view.viewWidth - 33,44)];
     }
    _scrollTop.showsHorizontalScrollIndicator = NO;
    _scrollTop.showsVerticalScrollIndicator = NO;
    _scrollTop.topScrollViewDelegate = self;
    _scrollTop.bounces = NO;
    _scrollTop.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_scrollTop];
    _scrollTop.scrollsToTop = NO;
    
    if (!self.isNavigationBar) {
        _shadowLine = [[UIView alloc]initWithFrame:CGRectMake(0, IOS7_STATUS_BAR_HEGHT + 44, self.view.viewWidth, 0)];
        [_shadowLine drawShadowWithoffset:CGSizeMake(0, 0.6) radius:0.6 color:[UIColor blackColor] opacity:0.3];
        [self.view addSubview:_shadowLine];
    }
    
    if (self.isNavigationBar) {
        _mainScrollView = [[MIMainScrollView alloc]initWithFrame:CGRectMake(0,_scrollTop.bottom  , PHONE_SCREEN_SIZE.width, self.view.viewHeight -_scrollTop.bottom )] ;
    }
    else{
        _mainScrollView = [[MIMainScrollView alloc] initWithFrame:CGRectMake(0, _scrollTop.bottom + 0.5 , PHONE_SCREEN_SIZE.width, self.view.viewHeight  - TABBAR_HEIGHT -_scrollTop.bottom - 0.5)];
    }
    _mainScrollView.showsHorizontalScrollIndicator = NO;
    _mainScrollView.pagingEnabled = YES;
    _mainScrollView.delegate = self;
    [self.view addSubview:_mainScrollView];
    _mainScrollView.scrollsToTop = NO;
    
    if (self.isNavigationBar) {
        _shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, _scrollTop.bottom, PHONE_SCREEN_SIZE.width, self.view.viewHeight  - _scrollTop.bottom )];
    }else{
        _shadowView = [[UIView alloc] initWithFrame:CGRectMake(0,_scrollTop.bottom , PHONE_SCREEN_SIZE.width, self.view.viewHeight - TABBAR_HEIGHT - _scrollTop.bottom)];
    }
    self.shadowView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.35];
    self.shadowView.alpha = 0;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenScreenView)];
    [self.shadowView addGestureRecognizer:tap];
    [self.view addSubview:self.shadowView];
    [self.view insertSubview:self.shadowView belowSubview:_scrollTop];

    
    _tableViews = [[NSMutableArray alloc]initWithCapacity:0];
    
    _topAdView = [[MITopAdView alloc]initWithFrame:CGRectMake(0, 0, self.view.viewWidth, 50)];
    _topAdView.clickEventLabel = kBrandTopAds;
    _topAdView.hidden = YES;
    
    self.screenView = [[MIScreenView alloc]init];
    self.screenView.frame = _scrollTop.frame;
    self.screenView.delegate = self;
    self.screenView.alpha = 0;
    [self.view addSubview:self.screenView];
    
    [self loadTuanCatsData:YES];
    
    _screenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _screenBtn.backgroundColor = [UIColor whiteColor];
    [_screenBtn setImage:[UIImage imageNamed:@"the_drop_down"] forState:UIControlStateNormal];
    [_screenBtn addTarget:self action:@selector(showScreenView) forControlEvents:UIControlEventTouchUpInside];
    _screenBtn.frame = CGRectMake(_scrollTop.right, _scrollTop.top, PHONE_SCREEN_SIZE.width - _scrollTop.viewWidth, _scrollTop.viewHeight);
    [self.view addSubview:_screenBtn];
    
    UIView *screenLine = [[UIView alloc] initWithFrame:CGRectMake(0, (_scrollTop.viewHeight - 14) / 2, 1, 14)];
    screenLine.backgroundColor = [MIUtility colorWithHex:0xeeeeee];
    [_screenBtn addSubview:screenLine];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, _screenBtn.viewHeight - 0.5, _screenBtn.viewWidth, 0.5)];
    line.backgroundColor = [MIUtility colorWithHex:0xe4e4e4];
    [_screenBtn addSubview:line];
    
    _topBg = [[UIView alloc]initWithFrame:CGRectMake(0, _scrollTop.top, self.view.viewWidth - _screenBtn.viewWidth, _scrollTop.viewHeight)];
    _topBg.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.frame = CGRectMake(_topBg.centerX-30 + 44/2.0, 0, 60, _scrollTop.viewHeight);
    titleLabel.text = @"分类列表";
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor whiteColor];
    titleLabel.textColor = [MIUtility colorWithHex:0x999999];
    [_topBg addSubview:titleLabel];
    
    _titleLabelBottomLine = [[UIView alloc]initWithFrame:CGRectMake(0, _topBg.viewHeight - 0.5, self.view.viewWidth, 0.5)];
    _titleLabelBottomLine.backgroundColor = [MIUtility colorWithHex:0xe4e4e4];
    [_topBg addSubview:_titleLabelBottomLine];
    _topBg.alpha = 0;
    [self.view addSubview:_topBg];
    
    
    if (self.isNavigationBar) {
        [self.navigationBar setBarTitle:@"品牌特卖"];
        [self.navigationBar setBarLeftButtonItem:self selector:@selector(backToPrevious) imageKey:@"navigationbar_btn_back"];
    }
    else{
        self.navigationBar.hidden = YES;
    }
    
    _statusBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.viewWidth, IOS7_STATUS_BAR_HEGHT)];
    _statusBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_statusBgView];
    
    [self.view insertSubview:self.shadowView aboveSubview:_mainScrollView];
    [self.view insertSubview:self.screenView aboveSubview:self.shadowView];
    [self.view insertSubview:_scrollTop aboveSubview:self.screenView];
    [self.view insertSubview:_topBg aboveSubview:_scrollTop];
    [self.view bringSubviewToFront:_shadowLine];
    [self.view bringSubviewToFront:self.navigationBar];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self hiddenScreenView];
    
    NSDate *lastUpdateTuanTime = [[NSUserDefaults standardUserDefaults] objectForKey:kLastUpdateBrandTemaiTime];
    NSInteger interval = [lastUpdateTuanTime timeIntervalSinceNow];
    if (interval <= MIAPP_ONE_HOUR_INTERVAL && [[Reachability reachabilityForInternetConnection] isReachable]) {
        //如果超出一天，清空特卖缓存
        [self loadTuanCatsData:YES];
    }
    
    if(_currentView && [_currentView respondsToSelector:@selector(willAppearView)])
    {
        [_currentView performSelector:@selector(willAppearView) withObject:nil];
    }
}

- (void)relayoutView {
    [super relayoutView];
    
    CGFloat offset = HOTSPOT_STATUSBAR_HEIGHT;
    if (IS_HOTSPOT_ON) {
        offset = -HOTSPOT_STATUSBAR_HEIGHT;
    }

//    if (self.isNavigationBar) {
//        _mainScrollView.viewHeight = self.view.viewHeight - _scrollTop.bottom + offset;
//    } else {
//        _mainScrollView.viewHeight = self.view.viewHeight - TABBAR_HEIGHT -_scrollTop.bottom - 0.5 + offset;
//    }

    _mainScrollView.viewHeight += offset;
    for (UIView *tableView in _tableViews) {
        if (tableView.viewHeight != _mainScrollView.viewHeight) {
            tableView.viewHeight = _mainScrollView.viewHeight;
        }
    }

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if([_currentView respondsToSelector:@selector(willDisappearView)])
    {
        [_currentView performSelector:@selector(willDisappearView) withObject:nil];
    }
    [self setOverlayStatus:EOverlayStatusRemove labelText:nil];
}

-(void)backToPrevious
{
    [self.navigationController popViewControllerAnimated:YES];
}

// 选中某个类目
- (void)selectedIndex:(NSInteger)index
{
    [_mainScrollView setContentOffset:CGPointMake(index *self.view.viewWidth, 0) animated:YES];
    if (_tableViews.count > index && _scrollTop.currentPage == index) {
        [self canScrollToTopWithIndex:index];
        [self.screenView synButtonSelectWithIndex:index];
        [self hiddenScreenView];
        NSDictionary *dic = [_cats objectAtIndex:index];
        [MobClick event:kBrandCatClicks label:[dic objectForKey:@"desc"]];
    }
}

// 添加顶部scroll的类目
- (void) setTopScrollCatArray:(NSArray *)cats
{
    [_mainScrollView removeAllSubviews];
    [self.titleArray removeAllObjects];
    [_tableViews removeAllObjects];
    
    [self setMainCats:cats tabs:[MIConfig getBrandTabs]];
    
    NSInteger catIndex = 0;
    for (NSInteger i = 0; i < _cats.count; i++)
    {
        NSDictionary *dict = [_cats objectAtIndex:i];
        NSString *cat = [dict objectForKey:@"cat"];
        if ([cat isEqualToString:_cat]) {
            catIndex = i;
        }
        [self.titleArray addObject:[NSString stringWithFormat:@"%@",[dict objectForKey:@"desc"]]];
        CGRect frame = CGRectMake(i*PHONE_SCREEN_SIZE.width, 0, self.view.viewWidth, _mainScrollView.viewHeight);
        MIBrandTableView *table = [[MIBrandTableView alloc] initWithFrame:frame];
        table.catId = cat;
        table.refreshTableView.refreshTitleImg.image = [UIImage imageNamed:@"txt_refresh_pinpai"];
        table.cat = cat;
        MIPageBaseRequest *request = [[MIPageBaseRequest alloc]init];
        request.onCompletion = ^(id model){
            [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:kLastUpdateBrandTemaiTime];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [table finishLoadTableViewData:model];
        };
        request.onError = ^(MKNetworkOperation *completedOperation,MIError *error){
            [table failLoadTableViewData];
            MILog(@"error_msg=%@",error.description);
        };
        [request setFormat:[dict objectForKey:@"api_url"]];
        [request setModelName:NSStringFromClass([MITuanBrandGetModel class])];
        [request setPage:1];
        [request setPageSize:20];
        table.request = request;
        [_mainScrollView addSubview:table];
        [_tableViews addObject:table];
        if (i == 0)
        {
            _currentView = table;
            if([_currentView respondsToSelector:@selector(willAppearView)])
            {
                [_currentView performSelector:@selector(willAppearView) withObject:nil];
            }
        }
    }
    _scrollTop.titleArray = self.titleArray;
    _mainScrollView.contentSize = CGSizeMake(self.titleArray.count * self.view.viewWidth, 0);
    _mainScrollView.contentOffset = CGPointMake(catIndex * self.view.viewWidth, 0);
    
    [self.screenView reloadContenWithCats:self.titleArray];
    [self.screenView synButtonSelectWithIndex:catIndex];
    self.screenView.frame = CGRectMake(0, -self.screenView.viewHeight - 20, self.screenView.viewWidth, self.screenView.viewHeight);
    
    [_scrollTop selectIndexInScrollView:catIndex];
}

- (void)setMainCats:(NSArray *)cats tabs:(NSArray *)tabs
{
    NSMutableArray *mainCats = [[NSMutableArray alloc] initWithCapacity:9];
    NSString *apiUrl = [NSString stringWithFormat:@"http://m.mizhe.com/brand/all-{int}-{int}---1.html"];
    apiUrl = [apiUrl stringByReplacingOccurrencesOfString:@"{int}" withString:@"%d"];
    NSDictionary *newDict = @{@"desc":@"上新",@"api_url":apiUrl,@"cat":@"all"};
    [mainCats addObject:newDict];
    
    NSDictionary *yesterdayTab = nil;
    if (tabs && tabs.count > 0) {
        for (NSDictionary *dict in tabs) {
            if ([[dict objectForKey:@"desc"] isEqualToString:@"昨日热卖"]) {
                yesterdayTab = dict;
            }
            else {
                [mainCats addObject:dict];
            }
        }
    }
    
    for (NSInteger i = 0; i < cats.count; ++i)
    {
        MITuanBrandCatModel *model = [cats objectAtIndex:i];
        if (![model.catId isEqualToString:@"all"])
        {
            NSString *apiUrl = [NSString stringWithFormat:@"http://m.mizhe.com/brand/%@-{int}-{int}---1.html",model.catId];
            apiUrl = [apiUrl stringByReplacingOccurrencesOfString:@"{int}" withString:@"%d"];
            NSDictionary *dict = @{@"type":@"temai",@"desc":model.catName,@"api_url":apiUrl,@"cat":model.catId};
            [mainCats addObject:dict];
        }
    }
    
    // 昨日热卖加在最后面
    if (yesterdayTab) {
        [mainCats addObject:yesterdayTab];
    }
    
    _cats = mainCats;
}

//得到类目cat的数据
- (void)loadTuanCatsData:(BOOL)reload
{
    if (!self.isNavigationBar) {
        //初始化参数为全部
        _cat = @"";
    }
    NSArray *cats = [MIConfig getBrandCategory];
    [self setTopScrollCatArray:cats];
}

- (void)showScreenView
{
    if (self.screenView)
    {
        if (!_isShowScreen)
        {
            [UIView animateWithDuration:0.3 animations:^{
                self.shadowView.alpha = 1;
                _shadowLine.hidden = YES;
                _topBg.alpha = 1;
                [_screenBtn setImage:[UIImage imageNamed:@"Up_arrow"] forState:UIControlStateNormal];
                self.screenView.frame = CGRectMake(0, _scrollTop.bottom, self.screenView.viewWidth, self.screenView.viewHeight);
                self.screenView.alpha = 1;

            }];
            _isShowScreen = YES;
        }
        else
        {
            [UIView animateWithDuration:0.3 animations:^{
                _shadowLine.hidden = NO;
                self.shadowView.alpha = 0;
                _topBg.alpha = 0;
                [_screenBtn setImage:[UIImage imageNamed:@"the_drop_down"] forState:UIControlStateNormal];
                self.screenView.bottom = _scrollTop.bottom ;
                self.screenView.alpha = 0;
            }];
            _isShowScreen = NO;
        }
    }
}

- (void)hiddenScreenView
{
    if (self.screenView && _isShowScreen) {
        _isShowScreen = NO;
        self.shadowView.alpha = 0;
        _shadowLine.hidden = NO;
        [_screenBtn setImage:[UIImage imageNamed:@"the_drop_down"] forState:UIControlStateNormal];
        [UIView animateWithDuration:0.3 animations:^{
            _topBg.alpha = 0;
            self.screenView.bottom = _scrollTop.bottom ;
            self.screenView.alpha = 0;
        }];
    }
}

-(void)canScrollToTopWithIndex:(NSInteger)index
{
    if ([_currentView respondsToSelector:@selector(willDisappearView)]) {
        [_currentView performSelector:@selector(willDisappearView)];
    }
    _currentView = [_tableViews objectAtIndex:index];
    if([_currentView respondsToSelector:@selector(willAppearView)])
    {
        [_currentView performSelector:@selector(willAppearView) withObject:nil];
    }
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = scrollView.contentOffset.x/pageWidth;
    if (page != _scrollTop.currentPage && scrollView.contentOffset.x == page * self.view.viewWidth && _tableViews.count > page)
    {
        [_scrollTop selectIndexInScrollView:page];
        [self canScrollToTopWithIndex:page];
        NSDictionary *dic = [_cats objectAtIndex:page];
        [MobClick event:kBrandCatClicks label:[dic objectForKey:@"desc"]];
    }
    [self.screenView synButtonSelectWithIndex:page];
    [self hiddenScreenView];
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
