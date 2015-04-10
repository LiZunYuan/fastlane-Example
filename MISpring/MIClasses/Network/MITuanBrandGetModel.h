//
//  MITuanBrandGetModel.h
//  MISpring
//
//  Created by 曲俊囡 on 13-12-7.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MITuanBrandGetModel : NSObject

@property (nonatomic, retain) NSNumber * count;
@property (nonatomic, retain) NSNumber * page;
@property (nonatomic, retain) NSNumber * pageSize;

@property (nonatomic, retain) NSArray *brandItems;//数据类型为MIBrandItemModel

@end
