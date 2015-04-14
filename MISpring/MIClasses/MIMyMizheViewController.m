//
//  MIMyMizheViewController.m
//  MISpring
//
//  Created by XU YUJIAN on 13-1-25.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIMyMizheViewController.h"
#import "MIAppDelegate.h"
#import "MIUserGetRequest.h"
#import "MIUserGetModel.h"
#import "MITaobaoOrderViewController.h"
#import "MIPayApplyViewController.h"
#import "MIPayRecordViewController.h"
#import "MIPhoneSettingViewController.h"
#import "MIAlipaySettingViewController.h"
#import "MIHeartbeat.h"
#import "MIPushBadgeClearRequest.h"
#import "MIUpYun.h"

#import "MIExchangeViewController.h"
#import "MIExchangeOrderViewController.h"
#import "MISecurityAccountViewController.h"
#import "MIVIPCenterViewController.h"
#import "MIModifyHeadImageViewController.h"
#import "MIMsgCenterViewController.h"
#import "MICheckInAndInviteView.h"
#import "MIMyOrderViewController.h"
#import "MIUserFavorViewController.h"

#define USER_INFO_HEIGHT     107
#define CHECKIN_BTN_HEIGHT   30
#define HEIGHT_FOR_ROW       40
#define HEIGHT_FOR_SECTION   30
#define COMMON_MARGIN_WIDTH   5

@implementation MIMyMizheViewController
@synthesize userWall = _userWall;
@synthesize userHead = _userHead;
@synthesize usernameLabel = _usernameLabel;
@synthesize request = _request;
@synthesize vipCenterIndicator = _vipCenterIndicator;

