//
//  MIBrandShopView.m
//  MISpring
//
//  Created by 曲俊囡 on 13-12-6.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIBrandShopView.h"
#import "MITbWebViewController.h"
#import "MIBrandViewController.h"

@implementation MIBrandShopView
@synthesize shopImageView,timeImageView,shopNameLabel,relateId,nick,shopTimeLabel,shopTimer,shopEndTime;

- (id) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        UIView *buttonView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, PHONE_SCREEN_SIZE.width, 40)];
        buttonView.backgroundColor = [UIColor whiteColor];
        buttonView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToBrandShop)];
        [buttonView addGestureRecognizer:tap];
        [self addSubview:buttonView];
        
        shopImageView = [[UIImageView alloc] initWithFrame: CGRectMake(5, 5, 60, 30)];
        shopImageView.contentMode = UIViewContentModeScaleAspectFill;
        shopImageView.clipsToBounds = YES;
        shopImageView.userInteractionEnabled = NO;
        [buttonView addSubview:shopImageView];
        
        shopNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 0, 175, 40)];
        shopNameLabel.backgroundColor = [UIColor clearColor];
        shopNameLabel.font = [UIFont systemFontOfSize:16];
        shopNameLabel.textColor = [UIColor darkGrayColor];
        shopNameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        shopNameLabel.userInteractionEnabled = YES;
        [buttonView addSubview:shopNameLabel];
        
        timeImageView = [[UIImageView alloc] initWithFrame: CGRectMake(250, 15, 10, 10)];
        timeImageView.image = [UIImage imageNamed:@"img_lefttime"];
        [self addSubview:timeImageView];
        
        shopTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(260, 0, 55, 40)];
        shopTimeLabel.backgroundColor = [UIColor clearColor];
        shopTimeLabel.font = [UIFont systemFontOfSize:12];
        shopTimeLabel.textColor = [UIColor lightGrayColor];
        shopTimeLabel.textAlignment = NSTextAlignmentCenter;
        shopTimeLabel.userInteractionEnabled = YES;
        [buttonView addSubview:shopTimeLabel];
    }
    
    return self;
}

- (void)goToBrandShop
{
    [MobClick event:kBrandShopClicks];
    
    NSString *itemUrl = [NSString stringWithFormat:@"http://shop%@.m.taobao.com", self.relateId];
    [MINavigator openTbWebViewControllerWithURL:[NSURL URLWithString:itemUrl] desc:nick];
}

- (void)startTimer
{
    [self stopTimer];
    self.shopTimer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(handleTimer:) userInfo:nil repeats:YES];;
    [self.shopTimer fire];
}

- (void)stopTimer
{
    if (self.shopTimer) {
        [self.shopTimer invalidate];
        self.shopTimer = nil;
    }
}

- (void)handleTimer: (NSTimer *) timer
{
    double nowInterval = [[NSDate date] timeIntervalSince1970] + [MIConfig globalConfig].timeOffset;
    NSInteger intervalEndTime = shopEndTime.doubleValue - nowInterval;
    if (intervalEndTime <= 0) {
        shopTimeLabel.text = @"已结束";
        [shopTimer invalidate];
    } else {
//        NSInteger interval = [MIUtility calcIntervalWithEndTime:intervalEndTime andNowTime:nowInterval];
        NSInteger day = intervalEndTime / 60 / 60 / 24;
        NSInteger hour = intervalEndTime%(60 * 60 * 24)/60/60;
        NSInteger minute = intervalEndTime%(60*60)/60;
        if (day > 0) {
            shopTimeLabel.text = [[NSString alloc] initWithFormat:@"剩%ld天", (long)day];
        }else if(hour > 0){
            shopTimeLabel.text = [[NSString alloc] initWithFormat:@"剩%ld小时", (long)hour];
        } else if(minute > 0){
            shopTimeLabel.text = [[NSString alloc] initWithFormat:@"剩%ld分钟", (long)minute];
        } else {
            shopTimeLabel.text = @"即将结束";
        }
        
    }
}
@end
