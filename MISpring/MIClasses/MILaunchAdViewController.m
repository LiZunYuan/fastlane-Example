//
//  MILaunchAdViewController.m
//  MISpring
//
//  Created by 曲俊囡 on 14-5-20.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MILaunchAdViewController.h"
#import "MIAppDelegate.h"

@implementation MILaunchAdViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.navigationController setNavigationBarHidden:YES animated:NO];
    if (IOS_VERSION >= 7.0)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
	}
    
    self.viewHeight = SCREEN_HEIGHT;
    if (IOS_VERSION < 7.0) {
        self.viewHeight -= PHONE_STATUSBAR_HEIGHT;
    }
    self.adScrollView.frame = CGRectMake(0, 0, PHONE_SCREEN_SIZE.width, self.viewHeight);
    self.detailButton.layer.borderColor = [MIUtility colorWithHex:0xff8800].CGColor;
    self.detailButton.layer.borderWidth = 2;
    self.detailButton.layer.cornerRadius = 3;
    // Do any additional setup after loading the view from its nib.
    [self addADsImageViews:self.adsArrayDict];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    MIAppDelegate *appDelegate = (MIAppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.bShowLaunchAd = YES;
    
    [self startTimer];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self stopTimer];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
	if (IOS_VERSION >= 7.0) {
		return UIStatusBarStyleLightContent;
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

- (void)startTimer
{
    [self stopTimer];
    self.adsTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(handleTimer:) userInfo:nil repeats:YES];
}

- (void)stopTimer
{
    if (self.adsTimer) {
        [self.adsTimer invalidate];
        self.adsTimer = nil;
    }
}

- (void) handleTimer: (NSTimer *) timer
{
    [self refreshView];
    if (_pageControl.currentPage == _pageControl.numberOfPages - 1) {
        [self startExperiences];
    }else{
        _pageControl.currentPage++;
    }
    
    [UIView animateWithDuration:0.7
                     animations:^{
                         _adScrollView.contentOffset = CGPointMake(_pageControl.currentPage*SCREEN_WIDTH, 0);
                     }];
}
#pragma mark - 加载广告图片
- (void)addADsImageViews:(NSArray *) adsArrayDict{
    NSInteger i = 0;
    for (NSDictionary *dict in adsArrayDict) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(PHONE_SCREEN_SIZE.width * i++, 0, PHONE_SCREEN_SIZE.width, self.viewHeight)];
        unsigned long bg = strtoul([[dict objectForKey:@"bg"] UTF8String], 0, 16);
        view.backgroundColor = [MIUtility colorWithHex:bg];
        [_adScrollView addSubview:view];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 460 * SCREEN_WIDTH / 320)];
        imageView.centerY = view.centerY;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [imageView sd_setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"img"]]];
        [view addSubview:imageView];
    }
    
    if (1 == adsArrayDict.count)
    {
        _adScrollView.userInteractionEnabled = YES;
        UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(startExperiences)];
        swipe.direction = UISwipeGestureRecognizerDirectionLeft;
        [_adScrollView addGestureRecognizer:swipe];
    }
    [_adScrollView setContentSize:CGSizeMake(PHONE_SCREEN_SIZE.width * [adsArrayDict count], self.viewHeight)];
    [_adScrollView setContentOffset:CGPointMake(0, 0)];
    _pageControl.numberOfPages = [adsArrayDict count];
    _pageControl.currentPage = 0;
    [self refreshView];
}

- (void)refreshView
{
    if (self.pageControl.currentPage == self.pageControl.numberOfPages - 1)
    {
        self.pageControl.hidden = YES;
        self.reminderLabel.hidden = NO;
    } else {
        self.pageControl.hidden = NO;
        self.reminderLabel.hidden = YES;
    }
    
    if (self.adsArrayDict.count > self.pageControl.currentPage) {
        NSDictionary *dict = [self.adsArrayDict objectAtIndex:self.pageControl.currentPage];
        NSString *urlString = [dict objectForKey:@"target"];
        if (!urlString || [urlString isEqualToString:@""])
        {
            self.detailButton.hidden = YES;
        }
        else
        {
            self.detailButton.hidden = NO;
        }
    }
}

- (IBAction)goToDetail:(id)sender {
    if (_adsArrayDict.count > _pageControl.currentPage) {
        NSMutableDictionary *dict = [_adsArrayDict objectAtIndex:_pageControl.currentPage];
        NSString *desc = [dict objectForKey:@"desc"];
        NSString *login = [dict objectForKey:@"login"];
        if (login.integerValue == 1 && ![[MIMainUser getInstance] checkLoginInfo]) {
            [self stopTimer];
            MIButtonItem *cancelItem = [MIButtonItem itemWithLabel:@"取消"];
            cancelItem.action = ^{
                [self startTimer];
            };
            MIButtonItem *affirmItem = [MIButtonItem itemWithLabel:@"登录"];
            affirmItem.action = ^{
                [MINavigator openLoginViewController];
            };
            [[[UIAlertView alloc] initWithTitle:@"提醒" message:@"亲，请先登录哦~" cancelButtonItem:cancelItem otherButtonItems:affirmItem, nil] show];
        } else {
            if (1 == self.adsArrayDict.count) {
                [[MINavigator navigator] popToRootViewController:NO];
            }
            
            [MINavigator openShortCutWithDictInfo:dict];
        }
        
        [MobClick event:kSplashAdsClicks label:desc];
    }
}

- (void)startExperiences
{
    [self stopTimer];
    NSInteger toViewControllerIndex = [self.navigationController.viewControllers count] - 2;
    if (toViewControllerIndex < 0) {
        toViewControllerIndex = 0;
    }
    UIViewController *toViewController = [self.navigationController.viewControllers objectAtIndex:toViewControllerIndex];
    UIView *supView = self.view.superview;
    [supView insertSubview:toViewController.view belowSubview:self.view];
    [self.navigationController.view layoutIfNeeded];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.view.left = -SCREEN_WIDTH;
    } completion:^(BOOL finished) {
        [toViewController.view removeFromSuperview];
        [[MINavigator navigator] closePopViewControllerAnimated:NO];
    }];
}

#pragma mark - scrollView && page
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pageWidth = _adScrollView.frame.size.width;
    NSInteger page = floor((_adScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    _pageControl.currentPage = page;
    [self refreshView];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.bounds;
    float x = offset.x + bounds.size.width;
    if(x >= scrollView.contentSize.width) {
        [self startExperiences];
    }
}
@end
