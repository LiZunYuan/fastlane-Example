//
//  MINavigator.m
//  MISpring
//
//  Created by Yujian Xu on 13-3-11.
//  Copyright (c) 2013年 Husor Inc.. All rights reserved.
//

#import "MINavigator.h"
#import "MIAppDelegate.h"

#import "TencentOpenAPI/QQApiInterface.h"
#import "WXApi.h"
#import "MISinaWeibo.h"
#import "MITencentAuth.h"
#import "MIShareViewController.h"
#import "MIZhiDetailViewController.h"
#import "MILaunchAdViewController.h"
#import "MITenTuanViewController.h"
#import "MITomorrowViewController.h"
#import "MITemaiViewController.h"
#import "MITuanDetailViewController.h"
#import "MIBrandTuanDetailViewController.h"
#import "MIBrandViewController.h"
#import "MIBBBrandViewController.h"
#import "MIShareView.h"
#import "MITenViewController.h"
#import "MITuanViewController.h"
#import "MIBrandTeMaiViewController.h"
#import "MIWomenViewController.h"
#import "MIListTableViewController.h"
#import "MIYoupinRecommendViewController.h"
#import "MILoginContainerViewController.h"
#import "MILimitTuanViewController.h"
#import "MISecurityAccountViewController.h"
#import "MIPayApplyViewController.h"
#import "MIVIPCenterViewController.h"
#import "MIExchangeViewController.h"
#import "MIInviteFriendsViewController.h"
#import "MIMsgCenterViewController.h"
#import "MIMyOrderViewController.h"
#import "MIRegisterPhoneViewController.h"
#import "MIEmailBindViewController.h"

static MINavigator *instance = nil;

@implementation MINavigator
@synthesize navigationController = _navigationController;

#pragma mark - Singleton method
- (id) init
{
    self = [super init];
    if (self) {
        self.lockOpenController = NO;
    }
    return self;
}

+ (id) allocWithZone:(NSZone*) zone
{
    @synchronized(self) {
        if (instance == nil) {
            instance = [super allocWithZone:zone];  // assignment and return on first allocation
            return instance;
        }
    }
    return nil;
}

- (id) copyWithZone:(NSZone*) zone
{
    return instance;
}

+ (MINavigator*)navigator
{
    @synchronized(self) {
        if (instance == nil) {
            instance = [[MINavigator alloc] init];
        }
    }
    return instance;
}

#pragma mark - pubic method

// 打开新界面，默认为有动画效果的push方式
- (BOOL)openPushViewController:(UIViewController*)viewController animated:(BOOL)animate
{
    // 锁住打开其他界面，仅仅显示服务器的检查页面
    if (self.lockOpenController) {
        return NO;
    }
    
    if (viewController != nil) {
        if (self.navigationController != nil) {
            [self.navigationController pushViewController:viewController animated:animate];
        } else {
            self.navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
            MIAppDelegate* delegate = (MIAppDelegate*)[[UIApplication sharedApplication] delegate];
            delegate.window.rootViewController = self.navigationController;
            [delegate.window addSubview:[delegate.window.rootViewController view]];
            [delegate.window makeKeyAndVisible];
        }
        return YES;
    } else {
        MILog(@"MINavigator,bad param");
        return NO;
    }
}

// 关闭新界面，默认为有动画效果的pop方式
- (UIViewController*)closePopViewControllerAnimated:(BOOL)animate
{
    if (self.navigationController != nil) {
        return [self.navigationController popViewControllerAnimated:animate];
    } else {
        return nil;
    }
}

// 关闭新界面到指定界面，默认为有动画效果的pop方式
- (NSArray*)closePopViewControllerAtIndex:(NSUInteger)index animated:(BOOL)animate
{
    if (self.navigationController != nil) {
        NSArray *array = [self.navigationController viewControllers];
        if (array.count <= index) {
            return [self.navigationController popToRootViewControllerAnimated:animate];
        } else {
            UIViewController *viewController = [array objectAtIndex:array.count - index];
            return [self.navigationController popToViewController:viewController animated:animate];
        }
    } else {
        return nil;
    }
}

// 关闭所有新界面，默认为有动画效果的pop方式
- (NSArray*)closePopViewControllerToRootWithAnimated:(BOOL)animate
{
    if (self.navigationController != nil) {
        return [self.navigationController popToRootViewControllerAnimated:animate];
    } else {
        return nil;
    }
}

