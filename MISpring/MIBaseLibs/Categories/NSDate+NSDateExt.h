//
//  NSDate+NSDateExt.h
//  MISpring
//
//  Created by XU YUJIAN on 13-1-17.
//  Copyright (c) 2013年 MiZhe Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate(NSDateExt)
- (NSInteger) compareWithToday;
- (BOOL) compareWithToday2;
- (BOOL)compareWithThisYear;
- (NSString *) stringForSectionTitle;
- (NSString *) stringForSectionTitle2; //用于RenReniPad最近来访时间格式
- (NSString *) stringForSectionTitle3; //iphone
- (NSString *) stringForSectionTitle4;//目前sixin和ipad的时间分割策略，今天只显示HH:mm,不显示“今天”
- (NSString *) stringForSectionTitle5;//人人聊天的时间分割策略，前天以前的只显示日期
- (NSString *) stringForDateline; //将时间变为 yyyy－mm－dd的格式
- (NSString *) stringForTimeline; //将时间变为 mm-dd HH:mm
- (NSString *) stringForTimeline2;//将时间变为 HH:mm
- (NSString *) stringForTimeline3;//将时间变为 HH:mm:ss
- (NSString *) stringForTimeTips1;//将时间变为 HH点mm分
- (NSString *) stringForTimeTips2;//将时间变为 HH:mm开抢

- (NSString *) stringForTimeRelative;//计算原时间与现在时间的相对差，以字符串形式返回
/* +++++++++++++++++++++++++++++++++++++++++++++++++++++ */
/* 
 * zhengzheng 新鲜事，评论列表时间显示策略
 */
- (NSString*) stringForTimeRelativeForFeed;
- (NSString*) stringForTimelineCN;
/* ----------------------------------------------------- */
- (NSString *) stringForCounterhhmmss;
- (NSString*) stringForYyyymmddhhmmss;
- (NSString*) stringForYyyymmddhhmm;
- (NSString*) stringForYymmdd;
- (NSString*) stringForYymm;
- (NSString *) stringForIntervalSince1970; // 计算自1970年以来的秒数并返回字符串
- (NSString *) stringForVisitorTitle; //最近来访时间格式
- (NSString *) stringForTimelineWithFormat:(NSString *)format;
- (NSString *) stringForyyyymmdd;
-(NSString *)stringForhh;

@end
