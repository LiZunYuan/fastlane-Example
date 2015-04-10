//
//  MallSearchItemTableViewCell.h
//  MISpring
//
//  Created by Mac Chow on 13-3-22.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MallSearchItemTableViewCell : UITableViewCell

@property(nonatomic, assign) NSNumber * mallId;
@property(nonatomic, assign) NSString * mallName;

@property(nonatomic, strong) UIImageView * imageView;
@property(nonatomic, strong) UILabel * labelTitle;
@property(nonatomic, strong) UILabel * labelCommission;
@end
