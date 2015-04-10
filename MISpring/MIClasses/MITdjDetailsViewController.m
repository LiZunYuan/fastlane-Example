//
//  MITdjDetailsViewController.m
//  MISpring
//
//  Created by 徐 裕健 on 13-9-25.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MITdjDetailsViewController.h"
#import "MITaobaoDescViewController.h"
#import "MIVIPCenterViewController.h"

#define ToolViewHeight  50

@implementation MITdjDetailsViewController
@synthesize iid;
@synthesize webView = _webView;
@synthesize urlRequest = _urlRequest;
@synthesize virtualTips = _virtualTips;
@synthesize virtualView = _virtualView;
@synthesize keywordsArray = _keywordsArray;

-(id) initWithNumiid: (NSString *) numiid {
    self = [super init];
    if (self != nil) {
        self.iid = numiid;
        self.keywordsArray = [NSArray arrayWithObjects:@"冲值", @"话费", @"充值", @"捷易", @"易赛", @"点卡", @"龙之谷", @"qq", @"腾讯", @"币", @"网游", @"游戏", @"代练", @"虚拟", @"skype", @"花费", nil];
        NSString *defaultUserAgent = [[NSUserDefaults standardUserDefaults] stringForKey:kDefaultUserAgent];
        NSDictionary *dictionnary = [[NSDictionary alloc] initWithObjectsAndKeys:defaultUserAgent, @"UserAgent", nil];
        [[NSUserDefaults standardUserDefaults] registerDefaults:dictionnary];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSURLCache sharedURLCache] removeCachedResponseForRequest:self.urlRequest];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.navigationBar setBarTitle:@"商品详情" textSize:20.0];
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, self.navigationBarHeight, PHONE_SCREEN_SIZE.width, self.view.viewHeight - self.navigationBarHeight)];
    _webView.scrollView.bounces = NO;
    _webView.scrollView.directionalLockEnabled = YES;
    _webView.scrollView.pagingEnabled = YES;
    _webView.scrollView.showsVerticalScrollIndicator = YES;
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    
    _virtualView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    [[_virtualView layer] setShadowOffset:CGSizeMake(0, 2)];
    [[_virtualView layer] setShadowRadius: 3];
    [[_virtualView layer] setShadowOpacity: 0.8];
    [[_virtualView layer] setShadowColor:[UIColor darkGrayColor].CGColor];
    [_virtualView setBackgroundColor:[UIColor colorWithWhite:0.3 alpha:0.85]];
    
    _virtualTips = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    _virtualTips.lineBreakMode = UILineBreakModeCharacterWrap;
    _virtualTips.font = [UIFont systemFontOfSize: 14];
    _virtualTips.textColor = [UIColor whiteColor];
    _virtualTips.backgroundColor = [UIColor clearColor];
    _virtualTips.textAlignment = NSTextAlignmentCenter;
    _virtualTips.shadowColor = [UIColor blackColor];
    _virtualTips.shadowOffset = CGSizeMake(0, -1.0);
    _virtualTips.numberOfLines = 0;
    _virtualTips.text = @"若是虚拟商品，直接去购买无返利\n点此去充值中心购买拿返利";
    [_virtualView addSubview: _virtualTips];
    
    UITapGestureRecognizer *goChongzhiTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goChongzhi)];
    [_virtualView addGestureRecognizer:goChongzhiTap];
    
    [self.view insertSubview: _virtualView belowSubview:self.navigationBar];
    [self.view sendSubviewToBack:_webView];

    
    [MobClick event:kTaobaoDetailViewClicks];    
    NSString * outerCode = [[MIMainUser getInstance].userId stringValue];
    if (outerCode == nil || outerCode.length == 0) {
        outerCode = @"1";
    }
    BOOL isWiFi = [[Reachability reachabilityForInternetConnection] isReachableViaWiFi];
    NSString *appVersion = [MIConfig globalConfig].version;
    NSString *urlString = [NSString stringWithFormat:@"%@?id=%@&unid=%@&wifi=%d&ver=%@&jhs=%d",
                           [MIConfig globalConfig].tdjUrl, self.iid, outerCode, isWiFi, appVersion,self.isJhsRebate];
    self.urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [self.webView loadRequest:self.urlRequest];

    [self setOverlayStatus:EOverlayStatusLoading labelText:nil];
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString * url = [NSString stringWithFormat:@"%@", request.URL];
    if ([url hasPrefix:@"mizhe://action?"])
    {
        NSString *target = [MIUtility getParamValueFromUrl:url paramName:@"target"];
        MILog(@"target=%@", target);
        if ([target isEqualToString:@"item"])
        {
            // 获取商品的标题及图片地址，判断是否为虚拟商品
            _productTitle = [MIUtility getParamValueFromUrl:url paramName:@"title"];
            _picUrl = [MIUtility getParamValueFromUrl:url paramName:@"pic"];
            [self.navigationBar setBarRightButtonItem:self selector:@selector(goShareAction) imageKey:@"mi_navbar_share_img"];
            if (self.productTitle ) {
                [self showVirtualProductView];
            }
        } else if ([target isEqualToString:@"buyItem"]) {
            //通过外部APP打开连接
            NSString *clickUrl = [MIUtility getParamValueFromUrl:url paramName:@"clickUrl"];
            if (clickUrl) {
                NSURL *itemURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@&sche=mizheapp://action", clickUrl]];
                if ([MIConfig globalConfig].tbMidPage) {
                    MITbWebViewController * webVC = [[MITbWebViewController alloc] initWithURL:itemURL];
                    webVC.numiid = self.iid;
                    webVC.itemImageUrl = self.picUrl;
                    webVC.productTitle = self.productTitle;
                    [webVC setWebTitle:@"购买商品"];
                    [[MINavigator navigator] openPushViewController: webVC animated:YES];
                } else {
                    MITbkWebViewController *webVC = [[MITbkWebViewController alloc] initWithURL:itemURL];
                    webVC.numiid = self.iid;
                    webVC.itemImageUrl = self.picUrl;
                    webVC.productTitle = self.productTitle;
                    [webVC setWebTitle:@"购买商品"];
                    [[MINavigator navigator] openPushViewController:webVC animated:YES];
                }
            } else {
                [self showSimpleHUD:@"店小二太忙，请稍后再试"];
            }
        } else if ([target isEqualToString:@"shop"]) {
            // 进店铺看看
            [MobClick event:kTaobaoShopClicks];
            
            NSString *nick = [MIUtility getParamValueFromUrl:url paramName:@"nick"];
            NSString *shopUrl = [MIUtility getParamValueFromUrl:url paramName:@"url"];
            if (!nick) {
                nick = @"已进入店铺";
            }
            if (shopUrl) {
                [MINavigator openTbWebViewControllerWithURL:[NSURL URLWithString:shopUrl] desc:nick];
            } else {
                [self showSimpleHUD:@"店小二不在，请稍后再试"];
            }
        } else if ([target isEqualToString:@"app"]) {
            //通过外部APP打开连接
            NSString *appUrl = [MIUtility getParamValueFromUrl:url paramName:@"appUrl"];
            if (appUrl) {
                NSURL *appURL = [NSURL URLWithString:appUrl];
                if ([[UIApplication sharedApplication] canOpenURL:appURL]) {
                    [[UIApplication sharedApplication] openURL:appURL];
                }
            }
        }
        
        return NO;
    }

    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView*)webView
{
//    MILog(@"taobao detailes webViewDidFinishLoad");
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
    [self setOverlayStatus:EOverlayStatusRemove labelText:nil];
}

