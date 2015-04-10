//
//  MIBBBrandItemsGetModel.h
//  MISpring
//
//  Created by husor on 14-10-15.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MIBeibeiMartshowItemGetModel : NSObject
@property (nonatomic, strong) NSNumber *count;
@property (nonatomic, strong) NSNumber *gmtBegin;
@property (nonatomic, strong) NSNumber *gmtEnd;
@property (nonatomic, strong) NSString *logo;
@property (nonatomic, strong) NSString *brand;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSNumber *page;
@property (nonatomic, strong) NSNumber *pageSize;
@property (nonatomic, strong) NSString *mjPromotion;
@property (nonatomic, strong) NSNumber *totalCount;
@property (nonatomic, strong) NSArray *martshowItems;//数据类型为MIMartshowItemModel
@property (nonatomic, strong) NSString *sort;
@property (nonatomic, strong) NSNumber *filterSellout;


@end
