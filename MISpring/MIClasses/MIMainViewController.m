//
//  MIMainViewController.m
//  MISpring
//
//  Created by XU YUJIAN on 13-1-17.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIAppDelegate.h"
#import "MIMainViewController.h"
#import "MILoginViewController.h"
#import "MITuanItemModel.h"
#import "MITuanTenCatModel.h"
#import "NSDate+NSDateExt.h"
#import "NSString+NSStringEx.h"
#import "MITuanItemView.h"
#import "MITuanItemsCell.h"
#import "MITopScrollView.h"
#import "MIMainTableView.h"
#import "MIBaseTableView.h"
#import "MIMainWebview.h"
#import "MIScanViewController.h"
#import "FLAnimatedImageView.h"
#import "FLAnimatedImage.h"
#import "MIAdService.h"
#import "MIPopupItemView.h"
#import "MIInviteFriendsViewController.h"
#import "MIWomenTableView.h"

typedef void (^rockBlock)();
typedef void (^scanBlock)();
typedef void (^signInBlock)();

#define MI_MAINPAGE_ADS_SCROLLVIEW_TAG    9999
#define MI_MAINPAGE_SEARCHBAR_WIDTH       255

@interface MIMainViewController()<MITopScrollViewDelegate,MIViewLifecycleDelegate>
{
    UIView *_guideBgView;
    UIImageView *_guideImgView1;
    UIImageView *_guideImgView2;
    
    MITopScrollView *_scrollTop;
    UIScrollView *_mainScrollView;
    NSMutableArray *_mainTableViewArray;
    UIView *_currentView;
    UIButton *_screenBtn;
    UIView  *_topBg;
    FLAnimatedImageView *_gifImageView;
    NSArray        *_topbarArray;
    UIView *_transparentCoverView;  // popupMenu相关
}

@property (nonatomic, strong) FLAnimatedImageView *gifImageView;
@property (nonatomic, strong) MIPopupItemView *popupItemView;
@property (nonatomic, copy) rockBlock rockBlock;
@property (nonatomic, copy) scanBlock scanBlock;
@property (nonatomic, copy) signInBlock signInBlock;
@end

static BOOL configHasUpdate = NO;

@implementation MIMainViewController

+ (void)setRefreshFlag:(BOOL)flag
{
    configHasUpdate = flag;
}

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        _hasMore = NO;
        _isShowScreen = NO;
        _tuanTenPageSize = 30;

        _datasCateNames = [[NSMutableArray alloc] initWithCapacity:10];
        _datasCateIds = [[NSMutableArray alloc] initWithCapacity:10];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //信鸽tag
    if ([MIUtility isBeibeiAppExist]) {
        [XGPush delTag:@"未安装贝贝特卖"];
        [XGPush setTag:@"已安装贝贝特卖"];
    } else {
        [XGPush delTag:@"已安装贝贝特卖"];
        [XGPush setTag:@"未安装贝贝特卖"];
    }
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults boolForKey:kShakeTag]) {
        [XGPush delTag:@"未摇一摇用户"];
        [XGPush setTag:@"摇一摇用户"];
    } else {
        [XGPush delTag:@"摇一摇用户"];
        [XGPush setTag:@"未摇一摇用户"];
    }
    
    if ([userDefaults boolForKey:kSigninTag]) {
        [XGPush delTag:@"未签到用户"];
        [XGPush setTag:@"签到用户"];
    } else {
        [XGPush delTag:@"签到用户"];
        [XGPush setTag:@"未签到用户"];
    }

    if ([userDefaults stringForKey:kRandomTag] == nil || [userDefaults stringForKey:kRandomTag].length == 0) {
        NSArray *array = [[NSArray alloc] initWithObjects:@"A", @"B", @"C", @"D", nil];
        NSString *randomKey = [array objectAtIndex:arc4random() % 3];
        [XGPush setTag:randomKey];
        [userDefaults setObject:randomKey forKey:kRandomTag];
    }
    
    self.needRefreshView = YES;
