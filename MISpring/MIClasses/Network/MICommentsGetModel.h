//
//  MICommentsGetModel.h
//  MISpring
//
//  Created by 徐 裕健 on 13-10-23.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MICommentsGetModel : NSObject
@property(nonatomic, strong) NSNumber * count;
@property(nonatomic, strong) NSNumber * page;
@property(nonatomic, strong) NSNumber * pageSize;
@property(nonatomic, strong) NSArray * comments; ///数据类型为MICommentModel
@end
