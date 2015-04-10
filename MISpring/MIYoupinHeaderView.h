//
//  MIYoupinHeaderView.h
//  MISpring
//
//  Created by husor on 15-3-26.
//  Copyright (c) 2015年 Husor Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MIYoupinHeaderView : UIView
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UIImageView *priceBgImg;
@property (nonatomic, strong) UILabel *fengqiangLabel;
@property (nonatomic, strong) UILabel *priceLabel;

- (CGFloat)getViewHeight;
@end