//    [self.navigationBar setBarTitleImage:@"logo"];
    [self.navigationBar setBarTitle:@"米折网" textSize:20.0];
    self.navigationBar.titleLabel.textColor = [UIColor whiteColor];
    self.navigationBar.backgroundColor = MIColorNavigationBarBackground;
    [self.navigationBar setBarLeftButtonItem:self selector:@selector(toScanCode) imageKey:@"ic_richscan"];
    [self.navigationBar setBarRightButtonItem:self selector:@selector(showSearchView) imageKey:@"ic_search"];
    
    _gifImageView = [[FLAnimatedImageView alloc] initWithFrame:CGRectMake(0, IOS7_STATUS_BAR_HEGHT, 160, 44)];
    UITapGestureRecognizer *rec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickAds)];
    [_gifImageView addGestureRecognizer:rec];
    _gifImageView.contentMode = UIViewContentModeScaleToFill;
    _gifImageView.hidden = YES;
    _gifImageView.centerX = self.navigationBar.viewWidth/2;
    [self.navigationBar addSubview:_gifImageView];
    
    self.titleArray = [[NSMutableArray alloc] initWithCapacity:10];
    
    _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.navigationBar.bottom + 33, PHONE_SCREEN_SIZE.width, self.view.viewHeight - self.navigationBar.bottom - TABBAR_HEIGHT - 33)];
    _mainScrollView.showsHorizontalScrollIndicator = NO;
    _mainScrollView.pagingEnabled = YES;
    _mainScrollView.delegate = self;
    [self.view addSubview:_mainScrollView];
    _mainScrollView.scrollsToTop = NO;
    
    _mainTableViewArray = [[NSMutableArray alloc]initWithCapacity:5];
    
    _scrollTop = [[MITopScrollView alloc] initWithFrame:CGRectMake(0, self.navigationBar.bottom, self.view.viewWidth-33, 33)];
    _scrollTop.showsHorizontalScrollIndicator = NO;
    _scrollTop.showsVerticalScrollIndicator = NO;
    _scrollTop.topScrollViewDelegate = self;
    _scrollTop.bounces = NO;
    _scrollTop.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_scrollTop];
    _scrollTop.scrollsToTop = NO;
    
    _shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, PHONE_SCREEN_SIZE.width, self.view.viewHeight - TABBAR_HEIGHT)];
    self.shadowView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.35];
    self.shadowView.alpha = 0;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenScreenView)];
    [self.shadowView addGestureRecognizer:tap];
    [self.view addSubview:self.shadowView];
    [self.view insertSubview:self.shadowView belowSubview:_scrollTop];

    
    [self loadTuanCatsData:YES];
    
    _screenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _screenBtn.backgroundColor = [UIColor whiteColor];
    [_screenBtn setImage:[UIImage imageNamed:@"the_drop_down"] forState:UIControlStateNormal];
    [_screenBtn addTarget:self action:@selector(showScreenView) forControlEvents:UIControlEventTouchUpInside];
    _screenBtn.frame = CGRectMake(PHONE_SCREEN_SIZE.width - 33, self.navigationBar.bottom, 33, 33);
    [self.view addSubview:_screenBtn];
    
    UIView *screenLine = [[UIView alloc] initWithFrame:CGRectMake(0, (_scrollTop.viewHeight - 14) / 2, 1, 14)];
    screenLine.backgroundColor = [MIUtility colorWithHex:0xeeeeee];
    [_screenBtn addSubview:screenLine];
    
    UIView *screenbottomLine = [[UIView alloc]initWithFrame:CGRectMake(0, _screenBtn.viewHeight - 0.5, _screenBtn.viewWidth, 0.5)];
    screenbottomLine.backgroundColor = [MIUtility colorWithHex:0xe4e4e4];
    [_screenBtn addSubview:screenbottomLine];
    
    _topBg = [[UIView alloc]initWithFrame:CGRectMake(0, self.navigationBar.bottom, self.view.viewWidth - 33, 33)];
    _topBg.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.frame = CGRectMake(_topBg.centerX-30 + 33/2.0, 0, 60, 33);
    titleLabel.text = @"分类列表";
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor whiteColor];
    titleLabel.textColor = [MIUtility colorWithHex:0x999999];
    [_topBg addSubview:titleLabel];
    
    UIView *bottomLine = [[UIView alloc]initWithFrame:CGRectMake(0, _topBg.viewHeight - 0.5, self.view.viewWidth, 0.5)];
    bottomLine.backgroundColor = [MIUtility colorWithHex:0xe4e4e4];
    [_topBg addSubview:bottomLine];
    _topBg.alpha = 0;
    [self.view addSubview:_topBg];
    
    //弹出框后的其他地方加上透明view
    _transparentCoverView = [[UIView alloc] initWithFrame:self.view.bounds];
    _transparentCoverView.backgroundColor = [UIColor clearColor];
    
    //点击左上角+按钮后的弹出框
    _popupItemView = [[MIPopupItemView alloc]initWithFrame:CGRectMake(8, self.navigationBar.bottom  - (90 + 43), 120, 90 + 43)];
    _popupItemView.backgroundColor = [UIColor clearColor];
    _popupItemView.clipsToBounds = YES;
    
    NSMutableArray *array = [[NSMutableArray alloc]init];
    __weak typeof(self) weakSelf = self;
    self.rockBlock = ^{
        //进入摇一摇
        [weakSelf hidePopupMenu];
        NSString *shakeUrl = [MIConfig globalConfig].shakeUrl;
            MIWebViewController *vc = [[MIWebViewController alloc]initWithURL:[NSURL URLWithString:shakeUrl]];
            [[MINavigator navigator] openPushViewController:vc animated:YES];
    };
    self.scanBlock = ^{
        //扫码
        [weakSelf toScanCode];
    };
    self.signInBlock = ^{
       // 签到
        [weakSelf hidePopupMenu];
        NSString *checkinPath = [MIConfig globalConfig].checkinURL;
        [MINavigator openTbWebViewControllerWithURL:[NSURL URLWithString:checkinPath] desc:@"每日签到"];
    };
    [array addObject:[PopupMenuItem itemWithIcon:@"ic_default_qiandao" desc:@"每日签到" block:self.signInBlock]];
    [array addObject:[PopupMenuItem itemWithIcon:@"ic_default_yao" desc:@"摇一摇" block:self.rockBlock]];
    [array addObject:[PopupMenuItem itemWithIcon:@"ic_default_saoma" desc:@"扫一扫" block:self.scanBlock]];
    
    [_popupItemView setImgAndDescWithArray:array];
    
    UITapGestureRecognizer *tapNoneMenu = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hidePopupMenu)];
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(hidePopupMenu)];
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(hidePopupMenu)];
    [_transparentCoverView addSubview:_popupItemView];
    [_transparentCoverView addGestureRecognizer:tapNoneMenu];
    [_transparentCoverView addGestureRecognizer:swipeGesture];
    [_transparentCoverView addGestureRecognizer:panGesture];
    
    [self.view addSubview:_transparentCoverView];
    _transparentCoverView.alpha = 0;
    [self.view bringSubviewToFront:_popupItemView];
    [self.navigationBar setBarLeftButtonItem:self selector:@selector(togglePopupMenu) imageKey:@"ic_default_more"];
    
    [self.view insertSubview:_transparentCoverView aboveSubview:_topBg];

    
    [self.view bringSubviewToFront:self.navigationBar];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self registerNotifications];
    
    [self hiddenScreenView];
    
    if ([[MIConfig globalConfig].version isEqualToString:[MIConfig globalConfig].closeSearchVersion]) {
        self.navigationBar.rightButton.hidden = YES;
    } else {
        self.navigationBar.rightButton.hidden = NO;
    }
    
    [self viewBecomeActive];
    
    FLAnimatedImageView * __block gifImageView = _gifImageView;
    FLAnimatedImage * __block gifImage = nil;
    UIImage * __block gifImage2 = nil;
    [[MIAdService sharedManager] loadAdWithType:@[@(Topbar_Ads)] block:^(MIAdsModel *model){
        _topbarArray = model.topbarAds;
        if (IOS_VERSION >= 6.0)
        {
        
            if (model.topbarAds.count > 0)
            {
                self.navigationBar.titleLabel.hidden = YES;
                NSDictionary *dict = [model.topbarAds objectAtIndex:0];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSURL *url = [NSURL URLWithString:[dict objectForKey:@"img"]];
                    NSData *data2 = [NSData dataWithContentsOfURL:url];
                    gifImage = [FLAnimatedImage animatedImageWithGIFData:data2];
                    if (gifImage == nil) {
                        gifImage2 = [UIImage imageWithData:data2];
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (gifImage)
                        {
                            gifImageView.animatedImage = gifImage;
                            gifImageView.hidden = NO;
                            gifImageView.userInteractionEnabled = YES;
                        }
                        else if(gifImage2)
                        {
                            gifImageView.image = gifImage2;
                            gifImageView.hidden = NO;
                            gifImageView.userInteractionEnabled = YES;
                        }
                        else
                        {
                            gifImageView.animatedImage = nil;
                            gifImageView.hidden = YES;
                        }
                    });
                });
            }
            else
            {
                self.navigationBar.titleLabel.hidden = NO;
                gifImageView.animatedImage = nil;
                gifImageView.hidden = YES;
            }
        }
    }];
}

