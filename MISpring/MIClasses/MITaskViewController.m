//
//  MITaskViewController.m
//  MISpring
//
//  Created by 曲俊囡 on 14-5-26.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MITaskViewController.h"
#import "MIExchangeViewController.h"
#import "MITaskDetailViewController.h"
#import "MICoinEarnGetModel.h"
#import "YouMiConfig.h"
#import "YouMiPointsManager.h"
#import "YouMiWall.h"
#import <Escore/YJFUserMessage.h>

@implementation MITaskViewController
@synthesize taskTotalIncomeLabel,exchangeLabel,detailLabel,firstButton,secondButton,thirdButton;

- (void)loadView
{
    [super loadView];
    [self.navigationBar setBarTitle:@"天天赚米币"  textSize:20.0];
    UIButton *exchangeOrderBtn = [[UIButton alloc] initWithFrame:CGRectMake(320 - 85, (self.navigationBarHeight - PHONE_NAVIGATION_BAR_ITEM_HEIGHT), 80, PHONE_NAVIGATION_BAR_ITEM_HEIGHT)];
    [exchangeOrderBtn setTitle:@"查看规则" forState:UIControlStateNormal];
    [exchangeOrderBtn addTarget:self action:@selector(showRules) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBar addSubview:exchangeOrderBtn];
    self.view.backgroundColor = [UIColor whiteColor];
    
    taskTotalIncomeLabel.userInteractionEnabled = YES;
    taskTotalIncomeLabel.font = [UIFont systemFontOfSize:14];
    taskTotalIncomeLabel.textColor = [MIUtility colorWithHex:0xff8c25];
    taskTotalIncomeLabel.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reloadIncomeCoins)];
    [taskTotalIncomeLabel addGestureRecognizer:tap];

    exchangeLabel.userInteractionEnabled = YES;
    exchangeLabel.text = @"\n<u color=orange>去兑换</u>";
    exchangeLabel.font = [UIFont systemFontOfSize:12];
    exchangeLabel.textColor = [MIUtility colorWithHex:0xffaa53];
    exchangeLabel.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *exchangeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToExchange)];
    [exchangeLabel addGestureRecognizer:exchangeTap];
    
    detailLabel.userInteractionEnabled = YES;
    detailLabel.text = @"\n<u color=orange>查看明细</u>";
    detailLabel.font = [UIFont systemFontOfSize:12];
    detailLabel.textAlignment = RTTextAlignmentRight;
    detailLabel.textColor = [MIUtility colorWithHex:0xffaa53];
    detailLabel.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *detailTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToDetail)];
    [detailLabel addGestureRecognizer:detailTap];
    
    _ruleBgView.frame = self.view.bounds;
    _ruleView.center = self.ruleBgView.center;
    self.ruleBgView.alpha = 0;
    self.ruleBgView.userInteractionEnabled = NO;
    [self.view addSubview:self.ruleBgView];
    self.okButton.layer.cornerRadius = 3;
    self.line.image = [[UIImage imageNamed:@"ic_line"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    [self resizeVC];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    __weak typeof(self) weakSelf = self;
    _request = [[MICoinEarnGetRequest alloc] init];
    _request.onCompletion = ^(MICoinEarnGetModel *model) {
        [weakSelf finishEarnData:model];
    };
    
    _request.onError = ^(MKNetworkOperation* completedOperation, MIError* error) {
        weakSelf.taskTotalIncomeLabel.text = @"加载失败,点击可重新加载";
        weakSelf.taskTotalIncomeLabel.userInteractionEnabled = YES;

        MILog(@"error_msg=%@",error.description);
    };
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    taskTotalIncomeLabel.text = @"加载中...";
    taskTotalIncomeLabel.userInteractionEnabled = NO;
    [_request sendQuery];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [_request cancelRequest];
    taskTotalIncomeLabel.userInteractionEnabled = YES;
}

- (void)reloadIncomeCoins
{
    [_request sendQuery];
    taskTotalIncomeLabel.text = @"加载中...";
    taskTotalIncomeLabel.userInteractionEnabled = NO;
}
- (void)finishEarnData:(MICoinEarnGetModel *)model
{
    taskTotalIncomeLabel.text = [NSString stringWithFormat:@"<font size=20.0 >%d</font> 米币", model.earnCoin.intValue];
    taskTotalIncomeLabel.userInteractionEnabled = NO;

    MIMainUser *mainUser = [MIMainUser getInstance];
    mainUser.coin = model.coin;
    [mainUser persist];
}

- (void)resizeVC
{
    int taskNum = [MIConfig globalConfig].showLimei + [MIConfig globalConfig].showYoumi + [MIConfig globalConfig].showYijifen;
    NSArray *arrBtns = [NSArray arrayWithObjects:firstButton, secondButton, thirdButton, nil];
    for (UIButton *button in arrBtns)
    {
        if (button.tag > 100+taskNum)
        {
            button.hidden = YES;
        } else {
            button.hidden = NO;
            [button setBackgroundImage:[[UIImage imageNamed:@"bg_task__background"] resizableImageWithCapInsets:UIEdgeInsetsMake(24, 1, 24, 1)] forState:UIControlStateNormal];
            [button setBackgroundImage:[[UIImage imageNamed:@"bg_task__background_hl"] resizableImageWithCapInsets:UIEdgeInsetsMake(24, 1, 24, 1)] forState:UIControlStateHighlighted];
            
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setTitleColor:[MIUtility colorWithHex:0xff8c25] forState:UIControlStateHighlighted];
            button.clipsToBounds = YES;
            button.layer.cornerRadius = 4;
            button.layer.borderColor = [UIColor lightGrayColor].CGColor;
            button.layer.borderWidth = 0.6;
        }
        
        if (taskNum  == 1)
        {
            [button setTitle:@"进入任务区" forState:UIControlStateNormal];
        }
    }
    self.imageView.top = 80 + 60 * taskNum;
    self.scrollView.contentSize = CGSizeMake(PHONE_SCREEN_SIZE.width, self.imageView.bottom + 10);
}