// 打开模态界面，默认为有动画效果
- (BOOL)openModalViewController:(UIViewController*)viewController animated:(BOOL)animate
{
    if (viewController != nil && self.navigationController.visibleViewController != nil) {
        [self.navigationController.visibleViewController presentViewController:viewController animated:animate completion:^{
        }];
        return YES;
    } else {
        return NO;
    }
}

// 关闭模态界面
- (BOOL)closeModalViewController:(BOOL)animate completion:(void (^)(void))completion
{
    if (self.navigationController.visibleViewController != nil) {
        [self.navigationController.visibleViewController dismissViewControllerAnimated:animate completion:completion];
        return YES;
    } else {
        return NO;
    }
}

// 清空全部界面
- (void)removeAllViewControllers
{
    self.navigationController = nil;
}

- (void)popToRootViewController:(BOOL)animate
{
    if (self.navigationController != nil) {
        [self.navigationController popToRootViewControllerAnimated:animate];
    } else {
        return;
    }
}

// 回到根VC
- (BOOL)popToRootViewControllerWithAnimated:(BOOL)animated{
    UINavigationController *navigationController = self.navigationController;
    
    UIViewController* modalVC = [navigationController presentedViewController];
    NSUInteger viewCount = [navigationController.viewControllers count];
    if (modalVC != nil) {
        if (viewCount > 1) {
            [navigationController dismissViewControllerAnimated:NO completion:^{
                
            }];
        } else {
            [navigationController dismissViewControllerAnimated:animated completion:^{
                
            }];
        }
    }
    
    [navigationController popToRootViewControllerAnimated:animated];
    
    return YES;
}

// 页面跳转
- (BOOL)goMainScreenFromNullByIndex:(MainScreenIndex)screenIndex info:(NSDictionary*)info
{
    [self removeAllViewControllers];
    
    [MINavigator openMainViewController:screenIndex];
    
    return YES;
}

- (BOOL)goMainScreenFromAnyByIndex:(MainScreenIndex)screenIndex info:(NSDictionary*)info
{
    [self popToRootViewControllerWithAnimated:YES];
    
    UIViewController* vc = self.navigationController.topViewController;
    
    MIMainScreenViewController* mainVC = nil;
    if ([vc isKindOfClass:[MIMainScreenViewController class]]) {
        mainVC = (MIMainScreenViewController*)vc;
    } else {
        return [self goMainScreenFromNullByIndex:screenIndex info:info];
    }
    
    if (mainVC.tabBar != nil) {
        [mainVC.tabBar setSelectTabIndex:screenIndex animated:YES];
    } else {
        mainVC.currentViewControllerIndex = screenIndex;
    }
    
    return YES;
}

- (void)goTaobaoShopingWithTarget:(NSString *)target desc:(NSString *)desc login:(NSString *)login
{
    NSString *path = target;
    if (login && login.integerValue == 1) {
        path = [MIUtility trustLoginWithUrl:target];
    }
    
    NSMutableString * strUrl = [path mutableCopy];
    NSString * outerCode = [[MIMainUser getInstance].userId stringValue];
    if (outerCode != nil && outerCode.length != 0) {
        NSRange range = NSMakeRange(0, [strUrl length]);
        [strUrl replaceOccurrencesOfString:@"unid=1" withString:[NSString stringWithFormat:@"unid=%@", outerCode] options:NSCaseInsensitiveSearch range:range];
    }
    
    [MINavigator openTbWebViewControllerWithURL:[NSURL URLWithString:strUrl] desc:desc];
}

- (void)openShareViewControllerWithType:(NSString *)type title:(NSString *)title desc:(NSString *)desc url:(NSString *)url comment:(NSString *)comment img:(NSString *)img
{
    MIShareViewController *vc = [[MIShareViewController alloc] init];
    vc.itemTitle = title;
    vc.itemDesc = desc;
    vc.itemUrl = url;
    vc.defaultStatus = comment;
    vc.itemImageUrl = img;
    [[MINavigator navigator] openModalViewController:vc animated:YES];
}
#pragma mark - class method
// 打开taobao web页面
+ (void)openTbWebViewControllerWithURL:(NSURL*)url desc:(NSString *)desc
{
    MITbWebViewController * webVC = [[MITbWebViewController alloc] initWithURL:url];
    webVC.webTitle = desc;
    [[MINavigator navigator] openPushViewController: webVC animated:YES];
}

