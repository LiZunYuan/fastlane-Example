//
//  MIMallWebViewController.m
//  MISpring
//
//  Created by Mac Chow on 13-4-12.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIMallDetailController.h"

@implementation MIMallWebViewController

@synthesize loginView = _loginView;
@synthesize mall = _mall;

@synthesize rxUid = _rxUid;
@synthesize showDetailIcon = _showDetailIcon;

- (id) initWithURL:(NSURL *)URL mall: (MIMallModel *) mall
{
    _showDetailIcon = YES;
    self.mall = mall;
    self.rxUid = [NSRegularExpression regularExpressionWithPattern:@"\\?uid=(\\d+)" options:NSRegularExpressionCaseInsensitive error: nil];

    NSMutableString * strUrl = [URL.absoluteString mutableCopy];
    if (mall.mallId && mall.mallId.length > 0) {
        MIMainUser * user = [MIMainUser getInstance];
        NSRange rng = NSMakeRange(0, [strUrl length]);
        if ([user checkLoginInfo]) {
            NSTextCheckingResult * match=[self.rxUid firstMatchInString:strUrl options:0 range:rng];
            if (match) {
                [self.rxUid replaceMatchesInString:strUrl options:0 range:rng withTemplate:[NSString stringWithFormat:@"?uid=%@", user.userId]];
            } else {
                [strUrl appendFormat:@"?uid=%@", user.userId];
            }
        } else {
            [strUrl appendString:@"?uid=1"];
        }
    }
    
    NSDictionary * userAgentDict;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (mall.type.integerValue == 2) {
        //不支持移动商城返利，需要设置UA为电脑版
        userAgentDict = [[NSDictionary alloc] initWithObjectsAndKeys:[MIConfig globalConfig].mallUa, @"UserAgent", nil];
    } else {
        userAgentDict = [[NSDictionary alloc] initWithObjectsAndKeys:[userDefaults stringForKey:kDefaultUserAgent], @"UserAgent", nil];
    }
    [userDefaults registerDefaults:userAgentDict];

    return [super initWithURL: [NSURL URLWithString:strUrl]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationBar setBarTitle:self.mall.name textSize:18];
    if (self.mall.commission && self.mall.commission.floatValue > 0) {
        NSString *commissionDesc;

        float commission;
        if (self.mall.type.integerValue == 1 && self.mall.mobileCommission.floatValue != 0) {
            //移动商城
            commission = [self.mall.mobileCommission floatValue] / 100;
        } else {
            commission = [self.mall.commission floatValue] / 100;
        }
        
        if (self.mall.mode.intValue == 1) {
            //返利类型为米币
            commissionDesc = [NSString stringWithFormat:@"最高返%.1f%%米币", commission];
        } else {
            if (self.mall.commissionType.integerValue == 2) {
                //最高返利为按元计算
                commissionDesc = [NSString stringWithFormat:@ "最高返%.1f元", commission];
            } else {
                //最高返利为按比例计算
                commissionDesc = [NSString stringWithFormat:@"最高返%.1f%%", commission];
            }
        }
        UILabel *commissionDescLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.navigationBarHeight - 20, 220, 18)];
        commissionDescLabel.centerX = PHONE_SCREEN_SIZE.width / 2;
        commissionDescLabel.text = commissionDesc;
        commissionDescLabel.backgroundColor = [UIColor clearColor];
        commissionDescLabel.textColor = [UIColor whiteColor];
        commissionDescLabel.adjustsFontSizeToFitWidth = YES;
        commissionDescLabel.textAlignment = UITextAlignmentCenter;
        commissionDescLabel.font = [UIFont systemFontOfSize:12.0];
        commissionDescLabel.minimumFontSize = 10;
        [self.navigationBar addSubview: commissionDescLabel];
        [self.navigationBar setBarTitleLabelFrame:CGRectMake(50, self.navigationBarHeight - PHONE_NAVIGATION_BAR_ITEM_HEIGHT, 220,PHONE_NAVIGATION_BAR_ITEM_HEIGHT - commissionDescLabel.frame.size.height)];
    }
    
    _loginView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, SCREEN_WIDTH, self.navigationBarHeight)];
    _loginView.hidden = YES;
    [[_loginView layer] setShadowOffset:CGSizeMake(0, 2)];
    [[_loginView layer] setShadowRadius: 3];
    [[_loginView layer] setShadowOpacity: 0.8];
    [[_loginView layer] setShadowColor:[UIColor darkGrayColor].CGColor];
    [_loginView setBackgroundColor:[UIColor colorWithWhite:0.3 alpha:0.85]];
    
    UILabel * textLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, SCREEN_WIDTH, self.navigationBarHeight)];
    textLabel.font = [UIFont systemFontOfSize: 16];
    [textLabel setTextColor: [UIColor whiteColor]];
    textLabel.text = @"您尚未登录，点此登录后购买领取返利";
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.shadowColor = [UIColor blackColor];
    textLabel.shadowOffset = CGSizeMake(0, -1.0);
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loginClick:)];
    [_loginView addGestureRecognizer:singleTap];
    [_loginView addSubview: textLabel];
    
    [self.view insertSubview: _loginView belowSubview:self.navigationBar];
    [self.view sendSubviewToBack:_webView];
    
    if (self.mall.mallId && self.mall.mallId.length > 0 && self.showDetailIcon) {
        [self.navigationBar setBarRightButtonItem:self selector:@selector(goMallDetail) imageKey:@"ic_mall_detail_info"];
        _loginView.hidden = NO;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginEvent:kMallsTime label:self.mall.name];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endEvent:kMallsTime label:self.mall.name];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    [_webView stopLoading];
    _webView.delegate = nil;
    _webView = nil;
}

