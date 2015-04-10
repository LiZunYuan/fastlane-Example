//
//  MIBBMartshowItemModel.h
//  MISpring
//
//  Created by husor on 14-10-16.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MIMartshowItemModel : NSObject
@property (nonatomic, strong) NSNumber *iid;
@property (nonatomic, strong) NSNumber *vid;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *img;
@property (nonatomic, strong) NSNumber *price;
@property (nonatomic, strong) NSNumber *priceOri;
@property (nonatomic, strong) NSNumber *status;
@property (nonatomic, strong) NSNumber *stock;
@property (nonatomic, strong) NSNumber *discount;
@property (nonatomic, strong) NSString *mjPromotion;
@end
