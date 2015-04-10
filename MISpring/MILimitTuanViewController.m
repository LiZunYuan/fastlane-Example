//
//  MILimitTuanViewController.m
//  MISpring
//
//  Created by husor on 15-3-30.
//  Copyright (c) 2015年 Husor Inc. All rights reserved.
//

#import "MILimitTuanViewController.h"
#import "MILimitTuanContentView.h"
#import "MITuanActivityGetModel.h"
#import "MITuanItemModel.h"
#import "MITuanDetailViewController.h"

#define NORMAL_SPACE                  8
#define IMAGE_WIDTH                       (NSInteger)(280 * (SCREEN_HEIGHT / 568.0))
#define SCROLL_VIEW_WIDTH       (IMAGE_WIDTH + NORMAL_SPACE)

@interface MILimitTuanViewController ()

@end

@implementation MILimitTuanViewController

- (void)loadView
{
    [super loadView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationBar setBarTitle:@"限量抢购"];
    
    _countDownImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.navigationBar.bottom + 1 + 8, 98, 36)];
    _countDownImg.backgroundColor =[UIColor clearColor];
    [self.view addSubview:_countDownImg];
    _countDownTipLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 6, 65, 10)];
    _countDownTipLabel.backgroundColor = [UIColor clearColor];
    _countDownTipLabel.textAlignment = NSTextAlignmentRight;
    _countDownTipLabel.textColor = [MIUtility colorWithHex:0xeeeeee];
    _countDownTipLabel.font = [UIFont systemFontOfSize:9];
    [_countDownImg addSubview:_countDownTipLabel];
    
    _countDownLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, _countDownTipLabel.bottom  + 4, 70, 12)];
    _countDownLabel.backgroundColor = [UIColor clearColor];
    _countDownLabel.font = [UIFont systemFontOfSize:12];
    _countDownLabel.textColor = [MIUtility colorWithHex:0xffffff];
    _countDownLabel.textAlignment = NSTextAlignmentRight;
    [_countDownImg addSubview:_countDownLabel];
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - SCROLL_VIEW_WIDTH + NORMAL_SPACE) / 2.0, _countDownImg.bottom + 8, SCROLL_VIEW_WIDTH, IMAGE_WIDTH + 100)];
    _scrollView.clipsToBounds = NO;
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = NO;
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    self.view.clipsToBounds = YES;
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, _scrollView.bottom + 12, 100, 6)];
    _pageControl.enabled = NO;
    _pageControl.currentPage = 0;
    _pageControl.centerX = self.view.centerX;
    _pageControl.pageIndicatorTintColor = [MIUtility colorWithHex:0xe4e4e4];
    _pageControl.currentPageIndicatorTintColor = [MIUtility colorWithHex:0xFF8C24];
    [self.view addSubview:_pageControl];
    
    _modelArray = [[NSMutableArray alloc]initWithCapacity:0];
    
    __weak typeof(self) weakSelf = self;
    _request = [[MITuanActivityGetRequest alloc]init];
    _request.onCompletion = ^(MITuanActivityGetModel *model){
        [weakSelf finishLoadData:model];
    };
    _request.onError = ^(MKNetworkOperation *operation,MIError *error){
        [weakSelf failLoadData];
        MILog(@"error_mes=%@",error.description)
    };
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_modelArray.count == 0) {
        [self sendFirstPageRequest];
        [self setOverlayStatus:EOverlayStatusLoading labelText:nil];
    }
}

-(void)finishLoadData:(MITuanActivityGetModel *)model
{
    [self setOverlayStatus:EOverlayStatusRemove labelText:nil];
    if (model.tuanItems.count > 0) {
        [_modelArray removeAllObjects];
        [_modelArray addObjectsFromArray:model.tuanItems];
        self.startTime = model.startTime;
        self.endTime = model.endTime;
        [self startTimer];
        [self addContent];
    } else if (_modelArray.count == 0){
        [self setOverlayStatus:EOverlayStatusEmpty labelText:nil];
    }
}

- (void)startTimer
{
    [self stopTimer];
    self.limitTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(handleTimer:) userInfo:nil repeats:YES];
    [self.limitTimer fire];
}

