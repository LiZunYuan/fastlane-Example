//
//  MITenTemaiBaseViewController.m
//  MISpring
//
//  Created by husor on 14-12-4.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MITenTemaiBaseViewController.h"
#import "MIMainScrollView.h"
#import "MIBaseTableView.h"

@interface MITenTemaiBaseViewController ()<MITopScrollViewDelegate>
{

}
@end

@implementation MITenTemaiBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _lastscrollViewOffset = 0;
    self.tuanTenPageSize = 20;
    self.needRefreshView = YES;
    self.titleArray = [[NSMutableArray alloc] initWithCapacity:10];
    [self.navigationBar setBarTitle:_navigationBarTitle];
    [self.navigationBar setBarLeftButtonItem:self selector:@selector(backToPreviousVC) imageKey:@"navigationbar_btn_back"];
    
    //类目
    UIView *catView = [[UIView alloc] initWithFrame:CGRectMake(0, self.navigationBarHeight, PHONE_SCREEN_SIZE.width, 38)];
    catView.backgroundColor = [UIColor whiteColor];
    _topScrollView = [[MITopScrollView alloc] initWithFrame:CGRectMake(0, 0, PHONE_SCREEN_SIZE.width - 38, 38)];
    _topScrollView.topScrollViewDelegate = self;
    _topScrollView.showsHorizontalScrollIndicator = NO;
    _topScrollView.showsVerticalScrollIndicator = NO;
    _topScrollView.topScrollViewDelegate = self;
    _topScrollView.bounces = NO;
    _topScrollView.backgroundColor = [UIColor whiteColor];
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
    
    _scroll = [[MIMainScrollView alloc]initWithFrame:CGRectMake(0, catView.bottom, PHONE_SCREEN_SIZE.width, self.view.viewHeight - catView.bottom)];
    _scroll.backgroundColor = [UIColor clearColor];
    _scroll.bounces = NO;
    _scroll.showsHorizontalScrollIndicator = NO;
    _scroll.showsVerticalScrollIndicator = NO;
    _scroll.pagingEnabled = YES;
    _scroll.delegate = self;
    [self.view addSubview:_scroll];
    
    [self addScreenView];
    
    _tableArr = [[NSMutableArray alloc]initWithCapacity:_cats.count];
    for (NSInteger i = 0; i< _cats.count; i++) {
        MIBaseTableView *table = [[MIBaseTableView alloc]initWithFrame:CGRectMake(i*PHONE_SCREEN_SIZE.width, 0, _scroll.viewWidth, _scroll.viewHeight)];
        table.refreshTableView.refreshTitleImg.image = [UIImage imageNamed:@"txt_refresh_10yuan"];
        MITuanTenCatModel *model = [_cats objectAtIndex:i];
        table.cat = model.catId;
        table.backgroundColor = [UIColor clearColor];
        [_scroll addSubview:table];
        [_tableArr addObject:table];
        
        if (self.cat && [model.catId isEqualToString:self.cat]) {
            _topScrollView.currentPage = i;
        }
    }
    [self selectedIndex:_topScrollView.currentPage];
    
    _scroll.contentSize = CGSizeMake(self.view.viewWidth * _cats.count, 0);
    _scroll.contentOffset = CGPointMake(PHONE_SCREEN_SIZE.width * _topScrollView.currentPage, 0);
    
    _shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, PHONE_SCREEN_SIZE.width, self.view.viewHeight)];
    self.shadowView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.35];
    self.shadowView.alpha = 0;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenScreenView)];
    [self.shadowView addGestureRecognizer:tap];
    [self.view addSubview:self.shadowView];
    [self.view bringSubviewToFront:self.navigationBar];
}

- (void)addScreenView
{
    //由子类实现
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self hiddenScreenView];
    [self tableWillAppear];
}

- (void)finishLoadTableViewData:(id)model
{
    if (self.tableArr.count > self.topScrollView.currentPage) {
        MIBaseTableView *table = [self.tableArr objectAtIndex:self.topScrollView.currentPage];
        [table finishLoadTableViewData:model];
    }
}

-(void)backToPreviousVC
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) tableWillAppear
{
    if (_tableArr.count > _topScrollView.currentPage) {
        MIBaseTableView *table = [_tableArr objectAtIndex:_topScrollView.currentPage];
        table.request = self.request;
        if ([table respondsToSelector:@selector(willAppearView)]) {
            [table performSelector:@selector(willAppearView) withObject:nil];
        }
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
        [self.view bringSubviewToFront:self.screenView];
        [self.view bringSubviewToFront:self.navigationBar];
    }
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

- (NSMutableArray *)loadTuanCatsData:(BOOL)reload
{
    return nil;
}

- (void) setTopScrollCatArray:(NSArray *)cats
{
    _cats = cats;
    self.titleArray = [[NSMutableArray alloc] initWithCapacity:0];;
    for (NSInteger i = 0; i < cats.count; i++)
    {
        MITuanTenCatModel *model = [cats objectAtIndex:i];
        [self.titleArray addObject:model.catName];
    }
    self.topScrollView.titleArray = self.titleArray;
    
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger page = scrollView.contentOffset.x/pageWidth;
    if (page != _topScrollView.currentPage && scrollView.contentOffset.x == page * self.view.viewWidth && _cats.count > page)
    {
        [_topScrollView selectIndexInScrollView:page];
        MITuanTenCatModel *model = [_cats objectAtIndex:page];
        self.cat = model.catId;
        [self tableWillAppear];
    }
    [self.screenView synButtonSelectWithIndex:page];
}

#pragma mark - MITopScrollViewDelegate
- (void)selectedTitleIndex:(NSInteger)index
{
    [_scroll setContentOffset:CGPointMake(index*self.view.viewWidth, 0) animated:YES];
    [self.screenView synButtonSelectWithIndex:index];
    if (_cats.count > index) {
        MITuanTenCatModel *model = [_cats objectAtIndex:index];
        if (![model.catId isEqualToString:self.cat])
        {
            self.cat = model.catId;
            [self tableWillAppear];
        }
    }
}

#pragma mark-MIScreenSelectedDelegate
- (void)selectedCatId:(NSString *)catId catName:(NSString *)catName
{
    [self hiddenScreenView];
    [MobClick event:kTemaiCatClicks label:catName];
    self.cat = catId;
    NSInteger index = -1;
    for (NSInteger i = 0; i < self.cats.count; ++i) {
        MITuanTenCatModel *catModel = [self.cats objectAtIndex:i];
        if ([catModel.catId isEqualToString:self.cat]) {
            index = i;
            break;
        }
    }
    
    if (index != -1 && index != self.cats.count && _tableArr.count > index) {
        MIBaseTableView *table = [_tableArr objectAtIndex:index];
        if ([table respondsToSelector:@selector(willAppearView)]) {
            [table performSelector:@selector(willAppearView) withObject:nil];
        }
        _topScrollView.currentPage = index;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        _scroll.contentOffset = CGPointMake(PHONE_SCREEN_SIZE.width*index, 0);
        [UIView commitAnimations];
    }
}
- (void)selectedIndex:(NSInteger)index
{
    [_topScrollView selectIndexInScrollView:index];
    //类目列表刷新类目
    [_screenView synButtonSelectWithIndex:index];
    if (_cats.count > index) {
        MITuanTenCatModel *model = [_cats objectAtIndex:index];
        _cat = model.catId;
        if (_scroll) {
            _scroll.contentOffset = CGPointMake(self.view.viewWidth * index, 0);
        }
        [self tableWillAppear];
        [self hiddenScreenView];
    }
}

- (void)selectedSelf
{
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
