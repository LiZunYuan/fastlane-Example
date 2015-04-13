//
//  MIPayRecordViewController.m
//  MISpring
//
//  Created by Yujian Xu on 13-3-26.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIPayRecordViewController.h"
#import "NSString+NSStringEx.h"
#import "MIPayGetModel.h"
#import "MIPayModel.h"

#define MIPAY_RECORD_PAGESIZE      10
#define MIPAY_RECORD_ITEM_ACTIVITY 1

@interface MIPayRecordItemCell:UITableViewCell



@property(nonatomic, strong) UILabel *user;
@property(nonatomic, strong) RTLabel * amount;
@property(nonatomic, strong) RTLabel * income;
@property(nonatomic, strong) RTLabel * state;
@property(nonatomic, strong) UILabel *time;

@end

@implementation MIPayRecordItemCell
@synthesize amount;
@synthesize income;
@synthesize state;
@synthesize user;
@synthesize time;

- (id) initWithreuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    if (self) {
        self.viewWidth = SCREEN_WIDTH;
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.viewWidth, 20)];
        view.backgroundColor = [MIUtility colorWithHex:0xeeeeee];
        
        UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 20, self.viewWidth, 1)];
        line1.backgroundColor = [UIColor lightGrayColor];
        line1.alpha = 0.3;

        user = [[UILabel alloc]initWithFrame:CGRectMake(20, 22, self.viewWidth - 20, 30)];
        user.backgroundColor = [UIColor clearColor];
        user.font = [UIFont fontWithName:@"Arial" size:16];
        user.textColor = [UIColor grayColor];
        
        UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(20, 52, self.viewWidth -20, 1)];
        line2.backgroundColor = [UIColor lightGrayColor];
        line2.alpha = 0.3;
        
        amount = [[RTLabel alloc] initWithFrame: CGRectMake(20, 58, 280, 20)];
        amount.backgroundColor = [UIColor clearColor];
        amount.font = [UIFont fontWithName:@"Arial" size:14];

        income = [[RTLabel alloc] initWithFrame: CGRectMake(20, 78, 280, 20)];
        income.backgroundColor = [UIColor clearColor];
        income.font = [UIFont fontWithName:@"Arial" size:14];

        state = [[RTLabel alloc] initWithFrame: CGRectMake(20, 98, 280, 20)];
        state.backgroundColor = [UIColor clearColor];
        state.font = [UIFont fontWithName:@"Arial" size:14];
        
        UIView *line3 = [[UIView alloc]initWithFrame:CGRectMake(20, 118, self.viewWidth-20, 1)];
        line3.backgroundColor = [UIColor lightGrayColor];
        line3.alpha = 0.3;
        
        time = [[UILabel alloc]initWithFrame:CGRectMake(20, 123, self.viewWidth - 20, 30)];
        time.font =[UIFont fontWithName:@"Arial" size:16];
        time.backgroundColor = [UIColor clearColor];
        time.textColor = [UIColor grayColor];

        UIView *line5 = [[UIView alloc]initWithFrame:CGRectMake(0, 153, self.viewWidth, 1)];
        line5.backgroundColor = [UIColor lightGrayColor];
        line5.alpha = 0.3;

        [self addSubview:line1];
        [self addSubview:view];
        [self addSubview:user];
        [self addSubview:line2];
        [self addSubview: amount];
        [self addSubview: income];
        [self addSubview: state];
        [self addSubview:line3];
        [self addSubview:time];
        [self addSubview:line5];
    }

    return self;
}

@end

@implementation MIPayRecordViewController
@synthesize hasMore = _hasMore;
@synthesize orderNoteView = _orderNoteView;
@synthesize payRecordArray = _payRecordArray;


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.needRefreshView = YES;
    
    _orderNoteView = [[MIOrderNoteView alloc] initWithFrame:CGRectMake(0, self.navigationBarHeight, PHONE_SCREEN_SIZE.width, self.view.viewHeight - self.navigationBarHeight)];
    _orderNoteView.noteTile.text = @"暂时还没查到有提现记录哦~";
    [_orderNoteView.noteButton setTitle:@"逛逛今日特卖" forState:UIControlStateNormal];
    [_orderNoteView.noteButton addTarget:self action:@selector(goTaobaoShopping) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_orderNoteView];
    _orderNoteView.hidden = YES;
    
    self.baseTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _baseTableView.frame = CGRectMake(0, self.navigationBarHeight, SCREEN_WIDTH, self.view.viewHeight - self.navigationBarHeight);
    _baseTableView.backgroundColor = [UIColor clearColor];
    _baseTableView.backgroundView.alpha = 0;
    _baseTableView.dataSource = self;
    _baseTableView.delegate = self;
    [_baseTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view sendSubviewToBack:_baseTableView];
    
    _payRecordArray = [[NSMutableArray alloc] initWithCapacity:3];

    __weak typeof(self) weakSelf = self;
    _request = [[MIPayGetRequest alloc] init];
    [_request setPage:1];
    [_request setPageSize:MIPAY_RECORD_PAGESIZE];
    _request.onCompletion = ^(MIPayGetModel *model) {
        [weakSelf finishLoadTableViewData:model];
    };

    _request.onError = ^(MKNetworkOperation* completedOperation, MIError* error) {
        [weakSelf failLoadTableViewData];
        MILog(@"error_msg=%@",error.description);
    };

    [_request sendQuery];
    [self setOverlayStatus:EOverlayStatusLoading labelText:nil];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationBar setBarTitle: @"提现记录"];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_request cancelRequest];

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
    
    [_request setPage:1];
    [_request sendQuery];
}