- (void)stopTimer
{
    if (self.limitTimer) {
        [self.limitTimer invalidate];
        self.limitTimer = nil;
    }
}
- (void)handleTimer: (NSTimer *) timer
{
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970] + [MIConfig globalConfig].timeOffset;
    NSInteger interval = 0;
    if (now > self.endTime.integerValue){
        _countDownImg.image = [UIImage imageNamed:@"bg_tag_limit_gray"];
        _countDownTipLabel.text = @"活动已结束";
        _countDownLabel.text = @"00:00:00";
        [self stopTimer];
    }else{
        if (now < self.startTime.integerValue) {
            _countDownImg.image = [UIImage imageNamed:@"bg_tag_limit_green"];
            _countDownTipLabel.text = @"离活动开始还剩";
            interval = self.startTime.integerValue - now;
        }else{
            _countDownImg.image = [UIImage imageNamed:@"bg_tag_limit_orange"];
            _countDownTipLabel.text = @"离活动结束还剩";
            interval = self.endTime.integerValue - now;
        }
        NSInteger hour = interval%(60 * 60 * 24)/60/60;
        NSInteger minute = interval%(60*60)/60;
        NSInteger second = interval%60;
        _countDownLabel.text = [NSString stringWithFormat:@"%.2ld:%.2ld:%.2ld",(long)hour,(long)minute,(long)second];
    }
}

-(void)addContent
{
    if (_modelArray.count > 0) {
        [_scrollView removeAllSubviews];
        _scrollView.contentSize = CGSizeMake(SCROLL_VIEW_WIDTH * (_modelArray.count + 2) , 0);
        _pageControl.numberOfPages = _modelArray.count;
        
        //scrollView
        for (int i = 0; i < _modelArray.count + 2; i ++) {
            MITuanItemModel *model = nil;
            if (i == 0) {
                model = [_modelArray lastObject];
            } else if (i == _modelArray.count + 1) {
                model = [_modelArray firstObject];
            } else {
                model = [_modelArray objectAtIndex:i-1];
            }
            
            MILimitTuanContentView *view = [[MILimitTuanContentView alloc]initWithFrame:CGRectMake(SCROLL_VIEW_WIDTH * i, 0, IMAGE_WIDTH, IMAGE_WIDTH + 24 + 100)];
            view.clipsToBounds = YES;
            view.layer.cornerRadius = 4;
            view.layer.shadowOpacity = 0.8;
            view.layer.shadowOffset = CGSizeMake(0, 1);
            view.layer.shadowColor = [MIUtility colorWithHex:0xe4e4e4].CGColor;
            view.layer.shadowRadius = 1;
            view.backgroundColor = [UIColor clearColor];
            view.model = model;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goViewDetail:)];
            [view addGestureRecognizer:tap];
            [_scrollView addSubview:view];
        }
        
        _scrollView.contentOffset = CGPointMake(SCROLL_VIEW_WIDTH, 0);
        _pageControl.currentPage = 0;
    }
}

-(void)goViewDetail:(UIGestureRecognizer *)gesture
{
    MILimitTuanContentView *view = (MILimitTuanContentView *)gesture.view;
    MITuanDetailViewController *vc = [[MITuanDetailViewController alloc]initWithItem:view.model placeholderImage:[UIImage imageNamed:@"img_loading_daily1"]];
    [vc.detailGetRequest setType:view.model.type.intValue];
    [vc.detailGetRequest setTid:view.model.tuanId.intValue];
    [[MINavigator navigator] openPushViewController:vc animated:YES];
}

#pragma mark-UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger page = _scrollView.contentOffset.x / SCROLL_VIEW_WIDTH;
    NSInteger transferPage = page - 1;
    if (page == 0) {
        transferPage = _modelArray.count - 1;
        if (transferPage != _pageControl.currentPage || (_scrollView.contentOffset.x != SCROLL_VIEW_WIDTH * _modelArray.count)) {
            _pageControl.currentPage = transferPage;
            _scrollView.contentOffset = CGPointMake(SCROLL_VIEW_WIDTH * _modelArray.count, 0);
        }
    } else if (page == _modelArray.count + 1) {
        transferPage = 0;
        if (transferPage != _pageControl.currentPage || (_scrollView.contentOffset.x != SCROLL_VIEW_WIDTH)) {
            _pageControl.currentPage = transferPage;
            _scrollView.contentOffset = CGPointMake(SCROLL_VIEW_WIDTH, 0);
        }
    }
    
    if (transferPage != _pageControl.currentPage) {
        _pageControl.currentPage = transferPage;
    }
}

- (void)sendFirstPageRequest {
    [_request setCat:self.data];
    [_request setPage:1];
    [_request setPageSize:20];
    [_request sendQuery];
    
    [self setOverlayStatus:EOverlayStatusLoading labelText:nil];
}

//返回数据为空，点击屏幕重新加载数据时调用（overlay代理方法）
- (void)reloadTableViewDataSource {
    [self sendFirstPageRequest];
}

-(void)failLoadData
{
    [self setOverlayStatus:EOverlayStatusRemove labelText:nil];
    if (_modelArray.count == 0) {
        [self setOverlayStatus:EOverlayStatusReload labelText:nil];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
