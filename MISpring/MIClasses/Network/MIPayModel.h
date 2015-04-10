//
//  MIPayModel.h
//  MISpring
//
//  Created by Yujian Xu on 13-3-29.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MIPayModel : NSObject

@property (nonatomic, strong) NSString *alipay;
@property (nonatomic, strong) NSNumber *money;
@property (nonatomic, strong) NSString *payTime;
@property (nonatomic, strong) NSString *reqTime;
@property (nonatomic, strong) NSNumber *status;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *statusDesc;

@end
