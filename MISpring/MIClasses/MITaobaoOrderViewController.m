//
//  MITaobaoOrderViewController.m
//  MISpring
//
//  Created by Yujian Xu on 13-3-18.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MITaobaoOrderViewController.h"

#import "MIOrderTaobaoGetRequest.h"
#import "MIOrderTaobaoGetModel.h"
#import "MITbOrderModel.h"
#import "NSString+NSStringEx.h"
#import "MIOrderTaobaoCoinAwardModel.h"
#import "MIUITextButton.h"
#import "UIImage+MIAdditions.h"

#define MITAOBAO_OREDE_ITEM_ACTIVITY 1
#define MITAOBAO_OREDE_ITEM_COMMIT   2
#define MITAOBAO_OREDE_ITEM_PRICE    3
#define MITAOBAO_OREDE_ITEM_IMAGE    4
#define MITAOBAO_OREDE_PAGESIZE     10

@interface MIOrderTaobaoItemCell:UITableViewCell

@property(nonatomic, strong) UIImageView * imageView;
@property(nonatomic, strong) UILabel * titleLabel;
@property(nonatomic, strong) RTLabel * priceLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) RTLabel *returnLabel;
@property (nonatomic, strong) RTLabel *rewardLabel;
@property (nonatomic, strong)UIButton *commitBtn;
@end

@implementation MIOrderTaobaoItemCell
@synthesize imageView;
@synthesize titleLabel;
@synthesize priceLabel,timeLabel,returnLabel,rewardLabel,commitBtn;

- (id) initWithreuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 300, 25)];
        timeLabel.font = [UIFont systemFontOfSize:14];
        timeLabel.textColor = [UIColor colorWithWhite:0.3 alpha:0.5];
        
        UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(10, 35, self.viewWidth-20, 1)];
        line1.backgroundColor = [UIColor lightGrayColor];
        line1.alpha = 0.3;
        
        imageView = [[UIImageView alloc] initWithFrame: CGRectMake(10, 45, 50, 50)];
        [imageView.layer setBorderWidth:0.6]; //边框宽度
        [imageView.layer setBorderColor:[UIColor colorWithWhite:0.3 alpha:0.10].CGColor];
        
        titleLabel = [[UILabel alloc] initWithFrame: CGRectMake(70, 38+5, 210, 20)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textAlignment = UITextAlignmentLeft;
        titleLabel.textColor = [UIColor darkGrayColor];
        titleLabel.font = [UIFont fontWithName:@"Arial" size:13];
        
        priceLabel = [[RTLabel alloc] initWithFrame:CGRectMake(70, 65, 210, 20)];
        priceLabel.backgroundColor = [UIColor clearColor];
        priceLabel.font = [UIFont fontWithName:@"Arial" size:13];
        
        UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(10, 100, self.viewWidth-20, 1)];
        line2.backgroundColor = [UIColor lightGrayColor];
        line2.alpha = 0.3;
        
        UIImageView *indicator = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_avatar_arrow"]];
        indicator.frame = CGRectMake(self.viewWidth - 10-10, 60, 10, 15);
        
        returnLabel = [[RTLabel alloc] initWithFrame:CGRectMake(10, 110, 200, 25)];
        returnLabel.backgroundColor = [UIColor clearColor];
        returnLabel.textAlignment = RTTextAlignmentLeft;
        returnLabel.font = [UIFont systemFontOfSize:14];
        
        commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        commitBtn.backgroundColor = [MIUtility colorWithHex:0xff6600];
        commitBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        commitBtn.clipsToBounds = YES;
        commitBtn.layer.cornerRadius = 3;
        commitBtn.frame = CGRectMake(230, 105, 80, 25);
        [commitBtn setTitle:@"领取米币" forState:UIControlStateNormal];
        
        UIView *line3 = [[UIView alloc]initWithFrame:CGRectMake(0, 135, self.viewWidth, 1)];
        line3.backgroundColor = [UIColor lightGrayColor];
        line3.alpha = 0.3;
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 136, self.viewWidth, 14)];
        view.backgroundColor = [MIUtility colorWithHex:0xeeeeee];
        
        UIView *line4 = [[UIView alloc]initWithFrame:CGRectMake(0, 150, self.viewWidth, 1)];
        line4.backgroundColor = [UIColor lightGrayColor];
        line4.alpha = 0.3;
        
        [self addSubview:timeLabel];
        [self addSubview:line1];
        [self addSubview: imageView];
        [self addSubview: titleLabel];
        [self addSubview: priceLabel];
        [self addSubview:line2];
        [self addSubview: returnLabel];
        [self addSubview:indicator];
        [self addSubview:commitBtn];
        [self addSubview:view];
        [self addSubview:line3];
        [self addSubview:line4];
        //        [self addSubview: mobileLabel];
    }
    
    return self;
}

