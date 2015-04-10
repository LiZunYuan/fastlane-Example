//
//  MIExchangeOrderModel.h
//  MiZheHD
//
//  Created by haozi on 13-8-8.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MIExchangeOrderModel : NSObject
@property(strong, nonatomic) NSString *orderId;
@property(strong, nonatomic) NSString *goodsName;
@property(strong, nonatomic) NSNumber *price;
@property(strong, nonatomic) NSString *payType;
@property(strong, nonatomic) NSString *accessory;
@property(strong, nonatomic) NSString *status;
@property(strong, nonatomic) NSNumber *gmtCreate;
@end
