//
//  MIPayApplyGetModel.h
//  MISpring
//
//  Created by 徐 裕健 on 13-9-29.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MIPayApplyGetModel : NSObject

@property(nonatomic, strong) NSNumber *applySum;
@property (nonatomic, strong) NSNumber *incomeSum;
@property (nonatomic, strong) NSNumber *expensesSum;
@property (nonatomic, strong) NSNumber *coin;
@property (nonatomic, strong) NSString *tip;

@end
