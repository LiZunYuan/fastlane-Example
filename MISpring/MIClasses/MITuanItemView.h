//
//  MITuanItemView.h
//  MISpring
//
//  Created by 曲俊囡 on 14-5-14.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MITuanItemModel.h"

typedef enum {
    MITuanInsertAds,
    MITuanNormal,
}MITuanItemType;

@interface MITuanItemView : UIButton

@property (nonatomic, assign) MITuanItemType type;
@property (nonatomic, strong) NSString *cat;
@property (nonatomic, strong) MITuanItemModel *item;
@property (nonatomic, strong) UIImageView *itemImage;           //商品缩略图
@property (nonatomic, strong) UIImageView *statusImage;         //商品状态图
@property (nonatomic, strong) RTLabel *price;                   //商品价格
@property (nonatomic, strong) UILabel *viewsInfo;               //参团人数
@property (nonatomic, strong) UILabel *description;             //商品描述
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;
@property (nonatomic, strong) UIImageView *labelImageView; //商品标签
@property (nonatomic, strong) UIImageView *temaiImageView; //品牌特卖标志

@property (nonatomic, strong) UIImageView *icNewImgView;//新品标志
@property (nonatomic, strong) UIImageView *adView;
@property (nonatomic, strong) NSDictionary *dic;

- (void)actionClicked:(id)sender;

@end