- (void)loadMoreTableViewDataSource
{
    if (([_payRecordArray count] != 0) && _hasMore) {
        //只有当前有数据的前提下才会触发加载更多
        self.loading = YES;
        [_request setPage:([_payRecordArray count] / MIPAY_RECORD_PAGESIZE + 1)];
        [_request sendQuery];
        [_baseTableView reloadData];
    }
}

- (void)finishLoadTableViewData:(id)data
{
    [self setOverlayStatus:EOverlayStatusRemove labelText:nil];

    if (self.loading) {
        self.loading = NO;
        [super finishLoadTableViewData];
    }

    MIPayGetModel *model = (MIPayGetModel *)data;
    if (model.page.integerValue == 1) {
        [_payRecordArray removeAllObjects];
    }

    if (model.pays != nil  && model.count != 0) {
        [_payRecordArray addObjectsFromArray:model.pays];
    }

    if ([_payRecordArray count] != 0) {
        if (model.count.integerValue > [_payRecordArray count]) {
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
    [self setOverlayStatus:EOverlayStatusRemove labelText:nil];

    if (self.loading) {
        self.loading = NO;
        [super failLoadTableViewData];
    }

    if ([self.payRecordArray count] == 0) {
        [self setOverlayStatus:EOverlayStatusError labelText:nil];
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
    if (_hasMore && ([_payRecordArray count] == indexPath.row)) {
        [self loadMoreTableViewDataSource];
    }
    
    
//    [tableView deselectRowAtIndexPath:indexPath animated:NO];
//    if (_hasMore && ([_taobaoOrdersArray count] == indexPath.row)) {
//        [self loadMoreTableViewDataSource];
//    }
//else {
//        
//        MITbOrderModel *order = [_taobaoOrdersArray objectAtIndex:indexPath.row];
//        [MINavigator openTbViewControllerWithNumiid:order.itemId desc:@"商品详情"];
//        
//    }

    
    
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat heiht = 0.0;
    if (_hasMore && ([_payRecordArray count] == indexPath.row)) {
        heiht = 50; //加载更多的cell高度
    } else {
        heiht = 154;
    }

    return heiht;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = [_payRecordArray count];
    
    if (rows > 0 && _hasMore) {
        rows++;
    }
    return rows;

    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_hasMore && ([_payRecordArray count] == indexPath.row)) {
        UIActivityIndicatorView* spinner = (UIActivityIndicatorView *)[cell viewWithTag:MIPAY_RECORD_ITEM_ACTIVITY];
        cell.textLabel.textAlignment = UITextAlignmentCenter;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        if (self.loading) {
            cell.textLabel.text = @"加载中...";
            [spinner startAnimating];
        } else {
            cell.textLabel.text = @"加载更多...";
            [spinner stopAnimating];
        }
        
    }
    
   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_hasMore && ([_payRecordArray count] == indexPath.row)) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ActivityCellReuseIdentifier"];
        if(!cell){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ActivityCellReuseIdentifier"];
            cell.backgroundColor = [UIColor whiteColor];

            UIActivityIndicatorView *_indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            _indicatorView.center = CGPointMake(90, 25);
            _indicatorView.tag = MIPAY_RECORD_ITEM_ACTIVITY;
            [cell addSubview:_indicatorView];
        }

        return cell;
    }
    
    else{
        NSString *identifier = @"payRecordItemCell";
        MIPayRecordItemCell *itemCell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!itemCell) {
            itemCell = [[MIPayRecordItemCell alloc]initWithreuseIdentifier:identifier];
        }
        if (_payRecordArray.count > indexPath.row)
        {
            MIPayModel *record = [_payRecordArray objectAtIndex:indexPath.row];
            itemCell.contentView.backgroundColor = [UIColor whiteColor];
            itemCell.selectionStyle = UITableViewCellSelectionStyleNone;
            itemCell.accessoryType = UITableViewCellAccessoryNone;
            itemCell.user.text = record.alipay;
            itemCell.amount.text = [[NSString alloc] initWithFormat:@"提现金额：%ld元", (long)record.money.integerValue];
            
            NSString *income;
            if ([record.type isEqualToString:@"point"]) {
                income = [[NSString alloc] initWithFormat:@"实收：%ld个集分宝", (long)record.money.integerValue*100];
            }else {
                income = [[NSString alloc] initWithFormat:@"实收：%ld元", (long)record.money.integerValue];
            }
            itemCell.income.text = income;
            
            NSString *state;
            if (record.status.integerValue == 0) {
                state = [[NSString alloc] initWithFormat:@"状态：<font size=14.0 color='#ff0000'>%@</font>", @"受理中..."];
            } else if (record.status.integerValue == 1) {
                state = [[NSString alloc] initWithFormat:@"状态：<font size=14.0 color='#499d00'>%@</font>", @"提现成功"];
            } else {
                state = [[NSString alloc] initWithFormat:@"状态：<font size=14.0 color='#000000'>提现失败（%@）</font>", record.statusDesc];
            }
            
            itemCell.state.text = state;
            
            NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"提现时间：yyyy-MM-dd HH:mm"];
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:record.reqTime.doubleValue];
            NSString *title = [[NSString alloc] initWithFormat:@"%@", [dateFormatter stringFromDate:date]];
            itemCell.time.text = [[NSString alloc] initWithFormat:@"%@", title];
        }
        return itemCell;
    }
}

@end