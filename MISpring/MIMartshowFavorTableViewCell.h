//
//  BBMartshowFavorTableViewCell.h
//  BeiBeiAPP
//
//  Created by yujian on 14-11-27.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MIMartshowFavorItem.h"
#import "MIBrandItemModel.h"

@interface MIMartshowFavorTableViewCell : UITableViewCell

@property (nonatomic, strong) MIMartshowFavorItem *itemView1;
@property (nonatomic, strong) MIMartshowFavorItem *itemView2;

- (void)updateCellView:(MIMartshowFavorItem *)itemView favorModel:(MIBrandItemModel *)model;

@end
