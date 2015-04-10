//
//  MIMallsOrderViewController.m
//  MISpring
//
//  Created by Yujian Xu on 13-3-19.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIMallsOrderViewController.h"
#import "MIOrderMallGetModel.h"
#import "MIMallOrderModel.h"
#import "MIOrderMallCoinAwardModel.h"
#import "UIImage+MIAdditions.h"

#define MIMALL_OREDE_PAGESIZE     10
#define MIMALL_OREDE_ITEM_ACTIVITY 1
#define MIMALL_OREDE_ITEM_COMMIT   2
#define MIMALL_OREDE_ITEM_PRICE    3
#define MIMALL_OREDE_ITEM_IMAGE    4

@interface MIOrderMallItemCell:UITableViewCell

@property(nonatomic, strong) UIImageView *mallLogo;
@property(nonatomic, strong) RTLabel * mallLabel;
@property(nonatomic, strong) RTLabel * priceLabel;
//@property(nonatomic, strong) RTLabel * mobileLabel;

@end

@implementation MIOrderMallItemCell
@synthesize mallLogo;
@synthesize mallLabel;
@synthesize priceLabel;
//@synthesize mobileLabel;

- (id) initWithreuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    if (self) {
        mallLogo = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 80, 40)];

        mallLabel = [[RTLabel alloc] initWithFrame: CGRectMake(100, 6, 200, 20)];
        mallLabel.backgroundColor = [UIColor clearColor];
        mallLabel.textColor = [UIColor colorWithWhite:.2 alpha:1];
        mallLabel.font = [UIFont fontWithName:@"Arial" size:13];

        priceLabel = [[RTLabel alloc] initWithFrame: CGRectMake(100, 24, 200, 20)];
        priceLabel.backgroundColor = [UIColor clearColor];
        priceLabel.textColor = [UIColor colorWithWhite:.2 alpha:1];
        priceLabel.font = [UIFont fontWithName:@"Arial" size:13];

//        mobileLabel = [[RTLabel alloc] initWithFrame: CGRectMake(100, 42, 200, 20)];
//        mobileLabel.backgroundColor = [UIColor clearColor];
//        mobileLabel.font = [UIFont fontWithName:@"Arial" size:12];
//        mobileLabel.textColor = [UIColor grayColor];

        [self addSubview: mallLogo];
        [self addSubview: mallLabel];
        [self addSubview: priceLabel];
//        [self addSubview: mobileLabel];
    }

    return self;
}

@end

@implementation MIMallsOrderViewController
@synthesize hasMore = _hasMore;
@synthesize orderNoteView = _orderNoteView;
@synthesize segmentedSwitchView = _segmentedSwitchView;
@synthesize mallOrdersArray = _mallOrdersArray;
@synthesize request = _request;
@synthesize awardRequest = _awardRequest;


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.needRefreshView = YES;
    [self.navigationBar setBarTitle: @"商城返利订单" textSize:20.0];
    [self.navigationBar setBarRightButtonItem:self selector:@selector(goFiltering) imageKey:@"ic_category"];
    
    _orderNoteView = [[MIOrderNoteView alloc] initWithFrame:CGRectMake(0, self.navigationBarHeight, PHONE_SCREEN_SIZE.width, self.view.viewHeight - self.navigationBarHeight)];
    _orderNoteView.hidden = YES;
    NSString *tips = [NSString stringWithFormat:@"你暂时没有商城返利订单\n<font size=12.0> %@ </font>", @"在商城下单后10分钟左右显示在这里，部分已特殊说明的商城除外"];
    _orderNoteView.noteTile.text = tips;
    [_orderNoteView.noteButton setTitle:@"马上去购物，拿返利" forState:UIControlStateNormal];
    [_orderNoteView.noteButton addTarget:self action:@selector(goMallShopping) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_orderNoteView];
    
    self.baseTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _baseTableView.frame = CGRectMake(0, self.navigationBarHeight, SCREEN_WIDTH, self.view.viewHeight - self.navigationBarHeight);
    _baseTableView.backgroundColor = [UIColor clearColor];
    _baseTableView.backgroundView.alpha = 0;
    _baseTableView.dataSource = self;
    _baseTableView.delegate = self;
    
    _segmentedSwitchView = [[SegmentedSwitchView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 36)];
    _segmentedSwitchView.Delegate = self;
    [self.view addSubview:_segmentedSwitchView];
    [self.view bringSubviewToFront:self.navigationBar];

    
    _mallOrdersArray = [[NSMutableArray alloc] initWithCapacity:3];

    __weak typeof(self) weakSelf = self;
    _request = [[MIOrderMallGetRequest alloc] init];
    _currentPage = 1;
    [_request setPage:_currentPage];
    [_request setPageSize:MIMALL_OREDE_PAGESIZE];
    _request.onCompletion = ^(MIOrderMallGetModel *model) {
        MILog(@"get mall order successful");
        [weakSelf finishLoadTableViewData:model];
    };

    _request.onError = ^(MKNetworkOperation* completedOperation, MIError* error) {
        [weakSelf failLoadTableViewData];
        MILog(@"error_msg=%@",error.description);
    };

    [_segmentedSwitchView initContentTitle:[NSArray arrayWithObjects:@"全部订单", @"已返利订单", @"预返利订单", nil]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_request cancelRequest];
    [_awardRequest cancelRequest];

    if (self.loading) {
        self.loading = NO;
        [super finishLoadTableViewData];
    }
}

