//
//  MIBaseViewController.m
//  MISpring
//
//  Created by Yujian Xu on 13-3-11.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIBaseViewController.h"

@implementation MIBaseViewController
@synthesize loading = _loading;
@synthesize needRefreshView = _needRefreshView;
@synthesize overlayView = _overlayView;
@synthesize baseScrollView = _baseScrollView;
@synthesize baseTableView = _baseTableView;
@synthesize buttomPullDistance = _buttomPullDistance;
@synthesize navigationBar = _navigationBar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _buttomPullDistance = 50.0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.hasStatusBarHotSpot = IS_HOTSPOT_ON;
    
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [MIUtility colorWithHex:0xeeeeee];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    if (IOS_VERSION >= 7.0)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
	}
    
    MIPHONE_NAVIGATIONBAR_HEIGHT(IOS_VERSION, _navigationBarHeight);
    self.navigationBar = [[MICustomNavigationBar alloc] initWithFrame:CGRectMake(0, 0, PHONE_SCREEN_SIZE.width, _navigationBarHeight)];
    [self.view addSubview:self.navigationBar];
    
    MIOverlayView *view = [[MIOverlayView alloc] initWithFrame:CGRectMake(0, _navigationBarHeight, self.view.viewWidth, self.view.viewHeight - _navigationBarHeight)];
    view.userInteractionEnabled = NO;
    view.loadingText = NSLocalizedString(@"加载中...", @"加载中...");
    view.reloadText = NSLocalizedString(@"点击屏幕，重新加载", @"点击屏幕，重新加载");
    view.emptyText = NSLocalizedString(@"暂无内容", @"暂无内容");
    view.errorText = NSLocalizedString(@"网络不给力，请稍后再试", @"网络不给力，请稍后再试");
    view.alpha = 0;
    view.animate = YES;
    view.status = EOverlayStatusRemove;
    self.overlayView = view;
    [self.view addSubview:self.overlayView];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reloadTableViewDataSource)];
    [self.overlayView addGestureRecognizer:tapGestureRecognizer];
    
    _panBackController = [[YAPanBackController alloc] initWithCurrentViewController:self];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
	if (IOS_VERSION >= 7.0) {
        return UIStatusBarStyleDefault;
	} else {
		return UIStatusBarStyleBlackOpaque;
	}
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation
{
	return UIStatusBarAnimationNone;
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([self.navigationController.viewControllers count] > 1) {
        // 多于一级的时候，再创建返回按钮
        [self.navigationBar setBarLeftButtonItem:self selector:@selector(miPopToPreviousViewController) imageKey:@"navigationbar_btn_back"];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleUIApplicationWillChangeStatusBarFrameNotification:) name:UIApplicationWillChangeStatusBarFrameNotification object:nil];
    
    if (self.hasStatusBarHotSpot != IS_HOTSPOT_ON) {
        [self relayoutView];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_panBackController addPanBackToView:self.view];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [_panBackController removePanBackFromView:self.view];
}

- (void)handleUIApplicationWillChangeStatusBarFrameNotification:(NSNotification*)notification
{
    // 子类实现(状态栏变化通知)结合IS_HOTSPOT来判断是否开启的热点栏
    if (self.hasStatusBarHotSpot != IS_HOTSPOT_ON) {
        [self relayoutView];
    }
}

- (void)relayoutView
{
    self.hasStatusBarHotSpot = IS_HOTSPOT_ON;
    
    // 子类去做重新布局
}

//-(void)handleSwipeFromDirectionRight:(UISwipeGestureRecognizer *)recognizer {
//    [self miPopToPreviousViewController];
//}

#pragma mark - class methods

- (void)setBaseScrollView:(UIScrollView *)baseScrollView
{
    if (_baseScrollView == nil) {
        _baseScrollView = baseScrollView;
        _baseScrollView.contentSize = CGSizeMake(baseScrollView.viewWidth, baseScrollView.viewHeight + 1);
        _baseScrollView.delegate = self;
        _baseScrollView.showsVerticalScrollIndicator = NO;
    }

    if (_needRefreshView) {
        //初始化下拉刷新控件
        _refreshTableView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, -104, self.view.viewWidth, 104)];
        _refreshTableView.delegate = self;
        [_baseScrollView addSubview:_refreshTableView];
    }

    [self.view addSubview:_baseScrollView];
}

