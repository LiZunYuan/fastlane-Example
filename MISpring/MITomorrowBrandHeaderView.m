//
//  MITomorrowBrandHeaderView.m
//  MISpring
//
//  Created by yujian on 14-12-19.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MITomorrowBrandHeaderView.h"

@interface MITomorrowBrandHeaderView()
{
    UIImageView *_remindImageView;
    UIButton *_remindBtn;
    UILabel *_remindLabel;
    UIView *_timeView;
    UILabel *_timeLabel;
    NSTimer *_shopTimer;
}

@end

@implementation MITomorrowBrandHeaderView

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _timeView = [[UIView alloc] initWithFrame:CGRectMake(-self.viewHeight/2, 8, 150, 24)];
        _timeView.clipsToBounds = YES;
        _timeView.backgroundColor = [MIUtility colorWithHex:0xbebebe];
        _timeView.layer.cornerRadius = _timeView.viewHeight/2;
        
        UIImageView *timeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.viewHeight/2 + 16, 0, 14, 14)];
        timeImageView.centerY = _timeView.viewHeight/2;
        timeImageView.image = [UIImage imageNamed:@"zhuanc_ic_time"];
        [_timeView addSubview:timeImageView];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(timeImageView.right + 4, timeImageView.top, _timeView.viewWidth - timeImageView.right - 4 - _timeView.viewHeight/2,timeImageView.viewHeight)];
        _timeLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.font = [UIFont systemFontOfSize:12.0];
        _timeLabel.textColor = [MIUtility colorWithHex:0xffffff];
        _timeLabel.text = @"明日10点开抢";
        [_timeView addSubview:_timeLabel];
        
        [self addSubview:_timeView];
        
        _remindBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _remindBtn.frame = CGRectMake(0, 8, 80, _timeView.viewHeight);
        _remindBtn.backgroundColor = [MIUtility colorWithHex:0x7ac404];
        _remindBtn.clipsToBounds = YES;
        _remindBtn.layer.cornerRadius = 2;
        _remindBtn.right = self.viewWidth - 8;
        [_remindBtn addTarget:self action:@selector(clickRemindBtn) forControlEvents:UIControlEventTouchUpInside];
        
        _remindImageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 0, 12, 12)];
        _remindImageView.image = [UIImage imageNamed:@"ic_xiangqing_remind"];
        _remindImageView.centerY = _remindBtn.viewHeight/2;
        [_remindBtn addSubview:_remindImageView];
        
        _remindLabel = [[UILabel alloc] initWithFrame:CGRectMake(24, 0, 50, _remindBtn.viewHeight)];
        _remindLabel.backgroundColor = [UIColor clearColor];
        _remindLabel.font = [UIFont systemFontOfSize:12.0];
        _remindLabel.textAlignment = NSTextAlignmentCenter;
        _remindLabel.textColor = [MIUtility colorWithHex:0xffffff];
        _remindLabel.text = @"添加提醒";
        [_remindBtn addSubview:_remindLabel];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 40, self.viewWidth, 0.5)];
        line.backgroundColor = MILineColor;
        [self addSubview:line];
        
        [self addSubview:_remindBtn];
        
    }
    return self;
}

- (void)setIsRemindBrand:(BOOL)isRemindBrand
{
    _isRemindBrand = isRemindBrand;
    if (_isRemindBrand)
    {
        _remindImageView.image = [UIImage imageNamed:@"ic_xiangqing_remind_select"];
        _remindBtn.backgroundColor = [MIUtility colorWithHex:0xbebebe];
        _remindLabel.text = @"已加提醒";
    }
    else
    {
        _remindImageView.image = [UIImage imageNamed:@"ic_xiangqing_remind"];
        _remindBtn.backgroundColor = [MIUtility colorWithHex:0x7ac404];
        _remindLabel.text = @"添加提醒";
    }
}

- (void)clickRemindBtn
{
    if ([MIMainUser getInstance].loginStatus != MILoginStatusNormalLogin)
    {
        [MINavigator openLoginViewController];
        return;
    }
    
    self.isRemindBrand = !self.isRemindBrand;
    if (_delegate && [_delegate respondsToSelector:@selector(refreshRemindTag:)])
    {
        [_delegate refreshRemindTag:self.isRemindBrand];
    }
}

- (void)setCurBeginTime:(NSNumber *)beginTime
{
    _startTime = beginTime;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:beginTime.doubleValue];
    if (0 == [date compareWithToday])
    {
        _timeLabel.text = [NSString stringWithFormat:@"%@",[date stringForTimeTips2]];
    }
    else if(1 == [date compareWithToday])
    {
        _timeLabel.text = [NSString stringWithFormat:@"明日%@",[date stringForTimeTips2]];
    }
    else
    {
        _timeLabel.text = [NSString stringWithFormat:@"%@开抢",[date stringForTimeline]];
    }
    CGSize size = [_timeLabel.text sizeWithFont:_timeLabel.font constrainedToSize:CGSizeMake(270, _timeLabel.viewHeight)];
    _timeLabel.viewWidth = size.width;
    _timeView.viewWidth = size.width + 16 + _timeView.viewHeight/2 + 14 + _timeView.viewHeight;
}

- (void)setType:(BrandHeaderType)type
{
    _type = type;
    if (_type == TodayType)
    {
        _remindBtn.hidden = YES;
//        [self startTimer];
    }
    else
    {
        _remindBtn.hidden = NO;
//        [self stopTimer];
    }
    [self startTimer];
}

- (void)startTimer
{
    [self stopTimer];
    _shopTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(handleTimer:) userInfo:nil repeats:YES];
    [_shopTimer fire];
}

- (void)stopTimer
{
    if (_shopTimer) {
        [_shopTimer invalidate];
        _shopTimer = nil;
    }
}

- (void)handleTimer: (NSTimer *) timer
{
    double nowInterval = [[NSDate date] timeIntervalSince1970] + [MIConfig globalConfig].timeOffset;
    if (self.endTime.doubleValue <= nowInterval) {
        _timeLabel.textColor = [MIUtility colorWithHex:0x858585];
        _timeLabel.text = @"已结束";
        _remindImageView.image = [UIImage imageNamed:@"img_lefttime"];
        [self stopTimer];
    } else {
        if (_type == TodayType || self.startTime.doubleValue < nowInterval) {
            NSInteger left = self.endTime.doubleValue - nowInterval;
            NSInteger day = left / 60 / 60 / 24;
            NSInteger hour = left%(60 * 60 * 24)/60/60;
            NSInteger minute = left%(60*60)/60;
            NSInteger second = left%60;
            _timeLabel.text = [NSString stringWithFormat:@"剩%ld天%ld时%ld分%ld秒",(long)day,(long)hour,(long)minute,(long)second];
        } else {
            NSInteger left = self.startTime.doubleValue - nowInterval;
            NSInteger hour = left%(60 * 60 * 24)/60/60;
            NSInteger minute = left%(60*60)/60;
            NSInteger second = left%60;
            _timeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld:%02ld后开抢",(long)hour,(long)minute,(long)second];
        }
    }
    
    CGSize size = [_timeLabel.text sizeWithFont:_timeLabel.font constrainedToSize:CGSizeMake(270, _timeLabel.viewHeight)];
    _timeLabel.viewWidth = size.width;
    _timeView.viewWidth = size.width + 16 + _timeView.viewHeight/2 + 14 + _timeView.viewHeight;
}


@end
