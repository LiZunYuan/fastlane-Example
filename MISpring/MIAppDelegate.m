//
//  MIAppDelegate.m
//  MISpring
//
//  Created by XU YUJIAN on 13-1-17.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIAppDelegate.h"
#import "MICheckServerViewController.h"

//#import "MIUncaughtExceptionHandler.h"
#import "MILoginGuideViewController.h"
#import "MIZhiDetailViewController.h"
#import "MIBrandTuanDetailViewController.h"
#import "MITuanDetailViewController.h"
#import "MIBrandViewController.h"
#import "MILaunchAdViewController.h"
#import "MINavigator.h"
//#import "TopAppConnector.h"
#import "MIHeartbeat.h"
#import "TencentOpenAPI/QQApi.h"
#import "TencentOpenAPI/TencentOAuth.h"
#import "MISinaWeibo.h"
#import "MITencentAuth.h"

#import "MITemaiCategoryRequest.h"
#import "MITemaiCategoryGetModel.h"
#import "MIAppActiveAddRequest.h"
#import "MIAppActiveAddModel.h"
#import "MIAppConfigRequest.h"
#import "MIAppConfigModel.h"
#import "MIConfigModel.h"
#import "MIPushTokenUpdateRequest.h"
#import "MIPushTokenUpdateModel.h"
#import "MIAdService.h"
#import "MIAdsModel.h"
#import "MIMainViewController.h"
#import "MIUserFavorViewController.h"
#import "MIConfig.h"


#define XG_Token               @"xg_token"
#define XG_Register            @"XG_Register"

@implementation MIAppDelegate
@synthesize appNewVersion = _appNewVersion;
@synthesize bAppManualUpdate = _bAppManualUpdate;
@synthesize bShowLaunchAd = _bShowLaunchAd;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    MILog(@"launchOptions=%@", launchOptions);
//    [MIUncaughtExceptionHandler InstallUncaughtExceptionHandler];
//    NSString *path = [NSString stringWithFormat:@"%@/%@",[MIMainUser documentPath], kCrashLogPath];
//    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
//        NSString *crashLog = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
//        if (crashLog != nil) {
//            MILog(@"crashLog:%@",crashLog);
//        }
//    }

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window makeKeyAndVisible];

    self.bAppOpenFromBackground = NO;
    
    _catsEngine = [[MKNetworkEngine alloc] initWithHostName: @"m.mizhe.com" customHeaderFields:nil];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    //    判断应用上一次是否是正常退出，正常退出时清除正常退出时保存的数据，非正常退出则清空所有缓存数据
    if ([userDefaults objectForKey:@"terminateNomal"]) {
        [userDefaults removeObjectForKey:@"terminateNomal"];
        [userDefaults synchronize];
    }
    else{
        [_catsEngine emptyCache];
        [[MIAdService sharedManager] clearCache];
    }
    
    [WXApi registerApp:kWeixinAppKey];
    [MITencentAuth getInstance];
    
    //先注释掉友盟统计组件的应用，以免被截住应用程序崩溃信息
    [MobClick setCrashReportEnabled:YES];
    [MobClick setLogEnabled:NO];
    [MobClick startWithAppkey:kUmengAppKey reportPolicy:SEND_ON_EXIT channelId:[MIConfig globalConfig].channelId];
    
    //初始化信鸽Push信息
    [XGPush startApp:2200041293 appKey:@"I6336WL2JGZE"];
	[XGPush handleLaunching: launchOptions];
    
    //友盟渠道监控统计
//    NSString * umtrackAppKey = @"5538bd8b77eebb1a68c1c13d458f80dc";
//    NSString * deviceName = [[[UIDevice currentDevice] name] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSString * mac = [MIUtility getMacAddress];
//    NSString * idfa = [MIUtility getIdfaString];
//    NSString * idfv = [MIUtility getIdfvString];
//    NSString * urlString = [NSString stringWithFormat:@"http://log.umtrack.com/ping/%@/?devicename=%@&mac=%@&idfa=%@&idfv=%@", umtrackAppKey,deviceName,mac,idfa,idfv];
//    [NSURLConnection connectionWithRequest:[NSURLRequest requestWithURL: [NSURL URLWithString:urlString]] delegate:nil];
//    MILog(@"udid=%@", [MIOpenUDID value]);
    
    
    [self adsUpdate];
    
    // Override point for customization after application launch.
    NSString *lastVersion = [userDefaults objectForKey:@"version"];
