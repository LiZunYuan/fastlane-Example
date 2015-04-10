//
//  MITbWebViewController.m
//  MISpring
//
//  Created by lsave on 13-3-27.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//


#import "MIUtility.h"
#import "MIUITextButton.h"
#import "MTStatusBarOverlay.h"
#import "MIAppDelegate.h"
#import "MIUserGetRequest.h"
#import "MIUserGetModel.h"

@implementation MITbWebViewController
@synthesize numiid = _numiid;
@synthesize titleLabel = _titleLabel;
@synthesize productTitle = _productTitle;
@synthesize getTbkClickUrlRequest = _getTbkClickUrlRequest;

- (id) initWithURL: (NSURL*)URL
{
    if (self = [super init]) {
        NSMutableString * absoluteUrlString = [URL.absoluteString mutableCopy];
        if ([absoluteUrlString rangeOfString: kTtid].location == NSNotFound &&
            ([absoluteUrlString rangeOfString: @"taobao.com"].location != NSNotFound
             || [absoluteUrlString rangeOfString: @"tmall.com"].location != NSNotFound)) {
            if (URL.query == nil) {
                [absoluteUrlString appendFormat:@"?%@", kTtid];
            } else {
                [absoluteUrlString appendFormat:@"&%@", kTtid];
            }
        }
        
        self.tag = @"";
        self.originalUrl = absoluteUrlString;
        self.itemImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"app_share_pic"]];
        NSString *defaultUserAgent = [[NSUserDefaults  standardUserDefaults] stringForKey:kDefaultUserAgent];
        NSDictionary *dictionnary = [[NSDictionary alloc] initWithObjectsAndKeys:defaultUserAgent, @"UserAgent", nil];
        [[NSUserDefaults standardUserDefaults] registerDefaults:dictionnary];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *num_iid = self.numiid ? self.numiid : [MIUtility getNumiidFromUrl:self.originalUrl];
    if (num_iid && num_iid.length >= 5 && ![num_iid isEqualToString:@"400000"]) {
        __weak typeof(self) weakSelf = self;
        [self setOverlayStatus:EOverlayStatusLoading labelText:nil];
        _getTbkClickUrlRequest = [[MIGetTbkClickRequest alloc] initWithTag:self.tag numiid:num_iid];
        [_getTbkClickUrlRequest setOnCompletionHandler:^(NSString *tbkUrl) {
            [weakSelf loadUrl:tbkUrl];
        }];
        [_getTbkClickUrlRequest setOnErrorHandler:^{
            [weakSelf loadUrl:weakSelf.originalUrl];
        }];
        [_getTbkClickUrlRequest sendQuery];
    } else {
        [self loadUrl:self.originalUrl];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [_getTbkClickUrlRequest cancelRequest];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [_webView stopLoading];
    [NSObject cancelPreviousPerformRequestsWithTarget:_webView];
}

- (void)refreshAction {
    [_webView stopLoading];
    [_webView loadRequest:[NSURLRequest requestWithURL:self.URL]];
}

- (void)reloadHomeUrl
{    
    [_webView loadRequest:[[NSURLRequest alloc] initWithURL:self.URL]];
}