- (void)reloadTableViewDataSource
{
    if (self.loading) {
        [_request cancelRequest];
    }

    self.loading = YES;
    [self setOverlayStatus:EOverlayStatusRemove labelText:nil];

    _currentPage = 1;
    [_request setPage:_currentPage];
    [_request sendQuery];
}

- (void)loadMoreTableViewDataSource
{
    if (([_mallOrdersArray count] != 0) && _hasMore) {
        //只有当前有数据的前提下才会触发加载更多
        self.loading = YES;
        [_request setPage:++_currentPage];
        [_request sendQuery];
        [_baseTableView reloadData];
    }
}

- (void)finishLoadTableViewData:(MIOrderMallGetModel *)model
{
    [self setOverlayStatus:EOverlayStatusRemove labelText:nil];

    if (self.loading) {
        self.loading = NO;
        [super finishLoadTableViewData];
    }
    
    if (model.page.integerValue == 1) {
        [_mallOrdersArray removeAllObjects];
    }

    if (model.mallOrders != nil && model.count != 0) {
        [_mallOrdersArray addObjectsFromArray:model.mallOrders];
    }

    if ([_mallOrdersArray count] != 0) {
        if (model.count.integerValue > [_mallOrdersArray count]) {
            _hasMore = YES;
        } else {
            _hasMore = NO;
        }
        _orderNoteView.hidden = YES;
        _baseTableView.hidden = NO;
        [_baseTableView reloadData];
        
        if (model.page.integerValue == 1) {
            [self.baseTableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
        }
    } else {
        _baseTableView.hidden = YES;
        _orderNoteView.hidden = NO;
    }
}

- (void)failLoadTableViewData
{
    [self setOverlayStatus:EOverlayStatusRemove labelText:nil];

    if (self.loading) {
        self.loading = NO;
        [super failLoadTableViewData];
    }

    if ([self.mallOrdersArray count] == 0) {
        [self setOverlayStatus:EOverlayStatusError labelText:nil];
    }
}

- (void)updateCoin:(NSInteger)coin
{
    NSInteger origin = [MIMainUser getInstance].coin.integerValue;
    [MIMainUser getInstance].coin = [NSNumber numberWithInt:(coin + origin)];
    [[MIMainUser getInstance] persist];
}

- (void)goCommitCoin:(UIButton *)btn
{
    CGPoint point = btn.center;
    point = [_baseTableView convertPoint:point fromView:btn.superview];
    NSIndexPath* indexpath = [_baseTableView indexPathForRowAtPoint:point];
    MIMallOrderModel *order = [_mallOrdersArray objectAtIndex:[indexpath section]];

    UITableViewCell *cell = [_baseTableView cellForRowAtIndexPath:indexpath];
    RTLabel *commissionLabel = (RTLabel *)[cell viewWithTag:MIMALL_OREDE_ITEM_PRICE];

    NSString *commission;
    if (order.commissionMode.integerValue == 0) {
        //返利类型为金钱
        commission = [[NSString alloc] initWithFormat:@"%0.2f元", order.commission.doubleValue / 100.0];
    } else {
        //返利类型为米币
        commission = [[NSString alloc] initWithFormat:@"%d米币", order.commission.integerValue];
    }
    NSString *title = title = [[NSString alloc] initWithFormat:@"已返利 <font color='#ff6600'>%@</font> 奖励 <font color='#499d00'>%d米币</font>", commission, order.coin.integerValue];

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.yOffset = -80.f;
    hud.removeFromSuperViewOnHide = YES;

    if (_awardRequest) {
        [_awardRequest cancelRequest];
        _awardRequest = nil;
    }
    _awardRequest = [[MIOrderMallCoinAwardRequest alloc] init];
    [_awardRequest setCoin:order.oid.stringValue];

    __weak typeof(hud) bhud = hud;
    __weak typeof(self) weakSelf = self;
    _awardRequest.onCompletion = ^(MIOrderMallCoinAwardModel * model) {
        [bhud hide: YES];
        if ([model.success boolValue]) {
            btn.hidden = YES;
            commissionLabel.text = title;
            order.coinAward = [NSNumber numberWithBool:NO];
            [weakSelf updateCoin:order.coin.integerValue];
            NSString *message = [NSString stringWithFormat:@"恭喜您！获得了%d米币的奖励", order.coin.integerValue];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                                message:message
                                                               delegate:nil
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil, nil];
            [alertView show];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kShowGradeAlertView];
            [[NSUserDefaults standardUserDefaults] synchronize];
        } else {
            [weakSelf showSimpleHUD:@"网络服务繁忙，请稍候再试"];
        }
    };
    _awardRequest.onError = ^(MKNetworkOperation* completedOperation, MIError* error) {
        [bhud hide: YES];
    };

    [_awardRequest sendQuery];
}