// 打开taobao web/detail页面
+ (void)openTbViewControllerWithNumiid:(NSString*)numiid desc:(NSString *)desc
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:[MIConfig globalConfig].tbUrl, numiid]];
    MITbWebViewController *webVC = [[MITbWebViewController alloc] initWithURL:url];
    webVC.numiid = numiid;
    webVC.webTitle = desc;
    [[MINavigator navigator] openPushViewController: webVC animated:YES];
}

// 打开登录界面
+ (void)openLoginViewController
{
    MILoginContainerViewController* vc = [[MILoginContainerViewController alloc] init];
    [[MINavigator navigator] openModalViewController:vc animated:YES];
}

// 打开注册界面
+ (void)openBindEmailViewController;
{
    MIEmailBindViewController *controller = [[MIEmailBindViewController alloc] init];
    [[MINavigator navigator] openPushViewController:controller animated:YES];
}

// 打开主界面
+ (void)openMainViewController:(NSInteger)index
{
    MIMainScreenViewController* vc = [[MIMainScreenViewController alloc] initWithIndex:index];
    [[MINavigator navigator] openPushViewController:vc animated:NO];
}

// 打开设置界面
+ (void)openSettingViewController
{
    MISettingViewController* vc = [[MISettingViewController alloc] init];
    [[MINavigator navigator] openPushViewController:vc animated:YES];
}

// 打开新手引导界面
+ (void)openGuideViewController:(BOOL)fromSetting
{
    MILoginGuideViewController *vc = [[MILoginGuideViewController alloc] init];
    [[MINavigator navigator] openPushViewController:vc animated:YES];
}

+ (void)showSimpleHudWithTips:(NSString *)tips
{
    [MINavigator showSimpleHudWithTips:tips afterDelay:1.3];
}

+ (void)showSimpleHudWithTips:(NSString *)tips afterDelay:(NSTimeInterval)delay
{
    MIAppDelegate* delegate = (MIAppDelegate*)[[UIApplication sharedApplication] delegate];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:delegate.window animated:YES];
    
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = tips;
    hud.margin = 10.f;
    hud.yOffset = -100.f;
    hud.removeFromSuperViewOnHide = YES;
    
    [hud hide:YES afterDelay:delay];
}

