//
//  MITbkWebViewController.m
//  MISpring
//
//  Created by lsave on 13-3-27.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MITbkWebViewController.h"
#import "MIUtility.h"
#import "MIUITextButton.h"
#import "MTStatusBarOverlay.h"
#import "MIAppDelegate.h"
#import "MIUserGetRequest.h"
#import "MIUserGetModel.h"
#import "MITbkMobileItemsConvertModel.h"
#import "MITbkConvertItemModel.h"
#import "MITbkRebateAuthGetModel.h"
#import "MITbkAuthrizeItemModel.h"

static NSString *wvsUrlPrefix = @"http://wvs.m.taobao.com";
static NSString *zcUrlPrefix = @"http://zc.m.taobao.com";
static NSString *hfUrlPrefix = @"http://hf.m.tmall.com";
static NSString *yyzUrlPrefix = @"http://yyz.m.taobao.com/lady/pptmsale.html";
static NSString *kMizheSche = @"sche=mizheapp://action";

@implementation MITbkWebViewController

@synthesize titleLabel = _titleLabel;
@synthesize rebateLabel1 = _rebateLabel1;
@synthesize rebateLabel2 = _rebateLabel2;
@synthesize hiddenLabel = _hiddenLabel;
@synthesize loginTips = _loginTips;

@synthesize loginView = _loginView;
@synthesize loadAnyway = _loadAnyway;
@synthesize clickUrl = _clickUrl;
@synthesize webTitle = _webTitle;
@synthesize productTitle = _productTitle;
@synthesize numiid = _numiid;
@synthesize tuanNumiid = _tuanNumiid;
@synthesize brandNumiid = _brandNumiid;
@synthesize zhiNumiid = _zhiNumiid;
@synthesize keywordsArray = _keywordsArray;
@synthesize topSessionKey = _topSessionKey;
@synthesize topClient = _topClient;
@synthesize topRebateSessionKey = _topRebateSessionKey;
@synthesize topRebateClient = _topRebateClient;
@synthesize tbkItemsConvertRequest = _tbkItemsConvertRequest;
@synthesize tbkRebateAuthGetRequest = _tbkRebateAuthGetRequest;

