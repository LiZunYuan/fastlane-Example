//
//  MISettingViewController.m
//  MISpring
//
//  Created by Yujian Xu on 13-3-18.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MISettingViewController.h"
#import "MIAuthBindViewController.h"
#import "MIAboutViewController.h"
#import "MIAppDelegate.h"
#import "MILogoutRequest.h"
#import "MIHeartbeat.h"
#import "UMFeedback.h"
#import "MIFeedbackViewController.h"
#import "MISecurityAccountViewController.h"
#import "MINetworkCache.h"
#import "MIFunctionViewController.h"

#define MISETTING_LOGIN_OR_LOGOUT_ITEM_BUTTON 1
#define MISETTING_UMENG_FEEDBACK_NEWREPLIES   @"UmengFeedBackNewsReplies"

@implementation MISettingViewController
@synthesize loginOutButton;
@synthesize beibeiAdView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.navigationBar setBarTitle:@"关于米折"];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showChannel)];
    tapGesture.numberOfTapsRequired = 2;
    [self.navigationBar addGestureRecognizer:tapGesture];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, PHONE_SCREEN_SIZE.width, 88)];
    headerView.backgroundColor = [UIColor whiteColor];
    UIImage *image = [UIImage imageNamed:@"website_logo"];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.viewWidth - 190)/2, 10, 190, 68)];
    imageView.image = image;
    [headerView addSubview: imageView];
    
    self.baseTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _baseTableView.frame = CGRectMake(0, self.navigationBarHeight, SCREEN_WIDTH, self.view.viewHeight - self.navigationBarHeight - 50);
    _baseTableView.backgroundColor = [UIColor clearColor];
    _baseTableView.backgroundView.alpha = 0;
    _baseTableView.dataSource = self;
    _baseTableView.delegate = self;
    [self.view sendSubviewToBack:_baseTableView];
    
    _baseTableView.tableHeaderView = headerView;

    if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"beibeiapp://"]]) {
        beibeiAdView = [[MIBeibeiAdView alloc] initWithFrame:CGRectMake(0, 0, PHONE_SCREEN_SIZE.width, 50)];
        self.baseTableView.tableFooterView = beibeiAdView;
    }
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 50, SCREEN_WIDTH, 50)];
    bottomView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.7];
    bottomView.layer.shadowOffset = CGSizeMake(0, -1);
    bottomView.layer.shadowColor = [UIColor grayColor].CGColor;
    bottomView.layer.shadowRadius = 0.5;
    bottomView.layer.shadowOpacity = 0.5;
    [self.view addSubview:bottomView];
    
    loginOutButton = [[MICommonButton alloc] initWithFrame:CGRectMake(0, 0, 300.0, 36)];
    loginOutButton.center = CGPointMake(SCREEN_WIDTH/2.0, 25);
    [loginOutButton addTarget:self action:@selector(logoutButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:loginOutButton];
    
    [UMFeedback checkWithAppkey:kUmengAppKey];
}
-(void)showChannel
{
    [self showSimpleHUD:[MIConfig globalConfig].channelId];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self registerNotifications];
    if (beibeiAdView) {
        [beibeiAdView animationStart];
    }
    if ([MIMainUser getInstance].loginStatus == MILoginStatusNotLogined) {
        [loginOutButton turnOrange];
        [loginOutButton setTitle:@"登录米折" forState:UIControlStateNormal];
    } else {
        [loginOutButton turnRed];
        [loginOutButton setTitle:@"退出登录" forState:UIControlStateNormal];
    }

    [self.baseTableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self removeNotifications];
    if (beibeiAdView) {
        [beibeiAdView animationStop];
    }
}

-(void)loginSuccess
{
    [[MINavigator navigator] goMainScreenFromAnyByIndex:MAIN_SCREEN_INDEX_HOMEPAGE info:nil];
}

- (void)umFeedBackCheck:(NSNotification *)notification {
    if (notification.userInfo) {
        NSArray * newReplies = [notification.userInfo objectForKey:@"newReplies"];
        [[NSUserDefaults standardUserDefaults] setInteger:[newReplies count] forKey:MISETTING_UMENG_FEEDBACK_NEWREPLIES];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [_baseTableView reloadData];
    }
}