- (void)goFiltering
{
    float y = self.segmentedSwitchView.top;
    if (self.segmentedSwitchView.top == 0) {
        y = self.navigationBarHeight;
    } else {
        y = 0;
    }
    
    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.segmentedSwitchView.top = y;
    } completion:^(BOOL finished){
    }];
}

- (void) goMallShopping
{
    [[MINavigator navigator] goMainScreenFromAnyByIndex:MAIN_SCREEN_INDEX_REBATE info:nil];
}

#pragma mark - SegmentedSwitchView delegate
- (void) segmentedViewController:(SegmentedSwitchView *)segmentedControl touchedAtIndex:(NSUInteger)index
{
    switch (index) {
        case 0://全部订单
        {
            [_request setStatus:@""];
            break;
        }
        case 1://已返利订单
        {
            [_request setStatus:1];
            break;
        }
        case 2://预返利订单
        {
            [_request setStatus:0];
            break;
        }
        default:
        {
            [_request setStatus:@""];
            break;
        }
    }
    
    _orderNoteView.hidden = YES;
    [self reloadTableViewDataSource];
    [self setOverlayStatus:EOverlayStatusLoading labelText:nil];
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (_hasMore && ([_mallOrdersArray count] == indexPath.section)) {
        [self loadMoreTableViewDataSource];
    } else {
        if (indexPath.row == 1) {
            MIMallOrderModel *order = [_mallOrdersArray objectAtIndex:indexPath.section];
            NSURL * url = [[NSURL alloc] initWithString: [NSString stringWithFormat: @"%@rebate/mobile/%d?uid=%d", [MIConfig globalConfig].goURL, order.mallId.integerValue, [MIMainUser getInstance].userId.integerValue]];
            MIMallModel *mall = [[MIMallModel alloc] init];
            mall.mallId = [order.mallId stringValue];
            mall.logo = order.logo;
            mall.name = order.mallName;
            MIMallWebViewController * web = [[MIMallWebViewController alloc] initWithURL: url mall:mall];
            [[MINavigator navigator] openPushViewController: web animated:YES];
        }
    }
}

