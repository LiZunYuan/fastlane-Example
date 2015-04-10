//
//  MITemaiGetModel.h
//  MISpring
//
//  Created by 曲俊囡 on 14-7-21.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MITemaiGetModel : NSObject

@property(nonatomic, retain) NSNumber * count;
@property(nonatomic, retain) NSNumber * page;
@property(nonatomic, retain) NSNumber * pageSize;
@property(nonatomic, retain) NSArray * tuanItems; ///数据类型为MITuanItemModel

@end
