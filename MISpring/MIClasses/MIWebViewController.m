//
//  MIWebViewController.m
//  MISpring
//
//  Created by XU YUJIAN on 13-1-25.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIWebViewController.h"
#import "Reachability.h"
#import "TencentOpenAPI/QQApiInterface.h"
#import "WXApi.h"
#import "MISinaWeibo.h"
#import "MITencentAuth.h"
#import "MIShareViewController.h"
#import "MIZhiDetailViewController.h"
#import "MIUserGetRequest.h"
#import "NJKWebViewProgress.h"
#import "MIStatusBarOverlay.h"
#import "MizheFramework/HusorEncrypt.h"
#import "MIAppDelegate.h"
#import "MISecurityAccountViewController.h"

#define MIBASE_WEBVIEW_TOOLBAR_HEIHGT 32

@implementation MIWebViewController
@synthesize homeURL = _homeURL;
@synthesize webTitle = _webTitle;
@synthesize itemImageView = _itemImageView;

#pragma mark - Private
- (void)backAction {
    [_webView goBack];
}

- (void)forwardAction {
    [_webView goForward];
}

- (void)shareAction:(id) params {
    NSString *title;
    NSString *desc;
    NSString *smallImg;
    NSString *largeImg;
    NSString *comment;
    NSString *platform;
    NSString *callback;
    
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
        
        callback = [MIUtility getParamValueFromUrl:params paramName:@"callback"];
    } else {
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
                callback = [shareContentDict objectForKey:@"callback"];
            }
        } else {
            _itemUrl = self.URL.absoluteString;
            smallImg = [MIConfig globalConfig].appSharePicURL;
            largeImg = [MIConfig globalConfig].appSharePicLargeURL;

            NSString *num_iid = [MIUtility getNumiidFromUrl:_itemUrl];
            if (num_iid) {
                NSString *encryptUseDES = [MIUtility encryptUseDES:[[MIMainUser getInstance].userId stringValue]];
                NSNumber *kid = @([[HusorEncrypt getInstance] getKeyId]);
                _itemUrl = [NSString stringWithFormat:@"http://m.mizhe.com/share/t.html?iid=%@&pid=%@&kid=%@", num_iid, encryptUseDES, kid];
                
                if (_webPageTitle != nil && _webPageTitle.length > 5) {
                    NSMutableString *subTitle = [NSMutableString stringWithString:_webPageTitle];
                    if ([subTitle hasPrefix:@"手机淘宝网-"]) {
                        [subTitle replaceOccurrencesOfString:@"手机淘宝网-"
                                                  withString:@""
                                                     options:NSCaseInsensitiveSearch
                                                       range:NSMakeRange(0, subTitle.length)];
                    }
                    
                    if ([subTitle hasPrefix:@"天猫触屏版-"]) {
                        [subTitle replaceOccurrencesOfString:@"天猫触屏版-"
                                                  withString:@""
                                                     options:NSCaseInsensitiveSearch
                                                       range:NSMakeRange(0, subTitle.length)];
                        
                    }
                    
                    title = subTitle;
                }
            }
        }
    }
    
    if (platform == nil || platform.length == 0) {
        platform = @"qq_qzone_weixin_timeline_weibo_copy_refresh";
    }
    
    if (callback != nil && callback.length > 0) {
        shareEnable = YES;
        shareCallback = callback;
    }
    
    _itemUrl = _itemUrl.length ? _itemUrl : self.URL.absoluteString;
    title = title ? title : self.webPageTitle;
    if (title ==nil || title.length == 0) {
        title = @"米折网，女性专属优品特卖网站";//@"米折APP，千万女性专属的优品特卖会，省钱就在弹指间！";
    }
    desc = desc ? desc : @"国内最大的女性特卖网站，致力于为年轻女性提供时尚又实惠的专属特卖服务！每天10点开抢，不见不散~";
    comment = comment ? comment: @"米折APP，千万女性专属的优品特卖会，省钱就在弹指间！";
    smallImg = smallImg ? smallImg : [MIConfig globalConfig].appSharePicURL;
    largeImg = largeImg ? largeImg : [MIConfig globalConfig].appSharePicLargeURL;
    [self.itemImageView sd_setImageWithURL:[NSURL URLWithString:smallImg]
                       placeholderImage:[UIImage imageNamed:@"app_share_pic"]];
    [MINavigator showShareActionSheetWithUrl:_itemUrl title:title desc:desc comment:comment image:self.itemImageView smallImg:smallImg largeImg:largeImg inView:self.view platform:platform];
}

