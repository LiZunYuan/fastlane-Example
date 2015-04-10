//
//  MICommentsGetRequest.m
//  MISpring
//
//  Created by 徐 裕健 on 13-10-23.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MICommentsGetRequest.h"

@implementation MICommentsGetRequest
- (void)setType:(NSInteger)type
{
    [self.fields setObject:@(type) forKey:@"type"];
}
- (void)setItemId:(NSString *)itemId
{
    [self.fields setObject:itemId forKey:@"item_id"];
}
- (void)setCommentId:(NSString *)commentId
{
    [self.fields setObject:commentId forKey:@"comment_id"];
}
- (void) setPage:(NSInteger)page
{
    [self.fields setObject:[NSString stringWithFormat:@"%ld", (long)page] forKey:@"page"];
}
- (void) setPageSize:(NSInteger)pageSize
{
    [self.fields setObject:[NSString stringWithFormat:@"%ld", (long)pageSize] forKey:@"page_size"];
}
- (NSString *) getMethod
{
    return @"mizhe.comments.get";
}
- (BOOL)getForceReload
{
    return YES;
}
- (NSString *) getType
{
    return @"static";
}
- (NSString *) getStaticURL
{
    return [NSString stringWithFormat:@"%@/zhi/comment/%@-%@-%@-%@.html", [MIConfig globalConfig].staticApiURL, [self.fields objectForKey:@"type"], [self.fields objectForKey:@"item_id"], [self.fields objectForKey:@"page"], [self.fields objectForKey:@"page_size"]];
}
@end