//    if (lastVersion == nil) {
//        // 判断是否是第一次安装
//        [userDefaults setBool:YES forKey:kFirstActiveApp];
//    }
    
    if (lastVersion == nil) {
        [XGPush setTag:@"激活未注册"];
        [XGPush setTag:@"激活未抢购"];
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"激活时间yy年MM月"];
        NSString *time = [[NSString alloc] initWithFormat:@"%@", [dateFormatter stringFromDate:[NSDate date]]];
        [XGPush setTag:time];
        
        [userDefaults  setInteger:[[NSDate date] timeIntervalSince1970] forKey:kActiveTime];
        [userDefaults synchronize];
    } else {
        if ([MIMainUser getInstance].loginStatus == MILoginStatusNormalLogin) {
            [XGPush delTag:@"激活未注册"];
        }
    }
    
    NSString *firstRunVersion = [MIConfig globalConfig].firstRunTag;
    BOOL isFirstRunVersion;
    if (IOS_VERSION < 8.0) {
        isFirstRunVersion = [userDefaults boolForKey:firstRunVersion];
    } else {
        //存在上次安装的版本号，而且低于当前的版本号，即认为是第一次安装目前版本
        isFirstRunVersion = lastVersion && ([lastVersion compare:[MIConfig globalConfig].version] != NSOrderedAscending);
    }
    
    NSString *adsDataPath = [[MIMainUser documentPath] stringByAppendingPathComponent:@"app.config.data"];
    if (!isFirstRunVersion || ![[NSFileManager defaultManager] fileExistsAtPath:adsDataPath]) {
        // 判断是否是安装后的第一次运行
        [[SDImageCache sharedImageCache] clearDisk];
        [self appDefaultSetting];

        NSString *version = [MIConfig globalConfig].version;
        [userDefaults setObject:version forKey:@"version"];
        [userDefaults setObject:lastVersion forKey:@"lastVersion"];  // 记录上一版本号，做功能切换说明提示
        [userDefaults setBool:YES forKey:firstRunVersion];
        [userDefaults setBool:NO forKey:kShowNotifySettingAlertView];
        [userDefaults setInteger:0 forKey:kShowGradeAlertViewCount];
        [userDefaults setBool:YES forKey:[NSString stringWithFormat:@"shouldShowGradeAlertView%@", version]];
        [userDefaults setObject:[NSDate dateWithTimeIntervalSinceNow:MIAPP_ONE_MIN_INTERVAL] forKey:kLastUpdateHomeAdsTime];
        [userDefaults setObject:[NSDate dateWithTimeIntervalSinceNow:MIAPP_ONE_DAY_INTERVAL] forKey:kLastAppUpdateAlertView];
        [userDefaults setObject:[NSDate dateWithTimeIntervalSinceNow:MIAPP_ONE_DAY_INTERVAL] forKey:kLastUpdateCatsTime];
        [userDefaults setObject:[NSDate dateWithTimeIntervalSinceNow:MIAPP_ONE_WEEK_INTERVAL] forKey:[NSString stringWithFormat:@"lastShowTime%@", version]];
        [userDefaults setObject:[NSDate date] forKey:[NSString stringWithFormat:@"firstRunTime%@", version]];

        //保存系统默认的UA，添加米折app标识
        UIWebView *webView = [[UIWebView alloc] init];
        NSString *defaultUserAgent = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
        NSString *mizheUserAgent = [NSString stringWithFormat:@"%@ Mizhe/%@ (iPhone like mizhe_client)", defaultUserAgent, version];
        [userDefaults setObject:mizheUserAgent forKey:kDefaultUserAgent];
        
        [userDefaults setBool:NO forKey:version];
        [userDefaults setInteger:0 forKey:[NSString stringWithFormat:@"v%@",version]];
        
        [userDefaults synchronize];
        
		if (lastVersion != nil && [lastVersion compare:@"3.5.2"] != NSOrderedAscending) {
			[MINavigator openMainViewController:MAIN_SCREEN_INDEX_HOMEPAGE];
		} else {
            //上一版本号小于3.5.2都会出现新手引导页
            [MINavigator openMainViewController:MAIN_SCREEN_INDEX_HOMEPAGE];
			[MINavigator openGuideViewController:NO];
		}
    } else {
        [MINavigator openMainViewController:MAIN_SCREEN_INDEX_HOMEPAGE];
    }
    
    //登录失效消息通知
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(logoutForceAlert:)
                                                 name:MiNotificationShowAlertLogin object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(localTimeChange:) name:NSSystemClockDidChangeNotification object:nil];
    
    
    
    //调用本地通知处理方法
    NSDictionary* payload = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (payload) {
        MILog(@"payload=%@", payload);
        [self application:application didReceiveRemoteNotification:payload];
    }
    
    
    
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"terminateNomal" forKey:@"terminateNomal"];
    [defaults synchronize];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    if (_bNotifyNewVersion) {
        [MIUtility setLocalNotificationWithType:APP_LOCAL_NOTIFY_ACTION_UPDATE alertBody:@"米姑娘又更新了，马上去AppStore升级，更多惊喜" at:[[NSDate date] timeIntervalSince1970] + [MIConfig globalConfig].timeOffset + 3];
        _bNotifyNewVersion = NO;
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    //启动本地通知
    self.bOpenFromURL = NO;
    [MIConfig globalConfig].bNotification = NO;
    if ([MIUtility isNotificationEnable])
    {
//        NSDate *remindTime = [NSDate dateWithTimeIntervalSinceNow:300];
        //获得系统日期
        NSDate* today = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSString *todayTenStr = [formatter stringFromDate:today];
        NSString *todayTenClock = [NSString stringWithFormat:@"%@ 10:10:00", todayTenStr];
        formatter.dateFormat  = @"yyyy-MM-dd HH:mm:ss";
        NSDate *todayTenDate = [formatter dateFromString:todayTenClock];
        
        NSDate *remindTime = [todayTenDate dateByAddingTimeInterval: -MIAPP_ONE_WEEK_INTERVAL*2];

        [MIUtility setLocalNotificationWithType:APP_LOCAL_NOTIFY_ACTION_ALARM
                    alertBody:[NSString stringWithFormat:@"米姑娘一直为你砍价省钱，最近上新%ld款商品，全场包邮限时特卖中，看看有没中意的",(long)[MIUtility getRandomNumber:900 to:1000]]
                                             at:([remindTime timeIntervalSince1970]+ [MIConfig globalConfig].timeOffset)];
    }
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    [[SDImageCache sharedImageCache] clearMemory];
    [[MINetworkCache sharedNetworkCache] clearMemory];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

- (BOOL)willShowSplashAds
{
    if (!self.bShowLaunchAd && [MIAdService sharedManager].hasSplashAds) {
        return YES;
    }
    
    return NO;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    MILog(@"application applicationDidBecomeActive");
    [MIUtility setApplicationIconBadgeNumber:0];
    
    // 删除挂载的本地闹钟
    [MIUtility delLocalNotificationByType:APP_LOCAL_NOTIFY_ACTION_ALARM];
    
    // 判断网络是否正常
    if([[Reachability reachabilityForInternetConnection] isReachable]){
//        BOOL fisrtActiveApp = [[NSUserDefaults standardUserDefaults] boolForKey:kFirstActiveApp];
//        if (fisrtActiveApp) {
//            // 首次激活应用请求
//            MIAppActiveAddRequest *appActiveRequest = [[MIAppActiveAddRequest alloc] init];
//            [appActiveRequest setMac:[MIUtility getMacAddress]];
//            [appActiveRequest setBd:[MIConfig globalConfig].channelId];
//            [appActiveRequest setIdfa:[MIUtility getIdfaString]];
//            
//            MILog(@"mac=%@", [MIUtility getMacAddress]);
//            appActiveRequest.onCompletion = ^(MIAppActiveAddModel *model) {
//                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kFirstActiveApp];
//            };
//            
//            appActiveRequest.onError = ^(MKNetworkOperation* completedOperation, MIError* error) {
//                MILog(@"error_msg=%@",error.description);
//            };
//            [appActiveRequest sendQuery];
//        }
        
        [self localTimeChange:nil];
        [self localDataUpdate];
        [[MISinaWeibo getInstance] applicationDidBecomeActive];
        if ([MIConfig globalConfig].updateType.integerValue == 0) {
            [MobClick checkUpdateWithDelegate:self selector:@selector(appUpdate:)];
        }else{
            // 使用自身的appUpdate
            [self checkAppUpdate];
        }
        
        [MIAppDelegate sendCheckServerRequest:^(NSInteger status) {
            if (status == 0 && [MINavigator navigator].lockOpenController == NO) {
                MICheckServerViewController *controller = [[MICheckServerViewController alloc] init];
                [[MINavigator navigator] openPushViewController:controller animated:YES];
                [MINavigator navigator].lockOpenController = YES;
            } else if([MINavigator navigator].lockOpenController)
            {
                [MINavigator navigator].lockOpenController = NO;
                [[MINavigator navigator] closePopViewControllerAnimated:NO];
            }
        }];

    }
    
    if (self.bAppOpenFromBackground) {
        [[NSNotificationCenter defaultCenter] postNotificationName:MIApplicationBecomeActive object:nil];
    } else {
        self.bAppOpenFromBackground = YES;
    }
}

- (void)checkAppUpdate
{
    if (![[Reachability reachabilityForInternetConnection] isReachableViaWiFi]) {
        return;  //仅WiFi环境下检查更新
    }
    
    // 检查app更新
    MKNetworkEngine * catsEngine = [[MKNetworkEngine alloc] initWithHostName: @"m.mizhe.com" customHeaderFields:nil];
    NSString *urlPath = @"resource/check_update-iphone.html";
    MKNetworkOperation* op = [catsEngine operationWithPath: urlPath params: nil httpMethod:@"GET" ssl:NO];
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        NSData* data = completedOperation.responseData;
        if (data.length == 0) {
            return;
        }
        
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        if (dict == nil || [dict objectForKey:@"update_info"] == nil) {
            return;
        }
        dict = (NSDictionary *)[dict objectForKey:@"update_info"];
        
        
        NSString *latestVersion = [dict objectForKey:@"version"];
        if ([[MIConfig globalConfig].version compare:latestVersion] == NSOrderedAscending) {
            [self showAppUpdateDialogWithDicts:dict version:latestVersion];
        }
        
    } errorHandler:^(MKNetworkOperation* completedOperation, NSError *error) {
        // do nothing
    }];
    
    [catsEngine enqueueOperation:op];
}

