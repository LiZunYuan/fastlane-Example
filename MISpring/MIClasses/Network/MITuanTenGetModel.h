//
//  MITuanTenGetModel.h
//  MISpring
//
//  Created by Yujian Xu on 13-3-26.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MITuanTenGetModel : NSObject

@property(nonatomic, retain) NSNumber * count;
@property(nonatomic, retain) NSNumber * page;
@property(nonatomic, retain) NSNumber * pageSize;
@property(nonatomic, retain) NSMutableArray * tuanItems; ///数据类型为MITuanItemModel
@property(nonatomic, retain) NSMutableArray *tuanHotItems;//数据类型为MITuanHotItemModel
@property (nonatomic, strong) NSString *tuanHotTag;
@end