- (id) initWithURL: (NSURL*)URL
{
    self = [super init];
    NSMutableString * absoluteUrlString = [URL.absoluteString mutableCopy];
    if (self != nil) {
        _loadAnyway = NO;
        _keywordsArray = [NSArray arrayWithObjects:@"冲值", @"话费", @"充值", @"捷易", @"易赛", @"点卡", @"龙之谷", @"qq", @"腾讯", @"币", @"网游", @"游戏", @"代练", @"虚拟", @"skype", @"花费", nil];
        
        _topClient = [TopIOSClient getIOSClientByAppKey: [MIConfig globalConfig].topAppKey];
        _topRebateClient = [TopIOSClient getIOSClientByAppKey: [MIConfig globalConfig].topAppKey];
        
        __weak typeof(self) weakSelf = self;
        _tbkItemsConvertRequest = [[MITbkMobileItemsConvertRequest alloc] init];
        _tbkItemsConvertRequest.onCompletion = ^(MITbkMobileItemsConvertModel *model) {
            if (model.success.boolValue) {
                [weakSelf tbkItemsConvertApiCompletion:model];
            } else {
                [weakSelf tbkItemsConvertApiError];
            }
        };
        _tbkItemsConvertRequest.onError = ^(MKNetworkOperation* completedOperation, MIError* error) {
            [weakSelf tbkItemsConvertApiError];
        };
        
        _tbkRebateAuthGetRequest = [[MITbkRebateAuthGetRequest alloc] init];
        _tbkRebateAuthGetRequest.onCompletion = ^(MITbkRebateAuthGetModel *model) {
            if (model.success.boolValue) {
                [weakSelf tbkRebateAuthApiCompletion:model];
            } else {
                [weakSelf tbkRebateAuthApiError];
            }
        };
        _tbkRebateAuthGetRequest.onError = ^(MKNetworkOperation* completedOperation, MIError* error) {
            [weakSelf tbkRebateAuthApiError];
        };
        
        if (([absoluteUrlString rangeOfString: kTtid].location == NSNotFound)
            && ![absoluteUrlString hasPrefix:wvsUrlPrefix]
            && ![absoluteUrlString hasPrefix:yyzUrlPrefix]) {
            if (URL.query == nil) {
                [absoluteUrlString appendFormat:@"?%@", kTtid];
            } else {
                [absoluteUrlString appendFormat:@"&%@", kTtid];
            }
        }
        
        if ([absoluteUrlString rangeOfString: @"#!orderList-4/-Z1" options:NSCaseInsensitiveSearch].location != NSNotFound) {
            //全部订单需要重新拼接参数
            [absoluteUrlString replaceOccurrencesOfString:@"#!orderList-4/-Z1"
                                               withString:@""
                                                  options:NSCaseInsensitiveSearch
                                                    range:NSMakeRange(0, [absoluteUrlString length])];
            [absoluteUrlString appendString:@"#!orderList-4/-Z1"];
        }
        
        NSString *defaultUserAgent = [[NSUserDefaults standardUserDefaults] stringForKey:kDefaultUserAgent];
        NSDictionary *dictionnary = [[NSDictionary alloc] initWithObjectsAndKeys:defaultUserAgent, @"UserAgent", nil];
        [[NSUserDefaults standardUserDefaults] registerDefaults:dictionnary];
    }
    
    return [super initWithURL: [NSURL URLWithString: absoluteUrlString]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (self.tuanNumiid && self.origin != TuanOriginTmall) {
        _webView.top -= 45;
        _webView.viewHeight += 45;
        
        if (self.tips && self.tips.length) {
            CGFloat top = _webView.viewHeight - _toolbar.viewHeight - 55;
            
            CGSize size = [self.tips sizeWithFont:[UIFont systemFontOfSize:14]];
            CGFloat width = size.width + 40 + 5;
            self.tipsView = [[UIView alloc] initWithFrame:CGRectMake(PHONE_SCREEN_SIZE.width, top, width, 36)];
            self.tipsView.backgroundColor = [MIUtility colorWithHex:0xffa000 alpha:0.95];
            self.tipsView.alpha = 0;
            [self.view addSubview:self.tipsView];
            
            UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 0, size.width, 36)];
            tipsLabel.backgroundColor = [UIColor clearColor];
            tipsLabel.font = [UIFont systemFontOfSize:14];
            tipsLabel.textColor = [UIColor whiteColor];
            tipsLabel.textAlignment = NSTextAlignmentCenter;
            tipsLabel.text = self.tips;
            [self.tipsView addSubview:tipsLabel];
            
            UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
            closeButton.frame = CGRectMake(0, 0, 40, 36);
            [closeButton setImage:[UIImage imageNamed:@"ic_tip_close"] forState:UIControlStateNormal];
            [closeButton addTarget:self action:@selector(hideTips) forControlEvents:UIControlEventTouchUpInside];
            [self.tipsView addSubview:closeButton];
        }
    }
    [self.navigationBar setBarTitle:_webTitle textSize:18];
    self.navigationBar.clipsToBounds = YES;
    
    _rebateLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 220, 18)];
    _rebateLabel1.text = @"返利模式浏览";
    _rebateLabel1.backgroundColor = [UIColor clearColor];
    _rebateLabel1.textColor = [UIColor whiteColor];
    _rebateLabel1.adjustsFontSizeToFitWidth = YES;
    _rebateLabel1.textAlignment = UITextAlignmentCenter;
    _rebateLabel1.font = [UIFont systemFontOfSize:12.0];
    _rebateLabel1.minimumFontSize = 10;
    [self.navigationBar setBarTitleLabelFrame:CGRectMake(50, self.navigationBarHeight - PHONE_NAVIGATION_BAR_ITEM_HEIGHT, 220,PHONE_NAVIGATION_BAR_ITEM_HEIGHT - 18)];

    
    _rebateLabel2 = [[UILabel alloc] initWithFrame: CGRectMake(0, 20, 220, 18)];
    _rebateLabel2.text = @"";
    _rebateLabel2.backgroundColor = [UIColor clearColor];
    _rebateLabel2.textColor = [UIColor whiteColor];
    _rebateLabel2.textAlignment = UITextAlignmentCenter;
    _rebateLabel2.font = [UIFont systemFontOfSize: 12.0];
    _rebateLabel2.adjustsFontSizeToFitWidth = YES;
    _rebateLabel2.minimumFontSize = 10;
    _hiddenLabel = _rebateLabel2;

    UIView * tmpView = [[UIView alloc] initWithFrame: CGRectMake(0, self.navigationBarHeight - 20, 220, 40)];
    tmpView.centerX = PHONE_SCREEN_SIZE.width / 2;
    tmpView.clipsToBounds = YES;
    [tmpView addSubview:_rebateLabel1];
    [tmpView addSubview:_rebateLabel2];
    [self.navigationBar addSubview:tmpView];

    
    _loginView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    
    [[_loginView layer] setShadowOffset:CGSizeMake(0, 2)];
    [[_loginView layer] setShadowRadius: 3];
    [[_loginView layer] setShadowOpacity: 0.8];
    [[_loginView layer] setShadowColor:[UIColor darkGrayColor].CGColor];
    [_loginView setBackgroundColor:[UIColor colorWithWhite:0.3 alpha:0.85]];
    
    _loginTips = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    _loginTips.font = [UIFont systemFontOfSize: 16];
    [_loginTips setTextColor: [UIColor whiteColor]];
    _loginTips.backgroundColor = [UIColor clearColor];
    _loginTips.textAlignment = NSTextAlignmentCenter;
    _loginTips.shadowColor = [UIColor blackColor];
    _loginTips.shadowOffset = CGSizeMake(0, -1.0);
    [_loginView addSubview: _loginTips];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loginClick:)];
    [_loginView addGestureRecognizer:singleTap];
        
    [self.view insertSubview: _loginView belowSubview:self.navigationBar];
    [self.view sendSubviewToBack:_webView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (self.topSessionKey) {
        [self.topClient cancel:self.topSessionKey];
    }
    
    if (self.topRebateSessionKey) {
        [self.topRebateClient cancel:self.topRebateSessionKey];
    }
    
    if ([_tbkItemsConvertRequest.operation isExecuting]) {
        [_tbkItemsConvertRequest cancelRequest];
    }
    
    if ([_tbkRebateAuthGetRequest.operation isExecuting]) {
        [_tbkRebateAuthGetRequest cancelRequest];
    }
}

