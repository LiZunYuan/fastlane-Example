//
//  MIUserFavorViewController.h
//  MISpring
//
//  Created by yujian on 14-12-15.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MIBaseViewController.h"

typedef enum : NSInteger{
    ItemType,
    BrandType,
}ItemBrandType;

@interface MIUserFavorViewController : MIBaseViewController

@property (nonatomic, assign) ItemBrandType type;

@end
