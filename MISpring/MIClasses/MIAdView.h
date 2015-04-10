//
//  MIAdView.h
//  MISpring
//
//  Created by 曲俊囡 on 14-5-14.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MIAdView : UIView<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView * adScrollView;
@property (nonatomic, strong) UIPageControl * pageControl;
@property (nonatomic, strong) NSTimer *adsRepeatTimer;
@property (nonatomic, strong) NSArray * adsArrayDict;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger pages;

- (void)addADsImageViews:(NSArray *) adsArrayDict;
- (void)startTimer;
- (void)stopTimer;

@end
