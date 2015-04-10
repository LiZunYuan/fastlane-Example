//
//  MIHotRecommendView.h
//  MISpring
//
//  Created by husor on 15-3-25.
//  Copyright (c) 2015年 Husor Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MITuanHotItemModel.h"

@interface MIHotRecommendView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *hotImageView;
@property (weak, nonatomic) IBOutlet UIImageView *selloutImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *freeDeliveryImg;
@property (weak, nonatomic) IBOutlet UILabel *freeDeliveryLabel;//包邮
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *oriPriceLabel;
@property (weak, nonatomic) IBOutlet UIView *purchaseView;
@property (weak, nonatomic) IBOutlet UILabel *customersLabel;
@property (weak, nonatomic) IBOutlet UILabel *goBuyLabel;
@property (weak, nonatomic) IBOutlet UILabel *rmbLabel;
@property (weak, nonatomic) IBOutlet UILabel *rmb;
@property (nonatomic,strong) MITuanHotItemModel *model;
@end