- (id)init
{
    self = [super init];
    if (self) {
        __weak typeof(self) weakSelf = self;
        _request = [[MIUserGetRequest alloc] init];
        _request.onCompletion = ^(MIUserGetModel * model) {
            [weakSelf finishLoadTableViewData:model];
        };
        _request.onError = ^(MKNetworkOperation* completedOperation, MIError* error) {
            [weakSelf failLoadTableViewData];
            MILog(@"error_msg=%@",error.description);
        };
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.needRefreshView = YES;
    
    [self.navigationBar setBarTitle:@"我的米折"];
    [self.navigationBar setBarRightButtonItem:self selector:@selector(goSetting) imageKey:@"mi_navbar_tool_setting_img"];
//    [self.navigationBar setBarLeftButtonItem:self selector:@selector(goMsgCenter) imageKey:@"mi_navbar_tool_message_img"];
    
    _updateBadgeView = [[JSBadgeView alloc] initWithParentView:self.navigationBar.rightButton alignment:JSBadgeViewAlignmentTopRight];
    _updateBadgeView.badgeText = @"NEW";
    _updateBadgeView.userInteractionEnabled = NO;
    _updateBadgeView.badgeBackgroundColor = [UIColor orangeColor];
    _updateBadgeView.badgeTextColor = [UIColor whiteColor];
    _updateBadgeView.badgeStrokeColor = [UIColor clearColor];
    _updateBadgeView.badgeTextFont = [UIFont systemFontOfSize:8.0];
    _updateBadgeView.badgePositionAdjustment = CGPointMake(-15, 10);
    _updateBadgeView.alpha = 0.0;
    [self.navigationBar.rightButton addSubview:_updateBadgeView];
    
    self.baseTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _baseTableView.frame = CGRectMake(0, self.navigationBarHeight, self.view.viewWidth, self.view.viewHeight - TABBAR_HEIGHT - self.navigationBarHeight);
    _baseTableView.backgroundColor = [UIColor clearColor];
    _baseTableView.backgroundView.alpha = 0;
    _baseTableView.showsVerticalScrollIndicator = NO;
    _baseTableView.delegate = self;
    _baseTableView.dataSource = self;
    _baseTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectZero];
    headView.backgroundColor = [UIColor clearColor];
    
    _reminderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
    self.reminderLabel.backgroundColor = [MIUtility colorWithHex:0x333333];
    self.reminderLabel.userInteractionEnabled = YES;
    self.reminderLabel.alpha = 0.7;
    self.reminderLabel.text = @"账户安全检测  >";
    self.reminderLabel.textAlignment = UITextAlignmentCenter;
    self.reminderLabel.textColor = [UIColor whiteColor];
    self.reminderLabel.font = [UIFont systemFontOfSize:9];
    [headView addSubview:self.reminderLabel];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToReminderView)];
    [self.reminderLabel addGestureRecognizer:tap];
    
    _userWall = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, USER_INFO_HEIGHT)];
    _userWall.userInteractionEnabled = YES;
    _userWall.image = [UIImage imageNamed:@"bg_login"];
    [headView addSubview:_userWall];
    
    UITapGestureRecognizer *loginRecoginzer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userWallAction)];
    [headView addGestureRecognizer:loginRecoginzer];
    
    _userHead = [[UIImageView alloc] initWithFrame:CGRectMake(20, (USER_INFO_HEIGHT - 30 - 45) / 2, 45, 45)];
    _userHead.layer.cornerRadius = 22.5;
    _userHead.layer.masksToBounds = YES;
    _userHead.layer.borderColor = [UIColor whiteColor].CGColor;
    _userHead.layer.borderWidth = 2.0;
    _userHead.userInteractionEnabled = YES;
    [headView addSubview:_userHead];
    
    UITapGestureRecognizer *modifyHeadImage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(modifyHeadImage)];
    [self.userHead addGestureRecognizer:modifyHeadImage];
    
    _usernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(73, (USER_INFO_HEIGHT - 30 - 55) / 2, SCREEN_WIDTH - 70 - 100, 30)];
    _usernameLabel.textAlignment = UITextAlignmentLeft;
    _usernameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    _usernameLabel.backgroundColor = [UIColor clearColor];
    _usernameLabel.font = [UIFont systemFontOfSize: 16];
    _usernameLabel.adjustsFontSizeToFitWidth = YES;
    _usernameLabel.minimumScaleFactor = 14 / [UIFont labelFontSize];
    _usernameLabel.textColor = [UIColor whiteColor];
    [_usernameLabel setShadowColor: [UIColor colorWithWhite: 0.3 alpha: 0.65]];
    [_usernameLabel setShadowOffset: CGSizeMake(0.7, 0.7)];
    [headView addSubview:_usernameLabel];
    
    _levelImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 13, 14)];
    self.levelImageView.centerY = self.usernameLabel.centerY;
    [headView addSubview:self.levelImageView];
    
    _accountLabel = [[UILabel alloc] initWithFrame:CGRectMake(73, _usernameLabel.bottom + 4, SCREEN_WIDTH - 70, 20)];
    _accountLabel.textAlignment = UITextAlignmentLeft;
    _accountLabel.backgroundColor = [UIColor clearColor];
    _accountLabel.font = [UIFont systemFontOfSize:14];
    _accountLabel.adjustsFontSizeToFitWidth = YES;
    _accountLabel.minimumScaleFactor = 12 / [UIFont labelFontSize];
    _accountLabel.textColor = [UIColor whiteColor];
    [_accountLabel setShadowColor: [UIColor colorWithWhite: 0.3 alpha: 0.65]];
    [_accountLabel setShadowOffset: CGSizeMake(0.7, 0.7)];
    [headView addSubview:_accountLabel];
    
    _vipCenterIndicator = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 12, 23)];
    _vipCenterIndicator.image = [UIImage imageNamed:@"ic_user_vip"];
    [headView addSubview:_vipCenterIndicator];
    
    MICheckInAndInviteView *checkView = [[MICheckInAndInviteView alloc] initWithFrame:CGRectMake(0, USER_INFO_HEIGHT, PHONE_SCREEN_SIZE.width, CHECKIN_BTN_HEIGHT)];
    checkView.bottom = _userWall.bottom;
    [headView addSubview:checkView];
    
    headView.frame = CGRectMake(0, 0, PHONE_SCREEN_SIZE.width, checkView.bottom);
    _vipCenterIndicator.center = CGPointMake(SCREEN_WIDTH - 20, (headView.viewHeight - CHECKIN_BTN_HEIGHT)/2);
    
    _loginLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, headView.viewWidth, 30)];
    _loginLabel.text = @"登录米折，开启手机购物之旅";
    _loginLabel.backgroundColor = [UIColor clearColor];
    _loginLabel.textColor = [UIColor whiteColor];
    _loginLabel.font = [UIFont systemFontOfSize:14];
    _loginLabel.textAlignment = UITextAlignmentCenter;
    [headView addSubview:_loginLabel];
    
    _loginBtnLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 84, 24)];
    _loginBtnLabel.clipsToBounds = YES;
    _loginBtnLabel.layer.cornerRadius = 2;
    _loginBtnLabel.text = @"立即登录";
    _loginBtnLabel.textColor = [UIColor whiteColor];
    _loginBtnLabel.textAlignment = UITextAlignmentCenter;
    _loginBtnLabel.font = [UIFont systemFontOfSize:15];
    _loginBtnLabel.backgroundColor = [MIUtility colorWithHex:0xff8800];
    _loginBtnLabel.top = _loginLabel.bottom;
    _loginBtnLabel.centerX = self.view.viewWidth/2;
    [headView addSubview:_loginBtnLabel];
    
    self.baseTableView.tableHeaderView = headView;
    _headerViewHeight = headView.viewHeight;
    
    UISwipeGestureRecognizer *recognizerLeft = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(goSetting)];
    [recognizerLeft setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [self.view addGestureRecognizer:recognizerLeft];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    MIAppDelegate* delegate = (MIAppDelegate*)[[UIApplication sharedApplication] delegate];
    if (delegate.appNewVersion) {
        _updateBadgeView.alpha = 1.0;
    } else {
        _updateBadgeView.alpha = 0.0;
    }
    
    [self updateUserWallInfo];
    if([[Reachability reachabilityForInternetConnection] isReachable]){
        if (IOS_VERSION >= 8.0) {
            UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
            UIUserNotificationSettings *notificationSettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
            [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
        } else {
            UIRemoteNotificationType types = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert;
            [[UIApplication sharedApplication] registerForRemoteNotificationTypes: types];
        }
        
        //如果有新的订单，则更新用户账户信息
        if ([[MIHeartbeat shareHeartbeat] hasNewOrderMessage]) {
            [self reloadTableViewDataSource];
        }
    }
    
    [self registerNotifications];
    
    if ([MIMainUser getInstance].loginStatus == MILoginStatusNormalLogin) {
        [XGPush delTag:@"激活未注册"];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (self.loading) {
        self.loading = NO;
        [super finishLoadTableViewData];
    }
    [_request cancelRequest];
    [self removeNotifications];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

#pragma mark - Notification 处理
- (void)registerNotifications{
    
    //push newmessage数量更新通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateTabbarPushNewMessageCount)
                                                 name:MiNotificationNewsMessageDidUpdate
                                               object:nil];
}

- (void)removeNotifications{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)updateTabbarPushNewMessageCount
{
    if ([[MIMainUser getInstance] checkLoginInfo]) {
        if ([[MIHeartbeat shareHeartbeat] hasNewOrderMessage]) {
            [self reloadTableViewDataSource];
        }
        if ([[MIHeartbeat shareHeartbeat] hasNewMessage]) {
            [self.navigationBar setBarLeftButtonItem:self selector:@selector(goMsgCenter) imageKey:@"mi_navbar_tool_message_have"];
        } else {
            [self.navigationBar setBarLeftButtonItem:self selector:@selector(goMsgCenter) imageKey:@"mi_navbar_tool_message_img"];
        }
    } else {
        [self updateUserWallInfo];
    }
}

- (void)updateUserWallInfo
{
    if (![[MIMainUser getInstance] checkLoginInfo]) {
        //未登录
//        _userWall.image = [UIImage imageNamed:@"bg_login"];
        _userHead.hidden = YES;
        _levelImageView.hidden = YES;
        _usernameLabel.hidden = YES;
        _accountLabel.hidden = YES;
        _vipCenterIndicator.hidden = YES;
        _loginLabel.hidden = NO;
        _loginBtnLabel.hidden = NO;
        
        if (self.reminderLabel.viewHeight != 0) {
            [MIConfig globalConfig].isHiddenReminderView = YES;
            self.reminderLabel.viewHeight = 0;
            for (UIView *view in self.baseTableView.tableHeaderView.subviews)
            {
                if (![view isEqual:self.reminderLabel])
                {
                    view.transform = CGAffineTransformMakeTranslation(0, 0);
                }
            }
            UIView *view = self.baseTableView.tableHeaderView;
            view.viewHeight -= 20;
            self.baseTableView.tableHeaderView = view;
        }
    } else {
        [MITipView showContentOperateTipInView:self.view tipKey:@"MIMyMizheViewController" imgKey:@"img_tips_slide2update" type:MI_TIP_AUTO_DISMISS];
        
//        _userWall.image = [UIImage imageNamed:@"user_info_bg"];
        _loginLabel.hidden = YES;
        _loginBtnLabel.hidden = YES;
        _userHead.hidden = NO;
        _levelImageView.hidden = NO;
        _usernameLabel.hidden = NO;
        _accountLabel.hidden = NO;
        _vipCenterIndicator.hidden = NO;
        if ([[MIHeartbeat shareHeartbeat] hasNewMessage]) {
             [self.navigationBar setBarLeftButtonItem:self selector:@selector(goMsgCenter) imageKey:@"mi_navbar_tool_message_have"];
        } else {
             [self.navigationBar setBarLeftButtonItem:self selector:@selector(goMsgCenter) imageKey:@"mi_navbar_tool_message_img"];
        }
        
        MIMainUser *mainUser = [MIMainUser getInstance];
        if (mainUser.userId != nil && mainUser.userId.integerValue > 0) {
            if (mainUser.headURL && (mainUser.headURL.length != 0))
            {
                NSString *headUrl = [NSString stringWithFormat:@"%@!100x100.jpg", [MIMainUser getInstance].headURL];
                [self.userHead sd_setImageWithURL:[NSURL URLWithString: headUrl] placeholderImage:[UIImage imageNamed:@"ic_my_avatar"]];
            }
            CGFloat remainSum = (mainUser.incomeSum.doubleValue - mainUser.expensesSum.doubleValue) / 100.0;
            _accountLabel.text = [NSString stringWithFormat:@"余额：%0.2f元   米币：%d个", remainSum, [mainUser.coin intValue]];
            NSString *userName = ((mainUser.nickName == nil) || (mainUser.nickName.length == 0)) ? mainUser.loginAccount : mainUser.nickName;
            NSRange range = [userName rangeOfString:@"@"];
            if (range.location != NSNotFound) {
                userName = [userName substringToIndex:range.location];
            }
            _usernameLabel.text = userName;
            CGSize size = [_usernameLabel.text sizeWithFont:_usernameLabel.font constrainedToSize:_usernameLabel.frame.size lineBreakMode:NSLineBreakByCharWrapping];
            _levelImageView.left = _usernameLabel.left + size.width + 5;
            _levelImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"ic_avatar_v%ld", (long)mainUser.grade.integerValue]];
        } else {
            [self reloadTableViewDataSource];
        }
        
        if ((mainUser.loginAccount == nil) || (mainUser.loginAccount.length == 0) || ([mainUser.loginAccount hasSuffix:@"@open.mizhe"])
            || (mainUser.alipay == nil) || (mainUser.alipay.length == 0)
            || (mainUser.phoneNum == nil) || (mainUser.phoneNum.length == 0))
        {
            if (![MIConfig globalConfig].isHiddenReminderView)
            {
                self.reminderLabel.viewHeight = 20;
                for (UIView *view in self.baseTableView.tableHeaderView.subviews)
                {
                    if (![view isEqual:self.reminderLabel])
                    {
                        view.transform = CGAffineTransformMakeTranslation(0, 20);
                    }
                }
                UIView *view = self.baseTableView.tableHeaderView;
                
                view.viewHeight = _headerViewHeight + 20;
                self.baseTableView.tableHeaderView = view;
                [self.baseTableView reloadData];
            }
        } else {
            if (self.reminderLabel.viewHeight != 0) {
                [MIConfig globalConfig].isHiddenReminderView = YES;
                self.reminderLabel.viewHeight = 0;
                for (UIView *view in self.baseTableView.tableHeaderView.subviews)
                {
                    if (![view isEqual:self.reminderLabel])
                    {
                        view.transform = CGAffineTransformMakeTranslation(0, 0);
                    }
                }
                UIView *view = self.baseTableView.tableHeaderView;
                view.viewHeight -= 20;
                self.baseTableView.tableHeaderView = view;
            }
        }
    }
    
    [_baseTableView reloadData];
}

