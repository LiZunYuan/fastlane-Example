//
//  MIMsgCommentModel.h
//  MISpring
//
//  Created by 徐 裕健 on 13-12-31.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MIMsgCommentModel : NSObject
@property NSString *avatar;
@property NSString *nick;
@property NSNumber *gmtCreate;
@property NSNumber *toUid;
@property NSNumber *uid;
@property NSNumber *pid;
@property NSString *comment;
@property NSNumber *commentId;
@property NSNumber *type;
@property NSNumber *relateId;
@property NSString *img;
@property NSString *title;
@property NSNumber *commentHeight;
@end
