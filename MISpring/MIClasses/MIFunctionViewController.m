//
//  MIFunctionViewController.m
//  MISpring
//
//  Created by Yujian Xu on 13-6-26.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIFunctionViewController.h"
#import "UIImage+MIAdditions.h"

@implementation MIFunctionViewController
@synthesize pics = _pics;

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
    _scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_scrollView];
    
    _pics = [[NSMutableArray alloc] initWithCapacity:4];
    [_pics addObject:@"introduced001"];
    [_pics addObject:@"introduced002"];
    [_pics addObject:@"introduced003"];
    [self setOverlayStatus:EOverlayStatusLoading labelText:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    CGFloat viewTop, viewHeight;
    if ([UIDevice isRetina4inch]) {
        viewTop = 0;
        viewHeight = 460;
    } else {
        viewTop = self.navigationBarHeight;
        viewHeight = self.view.viewHeight - self.navigationBarHeight;
    }
    
    for (NSInteger i = 0; i < [_pics count]; i++ ) {
        CGRect frame = CGRectMake(PHONE_SCREEN_SIZE.width*i, 0, PHONE_SCREEN_SIZE.width, self.view.viewHeight - self.navigationBarHeight);
        UIImageView *pic = [[UIImageView alloc] initWithFrame:frame];
        pic.contentMode = UIViewContentModeScaleAspectFit;
        if (i == 0) {
            pic.backgroundColor = [MIUtility colorWithHex:0xff434d];
        } else if (i == 1) {
            pic.backgroundColor = [MIUtility colorWithHex:0xb346f9];
        } else if (i == 2) {
            pic.backgroundColor = [MIUtility colorWithHex:0xff2e8d];
        }
        
        //不加载到系统缓存中。
        NSString *imagePath = [[NSBundle mainBundle] pathForResource:[_pics objectAtIndex:i] ofType:@"png"];
        NSData *imagedata = [NSData dataWithContentsOfFile:imagePath];
        UIImage *image = [UIImage imageWithData:imagedata];
        UIImage *subImage = [UIImage getSubImage:image rect:CGRectMake(0, viewTop, PHONE_SCREEN_SIZE.width*2, viewHeight*2)];
        [pic setImage:subImage];
        [_scrollView addSubview:pic];
    }
    [_scrollView addSubview:[self theLastView:CGRectMake(PHONE_SCREEN_SIZE.width*[_pics count], 0,
                                                         PHONE_SCREEN_SIZE.width, self.view.viewHeight  - self.navigationBarHeight)]];
    _scrollView.contentSize = CGSizeMake(PHONE_SCREEN_SIZE.width * ([_pics count]+1), self.view.viewHeight - self.navigationBarHeight);
    [self setOverlayStatus:EOverlayStatusRemove labelText:nil];
}

- (UIView*)theLastView:(CGRect)frame{
    CGFloat viewTop, viewHeight;
    if ([UIDevice isRetina4inch]) {
        viewTop = 0;
        viewHeight = 460;
    } else {
        viewTop = self.navigationBarHeight;
        viewHeight = self.view.viewHeight - self.navigationBarHeight;
    }
    
    UIView *lastview = [[UIView alloc] initWithFrame:frame];
    UIImageView *viewbg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, PHONE_SCREEN_SIZE.width, frame.size.height)];
    viewbg.contentMode = UIViewContentModeScaleAspectFit;
    viewbg.backgroundColor = [MIUtility colorWithHex:0xffdb14];

    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"introduced004" ofType:@"png"];
    NSData *imagedata = [NSData dataWithContentsOfFile:imagePath];
    UIImage *image = [UIImage imageWithData:imagedata];
    UIImage *subImage = [UIImage getSubImage:image rect:CGRectMake(0, viewTop, PHONE_SCREEN_SIZE.width*2, viewHeight*2)];
    [viewbg setImage:subImage];
    [lastview addSubview:viewbg];
    
    UITapGestureRecognizer *loginRecoginzer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(startExperiences)];
    [lastview addGestureRecognizer:loginRecoginzer];
    return lastview;
}

- (void)startExperiences
{
    [[MINavigator navigator] goMainScreenFromAnyByIndex:MAIN_SCREEN_INDEX_HOMEPAGE info:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationBar setBarTitle: @"功能介绍"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    _scrollView = nil;

}

@end