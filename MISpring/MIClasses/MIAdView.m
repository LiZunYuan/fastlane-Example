//
//  MIAdView.m
//  MISpring
//
//  Created by 曲俊囡 on 14-5-14.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MIAdView.h"
#import "MIAppDelegate.h"
#import "MIZhiDetailViewController.h"
#import "NSString+MIImageAppending.h"


#define AD_VIEW_SIZE CGSizeMake(SCREEN_WIDTH, 100 * SCREEN_WIDTH / 320)
#define MI_MAINPAGE_ADS_SCHEDULED_TIMER_INTERVAL 5


@implementation MIAdView

- (id)init
{
    self = [super initWithFrame:CGRectMake(0, 0, AD_VIEW_SIZE.width, AD_VIEW_SIZE.height)];
    if (self) {
        
        _adScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, AD_VIEW_SIZE.height)];
        _adScrollView.backgroundColor = [UIColor lightGrayColor];
        _adScrollView.delegate = self;
        _adScrollView.showsHorizontalScrollIndicator = NO;
        _adScrollView.showsVerticalScrollIndicator = NO;
        _adScrollView.pagingEnabled = YES;
        _adScrollView.bounces = NO;
        [self addSubview:_adScrollView];
        
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, AD_VIEW_SIZE.height - 10, AD_VIEW_SIZE.width, 6)];
        _pageControl.enabled = NO;
        _pageControl.currentPage = 0;
        if (IOS_VERSION >= 6.0)
        {
            _pageControl.pageIndicatorTintColor = [MIUtility colorWithHex:0xffffff];
            _pageControl.currentPageIndicatorTintColor = [MIUtility colorWithHex:0xFF8C24];
        }
        [self addSubview:_pageControl];
        
        self.adsRepeatTimer = [NSTimer scheduledTimerWithTimeInterval:MI_MAINPAGE_ADS_SCHEDULED_TIMER_INTERVAL target:self selector:@selector(handleTimer:)  userInfo:nil  repeats:YES];
    }
    
    return self;
}

- (void)startTimer
{
    [self stopTimer];
    self.adsRepeatTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(handleTimer:) userInfo:nil repeats:YES];
}

- (void)stopTimer
{
    if (self.adsRepeatTimer) {
        [self.adsRepeatTimer invalidate];
        self.adsRepeatTimer = nil;
    }
}



#pragma mark - 每隔5秒切换广告
- (void) handleTimer: (NSTimer *) timer
{
    if (self.pages >1) {
        if (_pageControl.currentPage == self.pageControl.numberOfPages - 1) {
            _pageControl.currentPage = 0;
        }else{
            _pageControl.currentPage++;
        }
        
        if (self.currentPage >= self.pages - 2) {
            [UIView animateWithDuration:0.7
                             animations:^{
                                 _adScrollView.contentOffset = CGPointMake(++self.currentPage*SCREEN_WIDTH, 0);
                             }completion:^(BOOL finished) {
                                 self.currentPage = 1;
                                 _adScrollView.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
                             }];
        }else{
            [UIView animateWithDuration:0.7
                             animations:^{
                                 _adScrollView.contentOffset = CGPointMake(++self.currentPage*SCREEN_WIDTH, 0);
                             }];
        }

    }
    else{
        [self stopTimer];
    }

}

