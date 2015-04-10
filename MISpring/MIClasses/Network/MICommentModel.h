//
//  MICommentModel.h
//  MISpring
//
//  Created by 徐 裕健 on 13-10-23.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MICommentModel : NSObject
@property NSNumber *commentId;
@property NSNumber *uid;
@property NSNumber *pid;    //0表示原始评论，非0表示追评
@property NSString *comment;
@property NSNumber *createTime;
@property NSString *avatar; //发布评论的用户头像地址
@property NSString *nick;
@property NSString *toNick; //被追评的用户昵称
@property NSNumber *commentHeight;

@end
