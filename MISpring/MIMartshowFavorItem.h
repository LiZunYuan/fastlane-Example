//
//  BBMartshowFavorItem.h
//  BeiBeiAPP
//
//  Created by yujian on 14-11-27.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MIFavorBrandModel.h"
#import "MIFavorDeleteView.h"

@interface MIMartshowFavorItem : UIButton

@property (nonatomic, assign) BOOL isEditing;
@property (nonatomic, strong) MIFavorDeleteView *deleteView;
@property (nonatomic, strong) UIImageView *emptyBacImageView;
@property (nonatomic, strong) MIFavorBrandModel *model;
@property (nonatomic, strong) UIImageView *martshowIcon;
@property (nonatomic, strong) UILabel *martshowLabel;
@property (nonatomic, strong) UILabel *discountLabel;
//@property (nonatomic, strong) UILabel *mjView;
@property (nonatomic, strong) UIImageView *itemImageView;

@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UIImageView *tipImageView;

@end
