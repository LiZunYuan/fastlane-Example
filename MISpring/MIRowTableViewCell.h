//
//  MIRowTableViewCell.h
//  MISpring
//
//  Created by 曲俊囡 on 15/3/27.
//  Copyright (c) 2015年 Husor Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MIDeleteUILabel.h"
#import "MITuanItemModel.h"
#import "MITuanBuyButton.h"


@interface MIRowTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *itemImageView;
@property (weak, nonatomic) IBOutlet UIImageView *sellOutImageView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet MIDeleteUILabel *oriPriceLabel;

@property (strong, nonatomic) RTLabel *titleLabel;
//@property (nonatomic, strong) UIImageView *anewImageView;
@property (nonatomic, strong) MITuanBuyButton *tuanBuyButton;
@property (nonatomic, strong) MITuanItemModel *model;

- (void)updateCellView:(MITuanItemModel *)model;

@end