- (void)userWallAction
{
    if (![[MIMainUser getInstance] checkLoginInfo]) {
        //尚未登录，引导用户先登录
        [self goLogin];
    } else {
        [MobClick event:kVipCenterClicks];
        
        MIVIPCenterViewController *vipCenterView = [[MIVIPCenterViewController alloc] init];
        [[MINavigator navigator] openPushViewController:vipCenterView animated:YES];
    }
}

- (void)goMsgCenter
{
    if (![[MIMainUser getInstance] checkLoginInfo]) {
        //尚未登录，引导用户先登录
        [self goLogin];
    } else {
        [MobClick event:kMsgCenterClicks];
        
        if ([MIHeartbeat shareHeartbeat].heartBeatNewsMessage.msgs.integerValue > 0) {
            MIPushBadgeClearRequest * request = [[MIPushBadgeClearRequest alloc] init];
            request.onCompletion = ^(id result) {
                if ([MIUtility isNotificationTypeBadgeEnable]) {
                    NSInteger applicationIconBadgeNumber = [UIApplication sharedApplication].applicationIconBadgeNumber - [MIHeartbeat shareHeartbeat].heartBeatNewsMessage.msgs.integerValue;
                    [UIApplication sharedApplication].applicationIconBadgeNumber = applicationIconBadgeNumber;
                }
                [MIHeartbeat shareHeartbeat].heartBeatNewsMessage.msgs = [NSNumber numberWithInteger:0];
            };
            
            [request setComments];
            [request sendQuery];
        }
        
        MIMsgCenterViewController* vc = [[MIMsgCenterViewController alloc] init];
        [[MINavigator navigator] openPushViewController:vc animated:YES];
    }
}