- (void)setBaseTableView:(UITableView *)baseTableView
{
    if (_baseTableView == nil) {
        _baseTableView = baseTableView;
    }

    if (_needRefreshView) {
        //初始化下拉刷新控件
        _refreshTableView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, -104, self.view.viewWidth, 104)];
        _refreshTableView.delegate = self;
        [_baseTableView addSubview:_refreshTableView];
    }

    [self.view addSubview:_baseTableView];
}

- (void)miPopViewControllerWithAnimated:(BOOL)animated
{
    [[MINavigator navigator] closePopViewControllerAnimated:animated];
}

- (void)miPopToPreviousViewController
{
    [[MINavigator navigator] closePopViewControllerAnimated:YES];
}

- (void)miPopToViewControllerAtIndex:(NSUInteger)index
{
    [[MINavigator navigator] closePopViewControllerAtIndex:index animated:YES];
}

+ (UIBarButtonItem *)navigationBackButtonItemWithTarget:(id)target action:(SEL)action{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *normalImage = [UIImage imageNamed:@"navigationbar_btn_back"];
    UIImage *hlImage = [UIImage imageNamed:@"navigationbar_btn_back"];
    [button setImage:normalImage forState:UIControlStateNormal];
    [button setImage:hlImage forState:UIControlStateHighlighted];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    button.frame = CGRectMake(0,
                              0,
                              button.currentImage.size.width,
                              button.currentImage.size.height);

    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    buttonItem.width = [button currentImage].size.width;
    buttonItem.width = button.frame.size.width;
    return buttonItem;
}

// 提示
- (void)setOverlayStatus:(MIOverlayStatus )newStatus labelText:(NSString *)desc{
    @synchronized(self) {
        [self.overlayView suitForStatus:newStatus labelText:desc];
        // 设置alpha
        CGFloat finalAlpha = newStatus == EOverlayStatusRemove ? 0 : 1;

        [self.view bringSubviewToFront:_overlayView];
        if (!_overlayView.animate) {
            self.overlayView.alpha = finalAlpha;
        }else {
            [UIView animateWithDuration:0.3 animations:^(){
                self.overlayView.alpha = finalAlpha;
            }];
        }
    }
}

- (void)showSimpleHUD:(NSString *)tip{
    [self showSimpleHUD:tip afterDelay:1.3];
}

- (void)showSimpleHUD:(NSString *)tip afterDelay:(NSTimeInterval)delay{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = tip;
    hud.margin = 10.f;
    hud.yOffset = -100.f;
    hud.removeFromSuperViewOnHide = YES;

    [hud hide:YES afterDelay:delay];
}

- (void)showProgressHUD:(NSString *)tip{
    [self hideProgressHUD];
    _progresshud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _progresshud.yOffset = -60.f;
    _progresshud.labelText = tip;
    _progresshud.removeFromSuperViewOnHide = YES;
}

- (void)hideProgressHUD{
    if (_progresshud) {
        [_progresshud hide:YES];
        _progresshud = nil;
    }
}

#pragma mark - Data Source Loading / loading Methods
//开始重新加载时调用的方法
- (void)reloadTableViewDataSource{
    // 子类实现
    MILog(@"reloadDataWithLoadingOverlayStatus");
    [self setOverlayStatus:EOverlayStatusLoading labelText:nil];
}

//上拉继续加载更多时调用的方法
- (void)loadMoreTableViewDataSource
{
    // 子类实现

}

//完成加载时调用的方法
- (void)finishLoadTableViewData
{
    if (_baseScrollView) {
        [_refreshTableView egoRefreshScrollViewDataSourceDidFinishedLoading:self.baseScrollView];
    }

    if (_baseTableView) {
        [_refreshTableView egoRefreshScrollViewDataSourceDidFinishedLoading:self.baseTableView];
    }
}

//加载失败时调用的方法
- (void)failLoadTableViewData
{
    if (_baseScrollView) {
        [_refreshTableView egoRefreshScrollViewDataSourceDidFinishedLoading:self.baseScrollView];
    }

    if (_baseTableView) {
        [_refreshTableView egoRefreshScrollViewDataSourceDidFinishedLoading:self.baseTableView];
    }
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
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

//返回刷新时间的回调方法
-(NSString *)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView *)view
{
    return [NSString stringWithFormat:@"最后更新: %@", [[NSDate date] stringForSectionTitle3]];
}