- (IBAction)goToTaskRoom:(id)sender {
    
    UIButton *button = (UIButton *)sender;
    
    if (button.tag == 101)
    {
        if ([MIConfig globalConfig].showLimei)
        {
            [self enterLiMeiAdWall];
        }
        else if ([MIConfig globalConfig].showYoumi)
        {
            [self enterYouMiAdWall];
        }
        else
        {
            [self enterYJFAdWall];
        }
    }
    else if (button.tag == 102)
    {
        
        if ([MIConfig globalConfig].showLimei && [MIConfig globalConfig].showYoumi)
        {
            [self enterYouMiAdWall];
        }
        else
        {
            [self enterYJFAdWall];
        }
    }
    else  if (button.tag == 103)
    {
        [self enterYJFAdWall];
    }
}

#pragma  mark - JifenWall

// 进入力美积分墙
-(void)enterLiMeiAdWall
{
    // 实例化 immobView 对象,在此处替换在力美广告平台申请到的广告位 ID;
    if (!self.adView_adWall) {
        _adView_adWall = [[immobView alloc] initWithAdUnitId:ImmobAdUnitID adUnitType:0 rootViewController:self userInfo:nil];
        self.adView_adWall.delegate=self;
    }
    
    //添加 userAccount 属性,此属性针对多账户应用所使用,用于区分不同账户下的积分(可选)。
    NSString *uid = [NSString stringWithFormat:@"%@",[MIMainUser getInstance].userId];
    if (uid == nil || uid.length == 0) {
        uid = @"1";
    }
    
    NSString *uidDES = [MIUtility encryptUseDES:uid key:[MIConfig globalConfig].desKey];
    [self.adView_adWall.UserAttribute setObject:uidDES  forKey: accountname];
    //开始加载广告。
    [self.adView_adWall immobViewRequest];
    //将 immobView 添加到界面上。
    [self.view addSubview: self.adView_adWall];
    [self showProgressHUD:nil];
}
// 进入有米积分墙
-(void)enterYouMiAdWall
{
    // [可选] 例如开发者的应用是有登录功能的，则可以使用登录后的用户账号来替代有米为每台机器提供的标识（有米会为每台设备生成的唯一标识符）。
    NSString *uid = [NSString stringWithFormat:@"%@",[MIMainUser getInstance].userId];
    if (uid == nil || uid.length == 0) {
        uid = @"1";
    }
    
    NSString *uidDES = [MIUtility encryptUseDES:uid key:[MIConfig globalConfig].desKey];
    [YouMiConfig setUserID:uidDES];
    // 替换下面的appID和appSecret为你的appid和appSecret
    [YouMiConfig setShouldGetLocation:NO];
    [YouMiConfig launchWithAppID:YouMiAdAppID appSecret:YouMiAppSecret];
    // 开启积分管理[本例子使用自动管理];
    [YouMiPointsManager enable];
    // 开启积分墙
    [YouMiWall enable];
    [YouMiWall showOffers:YES didShowBlock:^{
        MILog(@"有米积分墙已显示");
    } didDismissBlock:^{
        MILog(@"有米积分墙已退出");
        taskTotalIncomeLabel.text = @"刷新中...";
        taskTotalIncomeLabel.userInteractionEnabled = NO;
        [_request sendQuery];
    }];
}
//进入易积分积分墙
- (void)enterYJFAdWall
{
    NSString *uid = [NSString stringWithFormat:@"%@",[MIMainUser getInstance].userId];
    if (uid == nil || uid.length == 0) {
        uid = @"1";
    }
    
    NSString *uidDES = [MIUtility encryptUseDES:uid key:[MIConfig globalConfig].desKey];
    NSString *uidParam = [NSString stringWithFormat:@"80613@%@", uidDES];
    [YJFUserMessage shareInstance].yjfCoop_info =  uidParam;//用户UID
    
    YJFIntegralWall *integralWall = [[YJFIntegralWall alloc] init];
    integralWall.delegate = self;
    [self presentViewController:integralWall animated:YES completion:nil];
}
#pragma mark - actions

- (IBAction)hiddenRuleView:(id)sender {
    [UIView animateWithDuration:0.3 animations:^{
        self.ruleBgView.alpha = 0;
    } completion:^(BOOL finished) {
        self.ruleBgView.userInteractionEnabled = NO;
    }];
}
- (void)showRules
{
    [UIView animateWithDuration:0.3 animations:^{
        self.ruleBgView.alpha = 1;
    } completion:^(BOOL finished) {
        self.ruleBgView.userInteractionEnabled = YES;
    }];
}
- (void)goToExchange
{
    MIExchangeViewController *vc = [[MIExchangeViewController alloc] init];
    [[MINavigator navigator] openPushViewController:vc animated:YES];
}
- (void)goToDetail
{
    MITaskDetailViewController *detailVC = [[MITaskDetailViewController alloc] init];
    [[MINavigator navigator] openPushViewController:detailVC animated:YES];
}

#pragma mark - immobViewDelegate
- (void) immobViewDidReceiveAd:(immobView*)immobView
{
    [self hideProgressHUD];
}

- (void) onDismissScreen:(immobView *)immobView
{
    [self hideProgressHUD];
    taskTotalIncomeLabel.text = @"刷新中...";
    taskTotalIncomeLabel.userInteractionEnabled = NO;
    [_request sendQuery];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