- (void)refreshAction {
    [_webView loadRequest:[NSURLRequest requestWithURL:self.URL]];
}

- (void)stopAction {
    [_webView stopLoading];
}

#pragma mark - Public

- (NSURL *)URL {
    NSURL *url = _loadingURL ? _loadingURL : _webView.request.URL;
    if (url == nil || url.absoluteString.length == 0) {
        url = self.homeURL;
    }
    return url;
}

- (void)openURL:(NSURL*)URL {
    _loadingURL = URL;
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
        _itemImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"app_share_pic"]];
        
        NSString *defaultUserAgent = [[NSUserDefaults standardUserDefaults] stringForKey:kDefaultUserAgent];
        NSDictionary *dictionnary = [[NSDictionary alloc] initWithObjectsAndKeys:defaultUserAgent, @"UserAgent", nil];
        [[NSUserDefaults standardUserDefaults] registerDefaults:dictionnary];
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGFloat ww = PHONE_SCREEN_SIZE.width;
    CGFloat wh = self.view.viewHeight;
    
    [self.navigationBar setBarTitle:_webTitle];
    [self.navigationBar setBarRightButtonItem:self selector:@selector(shareAction:) imageKey:@"ic_detail_share"];
    [self.navigationBar setBarCloseTextButtonItem:self selector:@selector(popViewController) title:@"关闭"];
    self.navigationBar.closeButton.hidden = YES;
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, self.navigationBarHeight, ww, wh-self.navigationBarHeight)];
    _webView.scrollView.backgroundColor = [MIUtility colorWithHex:0xeeeeee];
    _webView.scrollView.delegate = self;
    _webView.scalesPageToFit = YES;
    [self.view addSubview:_webView];
    [self.view bringSubviewToFront:self.navigationBar];
    
    _progressView= [[UIView alloc] init];
    _progressView.frame = CGRectMake(0, self.navigationBarHeight, 0, 2);
    _progressView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:_progressView];

    _progressProxy = [[NJKWebViewProgress alloc] init];
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    _webView.delegate = _progressProxy;
    
    if (_homeURL != nil) {
        [self openURL:_homeURL];
        [self setOverlayStatus:EOverlayStatusLoading labelText:nil];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (loginCallback && [[MIMainUser getInstance] checkLoginInfo]) {
        [self loginCallback];
    }
    
    [self registerNotifications];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // If the browser launched the media player, it steals the key window and never gives it
    // back, so this is a way to try and fix that
    [self.view.window makeKeyWindow];
    [self removeNotifications];
}

- (void) viewDidDisappear:(BOOL)animated
{
    [self resignFirstResponder];
    
    [super viewDidDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [self becomeFirstResponder];
    
    [super viewDidAppear:animated];
}

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (shakeEnable) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"shake_sound_male" ofType:@"m4r"];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &soundID);
    }
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
	if ((motion == UIEventSubtypeMotionShake) && shakeEnable)
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

- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (soundID != 0) {
        soundID = 0;
        AudioServicesDisposeSystemSoundID(soundID);
    }
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

#pragma mark - Notification 处理
- (void)registerNotifications{
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];

    // 登录成功通知
    [defaultCenter addObserver:self selector:@selector(reloadHomeUrl) name:MiNotifyUserHasLogined object:nil];
    [defaultCenter addObserver:self selector:@selector(reloadWebview) name:MiNotifyWebViewReload object:nil];
    [defaultCenter addObserver:self selector:@selector(shareCallback) name:MiNotifyUserHasShared object:nil];
}

