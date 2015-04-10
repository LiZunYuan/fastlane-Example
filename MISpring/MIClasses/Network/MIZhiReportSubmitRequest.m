//
//  MIZhiReportSubmitRequest.m
//  MISpring
//
//  Created by 曲俊囡 on 14-7-18.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MIZhiReportSubmitRequest.h"

@implementation MIZhiReportSubmitRequest

- (void)setZid:(NSString *)zid
{
    [self.fields setObject:zid forKey:@"zid"];
}
- (NSString *) getMethod
{
    return @"mizhe.zhi.report.submit";
}

@end
