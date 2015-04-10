//
//  BBFavorDoubleItem.h
//  BeiBeiAPP
//
//  Created by yujian on 14-11-19.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MIFavorDoubleItem.h"
#import "MIDeleteUILabel.h"
//#import "BBDeleteLabel.h"
#import "MIFavorItemModel.h"

@interface MIFavorDoubleItem : UIButton

@property (nonatomic, strong) MIFavorItemModel *model;
@property (nonatomic, strong) UIView *timeView;
@property (nonatomic, strong) UILabel *favorTitleLabel;
@property (nonatomic, strong) RTLabel *favorPriceLabel;
@property (nonatomic, strong) MIDeleteUILabel *originPriceLabel;
@property (nonatomic, strong) UILabel *discountLabel;
@property (nonatomic, strong) UIImageView *itemImageView;
@property (nonatomic, strong) UILabel *rmbLabel;
@property (nonatomic, strong) UIImageView *emptyBacImageView;
@property (nonatomic, strong) UIImageView *deleteView;
@property (nonatomic, strong) UIView *priceView;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UIImageView *tipImageView;

@property (nonatomic, assign) BOOL isEditing;

@property (nonatomic, copy) void (^selectedBlock)();

@end
