//
//  BBMainWebview.m
//  BeiBeiAPP
//
//  Created by 徐 裕健 on 14/10/28.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MIMainWebview.h"
//#import "BBMartshowViewController.h"

@implementation MIMainWebview
@synthesize homeURL = _homeURL;
@synthesize loadingURL = _loadingURL;
@synthesize itemImageUrl = _itemImageUrl;

- (void)stopAction {
    [_webView stopLoading];
}

- (void)refreshAction {
    [self.overlayView setOverlayStatus:EOverlayStatusLoading labelText:nil];
    [_webView loadRequest:[NSURLRequest requestWithURL:self.URL]];
}

- (void)shareAction:(id) params {
    NSString *platform;
    NSString *title;
    NSString *desc;
    NSString *smallImg;
    NSString *largeImg;
    NSString *comment;
    
    if (params != nil && [params isKindOfClass:[NSString class]]) {
        _itemUrl = [MIUtility getParamValueFromUrl:params paramName:@"url"];
        NSString *pid = [MIUtility getParamValueFromUrl:params paramName:@"pid"];
        if (pid != nil && pid.length > 0) {
            _itemUrl = [NSString stringWithFormat:@"%@&pid=%@", _itemUrl, pid];
        }
        title = [MIUtility getParamValueFromUrl:params paramName:@"title"];
        desc = [MIUtility getParamValueFromUrl:params paramName:@"desc"];
        smallImg = [MIUtility getParamValueFromUrl:params paramName:@"small_img"];
        largeImg = [MIUtility getParamValueFromUrl:params paramName:@"large_img"];
        comment = [MIUtility getParamValueFromUrl:params paramName:@"comment"];
        platform = [MIUtility getParamValueFromUrl:params paramName:@"platform"];
        if (platform == nil || platform.length == 0) {
            platform = @"qzone_timeline_weibo";
        }
    } else if ([_loadingURL.host hasSuffix:@"mizhe.com"]) {
        NSString *shareContent = [_webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('app_share_conf').getAttribute('value')"];
        if (shareContent != nil && shareContent.length) {
            NSDictionary *shareContentDict = [NSJSONSerialization JSONObjectWithData:[shareContent dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
            if (shareContentDict != nil) {
                _itemUrl = [shareContentDict objectForKey:@"url"];
                title = [shareContentDict objectForKey:@"title"];
                desc = [shareContentDict objectForKey:@"desc"];
                smallImg = [shareContentDict objectForKey:@"image"];
                largeImg = [shareContentDict objectForKey:@"image"];
                platform = [shareContentDict objectForKey:@"platform"];
            }
        }
    }
    
    if (platform == nil || platform.length == 0) {
        platform = @"qq_qzone_weixin_timeline_weibo_copy_refresh";
    }
    _itemUrl = _itemUrl.length ? _itemUrl : self.URL.absoluteString;
    title = title ? title : self.webPageTitle;
    desc = desc ? desc : @"米折网(mizhe.com),千万女性专属的优品特卖会！拥有专业的买手团队，与数十万淘宝卖家进行合作，每天10点千款上新，全场包邮，10元购和品牌特卖准时开抢，快去看看吧。";
    comment = comment ? comment: @"米折APP，千万女性专属的优品特卖会，省钱就在弹指间！";
    smallImg = smallImg ? smallImg : [MIConfig globalConfig].appSharePicURL;
    largeImg = largeImg ? largeImg : [MIConfig globalConfig].appSharePicLargeURL;
    [self.itemImageView sd_setImageWithURL:[NSURL URLWithString:smallImg] placeholderImage:[UIImage imageNamed:@"app_share_pic"]];
    [MINavigator showShareActionSheetWithUrl:_itemUrl title:title desc:desc comment:comment image:self.itemImageView smallImg:smallImg largeImg:largeImg inView:self.window platform:platform];
}

#pragma mark - Public

- (NSURL *)URL {
    NSURL *url = _loadingURL ? _loadingURL : _webView.request.URL;
    if (url == nil || url.absoluteString.length == 0) {
        url = self.homeURL;
    }
    return url;
}

- (NSURL *)loadingURL {
    NSURL *url = _loadingURL ? _loadingURL : _webView.request.URL;
    return url;
}

- (void)openURL:(NSURL*)URL {
    _loadingURL = URL;
    [self openRequest:[NSMutableURLRequest requestWithURL:URL]];
}

- (void)openRequest:(NSURLRequest*)request {
    if(_webView) {
        [self.overlayView setOverlayStatus:EOverlayStatusLoading labelText:nil];
        [_webView loadRequest:request];
    }
}

- (void)reloadWebview
{
    [self refreshAction];
}

#pragma mark - UIView

- (id)initWithURL:(NSURL*)URL frame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.homeURL = URL;
        _userInfoRequest = [[MIUserGetRequest alloc] init];
        _userInfoRequest.onCompletion = ^(MIUserGetModel * model) {
            [[MIMainUser getInstance] saveUserInfo:model];
        };
        _userInfoRequest.onError = ^(MKNetworkOperation* completedOperation, MIError* error) {
            MILog(@"error_msg=%@",error.description);
        };
        
        _overlayView = [[MIOverlayStatusView alloc] initWithFrame:CGRectMake(0, 0, self.viewWidth, self.viewHeight)];
        _overlayView.delegate = self;
        [self addSubview:_overlayView];
        
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.viewWidth, self.viewHeight)];
        _webView.scrollView.backgroundColor = [UIColor whiteColor];
        _webView.scrollView.delegate = self;
        _webView.scrollView.scrollsToTop = NO;
        _webView.delegate = self;
        _webView.scalesPageToFit = YES;
        [self addSubview:_webView];
        
        _refreshTableView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, -104, self.viewWidth, 104)];
        _refreshTableView.delegate = self;
        [_webView.scrollView addSubview:_refreshTableView];
        
        
        //返回顶部
        _goTopView = [[MIGoTopView alloc] initWithFrame:CGRectMake(self.viewWidth - 50, self.bottom - 10 - 40, 40, 40)];
        _goTopView.delegate = self;
        _goTopView.hidden = YES;
        [self addSubview:_goTopView];
        
        _buttomPullDistance = 50.0;
        _itemImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"app_share_pic"]];
        NSString *defaultUserAgent = [[NSUserDefaults standardUserDefaults] stringForKey:kDefaultUserAgent];
        NSDictionary *dictionnary = [[NSDictionary alloc] initWithObjectsAndKeys:defaultUserAgent, @"UserAgent", nil];
        [[NSUserDefaults standardUserDefaults] registerDefaults:dictionnary];
    }
    
    return self;
}

