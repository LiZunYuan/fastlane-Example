//
//  MITeachingsViewController.m
//  MISpring
//
//  Created by Yujian Xu on 13-4-14.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MITeachingsViewController.h"
#import "UIImage+MIAdditions.h"

@implementation MITeachingsViewController
@synthesize pics = _pics;
@synthesize pageControl = _pageControl;

- (void)viewDidLoad
{
    [super viewDidLoad];
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.frame = CGRectMake(0, self.navigationBarHeight, PHONE_SCREEN_SIZE.width, (self.view.viewHeight - self.navigationBarHeight));
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.bounces = NO;
    _scrollView.backgroundColor = [MIUtility colorWithHex:0x9BACB3];
    [self.view addSubview:_scrollView];
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.view.viewHeight - 15, SCREEN_WIDTH, 5)];
    [self.view addSubview:_pageControl];
    [self.view bringSubviewToFront:self.navigationBar];

    _pics = [[NSMutableArray alloc] initWithCapacity:10];
    [_pics addObject:@"http://s0.mizhe.cn/prom/2014/q2/iphone_taobao_course_001.jpg"];
    [_pics addObject:@"http://s0.mizhe.cn/prom/2014/q3/iphone_taobao_course_002.jpg"];
    [_pics addObject:@"http://s0.mizhe.cn/prom/2014/q3/iphone_taobao_course_003.jpg"];
    [_pics addObject:@"http://s0.mizhe.cn/prom/2014/q2/iphone_taobao_course_004.jpg"];
    [_pics addObject:@"http://s0.mizhe.cn/prom/2014/q2/iphone_taobao_course_005.jpg"];
    [_pics addObject:@"http://s0.mizhe.cn/prom/2014/q2/iphone_mall_course_001.jpg"];
    [_pics addObject:@"http://s0.mizhe.cn/prom/2014/q2/iphone_mall_course_002.jpg"];
    [_pics addObject:@"http://s0.mizhe.cn/prom/2014/q2/iphone_mall_course_003.jpg"];
    [_pics addObject:@"http://s0.mizhe.cn/prom/2014/q2/iphone_mall_course_004.jpg"];    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationBar setBarTitle: @"淘宝返利-新手指南" textSize:20.0];
    [self setOverlayStatus:EOverlayStatusLoading labelText:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    for (int i = 0; i < [_pics count]; i++ ) {
        
        UIImageView *pic = [[UIImageView alloc] initWithFrame:CGRectMake(PHONE_SCREEN_SIZE.width*i,
                                                                         0,
                                                                         PHONE_SCREEN_SIZE.width,
                                                                         self.view.viewHeight - self.navigationBarHeight)];
        pic.contentMode = UIViewContentModeCenter;
        __weak UIImageView *wPic = pic;
        [pic sd_setImageWithURL:[NSURL URLWithString:[_pics objectAtIndex:i]]
            placeholderImage:[UIImage imageNamed:@"default_avatar_img"]
                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                       wPic.contentMode = UIViewContentModeScaleToFill;
                       UIImage *subImage = [UIImage getSubImage:image rect:CGRectMake(0, 0, PHONE_SCREEN_SIZE.width*2, (self.view.viewHeight - self.navigationBarHeight)*2)];
                       [wPic setImage:subImage];
                   }];
        
        [_scrollView addSubview:pic];
    }
    [_scrollView addSubview:[self theLastView:CGRectMake(PHONE_SCREEN_SIZE.width*[_pics count], 0,
                                                         PHONE_SCREEN_SIZE.width, self.view.viewHeight  - self.navigationBarHeight)]];
    _scrollView.contentSize = CGSizeMake(PHONE_SCREEN_SIZE.width * ([_pics count]+1), self.view.viewHeight - self.navigationBarHeight);
    _pageControl.enabled = NO;
    _pageControl.currentPage = 0;
    _pageControl.numberOfPages = 10;
    [self setOverlayStatus:EOverlayStatusRemove labelText:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    _scrollView = nil;
}

- (UIView*)theLastView:(CGRect)frame{
    UIView *lastview = [[UIView alloc] initWithFrame:frame];
    UIImageView *viewbg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, PHONE_SCREEN_SIZE.width, self.view.viewHeight - self.navigationBarHeight)];
    viewbg.contentMode = UIViewContentModeCenter;

    __weak UIImageView *wPic = viewbg;
    [viewbg sd_setImageWithURL:[NSURL URLWithString:@"http://s0.mizhe.cn/prom/2014/q2/iphone_mall_course_005.jpg"]
           placeholderImage:[UIImage imageNamed:@"default_avatar_img"]
                  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                      wPic.contentMode = UIViewContentModeScaleToFill;
                      UIImage *subImage = [UIImage getSubImage:image rect:CGRectMake(0, 0, PHONE_SCREEN_SIZE.width*2, (self.view.viewHeight - self.navigationBarHeight)*2)];
                      [wPic setImage:subImage];
                  }];
    [lastview addSubview:viewbg];
    
    UIButton *start = [[MICommonButton alloc] initWithFrame:CGRectMake(45,self.view.viewHeight - self.navigationBarHeight - 65,232,35)];
    [start setTitle:NSLocalizedString(@"马上去购物，拿返利", @"马上去购物，拿返利") forState:UIControlStateNormal];
    [start addTarget:self action:@selector(startExperiences) forControlEvents:UIControlEventTouchUpInside];
    [lastview addSubview:start];
    
    return lastview;
}

- (void)startExperiences
{
    [[MINavigator navigator] goMainScreenFromAnyByIndex:MAIN_SCREEN_INDEX_REBATE info:nil];
}

#pragma mark - scrollView && page
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat pageWidth = _scrollView.frame.size.width;
    int page = floor((_scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    _pageControl.currentPage = page;
    if (page > 4) {
        [self.navigationBar setBarTitle: @"商城返利-新手指南" textSize:20.0];
    } else {
        [self.navigationBar setBarTitle: @"淘宝返利-新手指南" textSize:20.0];
    }
}

@end
