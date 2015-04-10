//
//  MITuanHotGetModel.h
//  MISpring
//
//  Created by 曲俊囡 on 15/3/27.
//  Copyright (c) 2015年 Husor Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MITuanHotGetModel : NSObject

@property (nonatomic, retain) NSNumber * count;
@property (nonatomic, retain) NSNumber * page;
@property (nonatomic, retain) NSNumber * pageSize;
@property (nonatomic, retain) NSNumber * hasMore;

@property (nonatomic, retain) NSArray *tuanItems;//数据类型为MITuanItemModel

@end
