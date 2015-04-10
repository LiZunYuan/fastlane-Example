//
//  MIThirdLoginViewController.m
//  MISpring
//
//  Created by XU YUJIAN on 13-1-22.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIThirdLoginViewController.h"
#import "MIAuthRequest.h"
#import "MIUserOpenAuthModel.h"
#import "MIUserGetRequest.h"

#define MITHIRD_LOGIN_BASE_URL @"http://api.mizhe.com/oauth2"
#define MITHIRD_LOGIN_SUCCESS @"http://api.mizhe.com/oauth2/peer"
#define BBTHIRD_LOGIN_BIND @"http://api.mizhe.com/oauth2/bind"

@implementation MIThirdLoginViewController
@synthesize delegate = _delegate;
@synthesize event = _event;

- (id)initWithOrigin:(NSString *)origin delegate:(id<MIAuthorizeViewDelegate>)delegate
{
    self = [super init];
    if (self) {
        self.delegate = delegate;
        if ([origin isEqualToString:@"taobao"]) {
            _webPageTitle = @"淘宝帐号登录";
            _event = kTaobaoLogin;
        }
        
        if ([origin isEqualToString:@"weibo"]) {
            _webPageTitle = @"新浪微博帐号登录";
            _event = kWeiboLogin;
        }
        
        if ([origin isEqualToString:@"qq"]) {
            _webPageTitle = @"QQ帐号登录";
            _event = kQQLogin;
        }
    }
    
    NSString *authUrl = [MIUtility serializeURL:[NSString stringWithFormat:@"%@/%@", MITHIRD_LOGIN_BASE_URL, origin]
                                         params:[NSDictionary dictionaryWithObjectsAndKeys:[MIConfig globalConfig].channelId, @"bd", nil]
                                     httpMethod:@"GET"];
    return [super initWithURL: [NSURL URLWithString: authUrl]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

//    [self setWebViewTitle:_webViewTitle];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)closeView:(NSString *)token
{
    [_webView stopLoading];
    _webView.delegate = nil;
    _webView.scrollView.delegate = nil;
    _webView = nil;
    [[MINavigator navigator] closeModalViewController:YES completion:^{
        MI_CALL_DELEGATE_WITH_ARG(_delegate, @selector(authFinishedSuccess:), token);
    }];
}

- (void)getUserInfo
{
    __weak typeof(self) weakSelf = self;
    MIUserGetRequest *_request = [[MIUserGetRequest alloc] init];
    _request.onCompletion = ^(MIUserGetModel * model) {
        [MobClick event:_event];
        [[MIMainUser getInstance] saveUserInfo:model];
        [weakSelf closeView:nil];
    };

    _request.onError = ^(MKNetworkOperation* completedOperation, MIError* error) {
        [[MIMainUser getInstance] logout];
        [weakSelf showSimpleHUD:@"网络繁忙，授权失败"];
    };
    [_request sendQuery];
}

- (void)didFinishAuthSuccess:(NSString *)token{
    MIAuthRequest *request = [[MIAuthRequest alloc] init];

    __weak typeof(self) weakSelf = self;
    request.onCompletion = ^(MIUserOpenAuthModel *authInfo) {
        MILog(@"获取session信息成功！");

        if ([authInfo.success boolValue]) {
            [MIMainUser getInstance].loginStatus = MILoginStatusNormalLogin;
            [MIMainUser getInstance].sessionKey = authInfo.data;
            [[MIMainUser getInstance] persist];
            [weakSelf getUserInfo];
        } else {
            [weakSelf showSimpleHUD:authInfo.message];
        }
    };
    
    request.onError = ^(MKNetworkOperation* completedOperation, MIError* error){
        MILog(@"获取session信息失败！");
        [weakSelf showSimpleHUD:@"网络繁忙，授权失败"];
//        MI_CALL_DELEGATE_WITH_ARG(_delegate, @selector(authFinishedFailure:), error);
    };
    
    [request setToken:token];
    [request sendQuery];
}

//-(void) didFinishAuthFailure:(NSError *) error{
//    MI_CALL_DELEGATE_WITH_ARG([RenrenAuthManager sharedInstance].delegate, @selector(authFinishedFailure:), [MIError errorWithNSError:error]);
//}

//-(void) didFinishAuthCancel{
//    [super closeWebView:nil];
//    if (_delegate != nil && [_delegate respondsToSelector:@selector(authWebViewDidCancel)]) {
//        [_delegate performSelector:@selector(authWebViewDidCancel)];
//    }
//}
//- (void)setNaviTitle: (NSString *) title {
//    //复写父类方法，以防修改导航栏标题
//}
//
//- (void)setWebViewTitle: (NSString *) title {
//    [_naviBar setNaviTitle:title textSize:15.0];
//}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    MILog(@"THIRD ua=%@", [request valueForHTTPHeaderField:@"User-Agent"]);

    NSURL *url = request.URL;
    MILog(@"sina url=%@", url);
    NSString *q = [url absoluteString];
    if([q hasPrefix:MITHIRD_LOGIN_SUCCESS])
    {
        NSString *query = [url fragment]; // url中＃字符后面的部分。
        if (!query) {
            query = [url query];
        }
        
        NSDictionary *dic = [MIUtility parseURLParams:query];
        NSString *token = [dic valueForKey:@"token"];
        if(token){
            MILog(@"token=%@",token);
            [self didFinishAuthSuccess:token];
            return NO;
        }
    }
    else if ([q hasPrefix:BBTHIRD_LOGIN_BIND])
    {
        NSString *query = [url fragment]; // url中＃字符后面的部分。
        if (!query) {
            query = [url query];
        }
        
        NSDictionary *dic = [MIUtility parseURLParams:query];
        NSString *token = [dic valueForKey:@"token"];
        if(token){
            [self closeView:token];
            return NO;
        }
    }

//    else if ([q hasPrefix:MITHIRD_LOGIN_CANCEL]){
//        [self didFinishAuthCancel];
//        return NO;
//    }

    return [super webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [super webViewDidFinishLoad:webView];
    
    //UIWebView 禁止长按链接弹出菜单
    [webView stringByEvaluatingJavaScriptFromString:@"document.body.style.webkitTouchCallout='none';"];
}

@end
