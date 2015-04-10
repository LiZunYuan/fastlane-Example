//
//  MICoinEarnHistoryGetModel.h
//  MISpring
//
//  Created by 曲俊囡 on 14-5-26.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MICoinEarnHistoryGetModel : NSObject

@property (nonatomic, strong) NSNumber *count;
@property (nonatomic, strong) NSNumber *page;
@property (nonatomic, strong) NSNumber *pageSize;
@property (nonatomic, strong) NSArray *items;//类型为MIItemModel


@end
