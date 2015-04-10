//
//  MIBrandCell.h
//  MISpring
//
//  Created by 曲俊囡 on 14-6-17.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MIBrandItemModel.h"

@interface MIBrandCellItemView : UIView
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *priceLabel;

@end


@interface MIBrandCell : UITableViewCell

@property (nonatomic, strong) MIBrandItemModel *itemModel;

@property (strong, nonatomic) MIBrandCellItemView *leftView;
@property (strong, nonatomic) MIBrandCellItemView *rightView;

@property (nonatomic, strong) UIImageView *shopImageView;
@property (nonatomic, strong) UIImageView *lastImageView;
@property (nonatomic, strong) UILabel *shopNameLabel;
@property (nonatomic, strong) UILabel *discountLabel;
@property (nonatomic, strong) UILabel *retainNumLabel;
//@property (nonatomic, strong) UIImageView *clockImageView;
@property (nonatomic, strong) UILabel *retainTimeLabel;

@property (strong, nonatomic)  NSTimer *shopTimer;

- (id) initWithReuseIdentifier:(NSString *)reuseIdentifier;
- (void)startTimer;
- (void)stopTimer;

@end
