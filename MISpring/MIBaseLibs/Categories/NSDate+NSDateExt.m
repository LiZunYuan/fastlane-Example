//
//  NSDate+NSDateExt.m
//  MISpring
//
//  Created by XU YUJIAN on 13-1-17.
//  Copyright (c) 2013年 MiZhe Inc. All rights reserved.
//

#import "NSDate+NSDateExt.h"
#import "NSString+NSStringEx.h"


@implementation NSDate(NSDateExt)

- (NSString *) stringForSectionTitle5//消息的时间分割策略，前天以前的只显示日期
{
    NSString *title;
    
	NSInteger intervalDay = [self compareWithToday];
	if (0 == intervalDay) {
		title = [NSString stringWithFormat:@"%@",[self stringForTimeline2]];
	} else if (-1 == intervalDay) {
		title = [NSString stringWithFormat:NSLocalizedString(@"昨天 %@", @"昨天 %@"),[self stringForTimeline2]];
	} else if (-2 == intervalDay) {
        title = [NSString stringWithFormat:NSLocalizedString(@"前天 %@", @"前天 %@"),[self stringForTimeline2]];
	} else {
        
		NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        //[formatter setDateFormat:@"MM-dd HH:mm"];
		[formatter setDateFormat:@"yyyy-MM-dd"];
        
		title = [formatter stringFromDate:self];
	}
	
	return title;
    
}

- (NSString*) stringForSectionTitle4 {//目前sixin和ipad的时间分割策略，今天只显示HH:mm,不显示“今天”
	
	NSString *title;
    
	NSInteger intervalDay = [self compareWithToday];
	if (0 == intervalDay) {
		title = [NSString stringWithFormat:@"%@",[self stringForTimeline2]];
	} else if (-1 == intervalDay) {
		title = [NSString stringWithFormat:NSLocalizedString(@"昨天 %@", @"昨天 %@"),[self stringForTimeline2]];
	} else if (-2 == intervalDay) {
        title = [NSString stringWithFormat:NSLocalizedString(@"前天 %@", @"前天 %@"),[self stringForTimeline2]];
	} else {
        
		NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        //[formatter setDateFormat:@"MM-dd HH:mm"];
		[formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        
		title = [formatter stringFromDate:self];
	}
	
	return title;
}

- (NSString*) stringForSectionTitle3 {
	
	NSString *title;
    
	NSInteger intervalDay = [self compareWithToday];
	if (0 == intervalDay) {
		title = [NSString stringWithFormat:NSLocalizedString(@"今天 %@", @"今天 %@") ,[self stringForTimeline2]];
	} else if (-1 == intervalDay) {
		title = [NSString stringWithFormat:NSLocalizedString(@"昨天 %@", @"昨天 %@"),[self stringForTimeline2]];
    } else if (-2 == intervalDay) {
        title = [NSString stringWithFormat:NSLocalizedString(@"前天 %@", @"前天 %@"),[self stringForTimeline2]];
	} else {
        
		NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        //if ([self compareWithThisYear]) {
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        //}
		
		title = [formatter stringFromDate:self];
	}
	
	return title;
}

- (NSString*) stringForSectionTitle2 {
	
	NSString *title;
    
	NSInteger intervalDay = [self compareWithToday];
	if (0 == intervalDay) {
		title = [NSString stringWithFormat:NSLocalizedString(@"今天 %@", @"今天 %@") ,[self stringForTimeline2]];
	} else if (-1 == intervalDay) {
		title = [NSString stringWithFormat:NSLocalizedString(@"昨天 %@", @"昨天 %@") ,[self stringForTimeline2]];
	} else if (-2 == intervalDay) {
		title = [NSString stringWithFormat:NSLocalizedString(@"前天 %@", @"前天 %@") ,[self stringForTimeline2]];
	} else {
        
		NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        if ([self compareWithThisYear]) {
            [formatter setDateFormat:@"MM-dd HH:mm"];
        }else{
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        }
		
		title = [formatter stringFromDate:self];
	}
	
	return title;
}

- (BOOL) compareWithToday2{
    NSDate *today = [NSDate date];
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"yyyy-MM-dd"];
	
	NSString *todayStr = [formatter stringFromDate:today];
	today = [formatter dateFromString:todayStr];
	
	NSInteger interval = (NSInteger) [self timeIntervalSinceDate:today];
	
	NSInteger intervalDate = 0;
	if (interval <= 0) {
		intervalDate = interval / (24 * 60 * 60) - 1; 
	} else {
		intervalDate = interval / (24 * 60 * 60);
	}
	
    if (intervalDate ==0) {
        return YES; 
    }else{
        return NO;
    }
}