- (void)showAppUpdateDialogWithDicts:(NSDictionary *)appUpdateInfos version:(NSString *)version
{
    // 通过关键词搜索url
    NSString *title = [appUpdateInfos objectForKey:@"update_title"];
    NSString *updateLog = [appUpdateInfos objectForKey:@"update_log"];
    NSString *cancelDesc = [appUpdateInfos objectForKey:@"cancel_desc"];
    NSString *confirmDesc = [appUpdateInfos objectForKey:@"confirm_desc"];
    NSString *appUpdateUrl = [appUpdateInfos objectForKey:@"download_url"];
    
    MIButtonItem *cancelItem = [MIButtonItem itemWithLabel:cancelDesc];
    cancelItem.action = ^{
        _bNotifyNewVersion = YES;
    };
    
    MIButtonItem *affirmItem = [MIButtonItem itemWithLabel:confirmDesc];
    affirmItem.action = ^{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appUpdateUrl]];
    };
    
    NSDate *lastAppUpdateTime = [[NSUserDefaults standardUserDefaults] objectForKey:kLastAppUpdateAlertView];
    NSInteger interval = [lastAppUpdateTime timeIntervalSinceNow];
    if (interval > 0 || interval <= MIAPP_ONE_DAY_INTERVAL) {
        NSInteger alertCount = [[NSUserDefaults standardUserDefaults] integerForKey:version];
        if ([MIConfig globalConfig].updateTimes.integerValue > alertCount) {
            [[[UIAlertView alloc] initWithTitle:title
                                        message:updateLog
                               cancelButtonItem:cancelItem
                               otherButtonItems:affirmItem, nil] show];
        } else {
            MIButtonItem *otherItem = [MIButtonItem itemWithLabel:@"不再提示我"];
            otherItem.action = ^{
                _bNotifyNewVersion = YES;
                
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:_appNewVersion];
                [[NSUserDefaults standardUserDefaults] synchronize];
            };
            [[[UIAlertView alloc] initWithTitle:title
                                        message:updateLog
                               cancelButtonItem:cancelItem
                               otherButtonItems:affirmItem, otherItem, nil] show];
        }
        [[NSUserDefaults standardUserDefaults] setInteger:++alertCount forKey:version];
        [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:kLastAppUpdateAlertView];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}



- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //注册远程通知
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)pToken {
    //注册设备
    NSString * deviceTokenStr = [XGPush registerDevice:pToken];
    MILog(@"deviceTokenStr is %@",deviceTokenStr);
    
    //保存到服务器
    NSUserDefaults * standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSString *defaultToken = [standardUserDefaults objectForKey:XG_Token];
    BOOL xgRegister = [standardUserDefaults boolForKey:XG_Register];
    if (deviceTokenStr == nil || [deviceTokenStr isEqualToString:defaultToken]) {
        BOOL remoteNotificationEnable = [MIUtility isNotificationEnable];
        if (remoteNotificationEnable != YES && xgRegister) {
            [XGPush unRegisterDevice];
            [standardUserDefaults removeObjectForKey:XG_Token];
            [standardUserDefaults setBool:NO forKey:XG_Register];
            [self pushTokenUpdateWithToken:deviceTokenStr enable:NO];
        } else if (remoteNotificationEnable == YES && !xgRegister) {
            [XGPush initForReregister:^{
                [self pushTokenUpdateWithToken:deviceTokenStr enable:YES];
            }];
        }
    } else {
        [XGPush initForReregister:^{
            [self pushTokenUpdateWithToken:deviceTokenStr enable:YES];
        }];
    }
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    MILog(@"%@", error);
    NSUserDefaults * standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSString * deviceTokenStr = [standardUserDefaults objectForKey:XG_Token];
    if ([standardUserDefaults boolForKey:XG_Register] && deviceTokenStr) {
        [XGPush unRegisterDevice];
        [standardUserDefaults removeObjectForKey:XG_Token];
        [standardUserDefaults setBool:NO forKey:XG_Register];
        [self pushTokenUpdateWithToken:deviceTokenStr enable:NO];
    }
}