- (void)clickAds
{
    if (_topbarArray.count > 0)
    {
        NSDictionary *dict = [_topbarArray objectAtIndex:0];
        [MobClick event:kTopbarAds];
        [MINavigator openShortCutWithDictInfo:dict];
    }
}

- (void)relayoutView {
    [super relayoutView];
    
    CGFloat offset = HOTSPOT_STATUSBAR_HEIGHT;
    if (IS_HOTSPOT_ON) {
        offset = -HOTSPOT_STATUSBAR_HEIGHT;
    }
    
    _mainScrollView.viewHeight += offset;//self.view.viewHeight + offset - self.navigationBar.bottom - TABBAR_HEIGHT - 33;
    for (UIView *tableView in _mainTableViewArray) {
        if (tableView.viewHeight != _mainScrollView.viewHeight) {
            tableView.viewHeight = _mainScrollView.viewHeight;
        }
    }
}

/**
 * 在“后台”进入前台后才调用，第一次启动时，并不调用。
 */
- (void)viewBecomeActive
{
    NSDate *lastUpdateTuanTime = [[NSUserDefaults standardUserDefaults] objectForKey:kLastUpdateTemaiTime];
    NSInteger interval = [lastUpdateTuanTime timeIntervalSinceNow];
    if ((interval <= MIAPP_ONE_HOUR_INTERVAL && [[Reachability reachabilityForInternetConnection] isReachable]) || (configHasUpdate && self.appearFromTab)) {
        //如果超出一小时，清空特卖缓存
        configHasUpdate = NO;
        [self loadTuanCatsData:YES];
        
        self.appearFromTab = NO;
    }
    
    if(_currentView && [_currentView respondsToSelector:@selector(willAppearView)])
    {
        [_currentView performSelector:@selector(willAppearView) withObject:nil];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSString *lastVersion = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastVersion"];
    if (lastVersion != nil && [lastVersion compare:@"3.4.0"] == NSOrderedAscending) {
        [MITipView showAlertTipWithKey:@"MIMainViewController" message:@"1.米折网已升级为国内最大女性特卖平台，致力于为年轻女性提供专属的特卖服务。\n2.根据淘宝返利规则调整，返利查询结果不再显示，但对于支持返利的商品，你仍可以通过正确购买步骤获得返利，具体金额以实际到账为准。\n3.根据商城返利规则调整，米折App暂停商城返利功能，如需使用请前往米折网页版www.mizhe.com，已通过App完成购买的订单信息会同步到网页版。"];
    } else {
        // 判断是否显示引导图
        NSUserDefaults *userDefauts = [NSUserDefaults standardUserDefaults];
        
        MIAppDelegate *appDelegate = (MIAppDelegate *)[UIApplication sharedApplication].delegate;
        if (![appDelegate willShowSplashAds]) {
            if (![userDefauts objectForKey:@"homeGuideImg"]) {
                [self performSelector:@selector(showGuideImg) withObject:nil afterDelay:0.5];
            } else {
                [self performSelector:@selector(showDailogAds) withObject:nil afterDelay:0.5];
            }
        }
    }
    

}

- (void)showDailogAds
{
    MIAppDelegate *appDelegate = (MIAppDelegate *)[UIApplication sharedApplication].delegate;
    // 如果即将显示闪屏或者当前显示的不是带tabbar的页面（闪屏或者userguide）,则等0.5秒后再显示
    if ([appDelegate willShowSplashAds] || ![[MINavigator navigator].navigationController.topViewController isMemberOfClass:[MIMainScreenViewController class]]) {
        [self performSelector:@selector(showDailogAds) withObject:nil afterDelay:0.5];
        return;
    }
    
    if (_currentView && [_currentView isMemberOfClass:[MIMainTableView class]]) {
        [((MIMainTableView *)_currentView) showDailogAds];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if(_currentView && [_currentView respondsToSelector:@selector(willDisappearView)])
    {
        [_currentView performSelector:@selector(willDisappearView) withObject:nil];
    }
    [self.view.window makeKeyWindow];
    [self removeNotifications];
    [self hidePopupMenu];
}

-(void)showGuideImg
{
    MIAppDelegate *appDelegate = (MIAppDelegate *)[UIApplication sharedApplication].delegate;
    
    if ([appDelegate willShowSplashAds] || ![[MINavigator navigator].navigationController.topViewController isMemberOfClass:[MIMainScreenViewController class]]) {
        [self performSelector:@selector(showGuideImg) withObject:nil afterDelay:0.5];
        return;
    }
    
    if (_currentView && [_currentView isMemberOfClass:[MIMainTableView class]]) {
        [self showGuideImgView];
    }
}
-(void)showGuideImgView
{
    MIAppDelegate* delegate = (MIAppDelegate*)[UIApplication sharedApplication].delegate;
    UIWindow* window = delegate.window;
    
    if (_guideBgView) {
        [window bringSubviewToFront:_guideBgView];
        return;
    }
    _guideBgView = [[UIView alloc]initWithFrame:window.frame];
    _guideBgView.backgroundColor = [MIUtility colorWithHex:0x000000];
    _guideBgView.alpha = 0.8;
    _guideBgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapToGuide = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideGuideImg)];
    [_guideBgView addGestureRecognizer:tapToGuide];
    [window addSubview:_guideBgView];
    
    _guideImgView1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"img_gudie1"]];
    _guideImgView1.frame = CGRectMake(5, PHONE_STATUSBAR_HEIGHT + 12, 96, 126);
    _guideImgView1.backgroundColor = [UIColor clearColor];
    [_guideBgView addSubview:_guideImgView1];
    
    _guideImgView2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"img_gudie2"]];
    _guideImgView2.backgroundColor = [UIColor clearColor];
    _guideImgView2.frame = CGRectMake(_guideImgView1.centerX, _guideImgView1.bottom, 259, 234.5);
    [_guideBgView addSubview:_guideImgView2];
}