- (NSString*) stringForSectionTitle {
	
	NSString *title;
    
	NSInteger intervalDay = [self compareWithToday];
	if (0 == intervalDay) {
		title = NSLocalizedString(@"今日上新", @"今日上新");
	} else if (-1 == intervalDay) {
		title = NSLocalizedString(@"昨日上新", @"昨日上新");
	} else if (-2 == intervalDay) {
		title = NSLocalizedString(@"前天上新", @"前天上新");
	} else {
        title = NSLocalizedString(@"更早上新", @"更早上新");
	}
	
	return title;
}

//++ zhengzheng 最近来访的时间
- (NSString*) stringForVisitorTitle {
   	NSString *title = nil;
	
	NSInteger intervalSecond = -(NSInteger)[self timeIntervalSinceNow];
    NSInteger minTime = 60;
    NSInteger hourTime = 60 * minTime;
    NSInteger dayTime = 24 * hourTime;
    
    if(![self compareWithThisYear])
    {
        // 不是今年
        title = [NSString stringWithFormat:NSLocalizedString(@"%@",@"%@"),[self stringForDatelineCN]];
    }
    // 手机时间慢于服务器的情况均视为刚刚发送(e.g mobile： 11:28, server: 11:30)
    else
    {
        if([self compareWithToday] == 0)
        {
            // 今天
            if (intervalSecond < minTime)
            {
                // 小于一分钟
                title = NSLocalizedString(@"刚刚更新", @"刚刚更新");
            }
            else if(intervalSecond >= minTime && intervalSecond < hourTime)
            {
                // 大于等于一分钟，小于一小时
                title = [NSString stringWithFormat:NSLocalizedString(@"%d分钟前",@"%d分钟前"), intervalSecond / minTime];
            }
            else if(intervalSecond >= hourTime && intervalSecond < dayTime){
                // 大于等于一小时，小于一天
                title = [NSString stringWithFormat:NSLocalizedString(@"%@",@"%@"), [self stringForTimeline2]];
            }
        }
        else if([self compareWithToday] == -1)
        {
            // 昨天
            title = [NSString stringWithFormat:NSLocalizedString(@"昨天",@"昨天")];
        }
        else
        {
            // 不是今天也不是昨天并且在今年
            title = [NSString stringWithFormat:NSLocalizedString(@"%@",@"%@"), [self stringForTimelineWithFormat:@"MM月dd日"]];
        }
    }
	
	return title;
}
//--------
- (BOOL)compareWithThisYear
{
    NSDate *thisYear = [NSDate date];
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"yyyy"];
	
	NSString *thisYearString = [formatter stringFromDate:thisYear];
	NSString *dateYearString = [formatter stringFromDate:self];
    BOOL isThisYear = [thisYearString isEqualToString:dateYearString];	
	return isThisYear;
    
}

- (NSInteger) compareWithToday
{
	NSDate *today = [NSDate dateWithTimeIntervalSinceNow:[MIConfig globalConfig].timeOffset];
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"yyyy-MM-dd"];
	
	NSString *todayStr = [formatter stringFromDate:today];
	today = [formatter dateFromString:todayStr];
	
	NSInteger interval = (NSInteger) [self timeIntervalSinceDate:today];
	
	NSInteger intervalDate = 0;
	if (interval <= 0) {
		intervalDate = interval / (24 * 60 * 60) - 1; 
	} else {
		intervalDate = interval / (24 * 60 * 60);
	}
	
	return intervalDate;
}

- (NSString*) stringForDateline {
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"yyyy-MM-dd"];
	NSString* str = [formatter stringFromDate:self];
	return str;
}

/* ++++++++++++++++++++++++++++++++++++++++++ */
/*
 * zhengzheng 
 */
- (NSString*) stringForDatelineCN {
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"yyyy年MM月dd日"];
	NSString* str = [formatter stringFromDate:self];
	return str;
}

- (NSString*) stringForTimelineCN {
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"MM月dd日 HH:mm:ss"];
	NSString *timeStr = [formatter stringFromDate:self];
		
	return timeStr;
}
/* ----------------------------------------- */

- (NSString*) stringForTimeline {
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"MM-dd HH:mm"];
	NSString *timeStr = [formatter stringFromDate:self];
		
	return timeStr;
}
- (NSString*) stringForTimeline2{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"HH:mm"];
	NSString *timeStr = [formatter stringFromDate:self];
		
	return timeStr;
}
- (NSString*) stringForTimeline3{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"HH:mm:ss"];
	NSString *timeStr = [formatter stringFromDate:self];
    
	return timeStr;
}
- (NSString*) stringForTimeTips1{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"HH点mm分开抢"];
	NSString *timeStr = [formatter stringFromDate:self];
    
	return timeStr;
}
- (NSString*) stringForTimeTips2{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"HH:mm开抢"];
	NSString *timeStr = [formatter stringFromDate:self];
    
	return timeStr;
}
- (NSString *) stringForTimelineWithFormat:(NSString *)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:format];
	NSString *timeStr = [formatter stringFromDate:self];
		
	return timeStr;
}