#pragma mark - UIScrollViewDelegate Methods
//滚动控件的委托方法
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_needRefreshView) {
        [_refreshTableView egoRefreshScrollViewDidScroll:scrollView];
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (_needRefreshView) {
        [_refreshTableView egoRefreshScrollViewDidEndDragging:scrollView];

        //上拉刷新
        CGPoint offset = scrollView.contentOffset;
        CGRect bounds = scrollView.bounds;
        CGSize size = scrollView.contentSize;
        UIEdgeInsets inset = scrollView.contentInset;
        float y = offset.y + bounds.size.height - inset.bottom;
        if((y > size.height + _buttomPullDistance) && !_loading) {
            [self loadMoreTableViewDataSource];
        }
    }
}

@end

#pragma mark - MIEmptyTipView
@interface MIOverlayView (private)
// 重置图片
- (void)resetImgWithName:(NSString *)name;

@end

@implementation MIOverlayView
@synthesize status = _overlayStatus;
@synthesize imgView = _imgView;
@synthesize label = _label;
@synthesize loadingText = _loadingText;
@synthesize emptyText = _emptyText;
@synthesize errorText = _errorText;
@synthesize indicatorView = _indicatorView;
@synthesize animate = _animate;

// 状态机切换
- (void)suitForStatus:(MIOverlayStatus)status  labelText:(NSString *)desc{
    self.status = status;

    if (status == EOverlayStatusLoading) {
        [self.indicatorView startAnimating];
    }
    else {
        if ([self.indicatorView isAnimating]) {
            [self.indicatorView stopAnimating];
        }
    }

    switch (status) {
        case EOverlayStatusLoading:
            [self resetImgWithName:nil];
            self.label.text = (desc ? desc : _loadingText);
            break;

        case EOverlayStatusReload:
            self.userInteractionEnabled = YES;
            self.label.text = (desc ? desc : _reloadText);
            [self resetImgWithName:@"overlay_error"];
            break;

        case EOverlayStatusEmpty:
            self.label.text = (desc ? desc : _emptyText);
            [self resetImgWithName:@"order_not_found"];
            break;

        case EOverlayStatusError:
            self.label.text = (desc ? desc : _errorText);
            [self resetImgWithName:@"overlay_error"];
            break;

        case EOverlayStatusRemove:
            self.label.text = nil;
            [self resetImgWithName:nil];
            break;

        default:
            break;
    }
}

- (UIImageView *)imgView {
    if (_imgView == nil) {
        NSInteger navigationBarHeight;
        MIPHONE_NAVIGATIONBAR_HEIGHT(IOS_VERSION, navigationBarHeight);

        CGRect newFrame = CGRectMake(0, (self.viewHeight - kOverlayImageHeight - kOverlayTextHeight) / 2 - navigationBarHeight, self.viewWidth, kOverlayImageHeight);
        _imgView = [[UIImageView alloc] initWithFrame:newFrame];
        _imgView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_imgView];
    }

    return _imgView;
}

- (UILabel *)label {
    if (_label == nil) {
        NSInteger navigationBarHeight;
        MIPHONE_NAVIGATIONBAR_HEIGHT(IOS_VERSION, navigationBarHeight);

        CGRect newFrame = CGRectMake(0, (self.viewHeight - kOverlayImageHeight - kOverlayTextHeight) / 2 + kOverlayImageHeight - navigationBarHeight, self.viewWidth, kOverlayTextHeight);
        _label = [[UILabel alloc] initWithFrame:newFrame];
        _label.backgroundColor = [UIColor clearColor];
        _label.numberOfLines = 0;
        _label.textAlignment = UITextAlignmentCenter;
        _label.textColor = [UIColor grayColor];
        [self addSubview:_label];
    }

    return _label;
}

- (UIActivityIndicatorView *)indicatorView {
    if (_indicatorView == nil) {
        NSInteger navigationBarHeight;
        MIPHONE_NAVIGATIONBAR_HEIGHT(IOS_VERSION, navigationBarHeight);

        CGFloat indicatorWidth = 30;
        CGRect newFrame = CGRectMake((self.viewWidth - indicatorWidth) / 2,
                                     (self.viewHeight - kOverlayImageHeight - kOverlayTextHeight) / 2 + kOverlayImageHeight - indicatorWidth - navigationBarHeight,
                                     indicatorWidth,
                                     indicatorWidth);
        _indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:newFrame];
        _indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;

        [self addSubview:_indicatorView];
    }

    return _indicatorView;
}

// 重置图片
- (void)resetImgWithName:(NSString *)name {
    [self.imgView setImage:[UIImage imageNamed:name]];
}

@end