- (void)reloadHomeUrl
{
    _numiid = nil;
    
    NSString *absoluteString = self.URL.absoluteString;
    NSString *num_iid = [MIUtility getNumiidFromUrl:absoluteString];
    if ([absoluteString hasPrefix:wvsUrlPrefix] || [absoluteString hasPrefix:zcUrlPrefix]) {
        NSString *pid = [MIConfig globalConfig].saPid;
        NSString * userid = [[MIMainUser getInstance].userId stringValue];
        if (userid == nil || userid.length == 0) {
            userid = @"1";
        }
        
        NSString *wvsUrl = @"http://wvs.m.taobao.com?pid=%@&unid=%@&backHiddenFlag=1";
        NSString *mobilePhoneFeeUrl = [NSString stringWithFormat:wvsUrl, pid, userid];
        [_webView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:mobilePhoneFeeUrl]]];
    } else if (num_iid) {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://a.m.taobao.com/i%@.htm", num_iid]];
        [_webView loadRequest:[[NSURLRequest alloc] initWithURL:url]];
    } else {
        [_webView loadRequest:[[NSURLRequest alloc] initWithURL:self.URL]];
    }
}

- (void)setNaviTitle: (NSString *) title {
    return;
}

- (void) setRebate: (NSString *) rebateInfo {
    if (_rebateLabel1.frame.origin.y == 0) {
        if ([_rebateLabel1.text isEqualToString:rebateInfo]) {
            return;
        }
    } else if ([_rebateLabel2.text isEqualToString:rebateInfo]) {
        return;
    }
    self.hiddenLabel.text = rebateInfo;
    
    // position hidden status label under visible status label
    self.hiddenLabel.frame = CGRectMake(self.hiddenLabel.frame.origin.x,
                                              self.navigationBarHeight,
                                              self.hiddenLabel.frame.size.width,
                                              self.hiddenLabel.frame.size.height);
    
    
    // animate hidden label into user view and visible status label out of view
    [UIView animateWithDuration:0.50
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         // move both status labels up
                         _rebateLabel1.frame = CGRectMake(_rebateLabel1.frame.origin.x,
                                                              _rebateLabel1.frame.origin.y - self.navigationBarHeight,
                                                              _rebateLabel1.frame.size.width,
                                                              _rebateLabel1.frame.size.height);
                         _rebateLabel2.frame = CGRectMake(_rebateLabel2.frame.origin.x,
                                                              _rebateLabel2.frame.origin.y - self.navigationBarHeight,
                                                              _rebateLabel2.frame.size.width,
                                                              _rebateLabel2.frame.size.height);
                         if (self.hiddenLabel == _rebateLabel2) {
                             self.hiddenLabel = _rebateLabel2;
                         } else {
                             self.hiddenLabel = _rebateLabel1;
                         }
                     }
                     completion:^(BOOL finished) {                         
                     }];
}

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request
 navigationType:(UIWebViewNavigationType)navigationType
{
    if ([super webView:webView shouldStartLoadWithRequest:request navigationType:navigationType]) {

        NSString * url = [NSString stringWithFormat:@"%@", request.URL];
        NSRegularExpression *sclickRegExp = [NSRegularExpression regularExpressionWithPattern:[MIConfig globalConfig].appDl options:NSRegularExpressionCaseInsensitive error: nil];
        NSUInteger matches = [sclickRegExp numberOfMatchesInString:url options:NSMatchingReportCompletion range:NSMakeRange(0, [url length])];
        if (matches > 0) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
            return NO;
        }
        
        if (([url hasPrefix:wvsUrlPrefix] || [url hasPrefix:zcUrlPrefix] || [url hasPrefix:hfUrlPrefix])
            && ([url rangeOfString:[MIConfig globalConfig].saPid  options:NSCaseInsensitiveSearch].location == NSNotFound)) {
            NSString * outerCode = [[MIMainUser getInstance].userId stringValue];
            if (outerCode == nil || outerCode.length == 0) {
                outerCode = @"1";
            }
            
            NSString *wvsUrl = @"http://wvs.m.taobao.com?pid=%@&unid=%@&backHiddenFlag=1";
            NSString *mobilePhoneFeeUrl = [NSString stringWithFormat:wvsUrl, [MIConfig globalConfig].saPid, outerCode];
            [_webView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:mobilePhoneFeeUrl]]];
            return NO;
        }
        
        if (_loadAnyway) {
            [self hideLoginView];
            _loadAnyway = NO;
            return YES;
        }
        
        NSString *num_iid = [MIUtility getNumiidFromUrl:url];
        if (num_iid && ![self.numiid isEqualToString:num_iid] && num_iid.length >= 5 && ![num_iid isEqualToString:@"400000"]) {
            self.numiid = num_iid;
            _clickUrl = nil;
            _loadingURL = request.URL;
            return [self tbkItemConvertWithRequest:request];
        }
        return YES;
    } else {
        return NO;
    }
}