#pragma mark - private method
- (void)goChongzhi
{
    NSString *pid = [MIConfig globalConfig].saPid;
    NSString * outerCode = [[MIMainUser getInstance].userId stringValue];
    if (outerCode == nil || outerCode.length == 0) {
        outerCode = @"1";
    }
    
    NSString *mobilePhoneFeeUrl = [NSString stringWithFormat:@"http://wvs.m.taobao.com?pid=%@&unid=%@&backHiddenFlag=1", pid, outerCode];
    MITbWebViewController *webVC = [[MITbWebViewController alloc] initWithURL:[NSURL URLWithString:mobilePhoneFeeUrl]];
    [webVC setWebTitle:@"充值中心"];
    [[MINavigator navigator] openPushViewController:webVC animated:YES];
}

- (void) hideVirtualProductView {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration: 0.35];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    _virtualView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40);
    
    [UIView commitAnimations];
}

- (void) showVirtualProductView {
    if ([MIConfig globalConfig].wvsRate > 0) {
        for (NSString *keyword in _keywordsArray) {
            if ([self.productTitle rangeOfString:keyword  options:NSCaseInsensitiveSearch].location != NSNotFound) {
                [UIView animateWithDuration:0.35 delay:0 options:UIViewAnimationCurveEaseInOut animations:^{
                    _virtualView.top = self.navigationBarHeight;
                }completion:nil];
                break;
            }
        }
    } else {
        [self hideVirtualProductView];
    }
}

- (void)goShareAction
{
    [MobClick event:kTaobaoDetailShareClicks];
    
    NSString * outerCode = [[MIMainUser getInstance].userId stringValue];
    if (outerCode == nil || outerCode.length == 0) {
        outerCode = @"1";
    }
    NSString *encryptUseDES = [MIUtility encryptUseDES:outerCode key:[MIConfig globalConfig].desKey];
    NSString *url = [NSString stringWithFormat:@"http://m.mizhe.com/share/t.html?iid=%@&pid=%@", self.iid, encryptUseDES];
    NSString *desc = @"米折网（mizhe.com），网购省钱第一站！通过米折网到淘宝、天猫、当当、1号店等600多家商城购物可享最高50%的现金返利，作为导购返利的领导品牌，已受到千万买家的认可和喜爱，苹果AppStore榜首推荐，并获得Hao123和QQ导航等网站权威推荐，安全可靠，值得您的信赖！";
    NSString *comment = @"【分享好东东】通过@米折网 购买还有返利拿哦！";
    
    NSString *smallImg;
    NSString *largeImg;
    if (self.picUrl) {
        smallImg = [[NSString alloc] initWithFormat:@"%@_100x100.jpg", self.picUrl];
        largeImg = [[NSString alloc] initWithFormat:@"%@_670x670.jpg", self.picUrl];
    } else {
        smallImg = [MIConfig globalConfig].appSharePicURL;
        largeImg = [MIConfig globalConfig].appSharePicLargeURL;
    }
    
    UIImageView *itemImageView = [[UIImageView alloc] init];
    [itemImageView sd_setImageWithURL:[NSURL URLWithString:smallImg]
                  placeholderImage:[UIImage imageNamed:@"app_share_pic"]];
    [MINavigator showShareActionSheetWithUrl:url title:self.productTitle desc:desc comment:comment image:itemImageView smallImg:smallImg largeImg:largeImg inView:self.view platform:@"qq_qzone_weixin_timeline_weibo_copy"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