- (void)removeNotifications{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)reloadHomeUrl
{
    if (loginCallback) {
        [self performSelector:@selector(loginCallback) withObject:nil afterDelay:0.2];
    } else {
        [self openURL:_homeURL];
    }
}

// webView刷新
- (void)reloadWebview
{
    [_webView reload];
}

- (void)popViewController
{
    [super miPopToPreviousViewController];
}

- (void)miPopToPreviousViewController
{
    if ([_webView canGoBack])
    {
        [_webView goBack];
        self.navigationBar.closeButton.hidden = NO;
    }
    else
    {
        [super miPopToPreviousViewController];
    }
}

- (void)reloadTableViewDataSource
{
    [super reloadTableViewDataSource];
    [self openURL:self.URL];
}

#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    if (progress == 0.0) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        _progressView.viewWidth = 0;
        [UIView animateWithDuration:0.27 animations:^{
            _progressView.alpha = 1.0;
        }];
    }
    if (progress == 1.0) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [UIView animateWithDuration:0.27 delay:0 options:0 animations:^{
            _progressView.alpha = 0.0;
        } completion:nil];
    }
    
    _progressView.viewWidth = progress * self.view.viewWidth;
}

#pragma mark - UIWebViewDelegate

- (BOOL)isTaobaoURL:(NSURL*)URL {
    return [URL.scheme caseInsensitiveCompare:@"taobao"] == NSOrderedSame
    || [URL.scheme caseInsensitiveCompare:@"itaobao"] == NSOrderedSame
    || [URL.scheme caseInsensitiveCompare:[MIConfig globalConfig].taobaoSche] == NSOrderedSame;
}