// 检查服务器
+ (void)sendCheckServerRequest:(CheckStatusBlock)block
{
    MKNetworkEngine *catsEngine = [[MKNetworkEngine alloc] initWithHostName: @"s0.husor.cn" customHeaderFields:nil];
    MKNetworkOperation* adsOp = [catsEngine operationWithPath:@"/mizhe_status.json" params: nil httpMethod:@"GET" ssl:NO];
    [adsOp addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        NSData* data = completedOperation.responseData;
        if (data.length > 0)
        {
            
            NSMutableDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSNumber *status = [dict objectForKey:@"status"];
            
            // 防止因为诡异的网络问题造成返回脏数据
            if (status != nil) {
                block(status.integerValue);
            } else {
                block(1);
            }
        }
        else
        {
            block(1);
        }
    } errorHandler:^(MKNetworkOperation* completedOperation, NSError *error) {
        block(1);
    }];
    
    [catsEngine enqueueOperation:adsOp];
}


- (void)pushTokenUpdateWithToken:(NSString *)token enable:(BOOL)enable
{
    MIPushTokenUpdateRequest * request = [[MIPushTokenUpdateRequest alloc] init];
    request.onCompletion = ^(MIPushTokenUpdateModel *result) {
        if (result.success.boolValue == YES) {
            MILog(@"result=%d",result.success.boolValue);
            NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
            [standardUserDefaults setObject:token forKey:XG_Token];
            [standardUserDefaults setBool:enable forKey:XG_Register];
            [standardUserDefaults synchronize];
        }
    };
    
    request.onError = ^(MKNetworkOperation* completedOperation, MIError* error) {
        MILog(@"error_msg=%@",error.description);
    };
    
    [request setPushSrc:@"xinge"];
    [request setToken:token];
    [request setEnable:enable];
    [request sendQuery];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    MILog(@"didReceiveLocalNotification");

    if ([MIMainUser getInstance].loginStatus != MILoginStatusNormalLogin)
    {
        return;
    }
    
    NSDictionary *userInfo = notification.userInfo;
    AppLocalNotifiActionType type = [[userInfo objectForKey:@"type"] intValue];
    NSString* alert = notification.alertBody;
    if (application.applicationState != UIApplicationStateActive) {
        [MIUtility setPushTag:@"打开推送%@次"];
        if (type == APP_LOCAL_NOTIFY_ACTION_MARTSHOW_START_ALARM) {
            MIUserFavorViewController *vc = [[MIUserFavorViewController alloc] init];
            vc.type = BrandType;
            [[MINavigator navigator] openPushViewController:vc animated:YES];
        } else if(type == APP_LOCAL_NOTIFY_ACTION_PRODUCT_START_ALARM){
            MIUserFavorViewController *vc = [[MIUserFavorViewController alloc] init];
            vc.type = ItemType;
            [[MINavigator navigator] openPushViewController:vc animated:YES];
        } else if (type == APP_LOCAL_NOTIFY_ACTION_UPDATE) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[MIConfig globalConfig].appStoreURL]];
        }else if (type == APP_LOCAL_NOTIFY_ACTION_CHECK_IN_ALARM){
            if ([[MIMainUser getInstance] checkLoginInfo]) {
                NSString *checkinPath = [MIUtility trustLoginWithUrl:[MIConfig globalConfig].checkinURL];
                [MobClick event:kNotifyCheckin];
                [MINavigator openTbWebViewControllerWithURL:[NSURL URLWithString:checkinPath] desc:@"每日签到"];
            }else{
                [MINavigator openLoginViewController];
            }
        }
    }
    else {
        MIButtonItem *cancelItem = [MIButtonItem itemWithLabel:@"取消"];
        MIButtonItem *affirmItem = [MIButtonItem itemWithLabel:@"好"];
        NSString * desc = nil;
        if (type == APP_LOCAL_NOTIFY_ACTION_MARTSHOW_START_ALARM) {
            cancelItem.label = @"取消";
            affirmItem.label = @"去看看";
            desc = @"你添加的开抢提醒的专场开抢啦，赶紧去看看~~";
            affirmItem.action = ^{
                [MobClick event:@"kNotifyEventClicks"];
                // 跳到收藏专场页面
                MIUserFavorViewController *vc = [[MIUserFavorViewController alloc] init];
                vc.type = BrandType;
                [[MINavigator navigator] openPushViewController:vc animated:YES];
                
            };
        }
        else if(type == APP_LOCAL_NOTIFY_ACTION_PRODUCT_START_ALARM)
        {
            cancelItem.label = @"取消";
            affirmItem.label = @"去看看";
            desc = @"你添加的开抢提醒的单品开抢啦，赶紧去看看~~";
            affirmItem.action = ^{
                [MobClick event:@"kNotifyEventClicks"];
                // 跳到收藏专场页面
                MIUserFavorViewController *vc = [[MIUserFavorViewController alloc] init];
                vc.type = ItemType;
                [[MINavigator navigator] openPushViewController:vc animated:YES];
            };
        }
        else if (type == APP_LOCAL_NOTIFY_ACTION_CHECK_IN_ALARM){
            cancelItem.label = @"取消";
            affirmItem.label = @"去签到";
            desc = alert;
            affirmItem.action = ^{
                //跳转到签到页面
                if ([[MIMainUser getInstance] checkLoginInfo]) {
                    NSString *checkinPath = [MIUtility trustLoginWithUrl:[MIConfig globalConfig].checkinURL];
                    [MobClick event:kNotifyCheckin];
                    [MINavigator openTbWebViewControllerWithURL:[NSURL URLWithString:checkinPath] desc:@"每日签到"];
                }else{
                    [MINavigator openLoginViewController];
                }
            };
        }
        
        // 弹框提示
        if (affirmItem.action) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:desc cancelButtonItem:cancelItem otherButtonItems:affirmItem, nil];
            [alertView show];
        }
    }
}

