//
//  MICommentAddRequest.h
//  MISpring
//
//  Created by 徐 裕健 on 13-10-23.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIBaseRequest.h"

@interface MICommentAddRequest : MIBaseRequest
- (void)setType:(NSInteger)type;
- (void)setItemId:(NSInteger)itemId;
- (void)setTouid:(NSInteger)touid;
- (void)setPid:(NSInteger)pid;
- (void)setComment:(NSString *)comment;

@end