#pragma mark - Table view data source
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        UIView *viewForHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];

        UILabel *tips = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, SCREEN_WIDTH - 40, 30)];
        tips.backgroundColor = [UIColor clearColor];
        tips.font = [UIFont systemFontOfSize:12.0];
        tips.textAlignment = UITextAlignmentCenter;
        tips.textColor = [UIColor grayColor];
        tips.shadowColor = [UIColor whiteColor];
        tips.shadowOffset = CGSizeMake(0, -1.0);
        tips.numberOfLines = 0;
        tips.text = @"在商城下单后10分钟左右显示在这里，返利收入一般在1-2个月后由商家审核后到账";
        [viewForHeader addSubview:tips];
        return viewForHeader;
    } else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 40;
    } else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat heiht = 0.0;
    if (_hasMore && ([_mallOrdersArray count] == indexPath.section)) {
        heiht = 50; //加载更多的cell高度
    } else {
        switch (indexPath.row) {
            case 0:
                heiht = 30.0;
                break;
            case 1:
                heiht = 60.0;
                break;
            case 2:
                heiht = 40.0;
            default:
                break;
        };
    }

    return heiht;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger sections = [_mallOrdersArray count];

    if (sections > 0 && _hasMore) {
        sections++;
    }
    return sections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_hasMore && ([_mallOrdersArray count] == section)) {
        return 1;   //加载更多的cell
    } else {
        return 3;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_hasMore && ([_mallOrdersArray count] == indexPath.section)) {
        UIActivityIndicatorView* spinner = (UIActivityIndicatorView *)[cell viewWithTag:MIMALL_OREDE_ITEM_ACTIVITY];
        cell.textLabel.textAlignment = UITextAlignmentCenter;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        if (self.loading) {
            cell.textLabel.text = @"加载中...";
            [spinner startAnimating];
        } else {
            cell.textLabel.text = @"加载更多...";
            [spinner stopAnimating];
        }
    } else {
        MIMallOrderModel *order = [_mallOrdersArray objectAtIndex:indexPath.section];
        if (indexPath.row == 0) {
            NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"跟单时间：yyyy-MM-dd HH:mm"];
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:order.tradeTime.doubleValue];
            NSString *title = [[NSString alloc] initWithFormat:@"%@", [dateFormatter stringFromDate:date]];
            cell.textLabel.text = [[NSString alloc] initWithFormat:@"%@", title];
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.textLabel.textColor = [UIColor grayColor];
        } else if (indexPath.row == 1) {
            MIOrderMallItemCell *itemCell = (MIOrderMallItemCell *)cell;
            [itemCell.mallLogo sd_setImageWithURL:[NSURL URLWithString:order.logo] placeholderImage: [UIImage imageNamed:@"mizhewang_logo"]];
            itemCell.mallLabel.text = [NSString stringWithFormat:@"订单%@", order.orderId];
            NSString *price = [[NSString alloc] initWithFormat:@"￥%0.2f", order.tradeMoney.doubleValue / 100.0];
            if (order.isMobile.boolValue == YES) {
                price = [[NSString alloc] initWithFormat:@"%@   <font color='#808080'>%@</font>", price, @"手机订单"];
            }
            itemCell.priceLabel.text = price;
        } else if (indexPath.row == 2) {
            NSString *title;
            NSString *commission;
            if (order.commissionMode.integerValue == 0) {
                //返利类型为金钱
                commission = [[NSString alloc] initWithFormat:@"%0.2f元", order.commission.doubleValue / 100.0];
            } else {
                //返利类型为米币
                commission = [[NSString alloc] initWithFormat:@"%d米币", order.commission.integerValue];
            }

            UIImageView *expectImageView = (UIImageView *)[cell viewWithTag:MIMALL_OREDE_ITEM_IMAGE];
            if (order.status.integerValue == 0) {
                //预返利
                NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"预计yy年MM月到账"];
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:order.expectTime.doubleValue];
                NSString *expectTime = [[NSString alloc] initWithFormat:@"%@", [dateFormatter stringFromDate:date]];
                title = [[NSString alloc] initWithFormat:@"预返利 <font color='#ff6600'>%@</font><font color='#808080'>（%@）</font>", commission, expectTime];
                expectImageView.image = [UIImage loadImage:[UIImage imageNamed:@"expect_time"] rotateByDegree:-15];
                expectImageView.hidden = NO;
            } else if (order.status.integerValue == 1 || order.status.integerValue == 2) {
                //已返利
                title = [[NSString alloc] initWithFormat:@"已返利 <font color='#ff6600'>%@</font>", commission];
                expectImageView.hidden = YES;
            } else if (order.status.integerValue == -1) {
                //无效订单
                title = [[NSString alloc] initWithFormat:@"<font color='#808080'>%@</font>", @"无效订单"];
                expectImageView.hidden = YES;
            }

            NSInteger coin = order.coin.integerValue;
            if (coin != 0 && order.coinAward.boolValue == NO && order.status.integerValue != -1) {
                //有米币奖励并已领取
                title = [[NSString alloc] initWithFormat:@"%@   奖励 <font color='#499d00'>%d米币</font>", title, coin];
            }

            RTLabel *commissionLabel = (RTLabel *)[cell viewWithTag:MIMALL_OREDE_ITEM_PRICE];
            commissionLabel.text = title;

            UIButton *commitBtn = (UIButton *) [cell viewWithTag:MIMALL_OREDE_ITEM_COMMIT];
            if (order.coinAward.boolValue == NO) {
                commitBtn.hidden = YES;
            } else {
                commitBtn.hidden = NO;
            }
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_hasMore && ([_mallOrdersArray count] == indexPath.section)) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ActivityCellReuseIdentifier"];
        if(!cell){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ActivityCellReuseIdentifier"];
            cell.backgroundColor = [UIColor whiteColor];
            UIActivityIndicatorView *_indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            _indicatorView.center = CGPointMake(80, 25);
            _indicatorView.tag = MIMALL_OREDE_ITEM_ACTIVITY;
            [cell addSubview:_indicatorView];
        }

        return cell;
    } else {
        // Create submit button cell at the end of the table view
        if (indexPath.row == 0)
        {
            static NSString *titleCellIdentifier = @"TitleCellReuseIdentifier";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:titleCellIdentifier];
            if (nil == cell)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:titleCellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = [UIColor whiteColor];
            }

            return cell;
        } else if (indexPath.row == 1)
        {
            static NSString *cellIdentifier = @"MallItemCellReuseIdentifier";
            MIOrderMallItemCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (nil == cell)
            {
                cell = [[MIOrderMallItemCell alloc] initWithreuseIdentifier:cellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                cell.backgroundColor = [UIColor whiteColor];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }

            return cell;
        } else
        {
            static NSString *commitCellIdentifier = @"CommitCellReuseIdentifier";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:commitCellIdentifier];
            if (nil == cell)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:commitCellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = [UIColor whiteColor];

                RTLabel *commissionLabel = [[RTLabel alloc] initWithFrame: CGRectMake(20, 10, 280, 20)];
                commissionLabel.tag = MIMALL_OREDE_ITEM_PRICE;
                commissionLabel.font = [UIFont systemFontOfSize: 14];
                [cell addSubview:commissionLabel];
                
                UIButton *commitBtn = [[MICommonButton alloc] initWithFrame:CGRectMake(217,5,82,30)];
                commitBtn.tag = MIMALL_OREDE_ITEM_COMMIT;
                commitBtn.titleLabel.font = [UIFont systemFontOfSize:16];
                [commitBtn setTitle:@"领取米币" forState:UIControlStateNormal];
                [commitBtn addTarget:self action:@selector(goCommitCoin:) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:commitBtn];

                UIImageView *expectImageView = [[UIImageView alloc] initWithFrame:CGRectMake(260, 0, 40, 40)];
                expectImageView.tag = MIMALL_OREDE_ITEM_IMAGE;
                [cell addSubview:expectImageView];
             }
            
            return cell;
        }
    }
    
    return nil;
}
@end
