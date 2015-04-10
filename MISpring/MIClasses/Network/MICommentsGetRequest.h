//
//  MICommentsGetRequest.h
//  MISpring
//
//  Created by 徐 裕健 on 13-10-23.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIBaseRequest.h"

@interface MICommentsGetRequest : MIBaseRequest

- (void)setType:(NSInteger)type;
- (void)setItemId:(NSString *)itemId;
- (void)setCommentId:(NSString *)commentId;
- (void)setPage:(NSInteger)page;//可不用
- (void)setPageSize:(NSInteger)pageSize;


@end
