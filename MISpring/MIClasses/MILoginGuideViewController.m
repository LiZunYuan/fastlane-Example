//
//  MILoginGuideViewController.m
//  MISpring
//
//  Created by XU YUJIAN on 13-1-17.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MILoginGuideViewController.h"
#import "MINavigator.h"

@implementation MILoginGuideViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    if (IOS_VERSION >= 7.0)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
	}
    
    self.view.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    NSMutableArray *pics = [[NSMutableArray alloc] initWithCapacity:3];
    [pics addObject:@"introduced001"];
    [pics addObject:@"introduced002"];
    [pics addObject:@"introduced003"];

    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, PHONE_SCREEN_SIZE.width, self.view.viewHeight)];
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.contentSize = CGSizeMake(PHONE_SCREEN_SIZE.width * ([pics count] + 1), self.view.viewHeight);
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.bounces = NO;
    _scrollView.backgroundColor = [UIColor whiteColor];

    for (NSInteger i=0;i<pics.count;i++ ) {
        CGRect frame = CGRectMake(PHONE_SCREEN_SIZE.width*i, 0, PHONE_SCREEN_SIZE.width, self.view.viewHeight);
        UIImageView *pic = [[UIImageView alloc] initWithFrame:frame];
        pic.contentMode = UIViewContentModeScaleAspectFit;
        pic.backgroundColor = [MIUtility colorWithHex:0xf8f8f8];

        //不加载到系统缓存中。
        NSString *imagePath = [[NSBundle mainBundle] pathForResource:[pics objectAtIndex:i] ofType:@"png"];
        NSData *imagedata = [NSData dataWithContentsOfFile:imagePath];
        UIImage *image = [UIImage imageWithData:imagedata];
        [pic setImage:image];
        [_scrollView addSubview:pic];
    }
    [_scrollView addSubview:[self theLastView:CGRectMake(PHONE_SCREEN_SIZE.width*[pics count], 0,
                                                             PHONE_SCREEN_SIZE.width, self.view.viewHeight)]];
    [self.view addSubview:_scrollView];
    
    UIImageView *closeView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_close"]];
    closeView.userInteractionEnabled = YES;
    closeView.left = PHONE_SCREEN_SIZE.width - closeView.viewWidth - 10;
    closeView.top = 10;
    UITapGestureRecognizer *closeRecoginzer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(startExperiences)];
    [closeView addGestureRecognizer:closeRecoginzer];
    [self.view addSubview:closeView];
}

- (UIView*)theLastView:(CGRect)frame{
    UIView *lastview = [[UIView alloc] initWithFrame:frame];
    UIImageView *viewbg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, PHONE_SCREEN_SIZE.width, self.view.viewHeight)];
    viewbg.contentMode = UIViewContentModeScaleAspectFit;
    viewbg.backgroundColor = [MIUtility colorWithHex:0xf8f8f8];

    NSString *imagePath = nil;

    imagePath = [[NSBundle mainBundle] pathForResource:@"introduced004" ofType:@"png"];
    NSData *imagedata = [NSData dataWithContentsOfFile:imagePath];
    UIImage *image = [UIImage imageWithData:imagedata];
    [viewbg setImage:image];
    [lastview addSubview:viewbg];    

    UITapGestureRecognizer *loginRecoginzer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(startExperiences)];
    [lastview addGestureRecognizer:loginRecoginzer];
    
    return lastview;
}

- (void)startExperiences
{
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
        [[MINavigator navigator] popToRootViewController:NO];
    }];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

    _scrollView = nil;
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
    return YES;
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
