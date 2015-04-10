//
//  MILaunchAdViewController.h
//  MISpring
//
//  Created by 曲俊囡 on 14-5-20.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MIBaseViewController.h"

@interface MILaunchAdViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIScrollView *adScrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIButton *detailButton;
@property (weak, nonatomic) IBOutlet UILabel *reminderLabel;
@property (nonatomic, strong) NSArray * adsArrayDict;
@property (nonatomic, strong) NSTimer *adsTimer;
@property (nonatomic, assign) CGFloat viewHeight;
@end
