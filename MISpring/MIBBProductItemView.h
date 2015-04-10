//
//  MIBBProductItemView.h
//  MISpring
//
//  Created by husor on 14-10-16.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MIMartshowItemModel.h"
#import "MIDeleteUILabel.h"
@interface MIBBProductItemView : UIButton
@property (nonatomic, strong) NSString *hudString;
@property (nonatomic, strong) UILabel *rmbLabel;
@property (nonatomic, strong) UIImageView *itemImage;           //商品缩略图
@property (nonatomic, strong) UIImageView *selloutImg;          //销售状态
@property (nonatomic, strong) RTLabel *price;                   //商品价格
@property (nonatomic, strong) MIDeleteUILabel *priceOriLabel;   //原价
@property (nonatomic, strong) UILabel *discountLabel;               //折扣
@property (nonatomic, strong) UILabel *description;             //商品描述
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;
@property (nonatomic, strong) NSString *mjPromotion;
@property (nonatomic, strong) UIImageView *anewImageView;         //新品标志

@property (nonatomic, copy) void (^selectedBlock)();



@end
