//
//  MIZhiItemVoteAddRequest.m
//  MISpring
//
//  Created by 徐 裕健 on 13-10-23.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIZhiItemVoteAddRequest.h"

@implementation MIZhiItemVoteAddRequest
- (void)setZid:(NSString *)zid
{
    [self.fields setObject:zid forKey:@"zid"];
}
- (NSString *) getMethod
{
    return @"mizhe.zhi.vote.add";
}
@end
