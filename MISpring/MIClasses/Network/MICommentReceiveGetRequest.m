//
//  MICommentReceiveGetRequest.m
//  MISpring
//
//  Created by 徐 裕健 on 13-12-31.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MICommentReceiveGetRequest.h"

@implementation MICommentReceiveGetRequest

- (void)setPage:(NSInteger)page
{
    [self.fields setObject:@(page) forKey:@"page"];
}

- (void)setPageSize:(NSInteger)pageSize
{
    [self.fields setObject:@(pageSize) forKey:@"page_size"];
}

- (NSString *) getMethod
{
    return @"mizhe.comment.receive.get";
}

@end
