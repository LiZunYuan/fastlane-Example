//
//  MIUserFavorItemAddModel.h
//  MISpring
//
//  Created by yujian on 14-12-15.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MIUserFavorItemAddModel : NSObject

@property (nonatomic, strong) NSString *data;
@property (nonatomic, strong) NSNumber *success;//如果success false data 为 out_of_limit 表示到收藏上限 客户端可以做相应的处理
@property (nonatomic, strong) NSString *message;

@end
