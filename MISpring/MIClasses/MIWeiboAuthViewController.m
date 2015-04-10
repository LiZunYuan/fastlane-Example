//
//  MIWeiboAuthViewController.m
//  MISpring
//
//  Created by Yujian Xu on 13-6-18.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIWeiboAuthViewController.h"
#import "MISinaWeibo.h"

@implementation MIWeiboAuthViewController
@synthesize delegate;

- (id)initWithAuthParams:(NSDictionary *)params delegate:(id<MIAuthorizeDelegate>) _delegate;
{
    if ((self = [self init]))
    {
        authParams = [params copy];
        appRedirectURI = [authParams objectForKey:@"redirect_uri"];
        _webPageTitle = @"新浪微博授权";
        self.delegate = _delegate;
    }

    NSString *authPagePath = [MIUtility serializeURL:kSinaWeiboWebAuthURL
                                                     params:params httpMethod:@"GET"];
    return [super initWithURL:[NSURL URLWithString:authPagePath]];
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

- (void)close
{
    [_webView stopLoading];
    _webView.delegate = nil;
    _webView.scrollView.delegate = nil;
    _webView = nil;

    [[MINavigator navigator] closeModalViewController:NO completion:^{
        MI_CALL_DELEGATE(delegate, @selector(authFinishedSuccess));
    }];
}

- (void)requestAccessTokenWithAuthorizationCode:(NSString *)code
{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [authParams objectForKey:@"client_id"], @"client_id",
                            [authParams objectForKey:@"client_secret"], @"client_secret",
                            @"authorization_code", @"grant_type",
                            [authParams objectForKey:@"redirect_uri"], @"redirect_uri",
                            code, @"code", nil];

    MKNetworkEngine * catsEngine = [[MKNetworkEngine alloc] initWithHostName: kSinaWeiboWebAccessTokenURL customHeaderFields:nil];
    MKNetworkOperation* op = [catsEngine operationWithPath: nil params: params httpMethod:@"POST" ssl:YES];

    __weak typeof(self) weakSelf = self;
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        NSData* data = completedOperation.responseData;
        if (data) {
            NSMutableDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            if (dict) {
                [[MISinaWeibo getInstance] logInDidFinishWithAuthInfo:dict];
                [weakSelf close];
                return;
            } 
        }
     
        [weakSelf showSimpleHUD:@"网络繁忙，授权失败"];
    } errorHandler:^(MKNetworkOperation* completedOperation, NSError *error) {
        [weakSelf showSimpleHUD:@"网络繁忙，授权失败"];
    }];

    [catsEngine enqueueOperation:op];
}

#pragma mark - UIWebView Delegate

- (void)webViewDidFinishLoad:(UIWebView *)aWebView
{
    [super webViewDidFinishLoad:aWebView];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [super webView:webView didFailLoadWithError:error];
}

- (BOOL)webView:(UIWebView *)aWebView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *url = request.URL.absoluteString;
    MILog(@"url = %@", url);

    NSString *siteRedirectURI = [NSString stringWithFormat:@"%@%@", kSinaWeiboSDKOAuth2APIDomain, appRedirectURI];

    if ([url hasPrefix:appRedirectURI] || [url hasPrefix:siteRedirectURI])
    {
        NSString *error_code = [MIUtility getParamValueFromUrl:url paramName:@"error_code"];
        if (error_code)
        {
            [self showSimpleHUD:@"网络繁忙，授权失败"];
        }
        else
        {
            NSString *code = [MIUtility getParamValueFromUrl:url paramName:@"code"];
            if (code)
            {
                [self requestAccessTokenWithAuthorizationCode:code];
            }
        }

        return NO;
    }

    return YES;
}

@end