+(void)logout
{
    NSArray *localNotifications = @[@(APP_LOCAL_NOTIFY_ACTION_MARTSHOW_START_ALARM),
                                    @(APP_LOCAL_NOTIFY_ACTION_PRODUCT_START_ALARM),
                                    @(APP_LOCAL_NOTIFY_ACTION_CHECK_IN_ALARM)];
    for (NSNumber *type in localNotifications) {
        [MIUtility delLocalNotificationByType:type.integerValue];
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    MILog(@"application didReceiveRemoteNotification = %@", userInfo);

    [MIConfig globalConfig].bNotification = YES;
    [XGPush handleReceiveNotification:userInfo];
    
    AppRemoteNotifiActionType type = [[userInfo objectForKey:@"type"] intValue];
    NSString* alert = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
    NSString* desc = [userInfo objectForKey:@"desc"];
    NSString* target = [userInfo objectForKey:@"target"];
    NSString* data = [userInfo objectForKey:@"data"];
    NSString* source = [userInfo objectForKey:@"source"] ? [userInfo objectForKey:@"source"] : @"人工推送";
    if (application.applicationState != UIApplicationStateActive && target) {
        MILog(@"application applicationState != UIApplicationStateActive");
        [MobClick event:kNotifyClicks];
        [MIUtility setPushTag:@"打开推送%@次"];
        [MIConfig globalConfig].notificationSource = source;
        switch (type) {
            case APP_REMOTE_NOTIFY_ACTION_TAOBAO:
            {
                //直接通过打开淘宝浏览器查看内容
                [MINavigator openTbWebViewControllerWithURL:[NSURL URLWithString:target] desc:desc];
                break;
            }
            case APP_REMOTE_NOTIFY_ACTION_UPDATE:
            {
                //直接跳转到APP STORE更新应用程序
                NSString *version = [userInfo objectForKey:@"ver"];
                if (version && ![version isEqualToString:[MIConfig globalConfig].version]) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:target]];
                }
                break;
            }
            case APP_REMOTE_NOTIFY_ACTION_TABS:
            {
                [MINavigator openShortCutWithDictInfo:@{@"target": target}];
                break;
            }
            case APP_REMOTE_NOTIFY_ACTION_ZHI:
            {
                MIZhiDetailViewController *detailView = [[MIZhiDetailViewController alloc] initWithItem:nil];
                detailView.zid = target;
                [[MINavigator navigator] openPushViewController:detailView animated:YES];
                break;
            }
            case APP_REMOTE_NOTIFY_ACTION_CATEGORY:
            {
                if (data && data.length) {
                    [MINavigator openShortCutWithDictInfo:@{@"target": target, @"data": data}];
                }
                break;
            }
            case APP_REMOTE_NOTIFY_ACTION_BEIBEISHOP:
            {
                if (data && data.length) {
                    [MINavigator openShortCutWithDictInfo:@{@"target": target, @"data": data}];
                }
                break;
            }
            default:
                break;
        }
    } 

    if (application.applicationState == UIApplicationStateActive && target) {
        MILog(@"application applicationState == UIApplicationStateActive");

        MIButtonItem *cancelItem = [MIButtonItem itemWithLabel:@"取消"];
        MIButtonItem *affirmItem = [MIButtonItem itemWithLabel:@"好"];
        
        switch (type) {
            case APP_REMOTE_NOTIFY_ACTION_TAOBAO:
            {
                cancelItem.label = @"取消";
                affirmItem.label = @"去看看";
                affirmItem.action = ^{
                    [MobClick event:kNotifyClicks];

                    //直接通过打开淘宝浏览器查看内容
                    [MINavigator openTbWebViewControllerWithURL:[NSURL URLWithString:target] desc:desc];
                };

                break;
            }
            case APP_REMOTE_NOTIFY_ACTION_UPDATE:
            {
                NSString *version = [userInfo objectForKey:@"ver"];
                if (version && ![version isEqualToString:[MIConfig globalConfig].version]) {
                    cancelItem.label = @"残忍地拒绝";
                    affirmItem.label = @"快乐地升级";
                    affirmItem.action = ^{
                        [MobClick event:kNotifyClicks];

                        //直接跳转到APP STORE更新应用程序
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:target]];
                    };
                }
                break;
            }
            case APP_REMOTE_NOTIFY_ACTION_ZHI:
            {
                cancelItem.label = @"取消";
                affirmItem.label = @"去看看";
                affirmItem.action = ^{
                    [MobClick event:kNotifyClicks];

                    MIZhiDetailViewController *detailView = [[MIZhiDetailViewController alloc] initWithItem:nil];
                    detailView.zid = target;
                    [[MINavigator navigator] openPushViewController:detailView animated:YES];
                };
                break;
            }
            case APP_REMOTE_NOTIFY_ACTION_CATEGORY:
            {
                if (data && data.length) {
                    cancelItem.label = @"取消";
                    affirmItem.label = @"去看看";
                    affirmItem.action = ^{
                        [MobClick event:kNotifyClicks];
                        
                        [MINavigator openShortCutWithDictInfo:@{@"target": target, @"data": data}];
                    };
                }

                break;
            }
            case APP_REMOTE_NOTIFY_ACTION_BEIBEISHOP://3.5.0版本后开始支持
            {
                if (data && data.length) {
                    cancelItem.label = @"取消";
                    affirmItem.label = @"去看看";
                    affirmItem.action = ^{
                        [MobClick event:kNotifyClicks];
                        
                        [MINavigator openShortCutWithDictInfo:@{@"target": target, @"data": data}];
                    };
                }
                break;
            }
            default:
                break;
        }

        if (affirmItem.action) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:desc message:alert cancelButtonItem:cancelItem otherButtonItems:affirmItem, nil];
            [alertView show];
        }
    }

    if ((type == APP_REMOTE_NOTIFY_ACTION_MESSAGE) && [[MIMainUser getInstance] checkLoginInfo]) {
        //用户已经登录且属于推送用户消息的类型，更新用户的信息
        [[MIHeartbeat shareHeartbeat] pushNewMsgGet];
    }
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    NSString *urlScheme = url.absoluteString;
    if ([urlScheme hasPrefix:kQQAppKey]) {
        return [self handleOpenUrl:url];
    } else if ([urlScheme hasPrefix:@"sinaweibosso"]) {
        return [[MISinaWeibo getInstance] handleOpenURL:url];
    } else if ([urlScheme hasPrefix:kWeixinAppKey]){
        return [WXApi handleOpenURL:url delegate:self];
    } else if ([urlScheme hasPrefix:@"tencent"]){
        return [TencentOAuth HandleOpenURL:url];
    } else if ([urlScheme hasPrefix:@"mizheapp"]) {
        NSString *target = [MIUtility getParamValueFromUrl:urlScheme paramName:@"target"];
        if ([target isEqualToString:@"maintabs"]) {
            //跳转到主界面的相应的tab
            NSString *tab = [MIUtility getParamValueFromUrl:urlScheme paramName:@"tab"];
            [MINavigator openShortCutWithDictInfo:@{@"target": tab}];
        } else if ([target isEqualToString:@"taobao"]) {
            //直接通过打开淘宝浏览器查看内容
            NSString *taobaoUrl = [MIUtility getParamValueFromUrl:urlScheme paramName:@"taobaourl"];
            [MINavigator openTbWebViewControllerWithURL:[NSURL URLWithString:taobaoUrl] desc:@"米折"];
        } else if ([target isEqualToString:@"taobaoitem"]) {
            //进入淘宝商品详情页
            NSString *numiid = [MIUtility getParamValueFromUrl:urlScheme paramName:@"iid"];
            [MINavigator openTbViewControllerWithNumiid:numiid desc:@"商品详情"];
        } else if ([target isEqualToString:@"branddetail"]) {
            //跳转到品牌特卖专场页面
            NSString *aid = [MIUtility getParamValueFromUrl:urlScheme paramName:@"aid"];
            MIBrandViewController *vc = [[MIBrandViewController alloc] initWithAid:aid.integerValue];
            vc.numIid = [MIUtility getParamValueFromUrl:urlScheme paramName:@"iid"];
            [[MINavigator navigator] openPushViewController:vc animated:YES];
        } else if ([target isEqualToString:@"detail"]) {
            NSString *type = [MIUtility getParamValueFromUrl:urlScheme paramName:@"type"];;
            NSString *tid = [MIUtility getParamValueFromUrl:urlScheme paramName:@"tid"];
            NSString *iid = [MIUtility getParamValueFromUrl:urlScheme paramName:@"iid"];
            if (type.integerValue == 1 || type.integerValue == 2) {
                //跳转到团购特卖商品详情页面
                MITuanDetailViewController *vc = [[MITuanDetailViewController alloc] initWithItem:nil placeholderImage:nil];
                vc.iid = iid;
                [vc.detailGetRequest setType:type.integerValue];
                [vc.detailGetRequest setTid:tid.integerValue];
                [self performSelector:@selector(pushViewController:) withObject:vc afterDelay:0.2];
            } else if (type.integerValue == 3) {
                //跳转到品牌特卖商品详情页面
                MIBrandTuanDetailViewController *vc = [[MIBrandTuanDetailViewController alloc] initWithItem:nil placeholderImage:nil];
                vc.iid = iid;
                [vc.request setType:type.integerValue];
                [vc.request setTid:tid.integerValue];
                [self performSelector:@selector(pushViewController:) withObject:vc afterDelay:0.2];
            } else {
                MILog(@"undefined");
            }
        } else if ([target isEqualToString:@"zhi"]) {
            NSString *zid = [MIUtility getParamValueFromUrl:urlScheme paramName:@"desc"];
            MIZhiDetailViewController *detailView = [[MIZhiDetailViewController alloc] initWithItem:nil];
            detailView.zid = zid;
            [self performSelector:@selector(pushViewController:) withObject:detailView afterDelay:0.2];
        } else if ([target isEqualToString:@"webview"]) {
            NSString *url = [MIUtility getParamValueFromUrl:urlScheme paramName:@"url"];
            MITbWebViewController* webVC = [[MITbWebViewController alloc] initWithURL:[NSURL URLWithString:url]];
            webVC.webTitle = @"米折特卖";
            [self performSelector:@selector(pushViewController:) withObject:webVC afterDelay:0.2];
        } else {
            MILog(@"undefined");
        }
        
        return YES;
    } else {
        return YES;
    }
}

