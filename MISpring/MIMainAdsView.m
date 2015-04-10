//
//  BBMainAdsView.m
//  BeiBeiAPP
//
//  Created by yujian on 14-10-16.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MIMainAdsView.h"

@interface MIMainAdsView()
{
    NSTimer *_timer;
    NSNumber *_end;
    NSNumber *_begin;
    NSArray *_modelArray;
}

@end

@implementation MIMainAdsView

- (void)awakeFromNib
{
    _badgeTimeView = [[MIBadgeTimeView alloc] initWithFrame:CGRectMake(80, 20, 20 * 3 + 10, 20)];
    _badgeTimeView.hidden = YES;
    [self.leftAdsImageView addSubview:_badgeTimeView];
}

- (void)loadData:(NSArray *)dataArray
{
    _modelArray = dataArray;
    if (dataArray.count == 4)
    {
        NSDictionary *leftDic = [dataArray objectAtIndex:0];
        NSString *imgUrl = [leftDic objectForKey:@"img"];
        [self.leftAdsImageView sd_setImageWithURL:[leftDic objectForKey:@"img"] placeholderImage:[self imageWithUrl:imgUrl]];
        self.leftAdsImageView.tag = 0;
        self.leftAdsImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *loginRecoginzer1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goAdsView:)];
        [self.leftAdsImageView addGestureRecognizer:loginRecoginzer1];
        
        NSDictionary *dic2 = [dataArray objectAtIndex:1];
        imgUrl = [dic2 objectForKey:@"img"];
        self.rightTopImageView.contentMode = UIViewContentModeCenter;
        [self.rightTopImageView sd_setImageWithURL:[dic2 objectForKey:@"img"] placeholderImage:[UIImage imageNamed:@"img_loading_daily2"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (!error && image)
            {
                self.rightTopImageView.contentMode = UIViewContentModeScaleToFill;
            }
        }];
        self.rightTopImageView.tag = 1;
        self.rightTopImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *loginRecoginzer2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goAdsView:)];
        [self.rightTopImageView  addGestureRecognizer:loginRecoginzer2];
        
        NSDictionary *dic3 = [dataArray objectAtIndex:2];
        imgUrl = [dic3 objectForKey:@"img"];
        [self.buttonLeftImageView sd_setImageWithURL:[dic3 objectForKey:@"img"] placeholderImage:[UIImage imageNamed:@"img_loading_daily3"]];
        self.buttonLeftImageView.tag = 2;
        self.buttonLeftImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *loginRecoginzer3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goAdsView:)];
        [self.buttonLeftImageView addGestureRecognizer:loginRecoginzer3];
        
        NSDictionary *dic4 = [dataArray objectAtIndex:3];
        imgUrl = [dic4 objectForKey:@"img"];
        [self.buttonRightImageView sd_setImageWithURL:[dic4 objectForKey:@"img"] placeholderImage:[UIImage imageNamed:@"img_loading_daily3"]];
        self.buttonRightImageView.tag = 3;
        self.buttonRightImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *loginRecoginzer4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goAdsView:)];
        [self.buttonRightImageView addGestureRecognizer:loginRecoginzer4];
        
        if ([leftDic objectForKey:@"show_left_time"] && [[leftDic objectForKey:@"show_left_time"] integerValue] > 0) {
            _end = [leftDic objectForKey:@"end"];
            _begin = [leftDic objectForKey:@"begin"];
            [self startTimer];
        }
    }
}

- (UIImage *)imageWithUrl:(NSString *)imgUrl
{
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:[imgUrl lastPathComponent] ofType:nil];
    NSData *imagedata = [NSData dataWithContentsOfFile:imagePath];
    if (imagedata) {
        return [UIImage imageWithData:imagedata];
    } else {
        return [UIImage imageNamed:@"img_loading_daily1"];
    }
}

- (void)goAdsView:(UIGestureRecognizer *)gesture
{
    UIImageView *imageView = (UIImageView *)gesture.view;
    NSDictionary *dict = [_modelArray objectAtIndex:imageView.tag];
    
    NSString *desc = [dict objectForKey:@"title"] ? [dict objectForKey:@"title"] : [dict objectForKey:@"desc"];
    if (desc) {
        [MobClick event:kHomeShortcut label:desc];
    } else {
        [MobClick event:kHomeShortcut];
    }

    [MINavigator openShortCutWithDictInfo:dict];
}

- (void)startTimer
{
    [self stopTimer];
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(handleTimer:) userInfo:nil repeats:YES];
    [_timer fire];
}

- (void)stopTimer
{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)handleTimer:(id)sender
{
    double nowInterval = [[NSDate date] timeIntervalSince1970] + [MIConfig globalConfig].timeOffset;
    if(nowInterval >= _begin.doubleValue && nowInterval < _end.doubleValue)
    {
        _badgeTimeView.hidden = NO;
    }
    else
    {
        _badgeTimeView.hidden = YES;
        [self stopTimer];
    }
    
    NSInteger endInterval = _end.doubleValue - nowInterval;
    NSInteger interval1 = [self calcBadgeTime:endInterval andNowTime:nowInterval];
    NSInteger hours = interval1 / 60 / 60;
    NSInteger minutes = interval1 / 60 % 60;
    NSInteger seconds = interval1 % 60;
    _badgeTimeView.hourBadgeView.text = [NSString stringWithFormat:@"%.2ld", (long)hours];
    _badgeTimeView.miniteBadgeView.text = [NSString stringWithFormat:@"%.2ld", (long)minutes];
    _badgeTimeView.secondBadgeView.text = [NSString stringWithFormat:@"%.2ld", (long)seconds];
}

- (NSInteger)calcBadgeTime:(NSInteger)endTime andNowTime:(NSInteger)nowTime
{
    NSDate* today = [NSDate dateWithTimeIntervalSinceNow:[MIConfig globalConfig].timeOffset];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"H"];
    
    NSInteger interval;
    NSString *todayStr = [formatter stringFromDate:today];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *todayDateStr = [formatter stringFromDate:today];
    NSString *today9Clock = [NSString stringWithFormat:@"%@ 09:00:00", todayDateStr];
    NSString *today10Clock = [NSString stringWithFormat:@"%@ 10:00:00", todayDateStr];
    formatter.dateFormat  = @"yyyy-MM-dd HH:mm:ss";
    NSDate *today9Date = [formatter dateFromString:today9Clock];
    NSDate *today10Date = [formatter dateFromString:today10Clock];
    if (todayStr.intValue < 9) {
        interval = [today9Date timeIntervalSince1970] - nowTime;
    }
    else if (todayStr.integerValue < 10) {
        interval = [today10Date timeIntervalSince1970] - nowTime;
    }
    else {
        NSDate *tomorrow9Date = [NSDate dateWithTimeInterval:24*60*60 sinceDate:today9Date];
        interval = [tomorrow9Date timeIntervalSince1970] - nowTime;
    }
    
    if (endTime < interval) {
        interval = endTime;
    }
    
    return interval;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
