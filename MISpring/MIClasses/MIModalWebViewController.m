//
//  MIModalWebViewController.m
//  MISpring
//
//  Created by 徐 裕健 on 13-9-24.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIModalWebViewController.h"

@implementation MIModalWebViewController

#pragma mark - Public

- (NSURL *)URL {
    NSURL *url = _loadingURL ? _loadingURL : _webView.request.URL;
    return url;
}

- (void)openURL:(NSURL*)URL {
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:URL];
    [self openRequest:request];
}


- (void)openRequest:(NSURLRequest*)request {
    if(self.view)
        [_webView loadRequest:request];
}

#pragma mark - UIViewController

- (id)initWithURL:(NSURL*)URL {
    
    self = [super init];
    
    if (self != nil) {
        self.homeURL = URL;
    }
    
    NSString *defaultUserAgent = [[NSUserDefaults standardUserDefaults] stringForKey:kDefaultUserAgent];
    NSDictionary *dictionnary = [[NSDictionary alloc] initWithObjectsAndKeys:defaultUserAgent, @"UserAgent", nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionnary];
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.navigationBar setBarLeftButtonItem:self selector:@selector(closeWebView:) imageKey:@"navigationbar_btn_close"];
    [self.navigationBar setBarTitle:_webPageTitle];
    
    CGFloat ww = self.view.viewWidth;
    CGFloat wh = self.view.viewHeight;
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, self.navigationBarHeight, ww, wh-self.navigationBarHeight)];
    _webView.scrollView.bounces = NO;
    _webView.scalesPageToFit = YES;
    [self.view addSubview:_webView];
    
    _accountLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    _accountLabel.font = [UIFont systemFontOfSize: 14];
    [_accountLabel setTextColor: [UIColor whiteColor]];
    _accountLabel.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.85];
    _accountLabel.textAlignment = NSTextAlignmentCenter;
    _accountLabel.shadowColor = [UIColor blackColor];
    _accountLabel.shadowOffset = CGSizeMake(0, -1.0);
    _accountLabel.lineBreakMode = NSLineBreakByCharWrapping;
    _accountLabel.numberOfLines = 0;
    [self.view insertSubview: _accountLabel belowSubview:self.navigationBar];
    [self.view sendSubviewToBack:_webView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _webView.delegate = self;
    _webView.scrollView.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (_homeURL != nil) {
        [self openURL:_homeURL];        
        [self setOverlayStatus:EOverlayStatusLoading labelText:nil];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [_webView stopLoading];
    _webView.delegate = nil;
    _webView.scrollView.delegate = nil;
    // If the browser launched the media player, it steals the key window and never gives it
    // back, so this is a way to try and fix that
    [self.view.window makeKeyWindow];
}

- (void)closeWebView: (id) event
{
    [_webView stopLoading];
    _webView.delegate = nil;
    _webView = nil;
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [[MINavigator navigator] closeModalViewController:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request
 navigationType:(UIWebViewNavigationType)navigationType {
    MILog(@"shouldStartLoadWithRequest=%@", request.URL.absoluteString);
    if ([request.URL.absoluteString isEqualToString:[MIConfig globalConfig].forgetPasswordURL]
        && [[MIMainUser getInstance] checkLoginInfo]) {
        _accountLabel.text = [NSString stringWithFormat:@"你注册的邮箱是\n%@", [MIMainUser getInstance].loginAccount];
        [UIView animateWithDuration:0.35 delay:0 options:UIViewAnimationCurveEaseInOut animations:^{
            _accountLabel.top = self.navigationBarHeight;
        } completion:nil];
    }
    _loadingURL = request.URL;
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView*)webView {
    [self setOverlayStatus:EOverlayStatusRemove labelText:nil];

    _loadingURL = webView.request.URL;
}

- (void)webView:(UIWebView*)webView didFailLoadWithError:(NSError*)error {

    //非网络原因
    if(error.code != -999 && error.code != 102) {
        //服务器页面抛出错误error，-999属于请求未完成（刷新过快），102属于网络错误
        //此两个错误不做异常处理
        [self setOverlayStatus:EOverlayStatusError labelText:nil];
    }
}

@end