- (void)pushViewController:(UIViewController *)vc
{
    if (self.bOpenFromURL) {
        return;
    }
    
    self.bOpenFromURL = YES;
    [[MINavigator navigator] openPushViewController:vc animated:YES];
}

- (BOOL)handleOpenUrl:(NSURL *)url
{
    QQApiMessage *msg = [QQApi handleOpenURL:url];
    BOOL handled = NO;
    if (msg) {
        switch (msg.type) {
            case QQApiMessageTypeSendMessageToQQResponse:
            {
                QQApiResultObject *result = (QQApiResultObject *)msg.object;
                NSString *error = result.error;
                if (error == nil || error.integerValue == 0) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:MiNotifyUserHasShared object:nil];
                    [MINavigator showSimpleHudWithTips:@"分享成功"];
                }
                handled = YES;
                break;
            }
            default:
                break;
        }
    }

    return handled;
}

- (void) onResp:(BaseResp*)resp
{
    if (resp.errCode == 0) {
        //微信分享成功
        [[NSNotificationCenter defaultCenter] postNotificationName:MiNotifyUserHasShared object:nil];
    }
}

//APP默认数据设置
- (void)appDefaultSetting
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSString *defaultDBPath;
    
    //安装APP默认配置数据
    NSString *appConfigDataPath = [[MIMainUser documentPath] stringByAppendingPathComponent:@"app.config.data"];
    BOOL result = [fileManager fileExistsAtPath:appConfigDataPath];
    if (result){
        [fileManager removeItemAtPath:appConfigDataPath error:&error];
    }
    defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"app.config.data"];
    [fileManager copyItemAtPath:defaultDBPath toPath:appConfigDataPath error:&error];
    
    //安装10元购类目默认数据
    NSString *tenCatsDataPath = [[MIMainUser documentPath] stringByAppendingPathComponent:@"tuan.cats.data"];
    result = [fileManager fileExistsAtPath:tenCatsDataPath];
    if (result){
        [fileManager removeItemAtPath:tenCatsDataPath error:&error];
    }
    defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"tuan.cats.data"];
    [fileManager copyItemAtPath:defaultDBPath toPath:tenCatsDataPath error:&error];
    
    //安装品牌团类目默认数据
    NSString *brandCatsDataPath = [[MIMainUser documentPath] stringByAppendingPathComponent:@"tuan.brand.cats.data"];
    result = [fileManager fileExistsAtPath:brandCatsDataPath];
    if (result){
        [fileManager removeItemAtPath:brandCatsDataPath error:&error];
    }
    defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"tuan.brand.cats.data"];
    [fileManager copyItemAtPath:defaultDBPath toPath:brandCatsDataPath error:&error];
    
    // 提示安装贝贝客户端数据清零
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:@"beibeiAlertShowTimes"];
    [userDefaults removeObjectForKey:@"lastAlertShowTime"];
    [userDefaults synchronize];
}

