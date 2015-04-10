//
//  MIExchangeGetModel.h
//  MiZheHD
//
//  Created by haozi on 13-8-8.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIBaseRequest.h"

@interface MIExchangeGetModel : NSObject
@property (strong, nonatomic) NSNumber *count;
@property (strong, nonatomic) NSNumber *page;
@property (strong, nonatomic) NSNumber *pageSize;
@property (strong, nonatomic) NSArray *exchangeOrders;

@end