#pragma mark - scrollView && page

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self stopTimer];
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = _adScrollView.frame.size.width;
    NSInteger page = floor((_adScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    if (self.adsArrayDict.count > 1)
    {
        if (page == 0)
        {
            _pageControl.currentPage = self.adsArrayDict.count - 1;
            [_adScrollView setContentOffset:CGPointMake(self.adsArrayDict.count * pageWidth, 0) animated:NO];
            self.currentPage = self.adsArrayDict.count;
        }
        else if(page == self.adsArrayDict.count + 2 - 1)
        {
            _pageControl.currentPage = 0;
            [_adScrollView setContentOffset:CGPointMake(pageWidth, 0) animated:NO];
            self.currentPage = 1;
        }
        else
        {
            _pageControl.currentPage = page - 1;
            self.currentPage = page;
        }
    }
    else
    {
        _pageControl.currentPage = page;
        self.currentPage = page;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self startTimer];
}



#pragma mark - 加载广告图片
- (void)addADsImageViews:(NSArray *) adsArrayDict{
    [_adScrollView removeAllSubviews];
    self.adsArrayDict = adsArrayDict;

    NSInteger count = 0;
    if (adsArrayDict.count > 1)
    {
        self.currentPage = 1;
        count = adsArrayDict.count+2;
    }
    else if(adsArrayDict.count == 1)
    {
        self.currentPage = 0;
        count = 1;
        [_adScrollView setContentOffset:CGPointMake(0, 0)];
    }
    else
    {
        return;
    }
    
    self.pages = count;
    
    for (NSInteger i= 0; i < count; i++) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, AD_VIEW_SIZE.height)];
        
        UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        indicatorView.tag = 999;
        indicatorView.center = CGPointMake(imageView.viewWidth / 2, imageView.viewHeight / 2);
        [indicatorView startAnimating];
        [imageView addSubview:indicatorView];
        
        imageView.userInteractionEnabled = YES;
        
        NSDictionary *dictionary = nil;
        if (count > adsArrayDict.count)
        {
            if (i == 0)
            {
                dictionary = [adsArrayDict objectAtIndex:adsArrayDict.count - 1];
            }
            else if(i == count - 1)
            {
                dictionary = [adsArrayDict objectAtIndex:0];
            }
            else
            {
                dictionary = [adsArrayDict objectAtIndex:i-1];
            }
        }
        else
        {
            dictionary = [adsArrayDict objectAtIndex:i];
        }

//        //跳转到APP STORE的URL样式为https://itunes.apple.com/cn/app/mi-zhe-tao-bao-sheng-qian/id633394165?mt=8&uo=4
//        NSURL *URL = [NSURL URLWithString:[dictionary objectForKey:@"target"]];
//        if ([URL.host isEqualToString:@"itunes.apple.com"]
//            || [URL.host isEqualToString:@"phobos.apple.com"]) {
//            MIAppDelegate* delegate = (MIAppDelegate*)[[UIApplication sharedApplication] delegate];
//            if(delegate.appNewVersion == nil){
//                //如果用户未更新，则显示新版的广告，否则剔除广告
//                [adsArrayDict removeObjectAtIndex:i--];
//                continue;
//            }
//        }
        
        NSString *imgUrl = [[dictionary objectForKey:@"img"] miImageAppendingWithSizeString:@"appprom"];
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"img_loading_lunbo"]];
        UITapGestureRecognizer *loginRecoginzer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goAdsView:)];
        [imageView addGestureRecognizer:loginRecoginzer];
        [_adScrollView addSubview:imageView];
    }
    
    
    [_adScrollView setContentSize:CGSizeMake(SCREEN_WIDTH * count, AD_VIEW_SIZE.height)];
    [_adScrollView setContentOffset:CGPointMake(self.currentPage*_adScrollView.viewWidth, 0)];
    _pageControl.numberOfPages = [adsArrayDict count];
    _pageControl.currentPage = 0;
}

- (void)goAdsView:(UIImageView *)imageView{
    if (_adsArrayDict.count > _pageControl.currentPage)
    {
        NSDictionary *dict = [_adsArrayDict objectAtIndex:_pageControl.currentPage];
        NSString *desc = [NSString stringWithFormat:@"%@", [dict objectForKey:@"desc"]];
        NSString *type = [NSString stringWithFormat:@"%@", [dict objectForKey:@"login"]];
        if (type && type.integerValue == 1 && ![[MIMainUser getInstance] checkLoginInfo]) {
            MIButtonItem *cancelItem = [MIButtonItem itemWithLabel:@"取消"];
            cancelItem.action = ^{
            };
            MIButtonItem *affirmItem = [MIButtonItem itemWithLabel:@"登录"];
            affirmItem.action = ^{
                [MINavigator openLoginViewController];
            };
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"亲，请先登录哦~" cancelButtonItem:cancelItem otherButtonItems:affirmItem, nil];
            [alertView show];
        } else {
            [MINavigator openShortCutWithDictInfo:dict];
        }
        
        [MobClick event:kAdsClicks label:desc];
    }
}

@end
