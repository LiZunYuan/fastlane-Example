//
//  MIExchangeViewController.m
//  MISpring
//
//  Created by 贺晨超 on 13-8-26.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIExchangeViewController.h"
#import "MIExchangeOrderViewController.h"
#import "MIAlipaySettingViewController.h"
#import "MIPhoneSettingViewController.h"
#import "MICoinModel.h"
#import "MIBBMarqueeView.h"

#pragma  mark - ExchangeHeaderView

@interface ExchangeHeadView : UIView

@property (nonatomic, strong) UIView *tipBgView;
@property (nonatomic, strong) MIBBMarqueeView *tipLabel;
@property (nonatomic, strong) UILabel *coinTipLabel;

@end

@implementation ExchangeHeadView

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = MINormalBackgroundColor;
        _tipBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, PHONE_SCREEN_SIZE.width, 24)];
        self.tipBgView.backgroundColor = [MIUtility colorWithHex:0xfffceb];
        [self addSubview:self.tipBgView];
        
        _tipLabel = [[MIBBMarqueeView alloc] initWithFrame:CGRectMake(12, 0, self.tipBgView.viewWidth - 24, 24)];
        self.tipLabel.backgroundColor = [UIColor clearColor];
        self.tipLabel.lable.textColor = [MIUtility colorWithHex:0xe89e5d];
        self.tipLabel.lable.font = [UIFont systemFontOfSize:11];
        [self.tipBgView addSubview:self.tipLabel];
        
        
        UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.tipBgView.viewHeight - 0.5, PHONE_SCREEN_SIZE.width, 0.5)];
        bottomLine.backgroundColor = MILineColor;
        [self.tipBgView addSubview:bottomLine];
        
        
        self.coinTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 44, SCREEN_WIDTH - 40, 30)];
        self.coinTipLabel.backgroundColor = [UIColor clearColor];
        self.coinTipLabel.font = [UIFont systemFontOfSize:11.0];
        self.coinTipLabel.textAlignment = UITextAlignmentCenter;
        self.coinTipLabel.textColor = MIColor666666;
        self.coinTipLabel.shadowColor = [UIColor whiteColor];
        self.coinTipLabel.shadowOffset = CGSizeMake(0, -1.0);
        self.coinTipLabel.numberOfLines = 0;
        [self addSubview:self.coinTipLabel];

    }
    return self;
}

@end

#pragma mark - ExchangeListCell
@interface ExchangeListCell : UITableViewCell

@property (nonatomic, strong) UIButton *coinButton;
@property (nonatomic, strong) RTLabel *coinLabel;
@property (nonatomic, strong) UILabel *tipsLabel;

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, copy) void(^exchageMIBI) (NSInteger index);

@end

@implementation ExchangeListCell
@synthesize coinButton,coinLabel,tipsLabel;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
		self.backgroundColor = [UIColor clearColor];
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 8, PHONE_SCREEN_SIZE.width, 72)];
        bgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:bgView];
        
        self.coinButton = [[UIButton alloc] initWithFrame:CGRectMake(bgView.viewWidth - 24 - 68, 0, 68, 28)];
        [self.coinButton setTitle:@"立即兑换" forState:UIControlStateNormal];
        self.coinButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        [self.coinButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.coinButton.centerY = bgView.viewHeight / 2;
        self.coinButton.clipsToBounds = YES;
        self.coinButton.backgroundColor = MIColorNavigationBarBackground;
        self.coinButton.layer.cornerRadius = 4;
        [self.coinButton addTarget:self action:@selector(exchangeMiBi) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:self.coinButton];

        self.coinLabel = [[RTLabel alloc] initWithFrame:CGRectMake(24, 13, 200, 32)];
        self.coinLabel.font = [UIFont systemFontOfSize:13];
        self.coinLabel.textColor = MIColor666666;
        self.coinLabel.backgroundColor = [UIColor clearColor];
        self.coinLabel.textAlignment = RTTextAlignmentLeft;
        self.coinLabel.text = @"<font size=24.0 color='#ff8c24'>2000</font>集分宝";
        [bgView addSubview:self.coinLabel];
        
        self.tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(24, self.coinLabel.bottom, 200, 12)];
        self.tipsLabel.font = [UIFont systemFontOfSize:11];
        self.tipsLabel.textColor = [MIUtility colorWithHex:0x999999];
        self.tipsLabel.backgroundColor = [UIColor clearColor];
        self.tipsLabel.textAlignment = UITextAlignmentLeft;
        self.tipsLabel.text = @"(价值20元，需要消耗2000米币)";
        [bgView addSubview:self.tipsLabel];
        
        UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, PHONE_SCREEN_SIZE.width, 0.5)];
        topLine.backgroundColor = MILineColor;
        [bgView addSubview:topLine];
        
        UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, bgView.viewHeight - 0.5, PHONE_SCREEN_SIZE.width, 0.5)];
        bottomLine.backgroundColor = MILineColor;
        [bgView addSubview:bottomLine];
    }
    return self;
}
- (void)exchangeMiBi
{
    
    if (_exchageMIBI)
    {
        _exchageMIBI(self.index);
    }
}
@end

