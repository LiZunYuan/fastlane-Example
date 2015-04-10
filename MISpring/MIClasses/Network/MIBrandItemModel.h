//
//  MIBrandItemModel.h
//  MISpring
//
//  Created by 曲俊囡 on 13-12-7.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum typeIndex{
    TenYuan = 1,
    YouPin = 2,
    Brand = 3,
    BBMartshowItem = 5,
    BBTuanItem = 6,
}typeIndex;

@interface MIBrandItemModel : NSObject

@property (nonatomic, strong) NSNumber *aid;
@property (nonatomic, strong) NSNumber *sid;
@property (nonatomic, strong) NSString *sellerNick;
@property (nonatomic, strong) NSString *logo;
@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, strong) NSString *endTime;
@property (nonatomic, strong) NSString *recomWords;
@property (nonatomic, strong) NSArray *items;//数据类型为MIItemModel
@property (nonatomic, strong) NSNumber *itemCount;
@property (nonatomic, strong) NSNumber *status;
@property (nonatomic, strong) NSNumber *discount;
@property (nonatomic, strong) NSString *labelImg; //标签类型，不为空则需要加载显示
@property (nonatomic, strong) NSNumber *origin;       //1:淘宝 2:天猫
@property (nonatomic, strong) NSNumber *type;        //5 beibei_martshow 6beibei_tuan
@property (nonatomic, strong) NSNumber *eventId;
@property (nonatomic, strong) NSNumber *iid;
@property (nonatomic, strong) NSNumber *goodsCount;

@end