- (BOOL)isTuanURL:(NSString *)url
{
    NSString * outerCode = [[MIMainUser getInstance].userId stringValue];
    if (outerCode == nil || outerCode.length == 0 || [MIConfig globalConfig].temaiRebate == FALSE) {
        outerCode = @"1";
    }
    NSString *tuOutCode = [NSString stringWithFormat:@"tu%@", outerCode];  //10元购商品
    NSString *brOutCode = [NSString stringWithFormat:@"br%@", outerCode];  //品牌特卖商品
    NSString *zhOutCode = [NSString stringWithFormat:@"zh%@", outerCode];  //超值爆料商品
    if ((([url rangeOfString:tuOutCode options:NSCaseInsensitiveSearch].location != NSNotFound || [url rangeOfString:brOutCode options:NSCaseInsensitiveSearch].location != NSNotFound) && ![MIConfig globalConfig].tuanTbApp)
        || ([url rangeOfString:zhOutCode options:NSCaseInsensitiveSearch].location != NSNotFound && ![MIConfig globalConfig].zhiTbApp)) {
        //如果属于10元购/品牌特卖/超值爆料的商品，则不跳转淘宝客户端
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request
 navigationType:(UIWebViewNavigationType)navigationType {
    NSString *mizheappInfo;
    NSString *url = request.URL.absoluteString;
    MILog(@"webview shouldStartLoadWithRequest url = %@", url);
    
    if ([MIUtility isAppURL:request.URL]) {
        //处理跳转到外部app的URL
        NSRegularExpression *sclickRegExp = [NSRegularExpression regularExpressionWithPattern:[MIConfig globalConfig].sclick options:NSRegularExpressionCaseInsensitive error: nil];
        NSUInteger matches = [sclickRegExp numberOfMatchesInString:url options:NSMatchingReportCompletion range:NSMakeRange(0, [url length])];
        if (matches > 0) {
            if ([self isTuanURL:url]) {
                NSRegularExpression *sclickRegExp = [NSRegularExpression regularExpressionWithPattern:[MIConfig globalConfig].jumpTb options:NSRegularExpressionCaseInsensitive error: nil];
                NSUInteger matches = [sclickRegExp numberOfMatchesInString:url options:NSMatchingReportCompletion range:NSMakeRange(0, [url length])];
                if (matches == 0) {
                    return NO;
                }
            }
            
            NSURL *itemURL = [request.URL copy];
            if ([url rangeOfString:@"sche=mizheapp" options:NSCaseInsensitiveSearch].location == NSNotFound) {
                itemURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@&sche=mizheapp://action", request.URL.absoluteString]];
            }
            [[UIApplication sharedApplication] performSelector:@selector(openURL:) withObject:itemURL afterDelay:0.0];
            if ([_webView canGoBack]) {
                [_webView performSelector:@selector(goBack) withObject:nil afterDelay:0.0];
            }
        } else if ([url rangeOfString:[MIConfig globalConfig].taobaoAppID options:NSCaseInsensitiveSearch].location != NSNotFound
                   || [url rangeOfString:[MIConfig globalConfig].beibeiAppID options:NSCaseInsensitiveSearch].location != NSNotFound) {
            [[UIApplication sharedApplication] performSelector:@selector(openURL:) withObject:request.URL afterDelay:0.0];
        } else if ([url hasPrefix:@"beibeiapp://"] || [url hasPrefix:@"beibeiapphd://"]) {
            [[UIApplication sharedApplication] performSelector:@selector(openURL:) withObject:request.URL afterDelay:0.0];
        } else if ([url hasPrefix:@"mqqwpa://"]) {
            NSURL *qqWpaURL = [NSURL URLWithString:url];
            if ([[UIApplication sharedApplication] canOpenURL:qqWpaURL]) {
                [[UIApplication sharedApplication] openURL:qqWpaURL];
            } else {
                NSString *uin = [MIUtility getParamValueFromUrl:url paramName:@"uin"];
                [[[UIAlertView alloc] initWithMessage:[NSString stringWithFormat:@"你还没安装qq客户端，我们在线QQ客服为：%@", uin]] show];
            }
        } else if ([url hasPrefix:@"tel://"]) {
            if ([[UIApplication sharedApplication] canOpenURL:request.URL]) {
                [[UIApplication sharedApplication] openURL:request.URL];
            } else {
                [[[UIAlertView alloc] initWithMessage:@"对不起，你的设备不支持拨号"] show];
            }
        } else {
            // 不需要外部打开
            return YES;
        }

        return NO;
    } else if ([self isTaobaoURL:request.URL]) {
        //如果是淘宝app scheme，必须跳转淘宝才能查看详情且h5还可以支持返利，则提示用户下载淘宝app
        NSRegularExpression *sclickRegExp = [NSRegularExpression regularExpressionWithPattern:[MIConfig globalConfig].jumpTb options:NSRegularExpressionCaseInsensitive error: nil];
        NSUInteger matches = [sclickRegExp numberOfMatchesInString:url options:NSMatchingReportCompletion range:NSMakeRange(0, [url length])];
        if (matches > 0 && [MIConfig globalConfig].htmlRebate) {
            MIButtonItem *cancelItem = [MIButtonItem itemWithLabel:@"取消"];
            cancelItem.action = ^{
            };
            MIButtonItem *affirmItem = [MIButtonItem itemWithLabel:@"好"];
            affirmItem.action = ^{
                NSString *taobao = [NSString stringWithFormat:@"https://itunes.apple.com/app/id%@?mt=8", [MIConfig globalConfig].taobaoAppID];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:taobao]];
            };
            
            UIAlertView *installTaobaoAlertView = [[UIAlertView alloc] initWithTitle:@"米姑娘提醒" message:@"请先安装最新版淘宝客户端，然后在米折查到有返利商品即自动跳转淘宝，在淘宝客户端购买即可获得返利" cancelButtonItem:cancelItem otherButtonItems:affirmItem, nil];
            [installTaobaoAlertView show];
        }
        return NO;
    } else if ([url hasPrefix:@"beibeiapp://"]) {
        //处理贝贝app相关的scheme
        NSString *itunes = @"https://itunes.apple.com/app/id%@?mt=8";
        NSString *beibei = [NSString stringWithFormat:itunes, [MIConfig globalConfig].beibeiAppID];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:beibei]];
        return NO;
    } else if ([url hasPrefix:@"mizhe://action?"]) {
        //处理米折自定义动作
        [self mizheAction:url];
        return NO;
    } else if ([url rangeOfString:@"mizheapp_info=" options:NSCaseInsensitiveSearch].location != NSNotFound) {
        //处理米折特卖相关链接，跳转到特卖相关页面
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
            return YES;
        }
    } else {
        return YES;
    }
}

