//
//  MIExchangeOrderViewController.m
//  MISpring
//
//  Created by 贺晨超 on 13-8-28.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIExchangeOrderViewController.h"

#pragma mark - ExchangeOrderTableCell
@interface ExchangeOrderTableCell : UITableViewCell

@property(nonatomic, strong) UILabel *itemTimeLabel;
@property(nonatomic, strong) UILabel *itemMoneyLabel;
@property(nonatomic, strong) UILabel *itemFooterLabel;
@property(nonatomic, strong) UILabel *itemNameLabel;
@property(nonatomic, strong) RTLabel *itemStatusLabel;

@end

@implementation ExchangeOrderTableCell
@synthesize itemTimeLabel;
@synthesize itemMoneyLabel;
@synthesize itemFooterLabel;
@synthesize itemNameLabel;
@synthesize itemStatusLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code

        itemTimeLabel = [[UILabel alloc] init];
        itemTimeLabel.backgroundColor = [UIColor clearColor];
        itemTimeLabel.frame = CGRectMake(10, 10, SCREEN_WIDTH - 40, 20);
        itemTimeLabel.font = [UIFont fontWithName:@"Arial" size:14];
        
        UILabel *splitLineTop = [[UILabel alloc] initWithFrame:CGRectMake(0, 38, SCREEN_WIDTH - 20, 1)];
        splitLineTop.alpha = 0.2;
        splitLineTop.backgroundColor = [UIColor lightGrayColor];
        
        itemNameLabel = [[UILabel alloc] init];
        itemNameLabel.frame = CGRectMake(10 , 48, 280, 20);
        itemNameLabel.backgroundColor = [UIColor clearColor];
        itemNameLabel.font = [UIFont fontWithName:@"Arial" size:14];
        
        itemMoneyLabel = [[UILabel alloc] init];
        itemMoneyLabel.frame = CGRectMake(10 , 68, 280, 20);
        itemMoneyLabel.backgroundColor = [UIColor clearColor];
        itemMoneyLabel.font = [UIFont fontWithName:@"Arial" size:14];
        
        UILabel *splitLineBottom = [[UILabel alloc] initWithFrame:CGRectMake(0, 118, SCREEN_WIDTH - 20, 1)];
        splitLineBottom.alpha = 0.2;
        splitLineBottom.backgroundColor = [UIColor lightGrayColor];
        
        itemStatusLabel = [[RTLabel alloc] init];
        itemStatusLabel.frame = CGRectMake(10 , 90, 280, 20);
        itemStatusLabel.backgroundColor = [UIColor clearColor];
        itemStatusLabel.font = [UIFont fontWithName:@"Arial" size:14];
        itemStatusLabel.font = itemMoneyLabel.font;
        
        itemFooterLabel = [[UILabel alloc] init];
        itemFooterLabel.textColor = [UIColor colorWithWhite:0.3 alpha:0.5];
        itemFooterLabel.frame = CGRectMake(10 , 128, 280, 20);
        itemFooterLabel.backgroundColor = [UIColor clearColor];
        itemFooterLabel.font = [UIFont fontWithName:@"Arial" size:14];
        
        UIButton *contentView = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 20, 158)];
        contentView.userInteractionEnabled = NO;
        contentView.backgroundColor = [UIColor whiteColor];
        contentView.layer.cornerRadius = 3.0;

        [contentView addSubview:itemTimeLabel];
        [contentView addSubview:splitLineTop];
        [contentView addSubview:itemNameLabel];
        [contentView addSubview:itemMoneyLabel];
        [contentView addSubview:splitLineBottom];
        [contentView addSubview:itemFooterLabel];
        [contentView addSubview:itemStatusLabel];
        [self addSubview:contentView];
    }
    return self;
}

@end



@implementation MIExchangeOrderViewController

@synthesize request;
@synthesize orderNoteView = _orderNoteView;


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.needRefreshView = YES;
    
    self.baseTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _baseTableView.frame = CGRectMake(0, self.navigationBarHeight, SCREEN_WIDTH, self.view.viewHeight - self.navigationBarHeight);
    _baseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _baseTableView.backgroundColor = [UIColor clearColor];
    _baseTableView.backgroundView.alpha = 0;
    _baseTableView.hidden = YES;
    _baseTableView.delegate = self;
    _baseTableView.dataSource = self;
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
    tipsLabel.text = [NSString stringWithFormat:@"申请兑换成功后，将在一个工作日内汇入你绑定的支付宝账户：%@", [MIMainUser getInstance].alipay];
    [viewForHeader addSubview:tipsLabel];
    _baseTableView.tableHeaderView = viewForHeader;
    _baseTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 20, 15)];
    
    _orderNoteView = [[MIOrderNoteView alloc] initWithFrame:CGRectMake(0, self.navigationBarHeight, PHONE_SCREEN_SIZE.width, self.view.viewHeight - self.navigationBarHeight)];
    NSString *tips = [NSString stringWithFormat:@"暂时还没查到有兑换记录哦~</font>"];
    _orderNoteView.noteTile.text = tips;
    [_orderNoteView.noteButton setTitle:@"逛逛今日特卖" forState:UIControlStateNormal];
    [_orderNoteView.noteButton addTarget:self action:@selector(goTaobaoShopping) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_orderNoteView];
    _orderNoteView.hidden = YES;
    
    _loading = YES;
    _currentPage = 1;
    _recordArray = [[NSMutableArray alloc] initWithCapacity:20];

    __weak typeof(self) weakSelf = self;
    request = [[MIExchangeGetRecordRequest alloc] init];
    request.onCompletion = ^(MIExchangeGetModel *model) {
        [weakSelf finishLoadTableViewData:model];
    };
    
    request.onError = ^(MKNetworkOperation* completedOperation, MIError* error) {
        [weakSelf failLoadTableViewData];
        MILog(@"error_msg=%@",error.description);
    };
    
    [request setType:@"coin"];
    [request setPage:1];
    [request setPageSize:10];
    [request sendQuery];
    
    [self setOverlayStatus:EOverlayStatusLoading labelText:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationBar setBarTitle: @"兑换记录"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [request cancelRequest];
}