@end

@implementation MITaobaoOrderViewController
@synthesize hasMore = _hasMore;
@synthesize orderNoteView = _orderNoteView;
@synthesize taobaoOrdersArray = _taobaoOrdersArray;
@synthesize request = _request;
@synthesize awardRequest = _awardRequest;


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.needRefreshView = YES;
    [self.navigationBar setBarTitle: @"淘宝返利"];
    
    _orderNoteView = [[MIOrderNoteView alloc] initWithFrame:CGRectMake(0, self.navigationBarHeight, PHONE_SCREEN_SIZE.width, self.view.viewHeight - self.navigationBarHeight)];
    NSString *tips = [NSString stringWithFormat:@"你暂时没有淘宝返利订单\n<font size=12.0> %@ </font>", @"在“我的淘宝”确认收货后1天左右显示在这里"];
    _orderNoteView.noteTile.text = tips;
    [_orderNoteView.noteButton setTitle:@"逛逛今日特卖" forState:UIControlStateNormal];
    [_orderNoteView.noteButton addTarget:self action:@selector(goTaobaoShopping) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_orderNoteView];
    _orderNoteView.hidden = YES;
    _orderNoteView.actionTip.hidden = NO;
    
    self.baseTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _baseTableView.frame = CGRectMake(0, self.navigationBarHeight, SCREEN_WIDTH, self.view.viewHeight - self.navigationBarHeight);
    _baseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _baseTableView.backgroundColor = [UIColor clearColor];
    _baseTableView.backgroundView.alpha = 0;
    _baseTableView.dataSource = self;
    _baseTableView.delegate = self;
    [self.view sendSubviewToBack:_baseTableView];
    
    UIView *viewForHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    viewForHeader.backgroundColor = [UIColor clearColor];
    UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 20, 40)];
    tipsLabel.backgroundColor = [UIColor clearColor];
    tipsLabel.font = [UIFont systemFontOfSize:12.0];
    tipsLabel.textAlignment = UITextAlignmentCenter;
    tipsLabel.textColor = [UIColor grayColor];
    tipsLabel.shadowColor = [UIColor whiteColor];
    tipsLabel.shadowOffset = CGSizeMake(0, -1.0);
    tipsLabel.numberOfLines = 0;
    tipsLabel.text = @"在“我的淘宝”确认收货后1天左右显示在这里，订单到账7天内可领取米币奖励";
    [viewForHeader addSubview:tipsLabel];
    _baseTableView.tableHeaderView = viewForHeader;
    _baseTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 20, 15)];
    
    UIButton *myTaobaoBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 85, (self.navigationBarHeight - PHONE_NAVIGATION_BAR_ITEM_HEIGHT), 80, PHONE_NAVIGATION_BAR_ITEM_HEIGHT)];
   [myTaobaoBtn setTitleColor:[MIUtility colorWithHex:0x333333] forState:UIControlStateNormal];
    myTaobaoBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [myTaobaoBtn setTitle:@"我的淘宝" forState:UIControlStateNormal];