- (void)goMallDetail
{
    MIMallDetailController * vc = [[MIMallDetailController alloc] initWithMallModel: self.mall];
    [[MINavigator navigator] openPushViewController: vc animated:YES];
}

- (void)reloadHomeUrl
{
    MIMainUser * user = [MIMainUser getInstance];
    NSMutableString * strUrl = [self.homeURL.absoluteString mutableCopy];
    NSRange rng = NSMakeRange(0, [strUrl length]);
    if ([user checkLoginInfo]) {
        NSTextCheckingResult * match=[_rxUid firstMatchInString:strUrl options:0 range:rng];
        if (match) {
            [_rxUid replaceMatchesInString:strUrl options:0 range:rng withTemplate:[NSString stringWithFormat:@"?uid=%@", user.userId]];
        } else {
            [strUrl appendFormat:@"?uid=%@", user.userId];
        }
    } else {
        [strUrl appendString:@"?uid=1"];
    }

    self.homeURL = [NSURL URLWithString: strUrl];
    [self openURL:self.homeURL];
}

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request
 navigationType:(UIWebViewNavigationType)navigationType
{
    if ([super webView:webView shouldStartLoadWithRequest:request navigationType:navigationType]) {
        MILog(@"url = %@", request.URL.absoluteString);
        _shareButton.enabled = NO;
        _loadingURL = webView.request.URL;
        [self hideLoginView];
        return YES;
    } else {
        return NO;
    }
}

- (void)webViewDidFinishLoad:(UIWebView*)webView {
    [super webViewDidFinishLoad:webView];

    _loadingURL = webView.request.URL;
    NSString *host = webView.request.URL.host;
    if (![[MIMainUser getInstance] checkLoginInfo]
        && ![host hasSuffix:@"mizhe.com"]
        && ![host hasSuffix:@"duomai.com"]
        && ![host hasSuffix:@"yiqifa.com"]) {
        [self showLoginView];
    }
}

- (void) hideLoginView {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration: 0.35];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    _loginView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40);
    
    [UIView commitAnimations];
}

- (void) showLoginView {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration: 0.35];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    _loginView.frame = CGRectMake(0, self.navigationBarHeight, SCREEN_WIDTH, self.navigationBarHeight);
    
    [UIView commitAnimations];
}

- (void) loginClick:(UIGestureRecognizer *)gestureRecognizer
{
    [MINavigator openLoginViewController];
}

#pragma mark - Private
- (void)backAction {
    [_webView goBack];
    [self hideLoginView];
}

- (void)forwardAction {
    [_webView goForward];
    [self hideLoginView];
}

@end