- (void)willAppearView
{
    _webView.scrollView.scrollsToTop = YES;
    if (!self.loadingURL) {
        [self openURL:self.homeURL];
    }
}

- (void)willDisappearView
{
    _webView.scrollView.scrollsToTop = NO;
}

- (void)goTopViewClicked
{
    [_webView.scrollView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    _goTopView.hidden = YES;
}

- (void)motionBegan
{
    if (shakeEnable) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"shake_sound_male" ofType:@"m4r"];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &soundID);
    }
}

- (void)motionEnded
{
    if (shakeEnable)
    {
        MILog(@"callback = %@", shakeCallback);
        shakeEnable = NO;
        AudioServicesPlayAlertSound(soundID);
        if (shakeCallback) {
            [_webView stringByEvaluatingJavaScriptFromString:shakeCallback];
            shakeCallback = nil;
        }
    }
}

- (void)motionCancelled
{
    if (soundID != 0) {
        soundID = 0;
        AudioServicesDisposeSystemSoundID(soundID);
    }
}

- (void)reloadTableViewDataSource
{
    [self.overlayView setOverlayStatus:EOverlayStatusLoading labelText:nil];
    [self openURL:self.homeURL];
}

- (void)reloadTableViewDataSource:(MIOverlayView *)overView
{
    [self reloadTableViewDataSource];
}