//APP 版本更新
- (void)appUpdate:(NSDictionary *)appUpdateInfo
{
    if([[appUpdateInfo valueForKey:@"update"] boolValue]){
        _appNewVersion = [appUpdateInfo valueForKey:@"version"];
        NSString *appUpdateUrl = [appUpdateInfo valueForKey:@"path"];
        NSString *updateLog = [appUpdateInfo valueForKey:@"update_log"];
        NSString *version = [[NSString alloc] initWithFormat:@"v%@", _appNewVersion];
        NSString *title = [[NSString alloc] initWithFormat:@"检测到新版本%@", version];

        MIButtonItem *cancelItem = [MIButtonItem itemWithLabel:@"残忍地拒绝"];
        cancelItem.action = ^{
            _bNotifyNewVersion = YES;
        };
        
        MIButtonItem *affirmItem = [MIButtonItem itemWithLabel:@"快乐地升级"];
        affirmItem.action = ^{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appUpdateUrl]];
        };
        if (!_bAppManualUpdate) {
            if (![[NSUserDefaults standardUserDefaults] boolForKey:_appNewVersion]
                && [[Reachability reachabilityForInternetConnection] isReachableViaWiFi]) {
                ///只有在wifi环境下，而且距上次提醒超过一天才会自动提示用户更新
                NSDate *lastAppUpdateTime = [[NSUserDefaults standardUserDefaults] objectForKey:kLastAppUpdateAlertView];
                NSInteger interval = [lastAppUpdateTime timeIntervalSinceNow];
                if (interval > 0 || interval <= MIAPP_ONE_DAY_INTERVAL) {
                    NSInteger alertCount = [[NSUserDefaults standardUserDefaults] integerForKey:version];
                    if (MIAPP_UPDATE_ALERT_MAXCOUNT > alertCount) {
                        [[[UIAlertView alloc] initWithTitle:title
                                                    message:updateLog
                                           cancelButtonItem:cancelItem
                                           otherButtonItems:affirmItem, nil] show];
                    } else {
                        MIButtonItem *otherItem = [MIButtonItem itemWithLabel:@"不再提示我"];
                        otherItem.action = ^{
                            _bNotifyNewVersion = YES;
                            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:_appNewVersion];
                            [[NSUserDefaults standardUserDefaults] synchronize];
                        };
                        [[[UIAlertView alloc] initWithTitle:title
                                                    message:updateLog
                                           cancelButtonItem:cancelItem
                                           otherButtonItems:affirmItem, otherItem, nil] show];
                    }
                    [[NSUserDefaults standardUserDefaults] setInteger:++alertCount forKey:version];
                    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:kLastAppUpdateAlertView];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
            }
        } else {
            ///在关于页面选择手动检查更新直接提醒
            [[[UIAlertView alloc] initWithTitle:title
                                        message:updateLog
                               cancelButtonItem:cancelItem
                               otherButtonItems:affirmItem, nil] show];
        }
    } else {
        if (_bAppManualUpdate) {
            _appNewVersion = nil;
            MBProgressHUD *_hub = [MBProgressHUD showHUDAddedTo:self.window animated:YES];

            // Configure for text only and offset down
            _hub.mode = MBProgressHUDModeText;
            _hub.labelText = @"当前已是最新版本";
            _hub.margin = 10.f;
            _hub.yOffset = -50.f;
            _hub.removeFromSuperViewOnHide = YES;

            [_hub hide:YES afterDelay:1.3];
        }
    }
    
    _bAppManualUpdate = NO; ///取消手动检查更新
}

//ads 广告更新
- (void)adsUpdate
{
    [[MIAdService sharedManager] loadAdWithType:@[@(All_Ads)] block:^(MIAdsModel *model) {
        ;
    }];
}

- (void)localDataUpdate
{
    if ([MIConfig globalConfig].bNotification) {
        MILog(@"localDataUpdate return");
        return;
    }
    
    if (!self.bShowLaunchAd) {
        //加载闪屏广告数据
        [[MIAdService sharedManager] loadAdWithType:@[@(Splash_Ads)] block:^(MIAdsModel *model) {
            if (model.splashAds.count) {
                //显示闪屏广告，增加延迟是由于在iOS8上，从外部启动app需要打开一个视图同时有闪屏需要展示就会黑屏的
                MILaunchAdViewController *vc = [[MILaunchAdViewController alloc] initWithNibName:@"MILaunchAdViewController" bundle:nil];
                    vc.adsArrayDict = model.splashAds;
                [self performSelector:@selector(pushViewController:) withObject:vc afterDelay:0.35];
            }
        }];
    }
    
    if ([[MIMainUser getInstance] checkLoginInfo]) {
        [[MIHeartbeat shareHeartbeat] startActivate];
    }
    
    NSDate *lastUpdatePushBadgeTime = [[NSUserDefaults standardUserDefaults] objectForKey:kLastUpdateHomeAdsTime];
    NSInteger interval = [lastUpdatePushBadgeTime timeIntervalSinceNow];
    if (interval > 0 || interval <= MIAPP_HALF_HOUR_INTERVAL) {
        //app 更新配置数据
        [MIAppDelegate updateAppConfigWithTs:nil onCompelete:^{
            ;
        }];
    }
    
    lastUpdatePushBadgeTime = [[NSUserDefaults standardUserDefaults] objectForKey:kLastUpdateCatsTime];
    interval = [lastUpdatePushBadgeTime timeIntervalSinceNow];
    if (interval > 0 || interval <= MIAPP_ONE_DAY_INTERVAL) {
        
        MITemaiCategoryRequest *temaiCatsRequest = [[MITemaiCategoryRequest alloc] init];
        temaiCatsRequest.onCompletion = ^(MITemaiCategoryGetModel *model) {
            [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:kLastUpdateCatsTime];
            [[NSUserDefaults standardUserDefaults] synchronize];
            if (model.tuanTenCats.count > 0) {
                [MIConfig globalConfig].tuanCategory = model.tuanTenCats;
                NSString *path = [[MIMainUser documentPath] stringByAppendingPathComponent:@"tuan.cats.data"];
                [NSKeyedArchiver archiveRootObject:model.tuanTenCats toFile:path];
            }
            if (model.tuanBrandCats.count > 0) {
                [MIConfig globalConfig].brandCategory = model.tuanBrandCats;
                NSString *path = [[MIMainUser documentPath] stringByAppendingPathComponent:@"tuan.brand.cats.data"];
                [NSKeyedArchiver archiveRootObject:model.tuanBrandCats toFile:path];
            }
            if (model.youpinCats.count > 0) {
                [MIConfig globalConfig].youpinCategory = model.youpinCats;
                NSString *path = [[MIMainUser documentPath] stringByAppendingPathComponent:@"youpin.cats.data"];
                [NSKeyedArchiver archiveRootObject:model.youpinCats toFile:path];
            }
        };
        
        temaiCatsRequest.onError = ^(MKNetworkOperation* completedOperation, MIError* error) {
            MILog(@"error_msg=%@",error.description);
        };
        [temaiCatsRequest sendQuery];
    }
}