+ (BOOL)openShortCutWithDictInfo:(NSDictionary *)dictInfo
{
    NSString *target = [[dictInfo objectForKey:@"target"] trim];
    NSString *desc = [dictInfo objectForKey:@"desc"];
    NSString *version = [dictInfo objectForKey:@"ver"];
    NSString *data = [dictInfo objectForKey:@"data"];
    NSString *login = [dictInfo objectForKey:@"login"];
    
    BOOL handled = YES;
    if (version && [version compare:[MIConfig globalConfig].version] == NSOrderedDescending) {
        MIButtonItem *cancelItem = [MIButtonItem itemWithLabel:@"稍后再说"];
        cancelItem.action = nil;
        
        MIButtonItem *affirmItem = [MIButtonItem itemWithLabel:@"立即更新"];
        affirmItem.action = ^{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[MIConfig globalConfig].appStoreURL]];
        };
        
        UIAlertView *updateAlertView = [[UIAlertView alloc] initWithTitle:@"米姑娘提示"
                                                                  message:@"需要升级新版本，才拥有该功能哦~"
                                                         cancelButtonItem:cancelItem
                                                         otherButtonItems:affirmItem, nil];
        [updateAlertView show];
        return YES;
    }

    if ([target hasPrefix:@"MI"]) {
        Class viewControllerClass = NSClassFromString(target);
        id obj = [[viewControllerClass alloc] init];
        [[MINavigator navigator] openPushViewController:(UIViewController *)obj animated:YES];
    } else if ([target hasPrefix:@"itms-apps://phobos.apple.com"] || [target hasPrefix:@"https://itunes.apple.com"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:target]];
    } else if ([MIUtility isWebURL:[NSURL URLWithString:target]]) {
        NSURL *url = [NSURL URLWithString:target];
        if (url) {
            NSInteger *flag = [[dictInfo objectForKey:@"flag"] integerValue];
            if (flag > 0) {
                // 外部打开
                [[UIApplication sharedApplication] openURL:url];
                return YES;
            }
        }
        
        BOOL isBeibei = [[url host] hasSuffix:@"beibei.com"];
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"beibeiapp://"]] && isBeibei) {
            if ([target isEqualToString:@"http://m.beibei.com"] || [target isEqualToString:@"http://m.beibei.com/"] || [target hasPrefix:@"http://m.beibei.com?"] || [target hasPrefix:@"http://m.beibei.com/?"]) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"beibeiapp://"]];
            } else {
                NSString *scheme = [NSString stringWithFormat:@"beibeiapp://action?target=webview&url=%@", [target urlEncode:NSUTF8StringEncoding]];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:scheme]];
            }
        }
        else {
            if (![[MIMainUser getInstance] checkLoginInfo] && [target rangeOfString: @"unid=1"].location != NSNotFound) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithLoginRebateAction:^{
                    [[MINavigator navigator] goTaobaoShopingWithTarget:target desc:desc login:login];
                }];
                [alertView show];
            } else {
                [[MINavigator navigator] goTaobaoShopingWithTarget:target desc:desc login:login];
            }
        }
    }
    else if ([target isPureInt]) {
        //淘宝商品投放
        [MINavigator openTbViewControllerWithNumiid:target desc:desc];
    } else if ([target isEqualToString:@"zhi"]) {//ver=2.0.0之后的版本开始支持
        MIZhiDetailViewController *detailView = [[MIZhiDetailViewController alloc] initWithItem:nil];
        detailView.zid = desc;
        [[MINavigator navigator] openPushViewController:detailView animated:YES];
    } else if ([target isEqualToString:@"yugao"]) {
        MITomorrowViewController *tomorrowVC = [[MITomorrowViewController alloc] init];
        [[MINavigator navigator] openPushViewController:tomorrowVC animated:YES];
    } else if ([target isEqualToString:@"groupon"] && [dictInfo objectForKey:@"data"]) {
        MITuanViewController *tenTuanVC = [[MITuanViewController alloc] init];
        tenTuanVC.isNavigationBar = YES;
        tenTuanVC.cat = [dictInfo objectForKey:@"data"];
        [[MINavigator navigator] openPushViewController:tenTuanVC animated:YES];
    } else if ([target isEqualToString:@"youpin"] && [dictInfo objectForKey:@"data"]) {//ver=3.2.0之后的版本开始支持
        MITuanViewController *tenTuanVC = [[MITuanViewController alloc] init];
        tenTuanVC.isNavigationBar = YES;
        tenTuanVC.subject = target;
        tenTuanVC.cat = [dictInfo objectForKey:@"data"];
        [[MINavigator navigator] openPushViewController:tenTuanVC animated:YES];
    } else if ([target isEqualToString:@"10yuan"] || [target isEqualToString:@"9kuai9"] || [target isEqualToString:@"19kuai9"]) {
        //ver=3.2.0之后的版本开始支持
        MITuanViewController *tenTuanVC = [[MITuanViewController alloc] init];
        tenTuanVC.isNavigationBar = YES;
        tenTuanVC.cat = [dictInfo objectForKey:@"data"];
        [[MINavigator navigator] openPushViewController:tenTuanVC animated:YES];
    } else if ([target isEqualToString:@"cat"] || [target isEqualToString:@"temai"]) {
        //ver=3.2.0之后的版本开始支持
        MITemaiViewController *temaiVC = [[MITemaiViewController alloc] init];
        temaiVC.cat = [dictInfo objectForKey:@"data"];
        temaiVC.navigationBarTitle = @"今日特卖";
        [[MINavigator navigator] openPushViewController:temaiVC animated:YES];
    } else if ([target isEqualToString:@"brandshop"]) {
        //ver=3.2.0之后的版本开始支持
        NSInteger aid = [[dictInfo objectForKey:@"aid"] integerValue];
        MIBrandViewController *vc = [[MIBrandViewController alloc] initWithAid:aid];
        vc.numIid = [[dictInfo objectForKey:@"iid"] stringValue];
        [[MINavigator navigator] openPushViewController:vc animated:YES];
    }  else if([target isEqualToString:@"my_favor"]){
        // 跳转到收藏夹
        MIUserFavorViewController *vc = [[MIUserFavorViewController alloc] init];
        vc.type = ItemType;     // 优先跳到收藏单品
        if (data && [data isEqualToString:@"brand"]) {
            vc.type = BrandType;
        }
        [[MINavigator navigator] openPushViewController:vc animated:YES];
    } else if ([target isEqualToString:@"detail"]) {
        NSInteger type = [[dictInfo objectForKey:@"type"] integerValue];
        NSInteger tid = [[dictInfo objectForKey:@"tid"] integerValue];
        NSString *iid = [[dictInfo objectForKey:@"iid"] description];
        if (type == 1 || type == 2) {
            MITuanDetailViewController *vc = [[MITuanDetailViewController alloc] initWithItem:nil placeholderImage:nil];
            vc.iid = iid;
            [vc.detailGetRequest setType:type];
            [vc.detailGetRequest setTid:tid];
            [[MINavigator navigator] openPushViewController:vc animated:YES];
        } else if (type == 3) {
            MIBrandTuanDetailViewController *vc = [[MIBrandTuanDetailViewController alloc] initWithItem:nil placeholderImage:nil];
            vc.iid = iid;
            [vc.request setType:type];
            [vc.request setTid:tid];
            [[MINavigator navigator] openPushViewController:vc animated:YES];
        } else {
            handled = NO;
            MILog(@"undefined");
        }
    } else if([target isEqualToString:@"brand"]){
        MIBrandTeMaiViewController *brandViewController = [[MIBrandTeMaiViewController alloc] init];
        brandViewController.isNavigationBar = YES;
        brandViewController.cat = [dictInfo objectForKey:@"data"];
        [[MINavigator navigator] openPushViewController:brandViewController animated:YES];
    } else if([target isEqualToString:@"beibeishop"]){
        NSInteger eventId = [[dictInfo objectForKey:@"data"] integerValue];
        MIBBBrandViewController *vc = [[MIBBBrandViewController alloc] initWithEventId:eventId];
        [[MINavigator navigator] openPushViewController:vc animated:YES];
    }else if ([target isEqualToString:@"nvzhuang"]){
        MIWomenViewController *womenVC = [[MIWomenViewController alloc] init];
        womenVC.cat = [dictInfo objectForKey:@"data"];
        womenVC.catName = desc;
        [[MINavigator navigator] openPushViewController:womenVC animated:YES];
    }else if ([target isEqualToString:@"tuan_hot"] ){
        //跳转到热卖页面（居家百货。手机周边）
        MIListTableViewController *listVC = [[MIListTableViewController alloc] init];
        listVC.target = target;
        listVC.data = [dictInfo objectForKey:@"data"];
        listVC.catName = desc;
        [[MINavigator navigator] openPushViewController:listVC animated:YES];
    }
    else if ( [target isEqualToString:@"tuan_activity"]){
        //根据data跳转到限量抢购、优品推荐、热卖页面
        if ([data isEqualToString:@"youpin_recommend"]) {
            //优品推荐
            MIYoupinRecommendViewController *vc = [[MIYoupinRecommendViewController alloc] init];
            vc.data = data;
            [[MINavigator navigator] openPushViewController:vc animated:YES];
        } else if([data isEqualToString:@"limited_buy"]){
            //限量抢购
            MILimitTuanViewController *vc = [[MILimitTuanViewController alloc]init];
            vc.data = data;
            [[MINavigator navigator] openPushViewController:vc animated:YES];
        }else{
            //热卖页面
            MIListTableViewController *listVC = [[MIListTableViewController alloc] init];
            listVC.target = target;
            listVC.data = [dictInfo objectForKey:@"data"];
            listVC.catName = desc;
            [[MINavigator navigator] openPushViewController:listVC animated:YES];
        }
    } else if ([target isEqualToString:@"account"]) {
        // 个人中心
        MIVIPCenterViewController *vc = [[MIVIPCenterViewController alloc] init];
        [[MINavigator navigator] openPushViewController:vc animated:YES];
    } else if ([target isEqualToString:@"exchange"]) {
        // 集分宝
        MIExchangeViewController *vc = [[MIExchangeViewController alloc] init];
        [[MINavigator navigator] openPushViewController:vc animated:YES];
    } else if ([target isEqualToString:@"invite"]) {
        // 邀请送现金
        MIInviteFriendsViewController *vc = [[MIInviteFriendsViewController alloc] init];
        [[MINavigator navigator] openPushViewController:vc animated:YES];
    } else if ([target isEqualToString:@"message"]) {
        // 消息中心
        MIMsgCenterViewController *vc = [[MIMsgCenterViewController alloc] init];
        [[MINavigator navigator] openPushViewController:vc animated:YES];
    } else if ([target isEqualToString:@"my_order"]) {
        // 我的订单
        NSURL *orderURL = [NSURL URLWithString:[MIConfig globalConfig].myTaobao];
        MIMyOrderViewController *myOrderViewController = [[MIMyOrderViewController alloc] initWithURL:orderURL];
        [[MINavigator navigator] openPushViewController:myOrderViewController animated:YES];
    } else if ([target isEqualToString:@"withdraw"]) {
        // 提现页面
        MIPayApplyViewController *vc = [[MIPayApplyViewController alloc] init];
        [[MINavigator navigator] openPushViewController:vc animated:YES];
    } else if ([target isEqualToString:@"safe_test"]) {
        // 安全检测
        MISecurityAccountViewController *vc = [[MISecurityAccountViewController alloc] init];
        [[MINavigator navigator] openPushViewController:vc animated:YES];
    }
    else {
        //跳转到主界面相应的tab
        NSString *map = [[MIConfig globalConfig].tabBarMaps objectForKey:target];
        if (map) {
            [[MINavigator navigator] goMainScreenFromAnyByIndex:map.integerValue info:nil];
        } else {
            handled = NO;
        }
    }
    
    return handled;
}

