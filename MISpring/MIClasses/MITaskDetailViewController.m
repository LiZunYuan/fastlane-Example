//
//  MITaskDetailViewController.m
//  MISpring
//
//  Created by 曲俊囡 on 14-5-26.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MITaskDetailViewController.h"
#import "MITaskDetailCell.h"
#import "MICoinEarnHistoryGetModel.h"
#import "MIItemModel.h"

@interface MITaskDetailViewController ()

@end

@implementation MITaskDetailViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        _tuanArray = [[NSMutableArray alloc] initWithCapacity:10];

    }
    return self;
}

- (void)loadView
{
    [super loadView];
    self.needRefreshView = YES;

    [self.navigationBar setBarTitle:@"收入明细"  textSize:20.0];
    
    self.baseTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _baseTableView.frame = CGRectMake(0, self.navigationBarHeight, self.view.viewWidth, self.view.viewHeight - self.navigationBarHeight);
    _baseTableView.backgroundColor = [UIColor clearColor];
    _baseTableView.backgroundView.alpha = 0;
    _baseTableView.delegate = self;
    _baseTableView.dataSource = self;
    _baseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _baseTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    __weak typeof(self) weakSelf = self;
    _request = [[MICoinEarnHistoryGetRequest alloc] init];
    _request.onCompletion = ^(MICoinEarnHistoryGetModel *model) {
        [weakSelf finishLoadTableViewData:model];
    };
    
    _request.onError = ^(MKNetworkOperation* completedOperation, MIError* error) {
        [weakSelf failLoadTableViewData];
        MILog(@"error_msg=%@",error.description);
    };
    [_request setPage:1];
    [_request setPageSize:20];
    [_request sendQuery];
    [self setOverlayStatus:EOverlayStatusLoading labelText:nil];

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

- (void)finishLoadTableViewData:(MICoinEarnHistoryGetModel *)model
{
    [self setOverlayStatus:EOverlayStatusRemove labelText:nil];
    
    if (self.loading) {
        self.loading = NO;
        [super finishLoadTableViewData];
    }
    
    if (model.page.integerValue == 1) {
        [_tuanArray removeAllObjects];
    }
    if (model.items.count != 0) {
        [_tuanArray addObjectsFromArray:model.items];
    }
    if (_tuanArray.count != 0) {
        if (model.count.integerValue > _tuanArray.count) {
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

#pragma mark - TableView datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = [self.tuanArray count];
    
    if (rows > 0 && _hasMore) {
        rows++;
    }
    return rows;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat heiht = 0.0;
    if (_hasMore && (self.tuanArray.count == indexPath.row)) {
        heiht = 50; //加载更多的cell高度
    } else {
        heiht = 90;
    }
    return heiht;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger count = [self.tuanArray count];
    if (_hasMore && (count > 0) && (indexPath.row == count) && !self.loading) {
        self.loading = YES;
        [_request setPage:(self.tuanArray.count / 20 + 1)];
        [_request sendQuery];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"taskDetailCell";
    static NSString *LoadMoreIdentifier = @"LoadMoreCellReuseIdentifier";
    if (_hasMore && (self.tuanArray.count == indexPath.row)) {
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
        
        MITaskDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"MITaskDetailCell" owner:self options:nil] objectAtIndex:0];
        }
        MIItemModel *item = [self.tuanArray objectAtIndex:indexPath.row];
        cell.nameLabel.text = item.appName;
        cell.incomeLabel.text = [NSString stringWithFormat:@"%d 米币",item.coin.intValue];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:item.time.longValue];
        cell.timeLabel.text = [date stringForDateline];
        
        return cell;
    }

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
