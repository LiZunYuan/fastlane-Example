//
//  MIUserFavorBrandGetModel.h
//  MISpring
//
//  Created by yujian on 14-12-15.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MIUserFavorBrandGetModel : NSObject

@property (nonatomic, strong) NSNumber *count;
@property (nonatomic, strong) NSNumber *page;
@property (nonatomic, strong) NSNumber *pageSize;
@property (nonatomic, strong) NSArray *favorBrands;

@end