-(void)hideGuideImg
{
    [UIView animateWithDuration:0.3 animations:^{
        _guideBgView.hidden = YES;
        [_guideBgView removeFromSuperview];
    }];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@"HaveHomeGuideImg" forKey:@"homeGuideImg"];
    [userDefaults synchronize];
}

-(void)togglePopupMenu
{
    if (_popupItemView.isShowSelf) {
        [_popupItemView hideSelf];
        [UIView animateWithDuration:0.3 animations:^{
            _transparentCoverView.alpha = 0;
        }];
    }else{
        _transparentCoverView.alpha = 1;
        [_popupItemView showSelf];
    }
}


-(void)hidePopupMenu
{
    if (_popupItemView.isShowSelf) {
        [_popupItemView hideSelf];
        [UIView animateWithDuration:0.3 animations:^{
            _transparentCoverView.alpha = 0;
        }];
    }
}

#pragma mark - Notification 处理
- (void)registerNotifications{
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    
    // 登录成功通知
    [defaultCenter addObserver:self selector:@selector(shareSuccess) name:MINotifyUserHasShared object:nil];
    [defaultCenter addObserver:self selector:@selector(loginSuccess) name:MINotifyUserHasLogined object:nil];
    [defaultCenter addObserver:self selector:@selector(reloadWebview) name:MINotifyWebViewReload object:nil];
    [defaultCenter addObserver:self selector:@selector(viewBecomeActive) name:MIApplicationBecomeActive object:nil];
}

