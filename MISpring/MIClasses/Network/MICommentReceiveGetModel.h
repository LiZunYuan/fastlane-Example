//
//  MICommentReceiveGetModel.h
//  MISpring
//
//  Created by 徐 裕健 on 13-12-31.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MICommentReceiveGetModel : NSObject
@property NSNumber *count;
@property NSNumber *page;
@property NSNumber *pageSize;
@property NSArray *msgComments;
@end
