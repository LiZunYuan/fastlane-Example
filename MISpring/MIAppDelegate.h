//
//  MIAppDelegate.h
//  MISpring
//
//  Created by XU YUJIAN on 13-1-17.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApi.h"
#import "XGPush.h"

typedef void (^CheckStatusBlock)(NSInteger status);
typedef enum _AppRemoteNotifiActionType{
    APP_REMOTE_NOTIFY_ACTION_MALL = 1,
    APP_REMOTE_NOTIFY_ACTION_TAOBAO,
    APP_REMOTE_NOTIFY_ACTION_UPDATE,
    APP_REMOTE_NOTIFY_ACTION_TABS,  //打开对应的tabs
    APP_REMOTE_NOTIFY_ACTION_MESSAGE,
    APP_REMOTE_NOTIFY_ACTION_ZHI,
    APP_REMOTE_NOTIFY_ACTION_CATEGORY,
    APP_REMOTE_NOTIFY_ACTION_BEIBEISHOP,
} AppRemoteNotifiActionType;

typedef enum _AppLocalNotifiActionType{
    APP_LOCAL_NOTIFY_ACTION_ALARM = 1,
    APP_LOCAL_NOTIFY_ACTION_MARTSHOW_START_ALARM,//收藏的专场提醒
    APP_LOCAL_NOTIFY_ACTION_PRODUCT_START_ALARM,// 收藏的单品提醒
    APP_LOCAL_NOTIFY_ACTION_UPDATE,//更新提醒
    APP_LOCAL_NOTIFY_ACTION_CHECK_IN_ALARM//签到提醒
} AppLocalNotifiActionType;

@interface MIAppDelegate : UIResponder <UIApplicationDelegate, WXApiDelegate>
{
    MKNetworkEngine * _catsEngine;
}
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString *appNewVersion;
@property (assign, nonatomic) BOOL bAppManualUpdate;
@property (assign, nonatomic) BOOL bShowLaunchAd;
@property (assign, nonatomic) BOOL bOpenFromURL;
@property (assign, nonatomic) BOOL bAppOpenFromBackground;
@property (assign, nonatomic) BOOL bNotifyNewVersion;

- (BOOL)willShowSplashAds;
- (void)appUpdate:(NSDictionary *)appUpdateInfo;
+ (void)sendCheckServerRequest:(CheckStatusBlock)block;
+ (void)updateAppConfigWithTs:(NSNumber *)ts onCompelete:(void (^)())block;
+(void)logout;

@end
