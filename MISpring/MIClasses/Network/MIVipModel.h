//
//  MIVipModel.h
//  MISpring
//
//  Created by 曲俊囡 on 13-11-20.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MIVipModel : NSObject<NSCoding>

@property(nonatomic, strong) NSNumber * grade;
@property(nonatomic, strong) NSNumber * extraRate;
@property(nonatomic, strong) NSNumber * doubleCoin;
@property(nonatomic, strong) NSNumber * halfCoupon;
@property(nonatomic, strong) NSNumber * inviteSum;
@property(nonatomic, strong) NSNumber * incomeSum;

@end