#pragma mark - MIExchangeViewController
@interface MIExchangeViewController()

@property (nonatomic, strong) ExchangeHeadView *headerView;
@end

@implementation MIExchangeViewController
@synthesize request;
@synthesize data;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        data = [[NSMutableArray alloc] initWithCapacity:4];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.navigationBar setBarTitle: @"兑换集分宝"];
    
    UIButton *exchangeOrderBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 85, (self.navigationBarHeight - PHONE_NAVIGATION_BAR_ITEM_HEIGHT), 80, PHONE_NAVIGATION_BAR_ITEM_HEIGHT)];
    [exchangeOrderBtn setTitle:@"兑换记录" forState:UIControlStateNormal];
    [exchangeOrderBtn setTitleColor:MIColorNavigationBarBackground forState:UIControlStateNormal];
    exchangeOrderBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [exchangeOrderBtn addTarget:self action:@selector(exchangeOrder) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBar addSubview:exchangeOrderBtn];
    
    self.baseTableView = [[UITableView alloc] initWithFrame: CGRectMake(0, self.navigationBarHeight, SCREEN_WIDTH, self.view.viewHeight - self.navigationBarHeight)  style:UITableViewStylePlain];
    _baseTableView.dataSource = self;
    _baseTableView.delegate = self;
    [_baseTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_baseTableView setBackgroundColor: [UIColor clearColor]];
    _baseTableView.backgroundView.alpha  = 0;
    [self.view sendSubviewToBack:_baseTableView];
    
    _headerView = [[ExchangeHeadView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 54)];
    self.headerView.tipBgView.hidden =YES;
    self.headerView.coinTipLabel.top = 20;
    _baseTableView.tableHeaderView = self.headerView;
    _baseTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 20, 5)];
    
    __weak typeof(self) bself = self;
    request = [[MIExchangeCoinsGetRequest alloc] init];
    request.onCompletion = ^(MIExchangeCoinsGetModel *model) {
        [bself finishLoadTableData:model];
    };
    
    request.onError = ^(MKNetworkOperation* completedOperation, MIError* error) {
        [bself failLoadTableViewData];
        MILog(@"error_msg=%@",error.description);
    };
    [request sendQuery];
    [self setOverlayStatus:EOverlayStatusLoading labelText:nil];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    if (self.request.operation.isExecuting) {
        [self.request cancelRequest];
        self.request = nil;
    }
}

- (void)finishLoadTableData:(MIExchangeCoinsGetModel *) model
{
    [self setOverlayStatus:EOverlayStatusRemove labelText:nil];
    if (model.tip && ![model.tip isEqualToString:@""]) {
        [self.headerView.tipLabel setLabelText: model.tip];
        self.headerView.tipLabel.lable.top = 6;
        [self.headerView.tipLabel startTimer];
        self.headerView.tipBgView.hidden = NO;
        self.headerView.coinTipLabel.top = self.headerView.tipBgView.bottom + 20;
        self.headerView.viewHeight = 74;
    }
    else
    {
        self.headerView.tipBgView.hidden =YES;
        self.headerView.coinTipLabel.top = 20;
        self.headerView.viewHeight = 54;
    }
    self.baseTableView.tableHeaderView = self.headerView;

    [data addObjectsFromArray:(NSMutableArray *)model.coins];
    [_baseTableView reloadData];
}

