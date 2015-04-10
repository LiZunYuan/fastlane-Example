//
//  MIBrandTomorrowGetModel.h
//  MISpring
//
//  Created by 曲俊囡 on 14-6-18.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MIBrandTomorrowGetModel : NSObject

@property (nonatomic, retain) NSNumber * count;
@property (nonatomic, retain) NSNumber * page;
@property (nonatomic, retain) NSNumber * pageSize;

@property (nonatomic, retain) NSArray *brandItems;//数据类型为MIBrandItemModel
@property (nonatomic, retain) NSArray *recomBrands;
@property (nonatomic, strong)NSString *emptyDesc;

@end