/**
 * 计算原时间与现在时间的相对差，以字符串形式返回
 */
- (NSString*) stringForTimeRelative {
   	NSString *title = nil;
	
    double nowInterval = [[NSDate date] timeIntervalSince1970] + [MIConfig globalConfig].timeOffset;
	NSInteger intervalSecond = nowInterval - [self timeIntervalSince1970];
	NSInteger t = 0;
    
    // 手机时间慢于服务器的情况均视为刚刚发送(e.g mobile： 11:28, server: 11:30)
    if (intervalSecond < 0)
    {
        //title = @"刚刚更新";
        title = NSLocalizedString(@"刚刚发布", @"刚刚发布");
    } else if ((t = intervalSecond/(60*60*24)) != 0) {
		if (t > 2) {
			title = [self stringForTimeline];
		}else {
			title = [NSString stringWithFormat:NSLocalizedString(@"%d天前", @"%d天前") ,t];
		}
	} else if ((t = intervalSecond/(60*60)) != 0) {
		title = [NSString stringWithFormat:NSLocalizedString(@"%d小时前", @"%d小时前"),t];
	} else if ((t = intervalSecond/60) != 0) {
		title = [NSString stringWithFormat:NSLocalizedString(@"%d分钟前", @"%d分钟前"),t];
	} else {
		//title = @"刚刚更新";
        title = NSLocalizedString(@"刚刚发布", @"刚刚发布");
	}
	
	return title;
}

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++ */
/*
 * zhengzheng 新鲜事，评论列表时间显示策略
 */
- (NSString*) stringForTimeRelativeForFeed
{
   	NSString *title = nil;
	
	NSInteger intervalSecond = -(NSInteger)[self timeIntervalSinceNow];
    NSInteger minTime = 60;
    NSInteger hourTime = 60 * minTime;
    NSInteger dayTime = 24 * hourTime;
    
    if(![self compareWithThisYear])
    {
        // 不是今年
        title = [NSString stringWithFormat:NSLocalizedString(@"%@ %@",@"%@ %@"),[self stringForDatelineCN], [self stringForTimeline2]];
    }
    // 手机时间慢于服务器的情况均视为刚刚发送(e.g mobile： 11:28, server: 11:30)
    else
    {
        if([self compareWithToday] == 0)
        {
            // 今天
            if (intervalSecond < minTime)
            {
                // 小于一分钟
                title = NSLocalizedString(@"刚刚更新", @"刚刚更新");
            }
            else if(intervalSecond >= minTime && intervalSecond < hourTime)
            {
                // 大于等于一分钟，小于一小时
                title = [NSString stringWithFormat:NSLocalizedString(@"%d分钟前",@"%d分钟前"), intervalSecond / minTime];
            }
            else if(intervalSecond >= hourTime && intervalSecond < dayTime){
                // 大于等于一小时，小于一天
                title = [NSString stringWithFormat:NSLocalizedString(@"今天 %@",@"今天 %@"), [self stringForTimeline2]];
            }
        }
        else if([self compareWithToday] == -1)
        {
            // 昨天
            title = [NSString stringWithFormat:NSLocalizedString(@"昨天 %@",@"昨天 %@"), [self stringForTimeline2]];
        }
        else
        {
            // 不是今天也不是昨天并且在今年
            title = [NSString stringWithFormat:NSLocalizedString(@"%@",@"%@"), [self stringForTimelineCN]];
        }
    }
	
	return title;
}
/* ------------------------------------------------------- */

- (NSString*) stringForCounterhhmmss{
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"HH小时mm分钟ss秒"];
	NSString *timeStr = [formatter stringFromDate:self];
		
	return timeStr;
}
- (NSString*) stringForYyyymmddhhmmss{
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	NSString *timeStr = [formatter stringFromDate:self];
    
	return timeStr;
}
- (NSString*) stringForYyyymmddhhmm{
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
	NSString *timeStr = [formatter stringFromDate:self];
    
	return timeStr;
}
- (NSString*) stringForYymm{
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"yyMM"];
	NSString *timeStr = [formatter stringFromDate:self];
    
	return timeStr;
}
- (NSString*) stringForYymmdd{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyMMdd"];
    NSString *timeStr = [formatter stringFromDate:self];
    
    return timeStr;
}

// 计算自1970年以来的秒数并返回字符串
- (NSString *) stringForIntervalSince1970 {
	NSNumber *seconds = [NSNumber numberWithDouble:[self timeIntervalSince1970]];
	
	return [seconds stringValue];
}

- (NSString *)stringForyyyymmdd
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *timeStr = [formatter stringFromDate:self];
    
    return timeStr;
}

-(NSString *)stringForhh
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH"];
    NSString *timeStr = [formatter stringFromDate:self];
    
    return timeStr;
}


@end
