//
//  MIMainScreenViewController.m
//  MISpring
//
//  Created by Yujian Xu on 13-3-12.
//  Copyright (c) 2013年 Husor Inc.. All rights reserved.
//

#import "MIMainScreenViewController.h"
#import "MIMainViewController.h"
#import "MIMyMizheViewController.h"
#import "MIPushBadgeGetModel.h"
#import "MIHeartbeat.h"
#import "MITenTuanViewController.h"
#import "MITuanViewController.h"
#import "MIBrandTeMaiViewController.h"
//#import "MIBeiBeiTeMaiViewController.h"

@implementation MIMainScreenViewController

@synthesize tabBar = _tabBar;
@synthesize currentViewControllerIndex = _currentViewControllerIndex;

- (id)initWithIndex:(MainScreenIndex)index
{
    self = [self init];
    if (self != nil) {
        
        MIMainViewController* homeViewController = [[MIMainViewController alloc] init];
        [self addChildViewController:homeViewController];
        
//        MIBeiBeiTeMaiViewController *beiBeiVC = [[MIBeiBeiTeMaiViewController alloc] init];
//        beiBeiVC.subject = @"";
//        beiBeiVC.navigationBarTitle = @"贝贝特卖";
//        [self addChildViewController:beiBeiVC];

        MIBrandTeMaiViewController* brandViewController = [[MIBrandTeMaiViewController alloc] init];
        [self addChildViewController:brandViewController];
        
        MITuanViewController *tenTuanVC = [[MITuanViewController alloc] init];
        tenTuanVC.subject = @"10yuan";
        [self addChildViewController:tenTuanVC];
        
        MITuanViewController *superior = [[MITuanViewController alloc]init];
        superior.subject = @"youpin";
        [self addChildViewController:superior];
        
        MIMyMizheViewController* myMiZheViewController = [[MIMyMizheViewController alloc] init];
        [self addChildViewController:myMiZheViewController];
        
        self.currentViewControllerIndex = index;
        _currentViewController = [self.childViewControllers objectAtIndex:index];
    }
    
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    for (UIViewController *viewController in self.childViewControllers) {
        viewController.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.view.viewHeight - TABBAR_HEIGHT);
    }
    [self.view addSubview:_currentViewController.view];
    self.tabBar = [[MIMainScreenTabBar alloc] initWithFrame:CGRectMake(0, self.view.viewHeight, 0, 0)];
    self.tabBar.barDelegate = self;
    self.tabBar.currentTabIndex = _currentViewControllerIndex;
    self.tabBar.frame = CGRectMake(0, self.view.viewHeight - TABBAR_HEIGHT, self.tabBar.selfSize.width, self.tabBar.selfSize.height);
    [self.view addSubview:self.tabBar];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self registerNotifications];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    //更新消息提醒
    [self.tabBar showBadge:[[MIHeartbeat shareHeartbeat] hasNewOrderMessage]];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self removeNotifications];
}

- (void)updateTabbarPushNewMessageCount:(NSNotification*)notification
{
    [self.tabBar showBadge:[[MIHeartbeat shareHeartbeat] hasNewOrderMessage]];
}

#pragma mark - Notification 处理
// 注册和注销消息
- (void)registerNotifications{
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    
    //push newmessage数量更新通知
    [defaultCenter addObserver:self
                      selector:@selector(updateTabbarPushNewMessageCount:)
                          name:MiNotificationNewsMessageDidUpdate
                        object:nil];
}

- (void)relayoutView
{
    [super relayoutView];
    
    CGFloat offset = HOTSPOT_STATUSBAR_HEIGHT;
    if (IS_HOTSPOT_ON) {
        offset = -HOTSPOT_STATUSBAR_HEIGHT;
    }
    
    self.tabBar.frame = CGRectMake(0, self.view.viewHeight - TABBAR_HEIGHT + offset, self.tabBar.selfSize.width, self.tabBar.selfSize.height);
}

