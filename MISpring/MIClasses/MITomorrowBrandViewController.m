//
//  MITomorrowBrandViewController.m
//  MISpring
//
//  Created by 曲俊囡 on 14-6-17.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MITomorrowBrandViewController.h"
#import "MIBrandViewController.h"
#import "MIBrandTomorrowGetModel.h"
#import "MIBrandItemModel.h"
#import "MIItemModel.h"
//#import "MIBrandTuanItemCell.h"
#import "MITomorrowBrandCell.h"
#import "MITomorrowBrandItemView.h"
#import "MIBrandTeMaiViewController.h"

@interface MITomorrowBrandViewController ()

@end

@implementation MITomorrowBrandViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        _hasMore = NO;
        _tuanBrandPageSize = 10;
        
        _tuanArray = [[NSMutableArray alloc] initWithCapacity:10];
        
        _datasCateNames = [[NSMutableArray alloc] initWithCapacity:10];
        _datasCateIds = [[NSMutableArray alloc] initWithCapacity:10];
        
        __weak typeof(self) weakSelf = self;
        _request = [[MIBrandTomorrowRequest alloc] init];
        _request.onCompletion = ^(MIBrandTomorrowGetModel *model) {
            [weakSelf finishLoadTableViewData:model];
        };
        
        _request.onError = ^(MKNetworkOperation* completedOperation, MIError* error) {
            [weakSelf failLoadTableViewData];
            MILog(@"error_msg=%@",error.description);
        };
        [_request setCat:@""];
        [_request setPageSize:_tuanBrandPageSize];

    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.needRefreshView = YES;
    [self.navigationBar removeFromSuperview];
    self.overlayView.top -= 44;
    
    _tuanItems = [[NSMutableArray alloc]initWithCapacity:0];
    _recomItems = [[NSMutableArray alloc]initWithCapacity:0];

    self.baseTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _baseTableView.frame = CGRectMake(0, 0, PHONE_SCREEN_SIZE.width, self.view.viewHeight - self.navigationBarHeight - 44);
    _baseTableView.backgroundColor = [UIColor clearColor];
    _baseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _baseTableView.showsVerticalScrollIndicator = NO;
    _baseTableView.backgroundView.alpha = 0;
    _baseTableView.alpha = 0;
    _baseTableView.dataSource = self;
    _baseTableView.delegate = self;
    [self.view sendSubviewToBack:_baseTableView];
    _baseTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.viewWidth, 5)];
    
    self.refreshTableView.refreshTitleImg.image = [UIImage imageNamed:@"txt_refresh_pinpai"];
    
    _headerView = [[MITomorrowHeaderView alloc]initWithFrame:CGRectMake(0, 0, self.view.viewWidth, 170)];
    _headerView.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goToBrandVC)];
    [_headerView.bgView addGestureRecognizer:tap];

    
    _footerView = [[MITomorrowFooterView alloc]initWithFrame:CGRectMake(0, 0, self.view.viewWidth, 40)];
    _footerView.backgroundColor = [UIColor clearColor];
    
    _goTopImageView = [[MIGoTopView alloc] initWithFrame:CGRectMake(self.view.viewWidth - 50, self.view.viewHeight - self.navigationBarHeight - 89, MISCROLL_TO_TOP_HEIGHT, MISCROLL_TO_TOP_HEIGHT)];
    _goTopImageView.delegate = self;
    _goTopImageView.hidden = YES;
    [self.view addSubview:self.goTopImageView];

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.tuanArray.count == 0)
    {
        _hasMore = NO;
        self.loading = YES;
        _currentBrandCount = 0;
        [_request setPage:1];
        [_request sendQuery];
        [self setOverlayStatus:EOverlayStatusLoading labelText:nil];
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

- (void)viewDidAppear:(BOOL)animated
{
}

-(void)viewDidDisappear:(BOOL)animated
{
}

- (void)goTopViewClicked
{
    [self.baseTableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    self.goTopImageView.hidden = YES;
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

- (void)finishLoadTableViewData:(MIBrandTomorrowGetModel *)model
{
    [self setOverlayStatus:EOverlayStatusRemove labelText:nil];
    
    if (self.loading) {
        self.loading = NO;
        [super finishLoadTableViewData];
    }
    _currentPage = model.page.integerValue;
    if (model.page.integerValue == 1) {
        _currentBrandCount = 0;
        [_tuanItems removeAllObjects];
        [_recomItems removeAllObjects];
    }
    _currentBrandCount += model.brandItems.count;
    [_tuanItems addObjectsFromArray:model.brandItems];
    [_recomItems addObjectsFromArray:model.recomBrands];

    if (_tuanItems.count > 0) {
        if (model.count.integerValue > _currentBrandCount) {
            _hasMore = YES;
            _baseTableView.tableFooterView = nil;
        } else {
            _hasMore = NO;
            _baseTableView.tableFooterView = _footerView;
        }
        _baseTableView.tableHeaderView = nil;
    } else {
        if (_recomItems.count == 0) {
            _headerView.bgView.hidden = YES;
        }
        _baseTableView.tableHeaderView = _headerView;
        _baseTableView.tableFooterView = nil;
        if (model.emptyDesc && ![model.emptyDesc isEmpty]) {
            _headerView.emptyLabel.text = model.emptyDesc;
        }else{
            _headerView.emptyLabel.text = @"明日预告更新时间：中午11点，节假日除外。此刻米姑娘正在为你疯狂砍价中，晚点再来看吧~";
        }
    }
    if (_tuanItems.count > 0) {
        _tuanArray = _tuanItems;
    }else{
        _tuanArray = _recomItems;
    }
    _baseTableView.alpha = 1;
    [_baseTableView reloadData];
}

-(void)goToBrandVC
{
    MIBrandTeMaiViewController *vc = [[MIBrandTeMaiViewController alloc]init];
    vc.isNavigationBar = YES;
    [[MINavigator navigator]openPushViewController:vc animated:YES];
}

- (void)failLoadTableViewData
{
    if (self.loading) {
        self.loading = NO;
        [super failLoadTableViewData];
    }
    
    if (_tuanArray.count == 0) {
        [self setOverlayStatus:EOverlayStatusReload labelText:nil];
    }else{
        [self setOverlayStatus:EOverlayStatusRemove labelText:nil];
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows;
    if (_tuanArray.count %2 == 0) {
        rows = self.tuanArray.count /2;
    }
    else{
        rows = (self.tuanArray.count + 1)/2;
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
    NSInteger count = _tuanArray.count;
    NSInteger rows = [self tableView:tableView numberOfRowsInSection:0] - 1;
    if (_hasMore && (indexPath.row == rows) && (count > 0))
    {
        return 50;
    }
    else
    {
        return (SCREEN_WIDTH - 24) / 2 + 54 + 8;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger count = _tuanArray.count;
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
    NSInteger count = _tuanArray.count;
    NSInteger rows = [self tableView:tableView numberOfRowsInSection:0] - 1;
    
    static NSString *brandIdentifier = @"brandCellReuseIdentifier";
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
    }
    else
    {
        MITomorrowBrandCell *brandCell = [tableView dequeueReusableCellWithIdentifier:brandIdentifier];
        if (!brandCell)
        {
            brandCell = [[MITomorrowBrandCell alloc] initWithReuseIdentifier:brandIdentifier];
            brandCell.selectionStyle = UITableViewCellSelectionStyleNone;
            brandCell.backgroundColor = [UIColor clearColor];
        }
        
        for (NSInteger i = indexPath.row*2; i < (indexPath.row + 1) * 2; i ++) {
            @try {
                MIBrandItemModel *brandModel = (MIBrandItemModel *)[_tuanArray objectAtIndex:i];
                if (i == indexPath.row*2) {
                    brandCell.itemView1.hidden = NO;
                    brandCell.itemView1.brandModel = brandModel;
                    [self updateCellView:brandCell.itemView1 brandModel:brandModel];
                } else {
                    brandCell.itemView2.hidden = NO;
                    brandCell.itemView2.brandModel = brandModel;
                    [self updateCellView:brandCell.itemView2 brandModel:brandModel];
                }
            }
            @catch (NSException *exception) {
                if (i == indexPath.row*2) {
                    brandCell.itemView1.hidden = YES;
                } else {
                    brandCell.itemView2.hidden = YES;
                }
            }
        }
        return brandCell;
    }
}

-(void)updateCellView:(MITomorrowBrandItemView *)itemView  brandModel:(MIBrandItemModel *)brandModel
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