- (void)failLoadTableViewData
{
    [self setOverlayStatus:EOverlayStatusError labelText:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.headerView.coinTipLabel.text = [NSString stringWithFormat:@"当前剩余米币 %ld 个，兑换集分宝在淘宝/天猫等网站可抵现金消费，100集分宝抵1元！", (long)[MIMainUser getInstance].coin.integerValue];
    [_baseTableView reloadData];
}


#pragma mark - tableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return data.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ExchangeListCell *cell = [tableView dequeueReusableCellWithIdentifier: @"exchangeCell"];
    if (cell == nil) {
        cell = [[ExchangeListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"exchangeCell"];
    }
    
    if (data.count > indexPath.row) {
        MICoinModel *model = [data objectAtIndex:indexPath.row];
        cell.index = indexPath.row;
        cell.coinLabel.text = [NSString stringWithFormat:@"<font size=24.0 color='#ff8c24'>%ld</font>集分宝", (long)model.coins.integerValue];
        cell.tipsLabel.text = [NSString stringWithFormat:@"(价值%ld元，需要消耗%ld米币)", (long)model.coins.integerValue / 100, (long)model.coins.integerValue];
        if ([MIMainUser getInstance].coin.integerValue < model.coins.integerValue) {
            cell.coinButton.backgroundColor = [MIUtility colorWithHex:0xbebebe];
            [cell.coinButton setTitle:@"米币不足" forState:UIControlStateNormal];
            cell.coinButton.userInteractionEnabled = NO;
        } else {
            cell.coinButton.backgroundColor = MIColorNavigationBarBackground;
            [cell.coinButton setTitle:@"立即兑换" forState:UIControlStateNormal];
            cell.coinButton.userInteractionEnabled = YES;
        }
        [cell setExchageMIBI:^(NSInteger index) {
            MIMainUser *mainUser = [MIMainUser getInstance];
            if ((mainUser.loginAccount == nil) || (mainUser.loginAccount.length == 0) || ([mainUser.loginAccount hasSuffix:@"@open.mizhe"])) {
                //用户邮箱为空或者是带有open.mizhe后缀的，说明是通过第三方账号登录，需要先设置邮箱及密码
                [MINavigator openBindEmailViewController];
            } else if ((mainUser.phoneNum == nil) || (mainUser.phoneNum.length == 0)) {
                MIButtonItem *cancelItem = [MIButtonItem itemWithLabel:@"取消"];
                MIButtonItem *affirmItem = [MIButtonItem itemWithLabel:@"好"];
                affirmItem.action = ^{
                    MIPhoneSettingViewController *vc = [[MIPhoneSettingViewController alloc] init];
                    [[MINavigator navigator] openPushViewController:vc animated:YES];
                };
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提醒"
                                                                    message:@"为了保障您的账户和资金安全，请先绑定手机号"
                                                           cancelButtonItem:cancelItem
                                                           otherButtonItems:affirmItem, nil];
                [alertView show];
            } else if ((mainUser.alipay == nil) || (mainUser.alipay.length == 0)) {
                //用户支付宝账号为空，需要先设置支付宝账号
                MIAlipaySettingViewController *vc = [[MIAlipaySettingViewController alloc] init];
                vc.barTitle = @"兑换设置";
                [[MINavigator navigator] openPushViewController:vc animated:YES];
            } else {
                if (data.count > index) {
                    MICoinModel *model = [data objectAtIndex:index];
                    MIMainUser *user = [MIMainUser getInstance];
                    if (user.coin.integerValue < model.coins.integerValue) {
                        [self showSimpleHUD:[NSString stringWithFormat:@"当前剩余米币不足%ld", (long)model.coins.integerValue]];
                    } else {
                        if (!self.veriCodeView) {
                            _veriCodeView = [[[NSBundle mainBundle] loadNibNamed:@"MICoinApplyVerifyView" owner:self options:nil] objectAtIndex:0];
                            self.veriCodeView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.veriCodeView.viewHeight);
                            if ([UIDevice isRetina4inch]) {
                                self.veriCodeView.bgView.top = 120 * SCREEN_WIDTH / 320;
                            }
                            [self.view addSubview:self.veriCodeView];
                        }
                        
                        self.veriCodeView.coinModel = model;
                        self.veriCodeView.alpha = 1;
                        [self.veriCodeView.codeTextField becomeFirstResponder];
                    }
                }
            }
        }];
    }
    
    return cell;
}


- (void) exchangeOrder
{
    MIExchangeOrderViewController *vc = [[MIExchangeOrderViewController alloc] init];
    [[MINavigator navigator] openPushViewController:vc animated:YES];
}
@end
