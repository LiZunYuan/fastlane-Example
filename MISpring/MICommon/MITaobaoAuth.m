//
//  MITaobaoAuth.m
//  MISpring
//
//  Created by 徐 裕健 on 13-9-4.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MITaobaoAuth.h"
#import "MITaobaoWebViewController.h"

static MITaobaoAuth *_taobaoInstance = nil;

@implementation MITaobaoAuth

@synthesize url;
@synthesize title;
@synthesize topAuth;
@synthesize userid;
@synthesize expirationDate;
@synthesize refreshTokenDate;

+ (MITaobaoAuth *) getInstance {
	@synchronized(self) {
		if (_taobaoInstance == nil) {
            // 看是否有最近的登录用户Id
            _taobaoInstance = [[MITaobaoAuth alloc] init];
		}
	}
    
	return _taobaoInstance;
}


+ (id) allocWithZone:(NSZone*) zone {
	@synchronized(self) {
		if (_taobaoInstance == nil) {
			_taobaoInstance = [super allocWithZone:zone];  // assignment and return on first allocation
			return _taobaoInstance;
		}
	}
	return nil;
}

- (id) copyWithZone:(NSZone*) zone {
	return _taobaoInstance;
}

- (id) init
{
	if (self = [super init]){
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        self.userid = [defaults objectForKey:kTaobaoTopAuthUserIdKey];
        self.expirationDate = [defaults objectForKey:kTaobaoTopAuthExpireKey];
        self.refreshTokenDate = [defaults objectForKey:kTaobaoTopAuthRefreshKey];
        
        TopIOSClient *topClient = [TopIOSClient getIOSClientByAppKey:[MIConfig globalConfig].topAppKey];
        self.topAuth = [topClient getAuthByUserId:self.userid];
    }
    
	return self;
}

/**
 * @description 判断登录是否有效，当已登录并且登录未过期时为有效状态
 * @return YES为有效；NO为无效
 */
- (BOOL)isAuthValid
{
    if (self.userid != nil && self.userid.length != 0) {
        NSDate *now = [NSDate date];
        return ([now compare:self.expirationDate] == NSOrderedAscending);
    }
        
    return NO;
}

#pragma mark - LogIn / LogOut

/**
 * @description 登录入口，当初始化SinaWeibo对象完成后直接调用此方法完成登录
 */
- (void)logIn:(NSString *) _url title:(NSString *) _title
{    
    self.url = _url;
    self.title = _title;
    
    MITaobaoAuthViewController *authorizeView = [[MITaobaoAuthViewController alloc] initWithDelegate:self];
    authorizeView.noToolBar = YES;
    [[MINavigator navigator] openModalViewController:authorizeView animated:YES];
}

/**
 * @description 退出方法，需要退出时直接调用此方法
 */
- (void)logOut
{
    if ([self isAuthValid]) {
        TopIOSClient *topClient = [TopIOSClient getIOSClientByAppKey:[MIConfig globalConfig].topAppKey];
        [topClient removeAuthByUserId:self.userid];
        
        NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
        [standardUserDefaults removeObjectForKey:kTaobaoTopAuthUserIdKey];
        [standardUserDefaults synchronize];
        
        self.userid = nil;
        self.expirationDate = nil;
        self.refreshTokenDate = nil;
    }
}

#pragma mark - TencentSessionDelegate
- (void)authFinishedSuccess
{
    if (self.url != nil && self.title != nil) {
        MITaobaoWebViewController * webVC = [[MITaobaoWebViewController alloc] initWithURL:[NSURL URLWithString: self.url]];
        [webVC setWebTitle:self.title];
        [[MINavigator navigator] openModalViewController: webVC animated:YES];
    }
}

@end