- (void)webViewDidFinishLoad:(UIWebView*)webView {
    [super webViewDidFinishLoad:webView];
    [MIUtility hideTaobaoSmartAd:webView];
    _loadingURL = webView.request.URL;

    NSString * url = _loadingURL.absoluteString;
    NSString *num_iid = [MIUtility getNumiidFromUrl:url];
    if (num_iid == nil && [url rangeOfString:kMizheSche  options:NSCaseInsensitiveSearch].location == NSNotFound){
        [self setRebate: @"返利模式浏览"];
        [self hideLoginView];
    }
    
    if (self.tipsView) {
        if (num_iid && ([self.brandNumiid isEqualToString:num_iid] || [self.tuanNumiid isEqualToString:num_iid])) {
            [self showTips];
        } else {
            [self hideTips];
        }
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
    if ([[MIMainUser getInstance] checkLoginInfo]) {
        _loginView.userInteractionEnabled = NO;

        if (([MIConfig globalConfig].wvsRate > 0)
            && (![_loadingURL.absoluteString hasPrefix:wvsUrlPrefix])) {
            for (NSString *keyword in _keywordsArray) {
                if ((_productTitle && [_productTitle rangeOfString:keyword  options:NSCaseInsensitiveSearch].location != NSNotFound)
                    || (_webPageTitle && [_webPageTitle rangeOfString:keyword  options:NSCaseInsensitiveSearch].location != NSNotFound)) {
                    
                    _loginTips.text = @"若是虚拟商品，则不返利";
                    [UIView animateWithDuration:0.35 delay:0 options:UIViewAnimationCurveEaseInOut animations:^{
                        _loginView.top = self.navigationBarHeight;
                    }completion:nil];
                    break;
                }
            }
        } else {
            [self hideLoginView];
        }
    } else {
        _loginView.userInteractionEnabled = YES;
        _loginTips.text = @"你尚未登录，点此登录后购买拿返利";
        [UIView animateWithDuration:0.35 delay:0 options:UIViewAnimationCurveEaseInOut animations:^{
            _loginView.top = self.navigationBarHeight;
        }completion:nil];
    }
}

- (void) showTips
{
    self.tipsView.alpha = 1;
    [UIView animateWithDuration:0.35 animations:^{
        self.tipsView.left = PHONE_SCREEN_SIZE.width - self.tipsView.viewWidth;
    }];
}

- (void) hideTips
{
    [UIView animateWithDuration:0.35 animations:^{
        self.tipsView.left = PHONE_SCREEN_SIZE.width;
    } completion:^(BOOL finished) {
        self.tipsView.alpha = 0;
    }];
}

- (BOOL) tbkItemConvertWithRequest:(NSURLRequest *)request
{
    // 判断聚划算是否支持返利
    if ([MIUtility isJhsRebate:request] == NO) {
        [self setRebate: @"该宝贝暂无返利"];
        _loadAnyway = YES;
        [self hideLoginView];
        return YES;
    } else {
        if (![MIUtility isTbkSclickUrl:request.URL.absoluteString]) {
            NSString *outerCode = [[MIMainUser getInstance].userId stringValue];
            if (outerCode == nil || outerCode.length == 0) {
                outerCode = @"1";
            }
            
            // 10元购商品需要加上团购标签
            NSString *type = @"";
            if ([self.numiid isEqualToString:self.tuanNumiid]) {
                type = @"tu";
                outerCode = [NSString stringWithFormat: @"tu%@", outerCode];
            } else if ([self.numiid isEqualToString:self.brandNumiid]) {
                type = @"br";
                outerCode = [NSString stringWithFormat: @"br%@", outerCode];
            } else if ([self.numiid isEqualToString:self.zhiNumiid]) {
                type = @"zh";
                outerCode = [NSString stringWithFormat: @"zh%@", outerCode];
            }
            
            if ([MIConfig globalConfig].topTbkApi) {
                if (self.topSessionKey) {
                    [self.topClient cancel:self.topSessionKey];
                    self.topSessionKey = nil;
                }
                
                NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
                [params setObject:@"taobao.tbk.mobile.items.convert" forKey:@"method"];
                [params setObject: _numiid forKey:@"num_iids"];
                [params setObject: @"click_url" forKey:@"fields"];
                [params setObject: outerCode forKey:@"outer_code"];
                
                self.topSessionKey = [self.topClient api:@"GET" params:params target:self cb:@selector(taobaokeMobileItemConvertApiResponse:) userId:nil needMainThreadCallBack:true];
            } else {
                if ([self.tbkItemsConvertRequest.operation isExecuting]) {
                    MILog(@"tbkItemsConvertRequest isExecuting");
                    [self.tbkItemsConvertRequest cancelRequest];
                }
                
                [self.tbkItemsConvertRequest setNumiids:_numiid];
                [self.tbkItemsConvertRequest setType:type];
                [self.tbkItemsConvertRequest sendQuery];
            }
        } else {
            self.clickUrl = request.URL.absoluteString;
            [self getTaobaoRebate:self.numiid];
        }
        return NO;
    }
}

- (void) tbkItemsConvertApiCompletion:(MITbkMobileItemsConvertModel *)model
{
    if (model.success.boolValue) {
        MITbkConvertItemModel *itemModel = [model.tbkConvertItems objectAtIndex:0];
        self.clickUrl = [NSString stringWithFormat:@"%@&%@", itemModel.clickUrl, kMizheSche];
        [self getTaobaoRebate:self.numiid];
    } else {
        [self tbkItemsConvertApiError];
    }
}

- (void) tbkItemsConvertApiError
{
    MILog(@"tbkItemsConvertApiError");
    [self setRebate: @"该宝贝暂无返利"];
    _loadAnyway = YES;
    [_webView loadRequest: [NSURLRequest requestWithURL: _loadingURL]];
    [self hideLoginView];
}

- (void) taobaokeMobileItemConvertApiResponse:(id)data
{    
    TopApiResponse *response = (TopApiResponse *)data;
    id responseObj = [TopIOSClient getResponseObject: response.content];
    if (responseObj && ![responseObj isKindOfClass: [TopServiceError class]]) {
        responseObj = (NSDictionary *)[responseObj objectForKey:@"tbk_mobile_items_convert_response"];
        if ([[responseObj objectForKey:@"total_results"] intValue] == 1) {
            responseObj = (NSDictionary *)[responseObj objectForKey:@"tbk_items"];
            responseObj = (NSArray *)[responseObj objectForKey:@"tbk_item"];
            responseObj = (NSDictionary *)[responseObj objectAtIndex:0];
            if (responseObj) {
                self.clickUrl = [NSString stringWithFormat:@"%@&%@", [responseObj objectForKey:@"click_url"], kMizheSche];
                [self getTaobaoRebate:self.numiid];
                return;
            }
        }
    }
    
    [self tbkItemsConvertApiError];
}

- (void) getTaobaoRebate:(NSString *)numiid
{
    if ([MIConfig globalConfig].topTbkApi) {
        if (self.topRebateSessionKey) {
            [self.topRebateClient cancel:self.topRebateSessionKey];
            self.topRebateSessionKey = nil;
        }
        
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setObject:@"taobao.taobaoke.rebate.authorize.get" forKey:@"method"];
        [params setObject:numiid forKey:@"num_iid"];
        self.topRebateSessionKey = [self.topRebateClient api:@"GET" params:params target:self cb:@selector(rebateApiResponse:) userId:nil needMainThreadCallBack:true];
    } else {
        if ([self.tbkRebateAuthGetRequest.operation isExecuting]) {
            MILog(@"tbkItemsConvertRequest isExecuting");
            [self.tbkRebateAuthGetRequest cancelRequest];
        }
        
        [self.tbkRebateAuthGetRequest setNumiids:numiid];
        [self.tbkRebateAuthGetRequest sendQuery];
    }
}