#pragma mark - UIScrollViewDelegate Methods
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_refreshTableView egoRefreshScrollViewDidScroll:scrollView];
    
    CGFloat y = scrollView.contentOffset.y;
    if (y < _lastscrollViewOffset - 15) {
        [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
            if (y > self.viewHeight - 45)
            {
                _goTopView.hidden = NO;
            }
            else
            {
                _goTopView.hidden = YES;
            }
        } completion:^(BOOL finished){
        }];
    } else if (y > _lastscrollViewOffset + 5 && y > 0){
        [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
            _goTopView.hidden = YES;
        } completion:^(BOOL finished){
        }];
    }
    
    if (y < _lastscrollViewOffset - 15) {
        [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
            if (y > self.viewHeight - 45)
            {
                _goTopView.hidden = NO;
            }
            else
            {
                _goTopView.hidden = YES;
            }
        } completion:^(BOOL finished){
        }];
    }
    
    _lastscrollViewOffset = y;
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_refreshTableView egoRefreshScrollViewDidEndDragging:scrollView];
}

#pragma mark - EGORefreshTableHeaderDelegate Methods
//下拉被触发调用的委托方法
-(void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view
{
    [self reloadTableViewDataSource];
}

//返回当前是刷新还是无刷新状态
-(BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView *)view
{
    return _loading;
}

//更新下拉刷新提示文案
-(NSString *)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView *)view
{
    NSString *header;
    NSInteger random = arc4random();
    if (random % 2) {
        header = @"特卖天天有，下单就包邮";
    } else {
        header = @"限时特卖，每天十点上新";
    }
    return header;
}
#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request
 navigationType:(UIWebViewNavigationType)navigationType {
    NSString *host = request.URL.host;
    NSString *url = request.URL.absoluteString;
    MILog(@"webview shouldStartLoadWithRequest url = %@", request.URL.absoluteString);
    
    NSRegularExpression *appDownloadRegExp = [NSRegularExpression regularExpressionWithPattern:[MIConfig globalConfig].appDl options:NSRegularExpressionCaseInsensitive error: nil];
    NSUInteger matches = [appDownloadRegExp numberOfMatchesInString:url options:NSMatchingReportCompletion range:NSMakeRange(0, [url length])];
    if (matches > 0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        return NO;
    }
    
    if ([host hasSuffix:@"mizhe.com"] && [url rangeOfString:@"mizheapp_info=" options:NSCaseInsensitiveSearch].location != NSNotFound) {
        //处理贝贝相关链接，跳转到本地相关页面
        NSString *mizheappInfo;
        NSString *fragment = request.URL.fragment;
        NSMutableString *mizheUrl = [NSMutableString stringWithString:url];
        if (fragment) {
            fragment = [NSString stringWithFormat:@"#%@", fragment];
            mizheappInfo = [mizheUrl stringByReplacingOccurrencesOfString:fragment withString:@""];
            mizheappInfo = [MIUtility getParamValueFromUrl:mizheappInfo paramName:@"mizheapp_info"];
        } else {
            mizheappInfo = [MIUtility getParamValueFromUrl:mizheUrl paramName:@"mizheapp_info"];
        }
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[mizheappInfo dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
        if (dic != nil) {
            [MINavigator openShortCutWithDictInfo:dic];
            return NO;
        } else {
            _loadingURL = webView.request.URL;
            return YES;
        }
    } else if ([url hasPrefix:@"mizhe://action?"]) {
        [self beibeiAction:url];
        return NO;
    } else if ([url hasPrefix:@"tel://"]) {
        if ([[UIApplication sharedApplication] canOpenURL:request.URL]) {
            [[UIApplication sharedApplication] openURL:request.URL];
        } else {
            [MINavigator showSimpleHudTips:@"你的手机未能拨打电话"];
        }
        return NO;
    } else if ([url hasPrefix:@"mqqwpa://"]) {
        NSURL *qqWpaURL = [NSURL URLWithString:url];
        if ([[UIApplication sharedApplication] canOpenURL:qqWpaURL]) {
            [[UIApplication sharedApplication] openURL:qqWpaURL];
        } else {
            NSString *uin = [MIUtility getParamValueFromUrl:url paramName:@"uin"];
            UIAlertView *alertView = [[UIAlertView alloc] initWithMessage:[NSString stringWithFormat:@"你还没安装qq客户端，我们在线QQ客服为：%@", uin]];
            [alertView show];
        }
        return NO;
    } else if ([MIUtility isAppURL:request.URL]) {
        return NO;
    } else {
        _loadingURL = webView.request.URL;
        return YES;
    }
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    _loading = YES;
}

- (void)webViewDidFinishLoad:(UIWebView*)webView {
    [_refreshTableView egoRefreshScrollViewDataSourceDidFinishedLoading:webView.scrollView];
    self.webPageTitle = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    MILog(@"webPageTitle=%@", self.webPageTitle);
    MILog(@"webview webViewDidFinishLoad url = %@", webView.request.URL.absoluteString);
    [self.overlayView setOverlayStatus:EOverlayStatusRemove labelText:nil];
    _loadingURL = webView.request.URL;
    _loading = NO;
}

- (void)webView:(UIWebView*)webView didFailLoadWithError:(NSError*)error {
    [_refreshTableView egoRefreshScrollViewDataSourceDidFinishedLoading:webView.scrollView];
    [self.overlayView setOverlayStatus:EOverlayStatusRemove labelText:nil];
    _loading = NO;

    //非网络原因
    if(error.code != -999 && error.code != 102 && error.code != 101) {
        //服务器页面抛出错误error，-999属于请求未完成（刷新过快），101属于网络错误，102属于主动中断载入
        //此两个错误不做异常处理
        [self.overlayView setOverlayStatus:EOverlayStatusReload labelText:nil];
    }
}

- (void)beibeiAction:(NSString *)schemes {
    NSString *target = [MIUtility getParamValueFromUrl:schemes paramName:@"target"];
    if ([target isEqualToString:@"shake"]) {
        //使能客户端开始监听摇一摇的动作
        NSString *state = [MIUtility getParamValueFromUrl:schemes paramName:@"state"];
        if ([state isEqualToString:@"relisten"]) {
            [self playsound];//播放摇奖结果提示音
        }
        
        NSString *appsScore = [MIUtility getParamValueFromUrl:schemes paramName:@"appsScore"];
        if ([appsScore isEqualToString:@"yes"]) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kShowGradeAlertView];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        shakeEnable = YES;
        shakeCallback = [MIUtility getParamValueFromUrl:schemes paramName:@"callback"];
    } else if ([target isEqualToString:@"playsound"]) {
        [self playsound];
    } else if ([target isEqualToString:@"share"]) {
        //表示需要分享
        shareEnable = YES;
        shareCallback = [MIUtility getParamValueFromUrl:schemes paramName:@"callback"];
        [self shareAction:schemes];
    } else if ([target isEqualToString:@"appsScore"]) {
        //提示用户去App Store评分
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kShowGradeAlertView];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else if ([target isEqualToString:@"appsRecommend"]) {
        //推荐APP下载提示
        NSString *appUrl = [MIUtility getParamValueFromUrl:schemes paramName:@"appUrl"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appUrl]];
    } else if ([target isEqualToString:@"refreshUserInfo"] && [[MIMainUser getInstance] checkLoginInfo]) {
        //需要刷新账号信息
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kShowGradeAlertView];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [_userInfoRequest sendQuery];
    } else if ([target isEqualToString:@"refresh"]) {
        //需要刷新当前页面
        [_webView reload];
    } else if ([target isEqualToString:@"login"]) {
        loginCallback = [MIUtility getParamValueFromUrl:schemes paramName:@"callback"];
        if ([[MIMainUser getInstance] checkLoginInfo]) {
            [self loginCallback];
        } else {
            [MINavigator openLoginViewController];
        }
    } else if ([target isEqualToString:@"checkApp"]) {
        NSString *scheme = [MIUtility getParamValueFromUrl:schemes paramName:@"scheme"];
        NSString *callback = [MIUtility getParamValueFromUrl:schemes paramName:@"callback"];
        if (scheme && callback) {
            scheme = [NSString stringWithFormat:@"%@://", scheme];
            BOOL checkApp = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:scheme]];
            NSString *checkAppCallback = [NSString stringWithFormat:@"%@(%d)", callback, checkApp];
            [_webView stringByEvaluatingJavaScriptFromString:checkAppCallback];
        }
    } else if ([target isEqualToString:@"checkLogin"]) {
        NSString *callback = [MIUtility getParamValueFromUrl:schemes paramName:@"callback"];
        NSString *loginInfo = [NSString stringWithFormat:@"%@(%d)", callback, [[MIMainUser getInstance] checkLoginInfo]];
        [_webView stringByEvaluatingJavaScriptFromString:loginInfo];
    } else if ([target isEqualToString:@"tabs"]) {
        NSString *tab = [MIUtility getParamValueFromUrl:schemes paramName:@"tab"];
        [MINavigator openShortCutWithDictInfo:@{@"target": target, @"desc": tab}];
    } else if ([target isEqualToString:@"viewController"]) {
        NSString *viewcontroller = [MIUtility getParamValueFromUrl:schemes paramName:@"vc"];
        Class viewControllerClass = NSClassFromString(viewcontroller);
        id obj = [[viewControllerClass alloc] init];
        if (obj) {
            [[MINavigator navigator] openPushViewController:(UIViewController *)obj animated:YES];
        }
    } else if ([target isEqualToString:@"clientInfo"]) {
        NSString *callback = [MIUtility getParamValueFromUrl:schemes paramName:@"callback"];
        NSData *clientInfoData = [NSJSONSerialization dataWithJSONObject:[MIConfig getClientInfo] options:NSJSONWritingPrettyPrinted error:nil];
        if (clientInfoData && callback) {
            NSString *javaScript = [clientInfoData javaScriptStringEncodeWithCallback:callback];
            [_webView stringByEvaluatingJavaScriptFromString:javaScript];
        }
    } else {
        MILog(@"undefined");
    }
}

