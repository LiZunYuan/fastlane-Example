//
//  MICustomerViewController.m
//  MISpring
//
//  Created by weihao on 14-12-1.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MICustomerViewController.h"
#import "MIWebToolbar.h"

@interface MICustomerViewController ()
{
    BOOL _isLive800;
    NSInteger _counter;
    NSTimer* _activateTimer;
    MIWebToolbar *_reloadToolBar;
    UIBarButtonItem *_reloadBarButton;
    UIActivityIndicatorView *_ActivityIndicator;
}

@end

@implementation MICustomerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _counter = 0;
    _isLive800 = NO;
    _ActivityIndicator= [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleGray];
    _ActivityIndicator.frame = CGRectMake(self.view.viewWidth - 44, IOS7_STATUS_BAR_HEGHT, 44, 44);
    [self.navigationBar addSubview:_ActivityIndicator];
    _ActivityIndicator.hidden = YES;
    [_ActivityIndicator startAnimating];
    
    [self.navigationBar setBarRightButtonItem:self selector:@selector(reloadHomeUrl) imageKey:@"ic_actbar_refresh"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (_counter < 0) {
        _counter = 0;
        [self reloadHomeUrl];
    } else {
        NSDate *lastLoadTime = [[NSUserDefaults standardUserDefaults] objectForKey:kLastLoadCustomerTime];
        NSInteger interval = [lastLoadTime timeIntervalSinceNow];
        if (interval <= MIAPP_TEN_MIN_INTERVAL) {
            [self reloadHomeUrl];
            [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:kLastLoadCustomerTime];
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.navigationBar.rightButton.hidden = NO;
    _ActivityIndicator.hidden = YES;
    [_ActivityIndicator removeFromSuperview];
    NSString *url = _webView.request.URL.absoluteString;
    NSRegularExpression *sclickRegExp = [NSRegularExpression regularExpressionWithPattern:[MIConfig globalConfig].live800CachedReg options:NSRegularExpressionCaseInsensitive error: nil];
    NSUInteger matches = [sclickRegExp numberOfMatchesInString:url options:NSMatchingReportCompletion range:NSMakeRange(0, url.length)];
    if (matches > 0) {
        if (_activateTimer == nil || !_activateTimer.isValid) {
            _counter = 9;
            _activateTimer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(counterTimer) userInfo:nil repeats:YES];
        }
    }
}

- (void)miPopToPreviousViewController
{
    if ([_webView canGoBack] && !_isLive800)
    {
        [_webView goBack];
        self.navigationBar.closeButton.hidden = NO;
    }
    else
    {
        self.navigationBar.closeButton.hidden = YES;
        [[MINavigator navigator] closePopViewControllerAnimated:YES];
    }
}

- (void)counterTimer
{
    _counter--;
    if (_counter < 0) {
        [_activateTimer invalidate];
        _activateTimer = nil;
    }
}

#pragma - mark UIWebViewDelegate
- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request
 navigationType:(UIWebViewNavigationType)navigationType {
    if ([super webView:webView shouldStartLoadWithRequest:request navigationType:navigationType]) {
        NSString *url = request.URL.absoluteString;
        NSRegularExpression *sclickRegExp = [NSRegularExpression regularExpressionWithPattern:[MIConfig globalConfig].live800CachedReg options:NSRegularExpressionCaseInsensitive error: nil];
        NSUInteger matches = [sclickRegExp numberOfMatchesInString:url options:NSMatchingReportCompletion range:NSMakeRange(0, url.length)];
        if (matches > 0 || [url rangeOfString:@"live800"].location != NSNotFound) {
            _isLive800 = YES;
        } else if ([url rangeOfString:WEBVIEW_COMPLETE_URL].location == NSNotFound) {
            _isLive800 = NO;
        }
        
        if ([url rangeOfString:@"complete"].location == NSNotFound) {
            if (_ActivityIndicator.superview == nil) {
                [self.navigationBar addSubview:_ActivityIndicator];
            }
            _ActivityIndicator.hidden = NO;
            self.navigationBar.rightButton.hidden = YES;
        }
        
        [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:kLastLoadCustomerTime];
        return YES;
    } else {
        return NO;
    }
}

- (void)webViewDidFinishLoad:(UIWebView*)webView {
    [super webViewDidFinishLoad:webView];
    self.navigationBar.rightButton.hidden = NO;
    _ActivityIndicator.hidden = YES;
}

- (void)webView:(UIWebView*)webView didFailLoadWithError:(NSError*)error {
    [super webView:webView didFailLoadWithError:error];
    self.navigationBar.rightButton.hidden = NO;
    _ActivityIndicator.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    [_webView stopLoading];
    [_webView loadHTMLString:@"" baseURL:nil];
    [_activateTimer invalidate];
    _activateTimer = nil;
    _counter = 0;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


@end
