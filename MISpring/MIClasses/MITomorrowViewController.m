//
//  MITomorrowViewController.m
//  MISpring
//
//  Created by 曲俊囡 on 14-6-17.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MITomorrowViewController.h"
#import "MITomorrowTenTuanViewController.h"
#import "MITomorrowYoupinViewController.h"
#import "MITomorrowBrandViewController.h"
#import "MIMainScrollView.h"
#import "MIViewControllerWapper.h"

@interface MITomorrowViewController ()<UIScrollViewDelegate>
@property (strong, strong) MIBaseViewController *currentViewController;
@property (strong, nonatomic) MIMainScrollView *mainView;
@property (nonatomic, strong) NSArray *vcArray;
@property (nonatomic, strong) NSMutableArray *wapperArray;
@end

@implementation MITomorrowViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationBar setBarTitle:@"明日预告"];

    _segmentView = [[MITuanSegmentView alloc] initWithFrame:CGRectMake(0, self.navigationBarHeight, PHONE_SCREEN_SIZE.width, 40)];
    _segmentView.delegate = self;
    [self.view addSubview:_segmentView];
    
    MITomorrowTenTuanViewController *tenTuanVC = [[MITomorrowTenTuanViewController alloc] init];
    tenTuanVC.subject = @"10yuan";

    [self addChildViewController:tenTuanVC];
    
    MITomorrowYoupinViewController *youpinVC = [[MITomorrowYoupinViewController alloc] init];
    youpinVC.subject = @"youpin";
    [self addChildViewController:youpinVC];

    MITomorrowBrandViewController *brandTuanVC = [[MITomorrowBrandViewController alloc] init];
    [self addChildViewController:brandTuanVC];
    
    _vcArray = [NSArray arrayWithObjects:tenTuanVC,youpinVC,brandTuanVC, nil];
    
    _mainView = [[MIMainScrollView alloc]initWithFrame:CGRectMake(0, _segmentView.bottom, self.view.viewWidth, self.view.viewHeight - _segmentView.bottom)];
    _mainView.backgroundColor = [UIColor clearColor];
    _mainView.bounces = NO;
    _mainView.showsVerticalScrollIndicator = NO;
    _mainView.showsHorizontalScrollIndicator = NO;
    _mainView.pagingEnabled = YES;
    _mainView.delegate = self;
    _mainView.contentSize = CGSizeMake(self.view.viewWidth *3, 0);
    _mainView.scrollsToTop = NO;
    
    _wapperArray = [[NSMutableArray alloc]initWithCapacity:3];
    
    for (NSInteger i = 0; i < 3; i ++) {
        MIViewControllerWapper *wapper = [[MIViewControllerWapper alloc]init];
        wapper.frame = CGRectMake(self.view.viewWidth * i, 0, _mainView.viewWidth, _mainView.viewHeight);
        wapper.backgroundColor = [UIColor clearColor];
        [_wapperArray addObject:wapper];
        wapper.viewController = [_vcArray objectAtIndex:i];
        [_mainView addSubview:wapper];
    }
    [self.view addSubview:_mainView];
    [self.view bringSubviewToFront:self.navigationBar];

    _currentIndex = TUAN_TAB_TEN;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (_currentViewController) {
        [_currentViewController viewWillAppear:animated];
        _currentViewController.baseTableView.scrollsToTop = YES;
    } else {
        MIViewControllerWapper *wapper = [_wapperArray objectAtIndex:_currentIndex];
        wapper.viewController.baseTableView.scrollsToTop = YES;
        [wapper load];
    }
}
#pragma mark - MISegmentViewDelegate
- (void)segmentView:(MITuanSegmentView *)segmentView didSelectIndex:(NSInteger)index
{
    MIViewControllerWapper *wapper = [_wapperArray objectAtIndex:index];
    if (_currentIndex != index) {
        [self canScrollToTopWithIndex:index];
        [wapper load];
        _mainView.contentOffset = CGPointMake(self.view.viewWidth * index, 0);
        [_segmentView setSelectTabIndex:index];
    }else{
        return;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x / self.view.viewWidth;
    MIViewControllerWapper *wapper = [_wapperArray objectAtIndex:index];    
    if (_currentIndex != index) {
        [wapper load];
        [self canScrollToTopWithIndex:index];
        [_segmentView setSelectTabIndex:index];
    }else{
        return;
    }
}

-(void)canScrollToTopWithIndex:(NSInteger)index
{
    MIViewControllerWapper *lastWapper = [_wapperArray objectAtIndex:_currentIndex];
    lastWapper.viewController.baseTableView.scrollsToTop = NO;
    MIViewControllerWapper *wapper = [_wapperArray objectAtIndex:index];
    wapper.viewController.baseTableView.scrollsToTop = YES;
    _currentIndex = index;
    _currentViewController = wapper.viewController;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
