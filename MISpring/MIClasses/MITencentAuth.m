//
//  MITencentAuth.m
//  MISpring
//
//  Created by Yujian Xu on 13-6-19.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MITencentAuth.h"

#define QZONE_ACCESS_TOKEN_KEY   @"QZoneAccessToken"
#define QZONE_OPEN_ID_KEY        @"QzoneOpenId"
#define QZONE_EXPIRATION_DATE_KEY      @"QZoneExpirationDate"

static MITencentAuth *_tencentInstance = nil;

@implementation MITencentAuth
@synthesize tencOAuth;
@synthesize openID;
@synthesize accessToken;
@synthesize expirationDate;
@synthesize invocation;

+ (MITencentAuth *) getInstance {
	@synchronized(self) {
		if (_tencentInstance == nil) {
            // 看是否有最近的登录用户Id
            _tencentInstance = [[MITencentAuth alloc] init];
		}
	}

	return _tencentInstance;
}


+ (id) allocWithZone:(NSZone*) zone {
	@synchronized(self) {
		if (_tencentInstance == nil) {
			_tencentInstance = [super allocWithZone:zone];  // assignment and return on first allocation
			return _tencentInstance;
		}
	}
	return nil;
}

- (id) copyWithZone:(NSZone*) zone {
	return _tencentInstance;
}

- (id) init
{
	if (self = [super init]){
        tencOAuth = [[TencentOAuth alloc] initWithAppId:kTencentAppID andDelegate:self];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        tencOAuth.openId = [defaults objectForKey:QZONE_OPEN_ID_KEY];
        tencOAuth.accessToken = [defaults objectForKey:QZONE_ACCESS_TOKEN_KEY];
        tencOAuth.expirationDate = [defaults objectForKey:QZONE_EXPIRATION_DATE_KEY];
    }

	return self;
}

/**
 * @description 判断登录是否有效，当已登录并且登录未过期时为有效状态
 * @return YES为有效；NO为无效
 */
- (BOOL)isAuthValid
{
    return [tencOAuth isSessionValid];
}

#pragma mark - LogIn / LogOut

/**
 * @description 登录入口，当初始化SinaWeibo对象完成后直接调用此方法完成登录
 */
- (void)logIn:(NSInvocation *) _invocation
{
    [self logOut];
    
    self.invocation = _invocation;

    [tencOAuth authorize:[NSArray arrayWithObjects:kOPEN_PERMISSION_ADD_SHARE, kOPEN_PERMISSION_ADD_PIC_T, kOPEN_PERMISSION_CHECK_PAGE_FANS, nil] inSafari:NO];
}

/**
 * @description 退出方法，需要退出时直接调用此方法
 */
- (void)logOut
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:QZONE_ACCESS_TOKEN_KEY];
    [defaults removeObjectForKey:QZONE_OPEN_ID_KEY];
    [defaults removeObjectForKey:QZONE_EXPIRATION_DATE_KEY];
    [defaults synchronize];
    
    tencOAuth.openId = nil;
    tencOAuth.accessToken = nil;
    tencOAuth.expirationDate = nil;
//    [tencentOAuth logout:self];
}

- (void)invocationInvoke
{
    if (invocation) {
        [invocation invoke];
        self.invocation = nil;
    }
}
#pragma mark - TencentSessionDelegate
- (BOOL)tencentNeedPerformIncrAuth:(TencentOAuth *)tencentOAuth withPermissions:(NSArray *)permissions
{
    [tencentOAuth incrAuthWithPermissions:permissions];
    return NO;
}

- (void)tencentDidLogin
{
    // 登录完成
    if (tencOAuth.accessToken && 0 != [tencOAuth.accessToken length]) {
        // 记录登录用户的OpenID、Token以及过期时间
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:tencOAuth.accessToken forKey:QZONE_ACCESS_TOKEN_KEY];
        [defaults setObject:tencOAuth.openId forKey:QZONE_OPEN_ID_KEY];
        [defaults setObject:tencOAuth.expirationDate forKey:QZONE_EXPIRATION_DATE_KEY];
        [defaults synchronize];
        
        [self performSelector:@selector(invocationInvoke) withObject:nil afterDelay:0.2];
        [MINavigator showSimpleHudWithTips:@"授权成功"];
    } else {
        // 登录不成功 没有获取accesstoken
        [MINavigator showSimpleHudWithTips:@"网络繁忙，授权失败"];
    }
}

- (void)tencentDidNotLogin:(BOOL)cancelled;
{
    //用户取消登录
    if (!cancelled) {
        [MINavigator showSimpleHudWithTips:@"网络繁忙，授权失败"];
    }
}

-(void)tencentDidNotNetWork
{
    //无网络连接，请设置网络
    [MINavigator showSimpleHudWithTips:@"网络繁忙，授权失败"];
}

- (void)addShareResponse:(APIResponse*) response
{
    if (response.detailRetCode == kOpenSDKErrorOperationDeny || [response.message rangeOfString:@"100030"].length > 0) {
        MIButtonItem *cancelItem = [MIButtonItem itemWithLabel:@"取消"];
        cancelItem.action = ^{
        };
        MIButtonItem *affirmItem = [MIButtonItem itemWithLabel:@"确定"];
        affirmItem.action = ^{
            [self logIn:nil];
        };
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享到QQ空间失败" message:@"您未授权米折发表分享到QQ空间，请重新授权" cancelButtonItem:cancelItem otherButtonItems:affirmItem, nil];
        [alertView show];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:MiNotifyUserHasShared object:nil];
        [MINavigator showSimpleHudWithTips:@"分享成功"];
    }
}


#pragma mark - TCAPIRequestDelegate
- (void)cgiRequest:(TCAPIRequest *)request didResponse:(APIResponse *)response
{
    if (URLREQUEST_SUCCEED == response.retCode && kOpenSDKErrorSuccess == response.detailRetCode) {
        [[NSNotificationCenter defaultCenter] postNotificationName:MiNotifyUserHasShared object:nil];
        [MINavigator showSimpleHudWithTips:@"分享成功"];
    } else {
        MIButtonItem *cancelItem = [MIButtonItem itemWithLabel:@"取消"];
        cancelItem.action = ^{
        };
        MIButtonItem *affirmItem = [MIButtonItem itemWithLabel:@"确定"];
        affirmItem.action = ^{
            [[MITencentAuth getInstance] logIn:nil];
        };
        
        NSString *msg = [NSString stringWithFormat:@"%@，请重新授权", response.errorMsg];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享给腾讯微博失败" message:msg cancelButtonItem:cancelItem otherButtonItems:affirmItem, nil];
        [alertView show];
    }
}

@end
