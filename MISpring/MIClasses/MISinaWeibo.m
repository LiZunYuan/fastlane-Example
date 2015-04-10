//
//  MISinaWeibo.m
//  MISpring
//
//  Created by Yujian Xu on 13-6-18.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MISinaWeibo.h"
#import "MIWeiboAuthViewController.h"

#define SINA_WEIBO_ACCESS_TOKEN_KEY   @"sinaWeiboAccessToken"
#define SINA_WEIBO_USER_ID_KEY        @"sinaWeiboUserId"
#define SINA_WEIBO_REMIND_IN_KEY      @"sinaWeiboRemindIn"
#define SINA_WEIBO_REFRESH_TOKEN_KEY  @"sinaWeiboRefreshToken"

static MISinaWeibo *_weiboInstance = nil;

@implementation MISinaWeibo
@synthesize userID;
@synthesize accessToken;
@synthesize expirationDate;
@synthesize refreshToken;
@synthesize ssoCallbackScheme;
@synthesize appKey;
@synthesize appSecret;
@synthesize appRedirectURI;
@synthesize invocation;

+ (MISinaWeibo *) getInstance {
	@synchronized(self) {
		if (_weiboInstance == nil) {
            // 看是否有最近的登录用户Id            
            _weiboInstance = [[MISinaWeibo alloc] init];
		}
	}

	return _weiboInstance;
}


+ (id) allocWithZone:(NSZone*) zone {
	@synchronized(self) {
		if (_weiboInstance == nil) {
			_weiboInstance = [super allocWithZone:zone];  // assignment and return on first allocation
			return _weiboInstance;
		}
	}
	return nil;
}

- (id) copyWithZone:(NSZone*) zone {
	return _weiboInstance;
}

- (id) init
{
	if (self = [super init]){
        self.appKey = kSinaAppKey;
        self.appSecret = kSinaAppSecret;
        self.appRedirectURI = kSinaAppRedirectURI;
        self.ssoCallbackScheme = [NSString stringWithFormat:@"sinaweibosso.%@://", self.appKey];

        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        self.userID = [defaults objectForKey:SINA_WEIBO_USER_ID_KEY];
        self.accessToken = [defaults objectForKey:SINA_WEIBO_ACCESS_TOKEN_KEY];
        self.refreshToken = [defaults objectForKey:SINA_WEIBO_REFRESH_TOKEN_KEY];
        NSString* remind_in = [defaults objectForKey:SINA_WEIBO_REMIND_IN_KEY];
        if (remind_in) {
            NSInteger expVal = [remind_in intValue];
            if (expVal == 0)
            {
                self.expirationDate = [NSDate distantFuture];
            }
            else
            {
                self.expirationDate = [NSDate dateWithTimeIntervalSinceNow:expVal];
            }
        } else {
            self.expirationDate = nil;
        }
    }

	return self;
}

/**
 * @description 存储认证信息
 */
- (void)logInDidFinishWithAuthInfo:(NSDictionary *)authInfo
{
    NSString *access_token = [authInfo objectForKey:@"access_token"];
    NSString *uid = [authInfo objectForKey:@"uid"];
    NSString *remind_in = [authInfo objectForKey:@"remind_in"];
    NSString *refresh_token = [authInfo objectForKey:@"refresh_token"];
    if (access_token && uid)
    {
        if (remind_in != nil)
        {
            NSInteger expVal = [remind_in intValue];
            if (expVal == 0)
            {
                self.expirationDate = [NSDate distantFuture];
            }
            else
            {
                self.expirationDate = [NSDate dateWithTimeIntervalSinceNow:expVal];
            }
        }

        self.accessToken = access_token;
        self.userID = uid;
        self.refreshToken = refresh_token;

        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:access_token forKey:SINA_WEIBO_ACCESS_TOKEN_KEY];
        [defaults setObject:uid forKey:SINA_WEIBO_USER_ID_KEY];
        [defaults setObject:remind_in forKey:SINA_WEIBO_REMIND_IN_KEY];
        [defaults setObject:refresh_token forKey:SINA_WEIBO_REFRESH_TOKEN_KEY];
        [defaults synchronize];
    }
}

/**
 * @description 清空认证信息
 */
- (void)removeAuthData
{
    self.accessToken = nil;
    self.userID = nil;
    self.expirationDate = nil;

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:SINA_WEIBO_ACCESS_TOKEN_KEY];
    [defaults removeObjectForKey:SINA_WEIBO_USER_ID_KEY];
    [defaults removeObjectForKey:SINA_WEIBO_REMIND_IN_KEY];
    [defaults removeObjectForKey:SINA_WEIBO_REFRESH_TOKEN_KEY];
    [defaults synchronize];
    
    NSHTTPCookieStorage* cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray* sinaweiboCookies = [cookies cookiesForURL:
                                 [NSURL URLWithString:@"https://open.weibo.cn"]];

    for (NSHTTPCookie* cookie in sinaweiboCookies)
    {
        [cookies deleteCookie:cookie];
    }
}

/**
 * @description 判断是否登录
 * @return YES为已登录；NO为未登录
 */
- (BOOL)isLoggedIn
{
    return userID && accessToken && expirationDate;
}

/**
 * @description 判断登录是否过期
 * @return YES为已过期；NO为未为期
 */
