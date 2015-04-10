//
//  MIZhiItemCell.h
//  MISpring
//
//  Created by 徐 裕健 on 13-10-18.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MIZhiItemModel.h"

@interface MIZhiItemCell : UITableViewCell

@property(nonatomic, strong) NSString *cat;
@property(nonatomic, strong) MIZhiItemModel *itemModel;
@property(nonatomic, strong) UIImageView * itemImage;
@property(nonatomic, strong) RTLabel * itemTitle;
@property(nonatomic, strong) UILabel *commentLabel;
@property(nonatomic, strong) UIImageView *voteImageView;
@property(nonatomic, strong) UILabel *voteLabel;
@property(nonatomic, strong) UIImageView *statusImage;
@property(nonatomic, strong) UILabel * timeLabel;

@end