+ (void)updateAppConfigWithTs:(NSNumber *)ts onCompelete:(void (^)())block
{
    NSString *urlPath = nil;
    if (ts == nil) {
        urlPath = [NSString stringWithFormat:@"resource/app_config-iPhone-%@.html", [MIConfig globalConfig].version];
    } else {
        urlPath = [NSString stringWithFormat:@"/resource/app_config-iPhone-%@.html?ts=%@", [MIConfig globalConfig].version, ts];
    }
    
    //配置更新
    MKNetworkEngine * catsEngine = [[MKNetworkEngine alloc] initWithHostName: @"m.mizhe.com" customHeaderFields:nil];
    MKNetworkOperation* op = [catsEngine operationWithPath: urlPath params: nil httpMethod:@"GET" ssl:NO];
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        NSData* data = completedOperation.responseData;
        if (data.length > 0) {
            NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSString *config = [MIUtility decryptUseDES:[dict objectForKey:@"config"]];
            if (config) {
                NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:[config dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
                if (dic) {
                    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:kLastUpdateHomeAdsTime];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    [NSKeyedArchiver archiveRootObject:[dict objectForKey:@"config"] toFile:[[MIMainUser documentPath] stringByAppendingPathComponent:@"app.config.data"]];
                    
                    MIConfigModel *configInfo = [MIUtility convertDisctionary2Object:dic className:@"MIConfigModel"];
                    [[MIConfig globalConfig] setAppConfigInfo:configInfo];
                    // 抛出配置已经更新的事件
                    [[NSNotificationCenter defaultCenter] postNotificationName:MIConfigHasUpdated object:nil];
                    [MIMainViewController setRefreshFlag:YES];
                    
                    if (block) {
                        block();
                    }
                }
            }
        }
    } errorHandler:^(MKNetworkOperation* completedOperation, NSError *error) {
    }];
    
    [catsEngine enqueueOperation:op];
}

/**
 *	@brief	登录信息失效，强制弹框提示用户重新登录
 *
 *	@param 	notification 	登录失败通知，对象为对应的错误码
 */
- (void)logoutForceAlert:(NSNotification *)notification {
    [[MIMainUser getInstance] logout];

    [[MIHeartbeat shareHeartbeat] stopActivate];  //停止更新冒泡的心跳
    
    MIButtonItem *cancelItem = [MIButtonItem itemWithLabel:@"取消"];
    cancelItem.action = nil;

    MIButtonItem *affirmItem = [MIButtonItem itemWithLabel:@"登录"];
    affirmItem.action = ^{
        [MINavigator openLoginViewController];
    };

    UIAlertView *loginAlertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                             message:@"为了您的账户安全，请重新登录"
                                                    cancelButtonItem:cancelItem
                                                    otherButtonItems:affirmItem, nil];
    [loginAlertView show];
}

/**
 *	@brief	Message的UILable在alertView.subviews里面是第3个元素，第一个元素是一个UIImageView(背景),UILable(标题),UILable(Message),UIButton(Cancel)...(如果还有的话以此类推)
 *
 *	@param 	alertView
 */
- (void)willPresentAlertView:(UIAlertView *)alertView{
    if (IOS_VERSION < 7.0 && alertView.subviews.count > 2) {
        UIView * view = [alertView.subviews objectAtIndex:2];
        if([view isKindOfClass:[UILabel class]]){
            UILabel* label = (UILabel*) view;
            label.textAlignment = UITextAlignmentLeft;
        }
    }
}
/**
 *	@brief	矫正系统时间
 *
 *	@param 	notification 	系统时间变更通知
 */
- (void)localTimeChange:(NSNotification *)notification
{
    MKNetworkEngine * serverTimeEngine = [[MKNetworkEngine alloc] initWithHostName: @"d.mizhe.com" customHeaderFields:nil];
    NSTimeInterval a = [[NSDate date] timeIntervalSince1970];
    NSString * ts = [NSString stringWithFormat:@"%.0f", a];
    MKNetworkOperation* op = [serverTimeEngine operationWithPath: @"ts.json" params: @{@"ts":ts} httpMethod:@"GET" ssl:NO];
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        NSData* data = completedOperation.responseData;
        if (data.length > 0) {
            NSMutableDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            double serverTime = [[dict objectForKey:@"ts"] doubleValue];
            [MIConfig globalConfig].timeOffset = serverTime - [[NSDate date] timeIntervalSince1970];
            MILog(@"timeoffset:%.f", [MIConfig globalConfig].timeOffset);
        }
    } errorHandler:^(MKNetworkOperation* completedOperation, NSError *error) {
        [MIConfig globalConfig].timeOffset = 0;
    }];
    
    [serverTimeEngine enqueueOperation:op];
}

@end
