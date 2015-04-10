//
//  MITomorrowTuanViewController.m
//  MISpring
//
//  Created by 曲俊囡 on 14-7-31.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MITomorrowTuanViewController.h"
#import "MITuanTomorrowGetModel.h"
#import "MITuanItemModel.h"
#import "MITuanItemView.h"
#import "MITuanItemsCell.h"
#import "MITuanDetailViewController.h"
#import "MITuanViewController.h"

@interface MITomorrowTuanViewController ()

@end

@implementation MITomorrowTuanViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _hasMore = NO;
        _tuanTenPageSize = 20;
        
        _tuanArray = [[NSMutableArray alloc]initWithCapacity:0];
        
        __weak typeof(self) weakSelf = self;
        _request = [[MITuanTomorrowRequest alloc] init];
        _request.onCompletion = ^(MITuanTomorrowGetModel *model) {
            [weakSelf finishLoadTableViewData:model];
        };
        
        _request.onError = ^(MKNetworkOperation* completedOperation, MIError* error) {
            [weakSelf failLoadTableViewData];
            MILog(@"error_msg=%@",error.description);
        };
        [_request setCat:@""];
        _subject = @"10yuan";
        [_request setPageSize:_tuanTenPageSize];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
        
    _headerView = [[MITomorrowHeaderView alloc]initWithFrame:CGRectMake(0, 0, self.view.viewWidth, 170)];
    _headerView.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goToTuanVC)];
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
        [_request setPage:1];
        [_request setSubject:_subject];
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

- (void)finishLoadTableViewData:(MITuanTomorrowGetModel *)model
{
    [self setOverlayStatus:EOverlayStatusRemove labelText:nil];
    
    if (self.loading) {
        self.loading = NO;
        [super finishLoadTableViewData];
    }
    if (model.page.integerValue == 1) {
        [_tuanItems removeAllObjects];
        [_recomItems removeAllObjects];
        [_baseTableView reloadData];
    }
    
    [_tuanItems addObjectsFromArray:model.tuanItems];
    [_recomItems addObjectsFromArray:model.recomItems];
    
    if (_tuanItems.count > 0) {
        if (model.count.integerValue > _tuanArray.count) {
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
        _tuanArray  = _tuanItems;
    }else{
        _tuanArray = _recomItems;
    }

    _baseTableView.alpha = 1;
    [_baseTableView reloadData];
}

- (void)failLoadTableViewData
{
    [self setOverlayStatus:EOverlayStatusRemove labelText:nil];
    
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

//刷新产品的cell
- (void)updateCellView:(MITuanItemView *)view tuanModel:(MITuanItemModel *)model
{
    view.item = model;
    [view.indicatorView startAnimating];
    
    NSMutableString *imgUrl = [NSMutableString stringWithString:model.img];
    [imgUrl appendString:@"_310x310.jpg"];
    [view.itemImage sd_setImageWithURL:[NSURL URLWithString:imgUrl]];
    view.statusImage.hidden = YES;

    double nowInterval = [[NSDate date] timeIntervalSince1970] + [MIConfig globalConfig].timeOffset;
    double interval = model.startTime.doubleValue - nowInterval;
    if (interval > 0) {
        view.viewsInfo.textColor = [MIUtility colorWithHex:0x8dbb1a];
        view.viewsInfo.text = [[NSDate dateWithTimeIntervalSince1970:model.startTime.doubleValue] stringForTimeTips2];
    } else {
        NSString *clickColumn;
        float clicksVolumn = model.clicks.floatValue + model.volumn.floatValue;
        if (clicksVolumn >= 10000.0) {
            clickColumn = [[NSString alloc] initWithFormat:@"%.1f万人在抢", clicksVolumn / 10000.0];
        } else {
            clickColumn = [[NSString alloc] initWithFormat:@"%.f人在抢", clicksVolumn];
        }
        view.viewsInfo.text = clickColumn;
        view.viewsInfo.textColor = [UIColor lightGrayColor];
    }
    
    NSString *decimal = model.price.pointValue;
    view.price.text = [[NSString alloc] initWithFormat:@"<font size=12.0>￥</font><font size=15.0>%ld</font><font size=12.0>%@</font>", (long)(model.price.integerValue) / 100, decimal];
    view.price.textAlignment = NSTextAlignmentLeft;
    NSString *desc = [model.title stringByReplacingOccurrencesOfString:@"【" withString:@"["];
    desc = [desc stringByReplacingOccurrencesOfString:@"，" withString:@","];
    view.description.text = [desc stringByReplacingOccurrencesOfString:@"】" withString:@"]"];
}

-(void)goToTuanVC
{
    MITuanViewController *tenTuanVC = [[MITuanViewController alloc] init];
    tenTuanVC.isNavigationBar = YES;
    if ([_subject isEqualToString:@"youpin"]) {
        tenTuanVC.cat = @"";
    }else{
        tenTuanVC.cat = @"9kuai9";
    }
    tenTuanVC.subject = _subject;
     [[MINavigator navigator] openPushViewController:tenTuanVC animated:YES];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        NSInteger count = _tuanArray.count;
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

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger count = [_tuanArray count];
    NSInteger rows = [self tableView:tableView numberOfRowsInSection:0] - 1;
    
    if (_hasMore && (count > 0) && (indexPath.row == rows) && !self.loading) {
        self.loading = YES;
        [_request setPage:(_tuanArray.count / _tuanTenPageSize + 1)];
        [_request sendQuery];
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
                MITuanItemModel *model = (MITuanItemModel *)[_tuanArray objectAtIndex:i];
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
    if (y < _lastscrollViewOffset - 15) {
        [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
            if (y > self.view.viewHeight)
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
