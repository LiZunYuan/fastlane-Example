//
//  MIBeibeiTemaiGetModel.h
//  MISpring
//
//  Created by husor on 14-10-14.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MIBeibeiTemaiGetModel : NSObject
@property(nonatomic, strong) NSNumber * count;
@property(nonatomic, strong) NSNumber *filterSellout;
@property(nonatomic, strong) NSNumber * page;
@property(nonatomic, strong) NSNumber * pageSize;
@property(nonatomic, strong) NSString *sort;
@property(nonatomic, strong) NSArray * tuanItems;// MITuanItemModel
@end
