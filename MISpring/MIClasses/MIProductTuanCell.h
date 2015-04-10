//
//  MIProductTuanCell.h
//  MISpring
//
//  Created by 曲俊囡 on 13-12-6.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MIItemModel.h"
#import "MIDeleteUILabel.h"

/**
 *	@brief 品牌特卖商品信息视图
 */
@interface MIBrandItemView : UIButton

@property (nonatomic, strong) NSString *cat;
@property (nonatomic, strong) MIItemModel *item;
@property (nonatomic, strong) UIImageView *itemImage;           //商品缩略图
@property (nonatomic, strong) UIImageView *selloutImg;          //销售状态
@property (nonatomic, strong) UILabel *price;                   //商品价格
@property (nonatomic, strong) UILabel *rmbLabel;                //人民币符号
@property (nonatomic, strong) MIDeleteUILabel *priceOri;
@property (nonatomic, strong) UILabel *discountLabel;
@property (nonatomic, strong) UILabel *description;             //商品描述
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

- (void)actionClicked:(id)sender;

@end

@interface MIProductTuanCell : UITableViewCell

@property(nonatomic, copy) NSString *cat;
@property(nonatomic, strong) MIBrandItemView * itemView1;
@property(nonatomic, strong) MIBrandItemView * itemView2;

- (id) initWithReuseIdentifier:(NSString *)reuseIdentifier;
- (void) updateCellView:(MIBrandItemView *)itemView tuanModel:(MIItemModel *)model;

@end
