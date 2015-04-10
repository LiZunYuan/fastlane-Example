//
//  MICommentReceiveGetRequest.h
//  MISpring
//
//  Created by 徐 裕健 on 13-12-31.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIBaseRequest.h"

@interface MICommentReceiveGetRequest : MIBaseRequest
- (void)setPage:(NSInteger)page;
- (void)setPageSize:(NSInteger)pageSize;
@end