- (void)loginSuccess
{
    for (int i = 0; i < _cats.count; i++)
    {
        NSDictionary *dict = [_cats objectAtIndex:i];
        if ([[dict objectForKey:@"type"] isEqualToString:@"webview"] && _mainTableViewArray.count > i)
        {
            MIMainWebview *mainWebview = [_mainTableViewArray objectAtIndex:i];
            [mainWebview loginSuccess];
        }
    }
}

-(void)toScanCode
{
    [_popupItemView hideSelf];
    [UIView animateWithDuration:0.3 animations:^{
        _transparentCoverView.alpha = 0;
    } completion:^(BOOL finished) {
        MIScanViewController *scanCodeVC = [[MIScanViewController alloc] init];
        [[MINavigator navigator] openModalViewController:scanCodeVC animated:YES];
    }];
}

- (void)reloadHomeViews
{
    [MIMainViewController setRefreshFlag:NO];
    [self setMainCats:[MIConfig getTuanCategory] tabs:[MIConfig getHomeTabs]];
    [self loadHomeTabViews];
    
    if(_currentView && [_currentView respondsToSelector:@selector(willAppearView)])
    {
        [_currentView performSelector:@selector(willAppearView) withObject:nil];
    }
}

- (void)shareSuccess
{
    for (int i = 0; i < _cats.count; i++)
    {
        NSDictionary *dict = [_cats objectAtIndex:i];
        if ([[dict objectForKey:@"type"] isEqualToString:@"webview"] && _mainTableViewArray.count > i)
        {
            MIMainWebview *mainWebview = [_mainTableViewArray objectAtIndex:i];
            [mainWebview shareSuccess];
        }
    }
}

- (void)reloadWebview
{
    for (int i = 0; i < _cats.count; i++)
    {
        NSDictionary *dict = [_cats objectAtIndex:i];
        if ([[dict objectForKey:@"type"] isEqualToString:@"webview"] && _mainTableViewArray.count > i)
        {
            MIMainWebview *mainWebview = [_mainTableViewArray objectAtIndex:i];
            [mainWebview reloadWebview];
        }
    }
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    for (int i = 0; i < _cats.count; i++)
    {
        NSDictionary *dict = [_cats objectAtIndex:i];
        if ([[dict objectForKey:@"type"] isEqualToString:@"webview"] && _mainTableViewArray.count > i)
        {
            MIMainWebview *mainWebview = [_mainTableViewArray objectAtIndex:i];
            [mainWebview motionBegan];
        }
    }
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake)
    {
        for (int i = 0; i < _cats.count; i++)
        {
            NSDictionary *dict = [_cats objectAtIndex:i];
            if ([[dict objectForKey:@"type"] isEqualToString:@"webview"] && _mainTableViewArray.count > i)
            {
                MIMainWebview *mainWebview = [_mainTableViewArray objectAtIndex:i];
                [mainWebview motionEnded];
            }
        }
    }
}

- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake)
    {
        for (int i = 0; i < _cats.count; i++)
        {
            NSDictionary *dict = [_cats objectAtIndex:i];
            if ([[dict objectForKey:@"type"] isEqualToString:@"webview"] && _mainTableViewArray.count > i)
            {
                MIMainWebview *mainWebview = [_mainTableViewArray objectAtIndex:i];
                [mainWebview motionCancelled];
            }
        }
    }
}

- (void)removeNotifications{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 加载轮播广告和快捷入口

- (void)hiddenScreenView
{
    if (self.screenView && _isShowScreen) {
        _isShowScreen = NO;
        self.shadowView.alpha = 0;
        [_screenBtn setImage:[UIImage imageNamed:@"the_drop_down"] forState:UIControlStateNormal];
        [UIView animateWithDuration:0.3 animations:^{
            _topBg.alpha = 0;
            self.screenView.frame = CGRectMake(0, -self.screenView.viewHeight - 20, self.screenView.viewWidth, self.screenView.viewHeight);
        }];
    }
}

- (void) setTopScrollCatArray:(NSArray *)cats
{
    [self.titleArray removeAllObjects];
    for (NSInteger i = 0; i < cats.count; i++)
    {
        NSDictionary *dict = [cats objectAtIndex:i];
        [self.titleArray addObject:[dict objectForKey:@"desc"]];
    }
    _scrollTop.titleArray = self.titleArray;
}

- (void)showScreenView
{
    if (self.screenView)
    {
        if (!_isShowScreen)
        {
            [UIView animateWithDuration:0.3 animations:^{
                self.shadowView.alpha = 1;
                _topBg.alpha = 1;
                [_screenBtn setImage:[UIImage imageNamed:@"Up_arrow"] forState:UIControlStateNormal];
                self.screenView.frame = CGRectMake(0, self.navigationBarHeight + 33, self.screenView.viewWidth, self.screenView.viewHeight);
            }];
            _isShowScreen = YES;
        }
        else
        {
            [UIView animateWithDuration:0.3 animations:^{
                self.shadowView.alpha = 0;
                _topBg.alpha = 0;
                [_screenBtn setImage:[UIImage imageNamed:@"the_drop_down"] forState:UIControlStateNormal];
                self.screenView.frame = CGRectMake(0, -self.screenView.viewHeight - 20, self.screenView.viewWidth, self.screenView.viewHeight);
            }];
            _isShowScreen = NO;
        }
    }
}

- (void)showSearchView
{
    MITbSearchViewController *searchViewController = [[MITbSearchViewController alloc] init];
    [[MINavigator navigator] openPushViewController:searchViewController animated:NO];
}

- (void)selectedIndex:(NSInteger)index
{
    [_mainScrollView setContentOffset:CGPointMake(index*self.view.viewWidth, 0) animated:YES];
    if (_mainTableViewArray.count > index && _scrollTop.currentPage == index) {
        UIView *view = [_mainTableViewArray objectAtIndex:index];
        if (_currentView != view) {
            [self canScrollToTopWithIndex:index];
            [self.screenView synButtonSelectWithIndex:index];
        }
        [self hiddenScreenView];
    }
}

//- (void)selectedCatId:(NSString *)catId catName:(NSString *)catName
//{
//    _cat = catId;
//    if ([catName isEqualToString:@"全部"])
//    {
//        [self.navigationBar setBarTitle:@"今日特卖"  textSize:20.0];
//    }
//    else
//    {
//        [self.navigationBar setBarTitle:catName  textSize:20.0];
//    }
//    
//    for (NSInteger i = 0; i < _cats.count; ++i)
//    {
//         MITuanTenCatModel *model = [_cats objectAtIndex:i];
//        if ([model.catId isEqualToString:_cat])
//        {
//            [self selectedTitleIndex:i];
//            break;
//        }
//    }
//    [self hiddenScreenView];
//}

- (void)selectedSelf
{
    [self hiddenScreenView];
}

- (void)setMainCats:(NSArray *)cats tabs:(NSArray *)tabs
{
    NSMutableArray *mainCats = [[NSMutableArray alloc] initWithCapacity:10];
    NSString *apiUrl = [NSString stringWithFormat:@"http://m.mizhe.com/temai/all---{int}-{int}---1.html"];
    apiUrl = [apiUrl stringByReplacingOccurrencesOfString:@"{int}" withString:@"%d"];
    NSDictionary *newDict = @{@"type":@"latest",@"desc":@"上新",@"api_url":apiUrl};
    [mainCats addObject:newDict];
    
    NSDictionary *yesterdayTab = nil;
    if (tabs && tabs.count > 0) {
        for (NSDictionary *dict in tabs) {
            if ([[dict objectForKey:@"desc"] isEqualToString:@"昨日热卖"]) {
                yesterdayTab = dict;
            }
            else if ([[dict objectForKey:@"type"] isEqualToString:@"webview"]) {
                // 检查是否过期
                NSInteger begin = [[dict objectForKey:@"begin"] integerValue];
                NSInteger end = [[dict objectForKey:@"end"] integerValue];
                NSInteger now = [[NSDate date] timeIntervalSince1970] + [MIConfig globalConfig].timeOffset;
                if (begin > 0 && end > 0 && (begin > now || end < now)) {
                    continue;
                }
                [mainCats addObject:dict];
            }
            else {
                [mainCats addObject:dict];
            }
        }
    }
    
    for (NSInteger i = 0; i < cats.count; ++i)
    {
        MITuanTenCatModel *model = [cats objectAtIndex:i];
        if (![model.catId isEqualToString:@"all"])
        {
            NSString *apiUrl = [NSString stringWithFormat:@"http://m.mizhe.com/temai/%@---{int}-{int}---1.html",model.catId];
            apiUrl = [apiUrl stringByReplacingOccurrencesOfString:@"{int}" withString:@"%d"];
            if ([model.catId isEqualToString:@"nvzhuang"])
            {
                NSDictionary *dict = @{@"type":@"nvzhuang",@"desc":model.catName,@"api_url":apiUrl,@"cat":model.catId};
                [mainCats addObject:dict];
            }
            else
            {
                NSDictionary *dict = @{@"type":@"temai",@"desc":model.catName,@"api_url":apiUrl,@"cat":model.catId};
                [mainCats addObject:dict];
            }
        }
    }
    
    // 昨日热卖加在最后面
    if (yesterdayTab) {
        [mainCats addObject:yesterdayTab];
    }
    
    _cats = mainCats;
}

//得到类目cat的数据
- (void)loadTuanCatsData:(BOOL)reload
{
    _cat = @"";
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
                   {
                       NSArray *cats = [MIConfig getTuanCategory];
                       NSArray *tabs = [MIConfig getHomeTabs];
                       dispatch_async(dispatch_get_main_queue(), ^
                                      {
                                          if (!self.screenView) {
                                              [self setMainCats:cats tabs:tabs];
                                              [self setTopScrollCatArray:_cats];
                                              _screenView = [[MIScreenView alloc] initWithArray:_titleArray];
                                              [self loadHomeTabViews];
                                              self.screenView.delegate = self;
                                              [self.view addSubview:self.screenView];
                                              [self.view insertSubview:self.screenView belowSubview:_scrollTop];
                                          } else {
                                              [self setMainCats:cats tabs:tabs];
                                              [self setTopScrollCatArray:_cats];
                                              [self loadHomeTabViews];
                                              [self.screenView reloadContenWithCats:self.titleArray];
                                          }

                                          //初始化参数为全部
                                          _cat = @"";
                                          _isShowScreen = NO;
                                          self.screenView.frame = CGRectMake(0, -self.screenView.viewHeight - 20, self.screenView.viewWidth, self.screenView.viewHeight);
                                      });
                   });
}

