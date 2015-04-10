//
//  MITaobaoDescViewController.m
//  MISpring
//
//  Created by 徐 裕健 on 13-9-25.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MITaobaoDescViewController.h"

@implementation MITaobaoDescViewController
@synthesize webview = _webview;
@synthesize desc = _desc;
@synthesize loadingIndicator;

-(id) initWithDesc: (NSString *) desc
{
    self = [super init];
    if (self != nil) {
        self.desc = desc;
    }
    
    return self;
}

- (void)loadView
{
    [super loadView];
    
    [self.navigationBar setBarTitle:@"宝贝图文详情" textSize:20.0];
    loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    loadingIndicator.center = CGPointMake(PHONE_SCREEN_SIZE.width - 30, PHONE_NAVIGATIONBAR_HEIGHT / 2);
    [self.view addSubview:loadingIndicator];
    
    _webview = [[UIWebView alloc] initWithFrame: CGRectMake(0, PHONE_NAVIGATIONBAR_HEIGHT, 320, self.view.viewHeight - PHONE_NAVIGATIONBAR_HEIGHT)];
    _webview.scrollView.bounces = NO;
    _webview.delegate = self;
    _webview.scalesPageToFit = YES;
    [self.view addSubview:_webview];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_webview loadHTMLString:self.desc baseURL:nil];
//    [self setOverlayStatus:EOverlayStatusLoading labelText:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request
 navigationType:(UIWebViewNavigationType)navigationType {
    if ([request.URL.absoluteString isEqualToString:@"about:blank"]) {
        return YES;
    } else {
        return NO;
    }
}
- (void)webViewDidStartLoad:(UIWebView *)webView{    
    [loadingIndicator startAnimating];
}
- (void)webViewDidFinishLoad:(UIWebView*)webView {
    [loadingIndicator stopAnimating];

//    [self setOverlayStatus:EOverlayStatusRemove labelText:nil];
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
}
@end
