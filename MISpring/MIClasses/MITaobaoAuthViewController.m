//
//  MITaobaoAuthViewController.m
//  MISpring
//
//  Created by 徐 裕健 on 13-9-3.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MITaobaoAuthViewController.h"
#import "TopAuthWebView.h"
#import "MITaobaoAuth.h"

#define MITAOBAO_AUTH_BASE_URL     @"https://oauth.taobao.com/authorize"
#define MITAOBAO_AUTH_CALLBACK_URL @"http://www.mizhe.com/openid/taobao/callback.html?"

@implementation MITaobaoAuthViewController
@synthesize delegate = _delegate;

- (id)initWithDelegate:(id<MIAuthorizeDelegate>)delegate;
{
    self = [super init];
    if (self) {
        _webPageTitle = @"绑定淘宝账号";
        self.delegate = delegate;
    }
    
    NSString *authUrl = [MIUtility serializeURL:MITAOBAO_AUTH_BASE_URL
                                         params:[NSDictionary dictionaryWithObjectsAndKeys:
                                                 @"token", @"response_type",
                                                 @"wap", @"view",
                                                 [MIConfig globalConfig].topAppKey, @"client_id",
                                                 MITAOBAO_AUTH_CALLBACK_URL, @"redirect_uri", nil]
                                     httpMethod:@"GET"];
    return [super initWithURL: [NSURL URLWithString: authUrl]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)closeView
{
    [_webView stopLoading];
    _webView.delegate = nil;
    _webView.scrollView.delegate = nil;
    _webView = nil;
    
    [_naviBar popNavigationItemAnimated:NO];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self dismissViewControllerAnimated:NO completion:^{
        MI_CALL_DELEGATE(_delegate, @selector(authFinishedSuccess));
    }];
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSURL *url = request.URL;
    MILog(@"sina url=%@", url);
    if([url.absoluteString hasPrefix:MITAOBAO_AUTH_CALLBACK_URL]) {
        NSRange range = [url.absoluteString rangeOfString:@"#"];
        if (range.location != NSNotFound) {
            
            NSString *token =  [url.absoluteString substringFromIndex:(range.location + 1)];
            TopAuth *auth = [[TopAuth alloc] initTopAuthFromString:token];
            TopIOSClient *topClient = [TopIOSClient getIOSClientByAppKey:[MIConfig globalConfig].topAppKey];
            [topClient setAuthByUserId:auth.user_id auth:auth];
            
            NSDate *expirationDate = [NSDate dateWithTimeIntervalSinceNow:auth.refresh_expire_time];
            NSDate *refreshTokenDate = [NSDate dateWithTimeIntervalSinceNow:auth.refresh_interval];
            [MITaobaoAuth getInstance].userid = auth.user_id;
            [MITaobaoAuth getInstance].expirationDate = expirationDate;
            [MITaobaoAuth getInstance].refreshTokenDate = refreshTokenDate;

            [[NSUserDefaults standardUserDefaults] setObject:auth.user_id forKey:kTaobaoTopAuthUserIdKey];
            [[NSUserDefaults standardUserDefaults] setObject:expirationDate
                                                      forKey:kTaobaoTopAuthExpireKey];
            [[NSUserDefaults standardUserDefaults] setObject:refreshTokenDate
                                                      forKey:kTaobaoTopAuthRefreshKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self closeView];
        } else {
            NSString *error = [MIUtility getParamValueFromUrl:url.absoluteString paramName:@"error"];
            if ([error isEqualToString:@"access_denied"]) {
                [self closeWebView:nil];
            } else {
                [self showSimpleHUD:@"网络繁忙，授权失败！"];
            }
        }

        return NO;
    }
    
    return [super webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
}


- (void)webViewDidStartLoad:(UIWebView *)webView{
    [super webViewDidStartLoad:webView];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [super webViewDidFinishLoad:webView];
    
    //UIWebView 禁止长按链接弹出菜单
    [webView stringByEvaluatingJavaScriptFromString:@"document.body.style.webkitTouchCallout='none';"];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    return [super webView:webView didFailLoadWithError:error];
}

@end