- (void)webViewDidFinishLoad:(UIWebView*)webView {
    self.webPageTitle = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    if ( _webPageTitle && ![_webPageTitle isEqualToString:@""]) {
        [self.navigationBar setBarTitle:self.webPageTitle];
    }
    MILog(@"webPageTitle=%@", self.webPageTitle);
    MILog(@"webview webViewDidFinishLoad url = %@", webView.request.URL.absoluteString);
    [self setOverlayStatus:EOverlayStatusRemove labelText:nil];
}

- (void)webView:(UIWebView*)webView didFailLoadWithError:(NSError*)error {

    [self setOverlayStatus:EOverlayStatusRemove labelText:nil];

    //非网络原因
    if(error.code != -999 && error.code != 102 && error.code != 101) {
        //服务器页面抛出错误error，-999属于请求未完成（刷新过快），101属于网络错误，102属于主动中断载入
        //此两个错误不做异常处理
        [self setOverlayStatus:EOverlayStatusReload labelText:nil];
    }
}

- (void)mizheAction:(NSString *)schemes {
    NSString *target = [MIUtility getParamValueFromUrl:schemes paramName:@"target"];
    NSString *callback = [MIUtility getParamValueFromUrl:schemes paramName:@"callback"];
    BOOL callBackNow = YES;     // 立即执行callback
    
    MILog(@"target=%@", target);
    if ([target isEqualToString:@"refresh"]) {
        //刷新当前界面重新登录认证
        [self openURL:self.homeURL];
    } else if ([target isEqualToString:@"tabs"]) {
        //跳转到主界面的相应的tab
        NSString *tab = [MIUtility getParamValueFromUrl:schemes paramName:@"tab"];
        [MINavigator openShortCutWithDictInfo:@{@"target": tab}];
    } else if ([target isEqualToString:@"shake"]) {
        //使能客户端开始监听摇一摇的动作
        NSString *state = [MIUtility getParamValueFromUrl:schemes paramName:@"state"];
        if ([state isEqualToString:@"relisten"]) {
            [self playsound];//播放摇奖结果提示音
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kShakeTag];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
		NSString *appsScore = [MIUtility getParamValueFromUrl:schemes paramName:@"appsScore"];
        if ([appsScore isEqualToString:@"yes"]) {
			[[NSUserDefaults standardUserDefaults] setBool:YES forKey:kShowGradeAlertView];
			[[NSUserDefaults standardUserDefaults] synchronize];
		}
        shakeEnable = YES;
        shakeCallback = callback;
        
        // 摇一摇需要延迟到shake动作结束后进行回调
        callBackNow = NO;
    } else if ([target isEqualToString:@"playsound"]) {
        [self playsound];
    } else if ([target isEqualToString:@"share"]) {
        [self shareAction:schemes];
        
        // 分享需要延迟到分享回来后进行回调
        callBackNow = NO;
    } else if ([target isEqualToString:@"changeTitle"]) {
        self.navigationBar.titleLabel.text = [MIUtility getParamValueFromUrl:schemes paramName:@"title"];
        NSString *hidden = [MIUtility getParamValueFromUrl:schemes paramName:@"hideBottomBar"];
        if ([hidden isEqualToString:@"no"]) {
            self.navigationBar.rightButton.hidden = NO;
        } else {
            self.navigationBar.rightButton.hidden = YES;
        }
    } else if ([target isEqualToString:@"appsScore"]) {
		//提示用户去App Store评分
		[[NSUserDefaults standardUserDefaults] setBool:YES forKey:kShowGradeAlertView];
		[[NSUserDefaults standardUserDefaults] synchronize];
	} else if ([target isEqualToString:@"appsRecommend"]) {
		//推荐APP下载提示
		NSString *appUrl = [MIUtility getParamValueFromUrl:schemes paramName:@"appUrl"];
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:appUrl]];
	} else if ([target isEqualToString:@"refreshUserInfo"]) {
        //需要刷新账号信息
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kShowGradeAlertView];
		[[NSUserDefaults standardUserDefaults] synchronize];
        
        MIUserGetRequest *_request = [[MIUserGetRequest alloc] init];
        _request.onCompletion = ^(MIUserGetModel * model) {
            [[MIMainUser getInstance] saveUserInfo:model];
        };
        _request.onError = ^(MKNetworkOperation* completedOperation, MIError* error) {
            MILog(@"error_msg=%@",error.description);
        };
        [_request sendQuery];
    } else if ([target isEqualToString:@"refresh"]) {
        //需要刷新当前页面
        [_webView reload];
        
        // 刷新本页面无需callback
        callBackNow = NO;
    } else if ([target isEqualToString:@"viewController"]) {
        NSString *viewcontroller = [MIUtility getParamValueFromUrl:schemes paramName:@"vc"];
        Class viewControllerClass = NSClassFromString(viewcontroller);
        id obj = [[viewControllerClass alloc] init];
        if (obj) {
            [[MINavigator navigator] openPushViewController:(UIViewController *)obj animated:YES];
        }
    } else if ([target isEqualToString:@"login"]) {
        loginCallback = [MIUtility getParamValueFromUrl:schemes paramName:@"callback"];
        if ([[MIMainUser getInstance] checkLoginInfo]) {
            [self loginCallback];
        } else {
            [MINavigator openLoginViewController];
        }
        
        // 延迟到登录成功后回调
        callBackNow = NO;
    } else if ([target isEqualToString:@"checkApp"]) {
        NSString *scheme = [MIUtility getParamValueFromUrl:schemes paramName:@"scheme"];
        if (scheme && callback) {
            scheme = [NSString stringWithFormat:@"%@://", scheme];
            BOOL checkApp = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:scheme]];
            NSString *checkAppCallback = [NSString stringWithFormat:@"%@(%d)", callback,checkApp];
            [_webView stringByEvaluatingJavaScriptFromString:checkAppCallback];
        }
        
        callBackNow = NO;
    } else if ([target isEqualToString:@"checkLogin"]) {
        NSString *loginInfo = [NSString stringWithFormat:@"%@(%d)", callback, [[MIMainUser getInstance] checkLoginInfo]];
        [_webView stringByEvaluatingJavaScriptFromString:loginInfo];
        
        callBackNow = NO;
    } else if ([target isEqualToString:@"clientInfo"]) {
        NSData *clientInfoData = [NSJSONSerialization dataWithJSONObject:[MIConfig getClientInfo] options:NSJSONWritingPrettyPrinted error:nil];
        if (clientInfoData && callback) {
            NSString *javaScript = [clientInfoData javaScriptStringEncodeWithCallback:callback];
            [_webView stringByEvaluatingJavaScriptFromString:javaScript];
        }
        
        callBackNow = NO;
    } else if ([target isEqualToString:@"zhi"]) {//ver=3.4.0之后的版本开始支持
        MIZhiDetailViewController *detailView = [[MIZhiDetailViewController alloc] initWithItem:nil];
        detailView.zid = [MIUtility getParamValueFromUrl:schemes paramName:@"desc"];
        [[MINavigator navigator] openPushViewController:detailView animated:YES];
    }else if ([target isEqualToString:@"checkinAlarm"]){
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setBool:YES forKey:kSigninTag];
        
        NSString *time = [MIUtility getParamValueFromUrl:schemes paramName:@"time"];
        NSString *title = [MIUtility getParamValueFromUrl:schemes paramName:@"title"];
        NSString *subtitle = [MIUtility getParamValueFromUrl:schemes paramName:@"subtitle"];
        NSString *desc = [NSString stringWithFormat:@"%@,%@", title ? title : @"", subtitle ? subtitle : @""];
        
        if (time.integerValue < 0 || time.integerValue > 1440) {
            [MIUtility delLocalNotificationByType:APP_LOCAL_NOTIFY_ACTION_CHECK_IN_ALARM];
        }else{
            NSCalendar *calendar = [NSCalendar currentCalendar];
            NSDateComponents *components = [calendar components:NSUIntegerMax fromDate:[NSDate date]];
            components.hour = 24;
            components.minute = time.integerValue;
            components.second = 0;
            NSTimeInterval interval = [[calendar dateFromComponents:components] timeIntervalSince1970];
            [MIUtility setLocalNotificationWithType:APP_LOCAL_NOTIFY_ACTION_CHECK_IN_ALARM alertBody:desc at:(interval + [MIConfig globalConfig].timeOffset)];
        }
    }
    else if([target isEqualToString:@"safe_test"]){
        if ([[MIMainUser getInstance] checkLoginInfo]) {
            MISecurityAccountViewController *vc = [[MISecurityAccountViewController alloc] init];
            [[MINavigator navigator] openPushViewController:vc animated:YES];
        } else {
            __weak typeof(self) weakSelf = self;
            MIButtonItem *cancelItem = [MIButtonItem itemWithLabel:@"取消"];
            cancelItem.action = ^{
                [weakSelf failLoadTableViewData];
            };
            MIButtonItem *affirmItem = [MIButtonItem itemWithLabel:@"登录"];
            affirmItem.action = ^{
                [MINavigator openLoginViewController];
            };
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"亲，您还没有登录哦~" cancelButtonItem:cancelItem otherButtonItems:affirmItem, nil];
            [alertView show];
        }
    }
    else {
        // 页面跳转统一处理
        NSDictionary *dict = [MIUtility parseURLParams:schemes];
        if ([MINavigator openShortCutWithDictInfo:dict]) {
            return;
        }
        
        MILog(@"undefined");
    }
    
    // 执行回调，通知调用结果
    if (callBackNow && callback) {
        NSString *javaScript = [callback rangeOfString:@"()"].length > 0 ? callback : [NSString stringWithFormat:@"%@()", callback];
        [_webView stringByEvaluatingJavaScriptFromString:javaScript];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [super scrollViewDidScroll:scrollView];
    CGFloat y = scrollView.contentOffset.y;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSNumber *first = [userDefaults objectForKey:@"firstEnterWeb"];
    
        if (y < _scrollOffSet - 15 || y <= 0) {

                if (y > self.view.viewHeight - TABBAR_HEIGHT && first.integerValue == 0)
                {
                    //信号区显示 “轻触此处回到顶部”
                    
                    MIStatusBarOverlay *overlay = [[MIStatusBarOverlay alloc]init];
                    [overlay showMessage:@"轻触此处回到顶部"];
                    [userDefaults setObject:@(10) forKey:@"firstEnterWeb"];
                }
            }

        _scrollOffSet = y;
}



- (void)playsound
{
    SystemSoundID soundId;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"shake_match" ofType:@"m4r"];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &soundId);
    AudioServicesPlayAlertSound(soundId);
}

- (void)loginCallback
{
    NSTimeInterval a = [[NSDate date] timeIntervalSince1970];
    NSString * ts = [NSString stringWithFormat:@"%.0f", a];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   [MIMainUser getInstance].sessionKey, @"session",
                                   [MIMainUser getInstance].userId.stringValue, @"uid",
                                   ts, @"ts",
                                   [MIConfig getUDID], @"udid", nil];
    NSString *signature = [MIUtility getSignWithDictionary:params];
    [params setObject:signature forKey:@"sign"];
    NSData *sessionData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
    NSString *javaScript = [sessionData javaScriptStringEncodeWithCallback:loginCallback];
    [_webView stringByEvaluatingJavaScriptFromString:javaScript];
    loginCallback = nil;
}

- (void)shareCallback
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