- (void)loadUrl:(NSString *)url {
    [self setOverlayStatus:EOverlayStatusLoading labelText:nil];
    self.homeURL = [NSURL URLWithString:url];
    if (self.homeURL != nil) {
        [self openURL:self.homeURL];
    }
}

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request
 navigationType:(UIWebViewNavigationType)navigationType
{
    if ([super webView:webView shouldStartLoadWithRequest:request navigationType:navigationType]) {
        NSString *url = request.URL.absoluteString;
        NSRegularExpression *sclickRegExp = [NSRegularExpression regularExpressionWithPattern:[MIConfig globalConfig].appDl options:NSRegularExpressionCaseInsensitive error: nil];
        NSUInteger matches = [sclickRegExp numberOfMatchesInString:url options:NSMatchingReportCompletion range:NSMakeRange(0, [url length])];
        if (matches > 0) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
            return NO;
        } else {
            NSUserDefaults * standardUserDefaults = [NSUserDefaults standardUserDefaults];
            if (![standardUserDefaults boolForKey:@"taobao_rebate_tips"] && [url hasPrefix:@"http://ai.m.taobao.com"]) {
                [standardUserDefaults setBool:YES forKey:@"taobao_rebate_tips"];
                [standardUserDefaults synchronize];
                
                MIButtonItem *cancelItem = [MIButtonItem itemWithLabel:@"跳过"];
                cancelItem.action = nil;
                
                MIButtonItem *affirmItem = [MIButtonItem itemWithLabel:@"去看看"];
                affirmItem.action = ^{
                    NSString *fanliCourse = @"http://h5.mizhe.com/help/course.html";
                    MITbWebViewController* vc = [[MITbWebViewController alloc] initWithURL:[NSURL URLWithString:fanliCourse]];
                    vc.webTitle = @"淘宝返利教程";
                    [[MINavigator navigator] openPushViewController:vc animated:YES];
                };
                
                UIAlertView *alertTip = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                   message:@"根据淘宝返利规则调整，米姑娘辛苦制作了淘宝返利教程宝典，要仔细看看了哦~"
                                                          cancelButtonItem:cancelItem
                                                          otherButtonItems:affirmItem, nil];
                [alertTip show];
            } else if ([request.URL.host hasSuffix:@"beibei.com"]) {
                // 如果进入贝贝特卖h5页面，是否提醒用户下载贝贝客户端
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                NSNumber *alertShowTimes = [userDefaults objectForKey:@"beibeiAlertShowTimes"];
                NSDate *lastAlertShowTime = [userDefaults objectForKey:@"lastAlertShowTime"];
                NSInteger beibeiAlertShowTimes = alertShowTimes.intValue;
                NSInteger muYingclicks = [userDefaults integerForKey:kMuyingItemClicksCount];
                if (muYingclicks >= 5 && [[Reachability reachabilityForInternetConnection] isReachableViaWiFi] &&
                    (!lastAlertShowTime || ![lastAlertShowTime compareWithToday] == 0) && beibeiAlertShowTimes < 3) {
                    MIButtonItem *cancelItem = nil;
                    if (beibeiAlertShowTimes < 2) {
                        cancelItem  = [MIButtonItem itemWithLabel:@"取消"];
                        [MobClick event:@"kAppAdClicks" label:@"取消"];
                    }
                    else{
                        cancelItem = [MIButtonItem itemWithLabel:@"忽略"];
                        [MobClick event:@"kAppAdClicks" label:@"忽略"];
                    }
                    MIButtonItem *affirmItem = [MIButtonItem itemWithLabel:@"去下载"];
                    affirmItem.action = ^{
                        [MobClick event:@"kAppAdClicks" label:@"去下载"];
                        NSString *itunes = @"https://itunes.apple.com/app/id%@?mt=8";
                        NSString *beibei = [NSString stringWithFormat:itunes, [MIConfig globalConfig].beibeiAppID];
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:beibei]];
                    };
                    
                    UIAlertView* beibeiAlert = [[UIAlertView alloc] initWithTitle:@"米姑娘提示"
                                                                          message:[MIConfig globalConfig].beibeiAppSlogan
                                                                 cancelButtonItem:cancelItem
                                                                 otherButtonItems:affirmItem, nil];
                    
                    [beibeiAlert show];
                    [userDefaults setObject:[NSDate date] forKey:@"lastAlertShowTime"];
                    [userDefaults setObject:@(++ beibeiAlertShowTimes) forKey:@"beibeiAlertShowTimes"];
                    [userDefaults synchronize];
                }
            }
            
//            if (self.tipsView) {
//                NSString *num_iid = [MIUtility getNumiidFromUrl:url];
//                if (num_iid && ([self.brandNumiid isEqualToString:num_iid] || [self.tuanNumiid isEqualToString:num_iid])) {
//                    [self showTips];
//                } else {
//                    [self hideTips];
//                }
//            }
            _loadingURL = webView.request.URL;
            return YES;
        }
    } else {
        return NO;
    }
}

- (void)webViewDidFinishLoad:(UIWebView*)webView {
    [super webViewDidFinishLoad:webView];
    [MIUtility hideTaobaoSmartAd:webView];
    [MIUtility hideTmallSmartAd:webView];

    _loadingURL = webView.request.URL;
}

//- (void) showTips
//{
//    self.tipsView.alpha = 1;
//    [UIView animateWithDuration:0.35 animations:^{
//        self.tipsView.left = PHONE_SCREEN_SIZE.width - self.tipsView.viewWidth;
//    }];
//}
//
//- (void) hideTips
//{
//    [UIView animateWithDuration:0.35 animations:^{
//        self.tipsView.left = PHONE_SCREEN_SIZE.width;
//    } completion:^(BOOL finished) {
//        self.tipsView.alpha = 0;
//    }];
//}
@end
