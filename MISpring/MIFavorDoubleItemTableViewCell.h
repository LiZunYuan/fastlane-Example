//
//  BBDoubleItemTableViewCell.h
//  BeiBeiAPP
//
//  Created by yujian on 14-11-19.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MIFavorDoubleItem.h"
#import "MIFavorItemModel.h"

typedef enum {
    MartshowItemFavorType,
    MartshowFavorType,
}FavorType;

@interface MIFavorDoubleItemTableViewCell : UITableViewCell

@property (nonatomic, assign) FavorType type;
@property (nonatomic, strong) MIFavorDoubleItem * itemView1;
@property (nonatomic, strong) MIFavorDoubleItem * itemView2;

- (void)updateCellView:(MIFavorDoubleItem *)itemView tuanModel:(MIFavorItemModel *)model;


@end