- (void)loadHomeTabViews
{
    [_mainScrollView setContentOffset:CGPointZero];
    [_mainTableViewArray removeAllObjects];
    [_mainScrollView removeAllSubviews];

    _mainScrollView.contentSize = CGSizeMake(_mainScrollView.viewWidth * _cats.count, _mainScrollView.viewHeight);
    
    for (int i = 0; i < _cats.count; ++i)
    {
        NSDictionary *dict = [_cats objectAtIndex:i];
        NSString *type = [dict objectForKey:@"type"];
        NSString *catId = [dict objectForKey:@"cat"];
        if ([type isEqualToString:@"latest"])
        {
            MIMainTableView *mainTableView = [[MIMainTableView alloc] initWithFrame:CGRectMake(i*_mainScrollView.viewWidth, 0, _mainScrollView.viewWidth, _mainScrollView.viewHeight)];
            mainTableView.adBox.adScrollView.scrollsToTop = NO;
            mainTableView.refreshTableView.refreshTitleImg.image = [UIImage imageNamed:@"txt_refresh_default"];
            MIPageBaseRequest *temaiReq  = [[MIPageBaseRequest alloc] init];
            temaiReq.onCompletion = ^(id model) {
                [mainTableView finishLoadTableViewData:model];
            };
            
            temaiReq.onError = ^(MKNetworkOperation* completedOperation, MIError* error){
                [mainTableView failLoadTableViewData];
                MILog(@"error_msg=%@",error.description);
            };
            [temaiReq setFormat:[dict objectForKey:@"api_url"]];
            [temaiReq setModelName:NSStringFromClass([MITemaiGetModel class])];
            [temaiReq setPage:1];
            [temaiReq setPageSize:20];
            mainTableView.request = temaiReq;
            [_scrollTop selectIndexInScrollView:i];
            _currentView = mainTableView;
            if ([_currentView respondsToSelector:@selector(willAppearView)]) {
                [_currentView performSelector:@selector(willAppearView) withObject:nil];
            }
            [_mainTableViewArray addObject:mainTableView];
            [_mainScrollView addSubview:mainTableView];
        }
        else if([type isEqualToString:@"webview"])
        {
            NSURL *URL = [NSURL URLWithString:[dict objectForKey:@"api_url"]];
            MIMainWebview *mainWebview = [[MIMainWebview alloc] initWithURL:URL frame:CGRectMake(i*_mainScrollView.viewWidth, 0, _mainScrollView.viewWidth, _mainScrollView.viewHeight)];
            [_mainTableViewArray addObject:mainWebview];
            [_mainScrollView addSubview:mainWebview];
        }
        else if([type isEqualToString:@"nvzhuang"])
        {
            MIWomenTableView *tableView = [[MIWomenTableView alloc] initWithFrame:CGRectMake(i*_mainScrollView.viewWidth, 0, _mainScrollView.viewWidth, _mainScrollView.viewHeight)];
            tableView.refreshTableView.refreshTitleImg.image = [UIImage imageNamed:@"txt_refresh_default"];
            MIPageBaseRequest *temaiReq  = [[MIPageBaseRequest alloc] init];
            temaiReq.onCompletion = ^(id model) {
                [tableView finishLoadTableViewData:model];
            };
            
            temaiReq.onError = ^(MKNetworkOperation* completedOperation, MIError* error){
                [tableView failLoadTableViewData];
                MILog(@"error_msg=%@",error.description);
            };
            
            [temaiReq setFormat:[dict objectForKey:@"api_url"]];
            [temaiReq setPage:1];
            [temaiReq setPageSize:20];
            [temaiReq setModelName:NSStringFromClass([MITemaiGetModel class])];
            // tableView.cat = model.catId;
            tableView.request = temaiReq;
            [_mainTableViewArray addObject:tableView];
            [_mainScrollView addSubview:tableView];
        }
        else if([type isEqualToString:@"temai"])
        {
            MIBaseTableView *tableView = [[MIBaseTableView alloc] initWithFrame:CGRectMake(i*_mainScrollView.viewWidth, 0, _mainScrollView.viewWidth, _mainScrollView.viewHeight)];
            tableView.catId = catId;
            tableView.refreshTableView.refreshTitleImg.image = [UIImage imageNamed:@"txt_refresh_default"];
            MIPageBaseRequest *temaiReq  = [[MIPageBaseRequest alloc] init];
            temaiReq.onCompletion = ^(id model) {
                [tableView finishLoadTableViewData:model];
            };
            
            temaiReq.onError = ^(MKNetworkOperation* completedOperation, MIError* error){
                [tableView failLoadTableViewData];
                MILog(@"error_msg=%@",error.description);
            };
            
            [temaiReq setFormat:[dict objectForKey:@"api_url"]];
            [temaiReq setPage:1];
            [temaiReq setPageSize:20];
            [temaiReq setModelName:NSStringFromClass([MITemaiGetModel class])];
           // tableView.cat = model.catId;
            tableView.request = temaiReq;
            [_mainTableViewArray addObject:tableView];
            [_mainScrollView addSubview:tableView];
        }
    }
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = scrollView.contentOffset.x/pageWidth;
    if (page != _scrollTop.currentPage && scrollView.contentOffset.x == page * self.view.viewWidth && _mainTableViewArray.count > page)
    {
        [_scrollTop selectIndexInScrollView:page];
        [self canScrollToTopWithIndex:page];
        NSDictionary *dic = [_cats objectAtIndex:page];
        [MobClick event:kTemaiCatClicks label:[dic objectForKey:@"desc"]];
    }
    [self.screenView synButtonSelectWithIndex:page];
    [self hiddenScreenView];
}

-(void)canScrollToTopWithIndex:(NSInteger)index
{
    if ([_currentView respondsToSelector:@selector(willDisappearView)]) {
        [_currentView performSelector:@selector(willDisappearView)];
    }
    _currentView = [_mainTableViewArray objectAtIndex:index];
    if([_currentView respondsToSelector:@selector(willAppearView)])
    {
        [_currentView performSelector:@selector(willAppearView) withObject:nil];
    }

}


@end