- (void)goSetting
{
    [MINavigator openSettingViewController];
}

- (void)goLogin
{
    [super finishLoadTableViewData];
    [MINavigator openLoginViewController];
    [MIConfig globalConfig].isHiddenReminderView = NO;
}

- (void)modifyHeadImage
{
    MIUpYun *upYun = [MIUpYun getInstance];
    [upYun modifyHeadImage];
}

- (void)goToReminderView
{
    [MIConfig globalConfig].isHiddenReminderView = YES;
    self.reminderLabel.viewHeight = 0;
    for (UIView *view in self.baseTableView.tableHeaderView.subviews)
    {
        if (![view isEqual:self.reminderLabel])
        {
            view.transform = CGAffineTransformMakeTranslation(0, 0);
        }
    }
    
    UIView *view = self.baseTableView.tableHeaderView;
    view.viewHeight -= 20;
    self.baseTableView.tableHeaderView = view;
    [self.baseTableView reloadData];
    
    //进入安全检测页面
    MISecurityAccountViewController *securityView = [[MISecurityAccountViewController alloc] init];
    [[MINavigator navigator] openPushViewController:securityView animated:YES];
}
#pragma mark - EGOPull CALL METHODS

- (void)reloadTableViewDataSource
{
    if ([[MIMainUser getInstance] checkLoginInfo]) {
        [_request cancelRequest];
        [_request sendQuery];
        self.loading = YES;
    } else {
        __weak typeof(self) weakSelf = self;
        MIButtonItem *cancelItem = [MIButtonItem itemWithLabel:@"取消"];
        cancelItem.action = ^{
            [weakSelf failLoadTableViewData];
        };
        MIButtonItem *affirmItem = [MIButtonItem itemWithLabel:@"登录"];
        affirmItem.action = ^{
            [weakSelf goLogin];
        };
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"亲，您还没有登录哦~" cancelButtonItem:cancelItem otherButtonItems:affirmItem, nil];
        [alertView show];
    }
}