- (BOOL)isAuthorizeExpired
{
    NSDate *now = [NSDate date];
    return ([now compare:expirationDate] == NSOrderedDescending);
}


/**
 * @description 判断登录是否有效，当已登录并且登录未过期时为有效状态
 * @return YES为有效；NO为无效
 */
- (BOOL)isAuthValid
{
    return ([self isLoggedIn] && ![self isAuthorizeExpired]);
}

#pragma mark - LogIn / LogOut

/**
 * @description 登录入口，当初始化SinaWeibo对象完成后直接调用此方法完成登录
 */
- (void)logIn:(NSInvocation *) _invocation
{
    [self removeAuthData];

    self.invocation = _invocation;
    ssoLoggingIn = NO;

    /*
    // open sina weibo app
    UIDevice *device = [UIDevice currentDevice];
    if ([device respondsToSelector:@selector(isMultitaskingSupported)] &&
        [device isMultitaskingSupported])
    {
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                self.appKey, @"client_id",
                                self.appRedirectURI, @"redirect_uri",
                                self.ssoCallbackScheme, @"callback_uri",
                                @"follow_app_official_microblog", @"scope", nil];

        // 先用iPad微博打开
        NSString *appAuthBaseURL = kSinaWeiboAppAuthURL_iPad;
        if ([UIDevice isDeviceiPad])
        {
            NSString *appAuthURL = [MIUtility serializeURL:appAuthBaseURL
                                                    params:params httpMethod:@"GET"];
            ssoLoggingIn = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appAuthURL]];
        }

        // 在用iPhone微博打开
        if (!ssoLoggingIn)
        {
            appAuthBaseURL = kSinaWeiboAppAuthURL_iPhone;
            NSString *appAuthURL = [MIUtility serializeURL:appAuthBaseURL
                                                    params:params httpMethod:@"GET"];
            ssoLoggingIn = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appAuthURL]];
        }
    }
    */
    
    if (!ssoLoggingIn)
    {
        // open authorize view

        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                self.appKey, @"client_id",
                                self.appSecret, @"client_secret",
                                @"code", @"response_type",
                                self.appRedirectURI, @"redirect_uri",
                                @"mobile", @"display",
                                @"follow_app_official_microblog", @"scope", nil];
        MIWeiboAuthViewController *authorizeView = [[MIWeiboAuthViewController alloc] initWithAuthParams:params delegate:self];
        [[MINavigator navigator] openModalViewController:authorizeView animated:YES];
    }
}

/**
 * @description 退出方法，需要退出时直接调用此方法
 */
- (void)logOut
{
    [self removeAuthData];
}

#pragma mark - MIAuthorizeDelegate
-(void)authFinishedSuccess
{
    if (invocation) {
        [invocation invoke];
        self.invocation = nil;
    }
}

#pragma mark - Application life cycle

/**
 * @description 当应用从后台唤起时，应调用此方法，需要完成退出当前登录状态的功能
 */
- (void)applicationDidBecomeActive
{
    if (ssoLoggingIn)
    {
        // user open the app manually
        // clean sso login state
        ssoLoggingIn = NO;
    }
}

/**
 * @description sso回调方法，官方客户端完成sso授权后，回调唤起应用，应用中应调用此方法完成sso登录
 * @param url: 官方客户端回调给应用时传回的参数，包含认证信息等
 * @return YES
 */
- (BOOL)handleOpenURL:(NSURL *)url
{
    NSString *urlString = [url absoluteString];
    if ([urlString hasPrefix:self.ssoCallbackScheme])
    {
        if (!ssoLoggingIn)
        {
            // sso callback after user have manually opened the app
            // ignore the request
        }
        else
        {
            ssoLoggingIn = NO;
            NSString *access_token = [MIUtility getParamValueFromUrl:urlString paramName:@"access_token"];
            if(access_token && access_token.length)
            {
                NSString *expires_in = [MIUtility getParamValueFromUrl:urlString paramName:@"expires_in"];
                NSString *remind_in = [MIUtility getParamValueFromUrl:urlString paramName:@"remind_in"];
                NSString *uid = [MIUtility getParamValueFromUrl:urlString paramName:@"uid"];
                NSString *refresh_token = [MIUtility getParamValueFromUrl:urlString paramName:@"refresh_token"];
                
                NSMutableDictionary *authInfo = [NSMutableDictionary dictionary];
                if (access_token) [authInfo setObject:access_token forKey:@"access_token"];
                if (expires_in) [authInfo setObject:expires_in forKey:@"expires_in"];
                if (remind_in) [authInfo setObject:remind_in forKey:@"remind_in"];
                if (refresh_token) [authInfo setObject:refresh_token forKey:@"refresh_token"];
                if (uid) [authInfo setObject:uid forKey:@"uid"];
                
                [self logInDidFinishWithAuthInfo:authInfo];
                [self performSelector:@selector(authFinishedSuccess) withObject:nil afterDelay:0.2];
                [MINavigator showSimpleHudWithTips:@"微博授权成功"];
            }
            else 
            {
                MILog(@"sso_error");
                [MINavigator showSimpleHudWithTips:@"微博授权失败，请重试"];
            }
        }
    }
    return YES;
}

@end
