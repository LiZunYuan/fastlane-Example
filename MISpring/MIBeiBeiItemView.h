//
//  MIBeiBeiItemView.h
//  MISpring
//
//  Created by husor on 14-10-14.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MITuanItemModel.h"
#import "MIDeleteUILabel.h"
@interface MIBeiBeiItemView : UIButton
@property (nonatomic, strong) NSString *cat;
@property (nonatomic, strong) MITuanItemModel *item;
@property (nonatomic, strong) UIImageView *itemImage;           //商品缩略图
@property (nonatomic, strong) UIImageView *statusImage;         //商品状态图
@property (nonatomic, strong) RTLabel *price;                   //商品价格
@property (nonatomic, strong) MIDeleteUILabel *priceOri;
@property (nonatomic, strong) RTLabel *viewsInfo;               //参团人数
@property (nonatomic, strong) UILabel *description;             //商品描述
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;
@property (nonatomic, strong) RTLabel *timeLabel; //品牌专场标签
@property (nonatomic, strong) UIImageView *temaiImageView; //品牌特卖标志
@property (nonatomic, strong) UILabel *brandTitle;
@property (nonatomic, strong) UIImageView *icNewImgView1;//新品标志
//@property (nonatomic, strong) UILabel *icNewImgView2;
@property (nonatomic, strong) NSNumber *startTime;
@property (nonatomic, strong) NSNumber *endTime;
@property (nonatomic, strong) UIView *bottomBg1;
//@property (nonatomic, strong) UIView *bottomBg2;
//@property (nonatomic, strong) RTLabel *discountLabel;

- (void)actionClicked:(id)sender;

@end