- (void)finishLoadTableViewData:(id)data
{
    if (self.loading) {
        self.loading = NO;
        [super finishLoadTableViewData];
    }
    
    [[MIMainUser getInstance] saveUserInfo:data];
    [self updateUserWallInfo];
}

- (void)failLoadTableViewData
{
    [super failLoadTableViewData];
    
    if (self.loading) {
        self.loading = NO;
    }
    [self updateUserWallInfo];
}

#pragma mark - TableView datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 2)
    {
        return 3;
    }
    return 2;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return HEIGHT_FOR_ROW;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DDBadgeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MIAccountTableViewCell"];
    if (!cell) {
        cell = [[DDBadgeViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"MIAccountTableViewCell"];
        cell.backgroundColor = [UIColor whiteColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.badgeText = nil;
    cell.badgeColor = [UIColor clearColor];
    cell.badgeHighlightedColor = [UIColor clearColor];
    NSInteger index = (indexPath.section << 1) + indexPath.row;
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    cell.detailTextLabel.backgroundColor = [UIColor clearColor];
    switch (index) {
        case 0:
        {
            cell.imageView.image = [UIImage imageNamed:@"orders"];
            cell.textLabel.text = @"我的订单";
            
            break;
        }
        case 1:
        {
            cell.imageView.image = [UIImage imageNamed:@"taobao_list"];
            cell.textLabel.text = @"淘宝返利";
            if ([MIHeartbeat shareHeartbeat].heartBeatNewsMessage.tbOrders.integerValue != 0) {
                cell.badgeText = [MIHeartbeat shareHeartbeat].heartBeatNewsMessage.tbOrders.stringValue;
                cell.badgeColor = [UIColor orangeColor];
                cell.badgeHighlightedColor = [UIColor whiteColor];
            }
            break;
        }
        case 2:
        {
            cell.imageView.image = [UIImage imageNamed:@"dollar"];
            cell.textLabel.text = @"我要提现";
            
            if ([MIHeartbeat shareHeartbeat].heartBeatNewsMessage.pays.integerValue != 0) {
                cell.badgeText = [MIHeartbeat shareHeartbeat].heartBeatNewsMessage.pays.stringValue;
                cell.badgeColor = [UIColor orangeColor];
                cell.badgeHighlightedColor = [UIColor whiteColor];
            }
            
            break;
        }
        case 3:
        {
            cell.imageView.image = [UIImage imageNamed:@"exchange"];
            cell.textLabel.text = @"兑换集分宝";
            break;
        }
        case 4:
        {
            cell.imageView.image = [UIImage imageNamed:@"ic_my_qiang"];
            cell.textLabel.text = @"开抢提醒";
            break;
        }
        case 5:
        {
            cell.imageView.image = [UIImage imageNamed:@"ic_my_sevicer"];
            cell.textLabel.text = @"联系客服";
            
            break;
        }
        case 6:
        {
            cell.imageView.image = [UIImage imageNamed:@"ic_my_help"];
            cell.textLabel.text = @"帮助中心";
//            cell.imageView.image = [UIImage imageNamed:@"ic_my_about"];
//            cell.textLabel.text = @"关于米折";
//            
//            MIAppDelegate* delegate = (MIAppDelegate*)[[UIApplication sharedApplication] delegate];
//            if (delegate.appNewVersion) {
//                cell.badgeText = @"NEW";
//                cell.badgeColor = [MIUtility colorWithHex:0xff4965];
//                cell.badgeHighlightedColor = [UIColor whiteColor];
//            }
            break;
        }
        default:
        {
            break;
        }
    }
    return cell;
}

#pragma mark - TableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (![[MIMainUser getInstance] checkLoginInfo]) {
        //尚未登录，提示用户先登录
        [self goLogin];
        return;
    }
    
    NSInteger index = (indexPath.section << 1) + indexPath.row;
    switch (index) {
        case 0:
        {
            NSURL *orderURL = [NSURL URLWithString:[MIConfig globalConfig].myTaobao];
            MIMyOrderViewController *myOrderViewController = [[MIMyOrderViewController alloc] initWithURL:orderURL];
            [[MINavigator navigator] openPushViewController:myOrderViewController animated:YES];
            break;
        }
        case 1:
        {
            if ([MIHeartbeat shareHeartbeat].heartBeatNewsMessage.tbOrders.integerValue > 0) {
                MIPushBadgeClearRequest * request = [[MIPushBadgeClearRequest alloc] init];
                request.onCompletion = ^(id result) {
                    if ([MIUtility isNotificationTypeBadgeEnable]) {
                        NSInteger applicationIconBadgeNumber = [UIApplication sharedApplication].applicationIconBadgeNumber - [MIHeartbeat shareHeartbeat].heartBeatNewsMessage.tbOrders.integerValue;
                        [UIApplication sharedApplication].applicationIconBadgeNumber = applicationIconBadgeNumber;
                    }
                    
                    [MIHeartbeat shareHeartbeat].heartBeatNewsMessage.tbOrders = [NSNumber numberWithInteger:0];
                };
                
                [request setTaoBaoOrders];
                [request sendQuery];
            }
            MITaobaoOrderViewController *tbOrderViewController = [[MITaobaoOrderViewController alloc] init];
            [[MINavigator navigator] openPushViewController:tbOrderViewController animated:YES];
            break;
        }
        case 2:
        {
            MIMainUser *mainUser = [MIMainUser getInstance];
            if ((mainUser.loginAccount == nil) || (mainUser.loginAccount.length == 0) || ([mainUser.loginAccount hasSuffix:@"@open.mizhe"])) {
                //用户邮箱为空或者是带有open.mizhe后缀的，说明是通过第三方账号登录，需要先设置邮箱及密码
                [MINavigator openBindEmailViewController];
            }
            else if ((mainUser.phoneNum == nil) || (mainUser.phoneNum.length == 0))
            {
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
            }
            else if ((mainUser.alipay == nil) || (mainUser.alipay.length == 0)) {
                //用户支付宝账号为空，需要先设置支付宝账号
                MIAlipaySettingViewController *vc = [[MIAlipaySettingViewController alloc] init];
                vc.barTitle = @"提现设置";
                [[MINavigator navigator] openPushViewController:vc animated:YES];
            }
            else {
                MIPayApplyViewController *vc = [[MIPayApplyViewController alloc] init];
                vc.alipayAccount = mainUser.alipay;
                [[MINavigator navigator] openPushViewController:vc animated:YES];
            }
            
            break;
        }
        case 3:
        {
            MIExchangeViewController *vc = [[MIExchangeViewController alloc] init];
            [[MINavigator navigator] openPushViewController:vc animated:YES];
            
            break;
        }
        case 4:
        {
            MIUserFavorViewController *controller = [[MIUserFavorViewController alloc] init];
            [[MINavigator navigator] openPushViewController:controller animated:YES];
            
            break;
        }
        case 5:
        {
            if (self.customerServiceVC == nil) {
                _customerServiceURL = [NSURL URLWithString:[MIConfig globalConfig].customerService];
                _customerServiceVC = [[MICustomerViewController alloc] initWithURL:_customerServiceURL];
                self.customerServiceVC.webTitle = @"联系客服";
            }
            [[MINavigator navigator] openPushViewController:self.customerServiceVC animated:YES];
            break;
        }
        case 6:
        {
            NSURL *helpURL = [NSURL URLWithString:[MIConfig globalConfig].helpCenter];
            [MINavigator openTbWebViewControllerWithURL:helpURL desc:@"帮助中心"];
           // [MINavigator openSettingViewController];
            break;
        }
        default:
            break;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (IOS_VERSION >= 7.0)
    {
        if (0 == section)
        {
            return 15.1;
        }
        else
        {
            return 0.1;
        }
    }
    else
    {
        return 10.1;
    }
}

@end