//    [myTaobaoBtn setTitleColor:[MIUtility colorWithHex:0xff5500] forState:UIControlStateNormal];
    [myTaobaoBtn addTarget:self action:@selector(goMyTaobao:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBar addSubview:myTaobaoBtn];
    
    _hasMore = NO;
    _taobaoOrdersArray = [[NSMutableArray alloc] initWithCapacity:3];
    
    __weak typeof(self) weakSelf = self;
    _request = [[MIOrderTaobaoGetRequest alloc] init];
    _currentPage = 1;
    [_request setPage:_currentPage];
    [_request setPageSize:MITAOBAO_OREDE_PAGESIZE];
    _request.onCompletion = ^(MIOrderTaobaoGetModel *model) {
        [weakSelf finishLoadTableViewData:model];
    };
    
    _request.onError = ^(MKNetworkOperation* completedOperation, MIError* error) {
        [weakSelf failLoadTableViewData];
        MILog(@"error_msg=%@",error.description);
    };
    
    [_request sendQuery];
    
    _loading = YES;
    [self setOverlayStatus:EOverlayStatusLoading labelText:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
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

- (void)goMyTaobao:(UIButton *)btn
{
    NSURL *taobaoURL = [NSURL URLWithString: [MIConfig globalConfig].myTaobao];
    [MINavigator openTbWebViewControllerWithURL:taobaoURL desc:@"我的淘宝"];
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
    if (([_taobaoOrdersArray count] != 0) && _hasMore) {
        //只有当前有数据的前提下才会触发加载更多
        self.loading = YES;
        [_request setPage:++_currentPage];
        [_request sendQuery];
        [_baseTableView reloadData];
    }
}

- (void)finishLoadTableViewData:(MIOrderTaobaoGetModel *)model
{
    [self setOverlayStatus:EOverlayStatusRemove labelText:nil];
    
    if (self.loading) {
        self.loading = NO;
        [super finishLoadTableViewData];
    }
    
    if (model.page.integerValue == 1) {
        [_taobaoOrdersArray removeAllObjects];
    }
    
    if (model.tbOrders != nil && model.count != 0) {
        [_taobaoOrdersArray addObjectsFromArray:model.tbOrders];
    }
    
    if ([_taobaoOrdersArray count] != 0) {
        if (model.count.integerValue > [_taobaoOrdersArray count]) {
            _hasMore = YES;
        } else {
            _hasMore = NO;
        }
        _orderNoteView.hidden = YES;
        _baseTableView.hidden = NO;
        [_baseTableView reloadData];
    } else {
        _baseTableView.hidden = YES;
        _orderNoteView.hidden = NO;
    }
}

- (void)failLoadTableViewData
{
    if (self.loading) {
        self.loading = NO;
        [super failLoadTableViewData];
    }
    
    [self setOverlayStatus:EOverlayStatusRemove labelText:nil];
    if ([self.taobaoOrdersArray count] == 0) {
        [self setOverlayStatus:EOverlayStatusError labelText:nil];
    }
}

- (void)updateCoin:(NSInteger)coin
{
    NSInteger origin = [MIMainUser getInstance].coin.integerValue;
    [MIMainUser getInstance].coin = @(coin + origin);
    [[MIMainUser getInstance] persist];
    [_baseTableView reloadData];
}

- (void)goCommitCoin:(UIButton *)btn
{
    CGPoint point = btn.center;
    point = [_baseTableView convertPoint:point fromView:btn.superview];
    NSIndexPath* indexpath = [_baseTableView indexPathForRowAtPoint:point];
    
    if (_taobaoOrdersArray.count > indexpath.row)
    {
        MITbOrderModel *order = [_taobaoOrdersArray objectAtIndex:[indexpath row]];
        
        UITableViewCell *cell = [_baseTableView cellForRowAtIndexPath:indexpath];
        RTLabel *commissionLabel1 = (RTLabel *)[cell viewWithTag:MITAOBAO_OREDE_ITEM_PRICE];
        NSString *title = [[NSString alloc] initWithFormat:@"已返利 <font color='#ff6600'>%0.2f元</font>  奖励 <font color='#499d00'>%ld米币</font>", order.commission.doubleValue, (long)order.coin.integerValue];
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.yOffset = -80.f;
        hud.removeFromSuperViewOnHide = YES;
        
        if (_awardRequest) {
            [_awardRequest cancelRequest];
            _awardRequest = nil;
        }
        _awardRequest = [[MIOrderTaobaoCoinAwardRequest alloc] init];
        [_awardRequest setCoin:order.oid.stringValue];
        
        __weak typeof(hud) bhud = hud;
        __weak typeof(self) weakSelf = self;
        _awardRequest.onCompletion = ^(MIOrderTaobaoCoinAwardModel * model) {
            [bhud hide: YES];
            if ([model.success boolValue]) {
                btn.hidden = YES;
                commissionLabel1.text = title;
                order.coinAward = [NSNumber numberWithBool:NO];
                [weakSelf updateCoin:order.coin.integerValue];
                NSString *message = [NSString stringWithFormat:@"恭喜您！获得了%ld米币的奖励", (long)order.coin.integerValue];
                [[[UIAlertView alloc] initWithMessage:message] show];
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kShowGradeAlertView];
                [[NSUserDefaults standardUserDefaults] synchronize];
            } else {
                [weakSelf showSimpleHUD:model.message];
            }
        };
        _awardRequest.onError = ^(MKNetworkOperation* completedOperation, MIError* error) {
            [bhud hide: YES];
        };
        
        [_awardRequest sendQuery];
    }
}

- (void) goTaobaoShopping
{
    [[MINavigator navigator] goMainScreenFromAnyByIndex:MAIN_SCREEN_INDEX_HOMEPAGE info:nil];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (_hasMore && ([_taobaoOrdersArray count] == indexPath.row)) {
        [self loadMoreTableViewDataSource];
    } else if(_taobaoOrdersArray.count > indexPath.row){
        
        MITbOrderModel *order = [_taobaoOrdersArray objectAtIndex:indexPath.row];
        [MINavigator openTbViewControllerWithNumiid:order.itemId desc:@"商品详情"];
    }
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0.0;
    if (_hasMore && ([_taobaoOrdersArray count] == indexPath.row)) {
        height = 50; //加载更多的cell高度
    } else {
        return 151;
    }
    
    return height;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = [_taobaoOrdersArray count];
    if (rows >0 && _hasMore) {
        rows ++;
        
    }
    return rows;
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_hasMore && ([_taobaoOrdersArray count] == indexPath.row)) {
        UIActivityIndicatorView* spinner = (UIActivityIndicatorView *)[cell viewWithTag:MITAOBAO_OREDE_ITEM_ACTIVITY];
        cell.textLabel.textAlignment = UITextAlignmentCenter;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        if (self.loading) {
            cell.textLabel.text = @"加载中...";
            [spinner startAnimating];
        } else {
            cell.textLabel.text = @"查看更多...";
            [spinner stopAnimating];
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_hasMore && ([_taobaoOrdersArray count] == indexPath.row)) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ActivityCellReuseIdentifier"];
        if(!cell){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ActivityCellReuseIdentifier"];
            cell.contentView.backgroundColor = [UIColor whiteColor];
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            UIActivityIndicatorView *_indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            _indicatorView.center = CGPointMake(80, 25);
            _indicatorView.tag = MITAOBAO_OREDE_ITEM_ACTIVITY;
            [cell addSubview:_indicatorView];
        }
        
        return cell;
    }
    else
    {
        static NSString *cellIdentifier = @"TaobaoItemCellReuseIdentifier";
        MIOrderTaobaoItemCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (nil == cell)
        {
            cell = [[MIOrderTaobaoItemCell alloc] initWithreuseIdentifier:cellIdentifier];
            cell.contentView.backgroundColor = [UIColor whiteColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        MITbOrderModel *order;
        @try {
            order = [_taobaoOrdersArray objectAtIndex:indexPath.row];
        }
        @catch (NSException *exception) {
            MILog(@"index outof range");
            return cell;
        }
        
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"跟单时间：yyyy-MM-dd HH:mm"];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:order.payTime.doubleValue];
        NSString *title = [[NSString alloc] initWithFormat:@"%@", [dateFormatter stringFromDate:date]];
        cell.timeLabel.text = [[NSString alloc] initWithFormat:@"%@", title];
        
        if (!order.itemPic) {
            cell.imageView.image = [UIImage imageNamed:@"img_loading_small"];
        }
        else{
            NSMutableString *imgUrl = [[NSMutableString alloc] initWithString:order.itemPic];
            [imgUrl appendString:@"_100x100.jpg"];
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage: [UIImage imageNamed:@"img_loading_small"]];
        }
        cell.titleLabel.text = order.itemTitle;
        
        NSString *price = [[NSString alloc] initWithFormat:@"￥%0.2f", order.tradeMoney.doubleValue];
        if (order.isMobile.boolValue == YES) {
            price = [[NSString alloc] initWithFormat:@"%@   <font color='#808080'>%@</font>", price, @"手机订单"];
        }
        
        cell.priceLabel.text = price;
        
        double commission = order.commission.doubleValue;
        NSInteger coin = order.coin.integerValue;
        NSString *titleStr;
        
        UIImageView *expectImageView = (UIImageView *)[cell viewWithTag:MITAOBAO_OREDE_ITEM_IMAGE];
        if (order.status.integerValue == 0) {
            //已返利
            if (coin == 0 || order.coinAward.boolValue == YES) {
                titleStr = [[NSString alloc] initWithFormat:@"已返利 <font color='#ff6600'>%0.2f元</font>", commission];
            } else {
                titleStr = [[NSString alloc] initWithFormat:@"已返利 <font color='#ff6600'>%0.2f元</font>  奖励 <font color='#499d00'>%ld米币</font>", commission, (long)coin];
            }
            expectImageView.hidden = YES;
        } else if (order.status.integerValue == 1) {
            //预返利
            NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"预计yy年MM月到账"];
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:order.expectTime.doubleValue];
            NSString *expectTime = [[NSString alloc] initWithFormat:@"%@", [dateFormatter stringFromDate:date]];
            titleStr = [[NSString alloc] initWithFormat:@"预返利 <font color='#ff6600'>%0.2f元</font><font color='#808080'>（%@）</font>", commission, expectTime];
            expectImageView.image = [UIImage loadImage:[UIImage imageNamed:@"expect_time"] rotateByDegree:-15];
            expectImageView.hidden = NO;
        } else if (order.status.integerValue == -1) {
            //无效订单
            titleStr = [[NSString alloc] initWithFormat:@"<font color='#808080'>%@</font>", @"无效订单"];
            expectImageView.hidden = YES;
        }
        cell.returnLabel.text = titleStr;
        
        [cell.commitBtn addTarget:self action:@selector(goCommitCoin:) forControlEvents:UIControlEventTouchUpInside];
        if (order.coinAward.boolValue == NO) {
            cell.commitBtn.hidden = YES;
        } else {
            cell.commitBtn.hidden = NO;
        }
        return cell;
    }
}


@end