- (void)playsound
{
    SystemSoundID soundId;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"shake_match" ofType:@"m4r"];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &soundId);
    AudioServicesPlayAlertSound(soundId);
}

- (void)loginSuccess
{
    if (loginCallback) {
        [self performSelector:@selector(loginCallback) withObject:nil afterDelay:0.2];
    } else {
        [self openURL:_homeURL];
    }
}

- (void)loginCallback
{
    NSTimeInterval a = [[NSDate date] timeIntervalSince1970];
    NSString * ts = [NSString stringWithFormat:@"%.0f", a];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   [MIMainUser getInstance].sessionKey, @"session",
                                   ts, @"ts",
                                   [MIMainUser getInstance].userId.stringValue, @"uid",
                                   [MIConfig getUDID], @"udid", nil];
    NSString *signature = [MIUtility getSignWithDictionary:params];
    [params setObject:signature forKey:@"sign"];
    NSData *loginInfoData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
    NSString *javaScript = [loginInfoData javaScriptStringEncodeWithCallback:loginCallback];
    [_webView stringByEvaluatingJavaScriptFromString:javaScript];
    loginCallback = nil;
}

- (void)shareSuccess
{
    MILog(@"shareEnable = %d, callback = %@", shareEnable, shareCallback);
    
    if (shareEnable && shareCallback) {
        [self performSelector:@selector(callbackShare) withObject:nil afterDelay:0.2];
    }
}

- (void)callbackShare
{
    MILog(@"callback = %@", shareCallback);
    
    [_webView stringByEvaluatingJavaScriptFromString:shareCallback];
    [self shareCancel];
}

- (void)shareCancel
{
    shareCallback = nil;
    shareEnable = NO;
}

@end
