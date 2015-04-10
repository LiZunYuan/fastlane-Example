//
//  MIZhiVoteGetRequest.m
//  MISpring
//
//  Created by 徐 裕健 on 14/7/25.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MIZhiVoteGetRequest.h"

@implementation MIZhiVoteGetRequest
- (void)setZid:(NSString *)zid
{
    [self.fields setObject:zid forKey:@"zid"];
}
- (NSString *) getMethod
{
    return @"mizhe.zhi.vote.get";
}
@end