- (void) goTaobaoShopping
{
    [[MINavigator navigator] goMainScreenFromAnyByIndex:MAIN_SCREEN_INDEX_HOMEPAGE info:nil];
}

- (void)reloadTableViewDataSource
{
    if (self.loading) {
        [request cancelRequest];
    }
    
    self.loading = YES;
    [self setOverlayStatus:EOverlayStatusRemove labelText:nil];
    
    _currentPage = 1;
    [request setPage:_currentPage];
    [request sendQuery];
}

- (void)loadMoreTableViewDataSource
{
    if (([_recordArray count] != 0) && _hasMore) {
        //只有当前有数据的前提下才会触发加载更多
        self.loading = YES;
        [request setPage:++_currentPage];
        [request sendQuery];
        [_baseTableView reloadData];
    }
}

- (void)finishLoadTableViewData:(MIExchangeGetModel *)model
{
    [self setOverlayStatus:EOverlayStatusRemove labelText:nil];
    
    if (self.loading) {
        self.loading = NO;
        [super finishLoadTableViewData];
    }
    
    if (model.page.integerValue == 1) {
        [_recordArray removeAllObjects];
    }
    
    if (model.exchangeOrders != nil && model.count != 0) {
        [_recordArray addObjectsFromArray:(NSMutableArray *)model.exchangeOrders];
    }
    
    if ([_recordArray count] != 0) {
        if (model.count.intValue > [_recordArray count]) {
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
    if ([self.recordArray count] == 0) {
        [self setOverlayStatus:EOverlayStatusError labelText:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger sections = [_recordArray count];
    
    if (sections > 0 && _hasMore) {
        sections++;
    }
    return sections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

//设置表格的头部
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}

//设置表格头部的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    } else {
        return 15;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat heiht = 0.0;
    if (_hasMore && ([_recordArray count] == indexPath.section)) {
        heiht = 50; //加载更多的cell高度
    } else {
        heiht = 158;
    }
    return heiht;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_hasMore && ([_recordArray count] == indexPath.section)) {
        static NSString *activityIndicatorIdentifier = @"ActivityCellReuseIdentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:activityIndicatorIdentifier];
        if(!cell){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:activityIndicatorIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            UIButton *contentView = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 20, 50)];
            contentView.userInteractionEnabled = NO;
            contentView.backgroundColor = [UIColor whiteColor];
            contentView.titleLabel.font = [UIFont systemFontOfSize:14];
            contentView.layer.cornerRadius = 3.0;
            contentView.clipsToBounds = YES;
            [cell addSubview:contentView];
            
            UILabel *loadMoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 50)];
            loadMoreLabel.textAlignment = UITextAlignmentCenter;
            loadMoreLabel.font = [UIFont systemFontOfSize:14];
            loadMoreLabel.tag = 1002;
            [contentView addSubview:loadMoreLabel];
            
            UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            spinner.center = CGPointMake(80, 25);
            spinner.tag = 1001;
            [contentView addSubview:spinner];
        }
        
        UIActivityIndicatorView *spinner = (UIActivityIndicatorView *)[cell viewWithTag:1001];
        UILabel *loadMoreLabel = (UILabel *)[cell viewWithTag:1002];
        if (self.loading) {
            loadMoreLabel.text = @"加载中...";
            [spinner startAnimating];
        } else {
            loadMoreLabel.text = @"查看更多...";
            [spinner stopAnimating];
        }
        
        return cell;
        
    }else{
        static NSString *TableIdentifier = @"ExchangeOrderTableCellIdentifier";
        ExchangeOrderTableCell *cell = [tableView dequeueReusableCellWithIdentifier:TableIdentifier];
        if(!cell){
            cell = [[ExchangeOrderTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: TableIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        MIExchangeOrderModel *model = _recordArray[indexPath.section];
        [cell.itemTimeLabel setText:[NSString stringWithFormat:@"订单编号 : %@", model.orderId]];
        [cell.itemNameLabel setText:[NSString stringWithFormat:@"商品名称 : %@", model.goodsName]];
        double price = model.price.doubleValue;
        if ([model.payType isEqualToString:@"1"]) {
            [cell.itemMoneyLabel setText:[NSString stringWithFormat:@"兑换金额 : %.0f元", price / 100]];
        } else {
            [cell.itemMoneyLabel setText:[NSString stringWithFormat:@"兑换金额 : %.0f米币", price]];
        }
        
        NSString *state;
        if ([model.status isEqualToString:@"1"]) {
            state = @"兑换状态 : <font color='#499d00'>已处理</font>";
        } else if ([model.status isEqualToString:@"2"]) {
            state = @"兑换状态 : <font color='#000000'>已取消</font>";
        } else {
            state = @"兑换状态 : <font color='#ff0000'>待处理</font>";
        }
        [cell.itemStatusLabel setText:state];
        
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"兑换时间 : yyyy-MM-dd HH:mm"];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:model.gmtCreate.doubleValue];
        NSString *title = [[NSString alloc] initWithFormat:@"%@", [dateFormatter stringFromDate:date]];
        
        [cell.itemFooterLabel setText:title];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (_hasMore && ([_recordArray count] == indexPath.section)) {
        [self loadMoreTableViewDataSource];
    }
}

@end