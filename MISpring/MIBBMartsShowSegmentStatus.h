//
//  MIBBMartsShowSegmentStatus.h
//  MISpring
//
//  Created by husor on 14-10-16.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_OPTIONS(NSUInteger, BBSelectedState) {
    BBSelectedStateNormal       = 0,
    BBSelectedStateSelected  = 1,
};

@interface MIBBMartsShowSegmentStatus : NSObject

@property (nonatomic, strong) NSNumber *inStockStatus;
@property (nonatomic, strong) NSNumber *filterStatus;

@end
