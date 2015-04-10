//
//  MIOrderMallGetModel.h
//  MISpring
//
//  Created by Yujian Xu on 13-4-3.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MIOrderMallGetModel : NSObject

@property(nonatomic, strong) NSNumber * count;
@property(nonatomic, strong) NSNumber * page;
@property(nonatomic, strong) NSNumber * pageSize;
@property(nonatomic, strong) NSArray * mallOrders; ///数据类型为MIMallOrderModel

@end