- (BOOL)isTaobaoURL:(NSURL*)URL {
    return [URL.scheme caseInsensitiveCompare:@"taobao"] == NSOrderedSame
    || [URL.scheme caseInsensitiveCompare:@"itaobao"] == NSOrderedSame
    || [URL.scheme caseInsensitiveCompare:[MIConfig globalConfig].taobaoSche] == NSOrderedSame;
}

// 根据扫描结果进入相应页面
- (void)openScanViewController:(NSString *)str
{
    NSURL *url = [NSURL URLWithString:str];
    if (url == nil) {
        // 去掉参数尝试，防止因为参数不合法(没有urlencode)造成解析URL失败
        NSString *urlStr = str;
        if ([str rangeOfString:@"?"].location != NSNotFound) {
            urlStr = [str substringToIndex:[str rangeOfString:@"?"].location];
        }
        url = [NSURL URLWithString:urlStr];
    }

    NSString *mizheappInfo;
    
    if ([self isTaobaoURL:url]) {
        //如果是淘宝app scheme，必须跳转淘宝才能查看详情且h5还可以支持返利，则提示用户下载淘宝app
        NSRegularExpression *sclickRegExp = [NSRegularExpression regularExpressionWithPattern:[MIConfig globalConfig].jumpTb options:NSRegularExpressionCaseInsensitive error: nil];
        NSUInteger matches = [sclickRegExp numberOfMatchesInString:str options:NSMatchingReportCompletion range:NSMakeRange(0, [str length])];
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
    }
    else if ([str rangeOfString:@"mizheapp_info=" options:NSCaseInsensitiveSearch].location != NSNotFound) {
        //处理米折特卖相关链接，跳转到特卖相关页面
        NSString *fragment = url.fragment;
        NSMutableString *mizheUrl = [NSMutableString stringWithString:str];
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
        }
    }
    else if ([MIUtility isWebURL:url]){
        MITbWebViewController *vc = [[MITbWebViewController alloc]initWithURL:url];
        [self openPushViewController:vc animated:NO];
    }
    else if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }
    else {
        MILog(@"undefine");
    }
}

