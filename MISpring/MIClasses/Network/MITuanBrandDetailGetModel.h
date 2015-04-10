//
//  MITuanBrandDetailGetModel.h
//  MISpring
//
//  Created by 曲俊囡 on 13-12-7.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MITuanBrandDetailGetModel : NSObject

@property (nonatomic, strong) NSNumber *aid;
@property (nonatomic, strong) NSNumber *sid;
@property (nonatomic, strong) NSString *sellerNick;
@property (nonatomic, strong) NSString *logo;
@property (nonatomic, strong) NSString *banner;
@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, strong) NSString *endTime;
@property (nonatomic, strong) NSString *recomWords;
@property (nonatomic, strong) NSArray *items;//数据类型为MIItemModel
@property (nonatomic, strong) NSNumber *status;
@property (nonatomic, strong) NSNumber *count;
@property (nonatomic, strong) NSNumber *page;
@property (nonatomic, strong) NSNumber *pageSize;

@end
