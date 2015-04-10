//
//  MICommentAddRequest.m
//  MISpring
//
//  Created by 徐 裕健 on 13-10-23.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MICommentAddRequest.h"

@implementation MICommentAddRequest
- (void)setType:(NSInteger)type
{
    [self.fields setObject:@(type) forKey:@"type"];
}
- (void)setItemId:(NSInteger)itemId
{
    //优惠id，必选
    [self.fields setObject:@(itemId) forKey:@"item_id"];
}
- (void)setTouid:(NSInteger)touid
{
    //被追评的用户id，可选
    [self.fields setObject:@(touid) forKey:@"to_uid"];
}
- (void)setPid:(NSInteger)pid
{
    //被追评的评论id，可选
    [self.fields setObject:@(pid) forKey:@"pid"];
}
- (void)setComment:(NSString *)comment
{
    //添加的评论内容，必选
    [self.fields setObject:comment forKey:@"comment"];
}
- (NSString *) getMethod
{
    return @"mizhe.comment.add";
}
@end