- (void)removeNotifications{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)showNotifyAndGradeView:(NSInteger)index
{
    BOOL remoteNotificationEnable;
    if (IOS_VERSION >= 8.0) {
        remoteNotificationEnable = [[UIApplication sharedApplication] currentUserNotificationSettings] != UIUserNotificationTypeNone;
    } else {
        remoteNotificationEnable = [[UIApplication sharedApplication] enabledRemoteNotificationTypes] != UIRemoteNotificationTypeNone;
    }
    
    if ((index == MAIN_SCREEN_INDEX_USER)
        && [MIMainUser getInstance].incomeSum.doubleValue != 0
        && (remoteNotificationEnable != YES)
        && ![[NSUserDefaults standardUserDefaults] boolForKey:kShowNotifySettingAlertView]) {
        MIButtonItem *cancelItem = [MIButtonItem itemWithLabel:@"下次再说"];
        cancelItem.action = ^{
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kShowNotifySettingAlertView];
        };
        MIButtonItem *affirmItem = [MIButtonItem itemWithLabel:@"确定"];
        affirmItem.action = ^{
            NSURL*url=[NSURL URLWithString:@"prefs:root=NOTIFICATIONS_ID"];
            [[UIApplication sharedApplication] openURL:url];
        };
        
        NSString *message;
        if (IOS_VERSION >= 7.0) {
            message = @"您现在无法收到返利、提现到账等消息通知，请到系统“设置”-“通知中心”-“米折”中开启";
        } else {
            message = @"您现在无法收到返利、提现到账等消息通知，请到系统“设置”-“通知”-“米折”中开启";
        }
        UIAlertView *notifySettingAlertView = [[UIAlertView alloc] initWithTitle:@"米姑娘提醒" message:message cancelButtonItem:cancelItem otherButtonItems:affirmItem, nil];
        [notifySettingAlertView show];
    } else {
        // 弹出去APP Store评分提示框
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        BOOL bShouldShowGradeAlertView = [userDefaults boolForKey:[NSString
                                                                   stringWithFormat:@"shouldShowGradeAlertView%@",
                                                                   [MIConfig globalConfig].version]];
        if (bShouldShowGradeAlertView) {
            NSInteger count = [userDefaults integerForKey:kShowGradeAlertViewCount];
            if (count < MIAPP_GRADE_ALERT_MAXCOUNT) {
                NSDate *firstRunTime = [userDefaults objectForKey:[NSString stringWithFormat:@"firstRunTime%@",
                                                                   [MIConfig globalConfig].version]];
                NSInteger installIntervalDays = [firstRunTime compareWithToday];
                
                NSDate *lastShowTime = [userDefaults objectForKey:[NSString stringWithFormat:@"lastShowTime%@",
                                                                   [MIConfig globalConfig].version]];
                NSInteger showIntervalDays = [lastShowTime compareWithToday];
                if (installIntervalDays <= -3 && showIntervalDays <= -7) {
                    BOOL bShowGradeAlertView = [[NSUserDefaults standardUserDefaults] boolForKey:kShowGradeAlertView];
                    if (bShowGradeAlertView) {
                        //应用安装时间超过3天后，如果发现用户有提现或者领取米币的动作即会弹出提示用户评价
                        UIAlertView *alertView = [[UIAlertView alloc] initWithGradeViewController:[MINavigator navigator].navigationController.topViewController];
                        [alertView show];
                        
                        [userDefaults setObject:[NSDate date]
                                         forKey:[NSString stringWithFormat:@"lastShowTime%@",
                                                 [MIConfig globalConfig].version]];
                        [userDefaults setBool:NO forKey:kShowGradeAlertView];
                        [userDefaults setInteger:++count forKey:kShowGradeAlertViewCount];
                        if (count == MIAPP_GRADE_ALERT_MAXCOUNT) {
                            //每个版本最多弹出3次提示，如果用户选择“喜欢”或者“不喜欢”则该版本不会再弹出评分
                            [userDefaults setBool:NO forKey:[NSString
                                                             stringWithFormat:@"shouldShowGradeAlertView%@",
                                                             [MIConfig globalConfig].version]];
                        }
                        
                        [userDefaults synchronize];
                    }
                }
            }
        }
    }
}

#pragma mark - mainScreenTabBar delegate
- (BOOL)mainScreenTabBar:(MIMainScreenTabBar *)tabBar didSelectIndex:(NSInteger)index animated:(BOOL)animated{
    
    if (index < 0 || index > MAIN_SCREEN_INDEX_USER || _transiting) {
        return NO;
    }
    
    _transiting = YES;
    MIBaseViewController *oldViewController = _currentViewController;
    MIBaseViewController *newViewController = [self.childViewControllers objectAtIndex:index];
    
    if ([newViewController isMemberOfClass:[MIMainViewController class]]) {
        MIMainViewController *vc = (MIMainViewController *)newViewController;
        vc.appearFromTab = YES;
    }
    
    //先让旧页面停止滚动
    [oldViewController.baseTableView setContentOffset:oldViewController.baseTableView.contentOffset animated:NO];
    
    [self transitionFromViewController:oldViewController toViewController:newViewController duration:0.02f options:UIViewAnimationOptionTransitionNone animations:^{
        
    } completion:^(BOOL finished) {
         _transiting = NO;
        _currentViewController = newViewController;
        self.currentViewControllerIndex = index;
        [self showNotifyAndGradeView:index];
        if (IOS_VERSION >= 7.0) {
            [self setNeedsStatusBarAppearanceUpdate];
        }
     }];
    
    [self.view bringSubviewToFront:self.tabBar];
    
    return YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    if (IOS_VERSION >= 7.0) {
        if (self.currentViewControllerIndex == MAIN_SCREEN_INDEX_HOMEPAGE)
        {
            return UIStatusBarStyleLightContent;
        }
        else
        {
            return UIStatusBarStyleDefault;
        }
    } else {
        return UIStatusBarStyleBlackOpaque;
    }
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation
{
    return UIStatusBarAnimationNone;
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

@end