#pragma mark - Notification 处理
- (void)registerNotifications{
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];

    // 登录成功通知
    [defaultCenter addObserver:self
                      selector:@selector(loginSuccess)
                          name:MiNotifyUserHasLogined
                        object:nil];
    [defaultCenter addObserver:self selector:@selector(umFeedBackCheck:) name:UMFBCheckFinishedNotification object:nil];
}

- (void)removeNotifications{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Table view delegate
/**
 * The cell has to be deselected otherwise iOS will re-select the cell after re-using it and thus the text field in the last re-used cell will become first responder
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSInteger row = indexPath.row;
    if ([[MIConfig globalConfig] isReviewVersion]) {
        row = row + 1;
    }
    switch (row) {
        case 0:
        {
            if ([[Reachability reachabilityForInternetConnection] isReachable]) {
                MIAppDelegate* delegate = (MIAppDelegate*)[[UIApplication sharedApplication] delegate];
                delegate.bAppManualUpdate = YES;
                [MobClick checkUpdate];
            } else {
                [self showSimpleHUD:@"网络不给力"];
            }
            break;
        }
        case 1:
        {
            if ([[MIMainUser getInstance] checkLoginInfo]) {
                MISecurityAccountViewController *vc = [[MISecurityAccountViewController alloc] init];
                [[MINavigator navigator] openPushViewController:vc animated:YES];
            } else {
                __weak typeof(self) weakSelf = self;
                MIButtonItem *cancelItem = [MIButtonItem itemWithLabel:@"取消"];
                cancelItem.action = ^{
                    [weakSelf failLoadTableViewData];
                };
                MIButtonItem *affirmItem = [MIButtonItem itemWithLabel:@"登录"];
                affirmItem.action = ^{
                    [MINavigator openLoginViewController];
                };
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"亲，您还没有登录哦~" cancelButtonItem:cancelItem otherButtonItems:affirmItem, nil];
                [alertView show];
            }

            break;
        }
        case 2:
        {
            //清理所有cookies及缓存
            NSHTTPCookieStorage* cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
            NSArray* allCookies = [cookies cookies];
            for (NSHTTPCookie* cookie in allCookies) {
                [cookies deleteCookie:cookie];
            }
            
            [[NSURLCache sharedURLCache] removeAllCachedResponses];
            [[SDImageCache sharedImageCache] clearDisk];
            [[MINetworkCache sharedNetworkCache] clearDisk];
            //                DDBadgeViewCell *badgeCell = (DDBadgeViewCell *)[tableView cellForRowAtIndexPath:indexPath];
            //                badgeCell.detailTextLabel.text = @"0 M";
            [self showSimpleHUD:@"清除缓存成功"];
            break;
        }
        case 3:
        {
            MIFeedbackViewController *vc = [[MIFeedbackViewController alloc] init];
            [[MINavigator navigator] openPushViewController:vc animated:YES];
            break;
        }
        case 4:
        {
            //投诉建议
            MIFunctionViewController *vc = [[MIFunctionViewController alloc] init];
            [[MINavigator navigator] openPushViewController:vc animated:YES];
            break;
        }
        case 5:
        {
            MITbWebViewController* vc = [[MITbWebViewController alloc] initWithURL:[NSURL URLWithString:[MIConfig globalConfig].specialNoticeURL]];
            vc.webTitle = @"特别声明";
            [[MINavigator navigator] openPushViewController:vc animated:YES];
        
            break;
        }
        case 6:
        {
            MITbWebViewController* vc = [[MITbWebViewController alloc] initWithURL:[NSURL URLWithString:[MIConfig globalConfig].agreementURL]];
            vc.webTitle = @"用户使用协议";
            [[MINavigator navigator] openPushViewController:vc animated:YES];
            break;
        }
        case 7:
        {
            NSString *fanliCourse = @"http://h5.mizhe.com/help/course.html";
            MITbWebViewController* vc = [[MITbWebViewController alloc] initWithURL:[NSURL URLWithString:fanliCourse]];
            vc.webTitle = @"淘宝返利教程";
            [[MINavigator navigator] openPushViewController:vc animated:YES];
            break;
        }
        case 8:
        {
            //去APP Store评分
            if (IOS_VERSION >= 7) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[MIConfig globalConfig].appStoreURL]];
            } else {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[MIConfig globalConfig].appStoreReviewURL]];
            }
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:[NSString stringWithFormat:@"shouldShowGradeAlertView%@",
                                                                      [MIConfig globalConfig].version]];
            [[NSUserDefaults standardUserDefaults] synchronize];
            break;
        }
        default:
            break;
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([[MIConfig globalConfig] isReviewVersion]) {
        return 8;
    }
    return 9;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    DDBadgeViewCell *badgeCell = (DDBadgeViewCell *)cell;
    if (indexPath.row == 3) {
        NSInteger count = [[NSUserDefaults standardUserDefaults] integerForKey:MISETTING_UMENG_FEEDBACK_NEWREPLIES];
        if (count > 0) {
            badgeCell.badgeText = [NSString stringWithFormat:@"%ld", (long)count];
            badgeCell.badgeColor = [UIColor orangeColor];
            badgeCell.badgeHighlightedColor = [UIColor whiteColor];
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DDBadgeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableViewCellReuseIdentifier"];
    if (!cell)
    {
        cell = [[DDBadgeViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"TableViewCellReuseIdentifier"];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    }
    NSInteger row = indexPath.row;
    if ([[MIConfig globalConfig]  isReviewVersion]) {
        row = row + 1;
    }
    
    switch (row) {
        case 0:
        {
            MIAppDelegate* delegate = (MIAppDelegate*)[[UIApplication sharedApplication] delegate];
            if (delegate.appNewVersion) {
                cell.textLabel.text = @"发现新版";
                cell.detailTextLabel.text = [[NSString alloc] initWithFormat:@"v%@", delegate.appNewVersion];
                cell.detailTextLabel.textColor = [MIUtility colorWithHex:0xff4965];
            } else {
                cell.textLabel.text = @"当前版本";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"v%@", [MIConfig globalConfig].version];
                cell.detailTextLabel.textColor = [MIUtility colorWithHex:0x505050];
            }
            break;
        }
        case 1:
            cell.textLabel.text = @"安全检测";
            break;
        case 2:
            cell.textLabel.text = @"清除缓存";
            break;
        case 3:
            cell.textLabel.text = @"意见反馈";
            break;
        case 4:
            cell.textLabel.text = @"功能介绍";
            break;
        case 5:
            cell.textLabel.text = @"特别声明";
            break;
        case 6:
            cell.textLabel.text = @"用户使用协议";
            break;
        case 7:
            cell.textLabel.text = @"淘宝返利教程";
            break;
        case 8:
            cell.textLabel.text = @"喜欢米折，打分鼓励一下";
            break;
        default:
            break;
    }
    cell.badgeColor = [UIColor clearColor];
    cell.badgeHighlightedColor = [UIColor clearColor];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

#pragma mark - Submit button

- (void)logoutButtonTouched:(UIButton *)button
{
    if ([MIMainUser getInstance].loginStatus == MILoginStatusNotLogined) {
        [MINavigator openLoginViewController];
    } else {
        MIActionSheet *actionSheet = [[MIActionSheet alloc] initWithTitle:@"确定要退出登录吗？"];
        [actionSheet addButtonWithTitle:@"确认退出" withBlock:^(NSInteger index) {
            MILogoutRequest * request = [[MILogoutRequest alloc] init];
            [request sendQuery];
            [[MIMainUser getInstance] logout];
            [MIAppDelegate logout];
            [[MIHeartbeat shareHeartbeat] stopActivate];  //停止更新冒泡的心跳
            [[NSUserDefaults standardUserDefaults] setObject:@[] forKey:kItemFavorListDefaults];
            [[NSUserDefaults standardUserDefaults] setObject:@[] forKey:kBrandFavorListDefaults];
            [[NSUserDefaults standardUserDefaults] setObject:@(INT_MAX) forKey:kBrandFavorBeginTimeDefaults];
            [[NSUserDefaults standardUserDefaults] setObject:@(INT_MAX) forKey:kItemFavorBeginTimeDefaults];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [MIUtility delLocalNotificationByType:APP_LOCAL_NOTIFY_ACTION_MARTSHOW_START_ALARM];
            [MIUtility delLocalNotificationByType:APP_LOCAL_NOTIFY_ACTION_PRODUCT_START_ALARM];
            [loginOutButton setTitle:@"登录米折" forState:UIControlStateNormal];
            [loginOutButton turnOrange];
        }];

        [actionSheet addButtonWithTitle:NSLocalizedString(@"取消", @"取消") withBlock:^(NSInteger index) {
        }];
        actionSheet.destructiveButtonIndex = actionSheet.numberOfButtons - 2;
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
		
        [actionSheet showInView:self.view];
    }
}

@end
