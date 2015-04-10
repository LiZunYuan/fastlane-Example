//
//  MITuanBaseViewController.m
//  MISpring
//
//  Created by 曲俊囡 on 14-7-22.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MITuanBaseViewController.h"
#import "MITuanItemModel.h"
#import "MITuanItemView.h"
#import "MITuanItemsCell.h"
#import "MITuanDetailViewController.h"
#import "MITuanTenCatModel.h"

@interface MITuanBaseViewController ()


@end

@implementation MITuanBaseViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        _hasMore = NO;
        _isShowScreen = NO;
        _tuanTenPageSize = 20;
        _subject = @"all";
        
        _datasCateNames = [[NSMutableArray alloc] initWithCapacity:10];
        _datasCateIds = [[NSMutableArray alloc] initWithCapacity:10];
        _tuanArray = [[NSMutableArray alloc] initWithCapacity:20];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.needRefreshView = YES;
    [self.navigationBar setBarTitle:_navigationBarTitle];

    self.titleArray = [[NSMutableArray alloc] initWithCapacity:10];
    
    self.baseTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _baseTableView.frame = CGRectMake(0, self.navigationBarHeight + 38, PHONE_SCREEN_SIZE.width, self.view.viewHeight - self.navigationBarHeight - 38);
    _baseTableView.backgroundColor = [UIColor clearColor];
    _baseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _baseTableView.showsVerticalScrollIndicator = NO;
    _baseTableView.backgroundView.alpha = 0;
    _baseTableView.dataSource = self;
    _baseTableView.delegate = self;
    _baseTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, PHONE_SCREEN_SIZE.width, 5)];
    _baseTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, PHONE_SCREEN_SIZE.width, 2)];
    [self.view sendSubviewToBack:_baseTableView];
    
    if (self.segmentType == MITuanSegmentViewNormal)
    {
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
    }
    else
    {
        _baseTableView.frame = CGRectMake(0, self.navigationBarHeight, PHONE_SCREEN_SIZE.width, self.view.viewHeight - self.navigationBarHeight - TABBAR_HEIGHT);
        [self.navigationBar setBarLeftButtonItem:self selector:@selector(showScreenView) imageKey:@"ic_category"];
    }
    
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
    if (self.tuanArray.count == 0) {
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
    
    [self setOverlayStatus:EOverlayStatusRemove labelText:nil];
}

- (void)goTopViewClicked
{
    [self.baseTableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    self.goTopImageView.hidden = YES;
}

//- (void)selectedCatId:(NSString *)catId catName:(NSString *)catName
//{
//    [self hiddenScreenView];
//    [MobClick event:kTemaiCatClicks label:catName];
//}
- (void)selectedIndex:(NSInteger)index
{
    //顶部导航条刷新类目
    [_topScrollView setButtonUnSelect];
    _topScrollView.scrollViewSelectedChannelID = index+100;
    [_topScrollView setButtonSelect];
    //类目列表刷新类目
    [_screenView synButtonSelectWithIndex:index];
    
    if (_cats.count > index) {
        MITuanTenCatModel *model = [_cats objectAtIndex:index];
        _cat = model.catId;
        [self hiddenScreenView];
        [MobClick event:kTemaiCatClicks label:model.catName];
    }
}
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
    _cats = cats;
    self.titleArray = [[NSMutableArray alloc] initWithCapacity:0];;
    for (NSInteger i = 0; i < cats.count; i++)
    {
        MITuanTenCatModel *model = [cats objectAtIndex:i];
        [self.titleArray addObject:model.catName];
    }
    self.topScrollView.catArray = self.titleArray;
    [self.topScrollView initWithNameButtons];
}

//得到类目cat的数据
- (void)loadTuanCatsData:(BOOL)reload
{
   
}

- (void) refreshData {
    
    _hasMore = NO;
    self.loading = YES;
    [_tuanArray removeAllObjects];
    [_baseTableView reloadData];
}
//下拉刷新
#pragma mark - EGOPullFresh methods
- (void)reloadTableViewDataSource
{
  
}

//刷新产品的cell
- (void)updateCellView:(MITuanItemView *)view tuanModel:(MITuanItemModel *)model
{
   
}
- (void)reloadTableViewForSale
{
    [self.baseTableView reloadData];
    MILog(@"timer is fired for sale");
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
        return 206.5;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger count = [_tuanArray count];
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
                id model = [_tuanArray objectAtIndex:i];
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
