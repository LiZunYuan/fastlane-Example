//
//  MITuanTomorrowGetModel.h
//  MISpring
//
//  Created by 曲俊囡 on 14-6-18.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MITuanTomorrowGetModel : NSObject

@property(nonatomic, retain) NSNumber * count;
@property(nonatomic, retain) NSNumber * page;
@property(nonatomic, retain) NSNumber * pageSize;
@property(nonatomic, retain) NSArray * tuanItems; ///数据类型为MITuanItemModel
@property(nonatomic, retain) NSArray *recomItems;//推荐商品
@property(nonatomic, strong)NSString *emptyDesc;

@end