+ (void)showShareActionSheetWithUrl:(NSString *)url title:(NSString *)title desc:(NSString *)desc comment:(NSString *)comment image:(UIImageView *)imageView smallImg:(NSString *)smallImg largeImg:(NSString *)largeImg inView:(UIView *)view platform:(NSString *)platform
{
    MIShareView *shareView = [[MIShareView alloc] initWithFrame:CGRectMake(0, 0, PHONE_SCREEN_SIZE.width, PHONE_SCREEN_SIZE.height)];
    
    NSString *errorMsg;
    __block typeof(shareView) weakShareView = shareView;
    [shareView setCancelBlock:^{
        [UIView animateWithDuration:0.3 animations:^{
            weakShareView.alphaView.alpha = 0;
            weakShareView.bgView.top = weakShareView.viewHeight;
        } completion:^(BOOL finished) {
            weakShareView.hidden = YES;
            [weakShareView removeFromSuperview];
            weakShareView = nil;
        }];
    }];
    
    if ([WXApi isWXAppInstalled]) {
        if ([platform rangeOfString:@"timeline"].location != NSNotFound) {
            [shareView addButtonWithDictionary:@{@"image": @"ic_share_pengyouquan",@"title":@"朋友圈"} withBlock:^(NSInteger index) {
                [MobClick event:kShared label:@"分享到朋友圈"];
                WXMediaMessage *message = [WXMediaMessage message];
                message.title = title;
                message.description = desc ? desc : comment;
                WXWebpageObject *ext = [WXWebpageObject object];
                ext.webpageUrl = url;
                message.mediaObject = ext;
                
                MBProgressHUD *_hub = [MBProgressHUD showHUDAddedTo:view animated:YES];
                _hub.labelText = @"加载中...";
                _hub.margin = 10.f;
                _hub.yOffset = -60.f;
                _hub.removeFromSuperViewOnHide = YES;
                
                UIImageView *shareImageView = [[UIImageView alloc] init];
                
                [shareImageView sd_setImageWithURL:[NSURL URLWithString:smallImg]
                                      placeholderImage:[UIImage imageNamed:@"app_share_pic"]
                                    completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
                                        if (shareImageView) {
                                            NSData *imageData = UIImageJPEGRepresentation(shareImageView.image, 1.0);
                                            message.thumbData = UIImageJPEGRepresentation(shareImageView.image, (32*1024.0 / imageData.length));
                                        } else {
                                            [message setThumbImage:[UIImage imageNamed:@"app_share_pic"]];
                                        }
                                        
                                        SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
                                        req.message = message;
                                        req.scene = WXSceneTimeline;
                                        [WXApi sendReq:req];
                                        
                                        [_hub hide:YES afterDelay:0.3];
                                    }];
            }];
        }
        
        if ([platform rangeOfString:@"weixin"].location != NSNotFound) {
            [shareView addButtonWithDictionary:@{@"image": @"ic_share_weixin",@"title":@"微信好友"} withBlock:^(NSInteger index) {
                [MobClick event:kShared label:@"分享给微信好友"];
                WXMediaMessage *message = [WXMediaMessage message];
                message.title = title;
                message.description = desc ? desc : comment;
                WXWebpageObject *ext = [WXWebpageObject object];
                ext.webpageUrl = url;
                message.mediaObject = ext;
                
                MBProgressHUD *_hub = [MBProgressHUD showHUDAddedTo:view animated:YES];
                _hub.labelText = @"加载中...";
                _hub.margin = 10.f;
                _hub.yOffset = -60.f;
                _hub.removeFromSuperViewOnHide = YES;

                UIImageView *shareImageView = [[UIImageView alloc] init];
                [shareImageView sd_setImageWithURL:[NSURL URLWithString:smallImg]
                             placeholderImage:[UIImage imageNamed:@"app_share_pic"]
                                    completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
                                        if (shareImageView) {
                                            NSData *imageData = UIImageJPEGRepresentation(shareImageView.image, 1.0);
                                            message.thumbData = UIImageJPEGRepresentation(shareImageView.image, (32*1024.0 / imageData.length));
                                        } else {
                                            [message setThumbImage:[UIImage imageNamed:@"app_share_pic"]];
                                        }
                                        
                                        SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
                                        req.message = message;
                                        req.scene = WXSceneSession;
                                        [WXApi sendReq:req];
                                        
                                        [_hub hide:YES afterDelay:0.3];
                                    }];
                
            }];
        }
    } else {
        errorMsg = @"对不起，请先安装微信";
    }
    
    // 在QQ未安装，且为当前审核版本，隐藏掉qzone分享
    if ((![[MIConfig globalConfig].version isEqualToString:[MIConfig globalConfig].reviewVersion] || [QQApiInterface isQQInstalled])
        && [platform rangeOfString:@"qzone"].location != NSNotFound) {
        [shareView addButtonWithDictionary:@{@"image": @"ic_share_kongjian",@"title":@"QQ空间"} withBlock:^(NSInteger index) {
            [MobClick event:kShared label:@"分享到QQ空间"];
            QQApiNewsObject *newsObj = [QQApiNewsObject
                                        objectWithURL:[NSURL URLWithString:url]
                                        title:title
                                        description:desc ? desc : comment
                                        previewImageURL:[NSURL URLWithString:smallImg]];
            SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
            QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
            if (EQQAPISENDFAILD == sent) {
                [MINavigator showSimpleHudWithTips:@"分享失败，请稍后再试"];
            }
        }];
    }
    
    if ([QQApiInterface isQQInstalled]) {
        if ([platform rangeOfString:@"qq"].location != NSNotFound) {
            [shareView addButtonWithDictionary:@{@"image": @"ic_share_qq",@"title":@"QQ好友"} withBlock:^(NSInteger index) {
                [MobClick event:kShared label:@"分享给QQ好友"];
                
                NSData *imageData;
                if (imageView) {
                    imageData = UIImageJPEGRepresentation(imageView.image, 1.0);
                } else {
                    NSString *imgPath = [[MIMainUser documentPath] stringByAppendingPathComponent:@"app_share_pic"];
                    imageData = [NSData dataWithContentsOfFile:imgPath];
                }
                QQApiNewsObject *object = [QQApiNewsObject objectWithURL:[NSURL URLWithString:url] title:title description:desc ? desc : comment previewImageData:imageData];
                SendMessageToQQReq* req = [SendMessageToQQReq reqWithContent:object];
                
                [QQApiInterface sendReq:req];
            }];
        }
    } else {
        if (errorMsg) {
            errorMsg = [NSString stringWithFormat:@"%@和QQ", errorMsg];
        } else {
            errorMsg = @"对不起，请先安装QQ";
        }
    }
    
    if ([platform rangeOfString:@"weibo"].location != NSNotFound) {
        [shareView addButtonWithDictionary:@{@"image": @"ic_share_weibo",@"title":@"新浪微博"} withBlock:^(NSInteger index) {
            MISinaWeibo *sinaWeibo = [MISinaWeibo getInstance];
            if ([sinaWeibo isAuthValid]) {
                [[MINavigator navigator] openShareViewControllerWithType:kShareToSinaWeibo title:title desc:desc url:url comment:comment img:largeImg];
            } else {
                NSString *type = [kShareToSinaWeibo copy];
                NSString *itemTitle = [title copy];
                NSString *itemDesc = [desc copy];
                NSString *itemUrl = [url copy];
                NSString *itemComment = [comment copy];
                NSString *itemImg = [largeImg copy];
                
                SEL invoSelector = @selector(openShareViewControllerWithType:title:desc:url:comment:img:);
                NSMethodSignature* ms = [MINavigator instanceMethodSignatureForSelector:invoSelector];
                NSInvocation* invocation = [NSInvocation invocationWithMethodSignature:ms];
                [invocation setTarget:[MINavigator navigator]];
                [invocation setSelector:invoSelector];
                [invocation setArgument:&type atIndex:2];
                [invocation setArgument:&itemTitle atIndex:3];
                [invocation setArgument:&itemDesc atIndex:4];
                [invocation setArgument:&itemUrl atIndex:5];
                [invocation setArgument:&itemComment atIndex:6];
                [invocation setArgument:&itemImg atIndex:7];
                [invocation retainArguments];
                [sinaWeibo logIn:invocation];
            }
        }];
    }
    
    if ([platform rangeOfString:@"copy"].location != NSNotFound) {
        [shareView addButtonWithDictionary:@{@"image": @"ic_share_copy",@"title":@"复制链接"} withBlock:^(NSInteger index) {
            [UIPasteboard generalPasteboard].string = [NSString stringWithFormat:@"%@ %@",title,url];
            [MINavigator showSimpleHudWithTips:@"已复制链接，去分享给好友吧"];
        }];
    }
    
    if ([platform rangeOfString:@"gohome"].location != NSNotFound) {
        [shareView addButtonWithDictionary:@{@"image": @"ic_share_home",@"title":@"返回首页"} withBlock:^(NSInteger index) {
            [MobClick event:kShared label:@"回到首页"];
            //跳转我的页面
            [[MINavigator navigator] goMainScreenFromAnyByIndex:MAIN_SCREEN_INDEX_HOMEPAGE info:nil];;
        }];
    }
    
    if ([platform rangeOfString:@"refresh"].location != NSNotFound) {
        [shareView addButtonWithDictionary:@{@"image":@"ic_share_refresh",@"title":@"刷新"} withBlock:^(NSInteger index){
            [[NSNotificationCenter defaultCenter] postNotificationName:MiNotifyWebViewReload object:nil];
        }];
    }
    
    
    if (shareView.eventArray.count) {
        [shareView loadData];
        [view addSubview:shareView];
        [UIView animateWithDuration:0.3 animations:^{
            shareView.alphaView.alpha = 0.35;
            shareView.bgView.top = shareView.viewHeight - shareView.bgView.viewHeight;
        }];
    } else {
        errorMsg = errorMsg ? errorMsg : @"对不起，你的手机不支持分享";
        [MINavigator showSimpleHudWithTips:errorMsg];
    }
}

+ (void)showSimpleHudTips:(NSString *)tips
{
    MIAppDelegate* delegate = (MIAppDelegate*)[[UIApplication sharedApplication] delegate];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:delegate.window animated:YES];
    
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = tips;
    hud.margin = 10.f;
    //    hud.yOffset = -80.f;
    hud.removeFromSuperViewOnHide = YES;
    
    [hud hide:YES afterDelay:1.3];
}

@end