- (void) rebateApiResponse:(id)data
{
	MILog(@"rebateApiResponse:");
	TopApiResponse *response = (TopApiResponse *)data;
	id responseObj = [TopIOSClient getResponseObject: response.content];
	if (responseObj && ![responseObj isKindOfClass: [TopServiceError class]]) {
		responseObj = (NSDictionary *)[responseObj objectForKey:@"taobaoke_rebate_authorize_get_response"];
        if ([[responseObj objectForKey:@"rebate"] boolValue] && [MIConfig globalConfig].htmlRebate) {
            [self setRebate: @"该宝贝有返利"];
            [_webView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString: self.clickUrl]]];
            return;
        }
	}
    
    [self tbkRebateAuthApiError];
}

- (void) tbkRebateAuthApiCompletion:(MITbkRebateAuthGetModel *)model
{
    MILog(@"tbkRebateAuthApiCompletion=%@", model);
    if (model.success.boolValue) {
        MITbkAuthrizeItemModel *tbkRebateItem = [model.tbkAuthrizeItems objectAtIndex:0];
        if (tbkRebateItem.rebate.boolValue && [MIConfig globalConfig].htmlRebate) {
            [self setRebate: @"该宝贝有返利"];
            [_webView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString: self.clickUrl]]];
            return;
        }
    }
    
    [self tbkRebateAuthApiError];
}

- (void) tbkRebateAuthApiError
{
    [self tbkItemsConvertApiError];
}

- (void) loginClick:(UIGestureRecognizer *)gestureRecognizer
{
    MILog(@"open login");
    [MINavigator openLoginViewController];
}

#pragma mark - Private
- (void)backAction {
    [_webView goBack];
    [self setRebate: @"返利模式浏览"];
    [self hideLoginView];
}

- (void)forwardAction {
    [_webView goForward];
    [self setRebate: @"返利模式浏览"];
    [self hideLoginView];
}

- (void)refreshAction {
    _numiid = nil;
    [_webView stopLoading];
    [_webView loadRequest:[NSURLRequest requestWithURL:self.URL]];
}

@end
