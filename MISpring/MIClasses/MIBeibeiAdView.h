//
//  MIBeibeiAdView.h
//  MISpring
//
//  Created by yujian on 14-7-26.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MIBeibeiAdView : UIView

@property (nonatomic, strong) UILabel *sloganLabel;
@property (nonatomic, strong) UILabel *beibeiLabel;
@property (nonatomic, strong) NSTimer *activateTimer;

- (void)animationStart;
- (void)animationStop;

@end
