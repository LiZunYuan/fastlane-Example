//
//  MIUserGetModel.h
//  MISpring
//
//  Created by Yujian Xu on 13-3-18.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MIUserGetModel : NSObject

@property (nonatomic, strong) NSNumber *uid;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *nick;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *alipay;
@property (nonatomic, strong) NSString *tel;
@property (nonatomic, strong) NSNumber *incomeSum;
@property (nonatomic, strong) NSNumber *expensesSum;
@property (nonatomic, strong) NSNumber *coin;
@property (nonatomic, strong) NSNumber *grade;
@property (nonatomic, strong) NSNumber *userTag;

@end
