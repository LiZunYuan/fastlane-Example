//
//  TbkItemTableViewCell.h
//  MISpring
//
//  Created by lsave on 13-3-18.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//


#import "MIDeleteUILabel.h"


@interface TbkItemTableViewCell : UITableViewCell

@property(nonatomic, strong) UIImageView * imageView;
@property(nonatomic, strong) UILabel * titleLabel;
@property(nonatomic, strong) RTLabel * priceLabel;
@property(nonatomic, strong) MIDeleteUILabel * delPriceLabel;
@property(nonatomic, strong) RTLabel * saveLabel;
@property(nonatomic, strong) UILabel * volumeLabel;
@property(nonatomic, strong) UILabel * nickLabel;
@property(nonatomic, strong) UIImageView *creditImg;

@end
