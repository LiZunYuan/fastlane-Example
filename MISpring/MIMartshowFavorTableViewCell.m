//
//  BBMartshowFavorTableViewCell.m
//  BeiBeiAPP
//
//  Created by yujian on 14-11-27.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MIMartshowFavorTableViewCell.h"
#import "MIMartshowFavorItem.h"
#import "MIItemModel.h"
#import "NSString+MIImageAppending.h"
#import "NSDate+NSDateExt.h"
//#import "BBMsItemModel.h"

@implementation MIMartshowFavorTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        _itemView1 = [[MIMartshowFavorItem alloc] initWithFrame:CGRectMake(8, 8, (SCREEN_WIDTH - 24) / 2, (SCREEN_WIDTH - 24) / 2 + 48)];
        [self addSubview: _itemView1];
        
        _itemView2 = [[MIMartshowFavorItem alloc] initWithFrame:CGRectMake(_itemView1.right + 8, _itemView1.top, _itemView1.viewWidth, _itemView1.viewHeight)];
        [self addSubview: _itemView2];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)updateCellView:(MIMartshowFavorItem *)itemView favorModel:(MIFavorBrandModel *)model;
{
    itemView.model = model;
    double nowInterval = [[NSDate date] timeIntervalSince1970] + [MIConfig globalConfig].timeOffset;
    int gmtEnd = model.endTime.intValue;
    int gmtBegin = model.startTime.intValue;
    itemView.martshowLabel.text = [NSString stringWithFormat:@"%@",model.sellerNick];
    if (model.items.count > 0)
    {
        MIItemModel *itemsModel = (MIItemModel *)[model.items objectAtIndex:0];
       // NSString *imgUrl = [itemsModel.img miImageAppendingWithSizeString:@"320x320"];
        [itemView.itemImageView sd_setImageWithURL:[NSURL URLWithString:itemsModel.img] placeholderImage:[UIImage imageNamed:@"img_loading_daily1"]];
    }
    
    itemView.discountLabel.text = [NSString stringWithFormat:@"%@起",model.discount.discountValue];
    CGSize size = [itemView.discountLabel.text sizeWithFont:[itemView.discountLabel font] constrainedToSize:CGSizeMake(50, itemView.discountLabel.viewHeight)];
    itemView.discountLabel.viewWidth = size.width;
    [itemView.martshowIcon sd_setImageWithURL:[NSURL URLWithString:model.logo]];
    
    itemView.tipImageView.hidden = YES;
    if (nowInterval < gmtBegin)
    {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:gmtBegin];
        itemView.tipLabel.text = [NSString stringWithFormat:@"%@开抢",[date stringForYyyymmddhhmm]];
        itemView.tipLabel.hidden = NO;
    }
    else if (nowInterval > gmtEnd)
    {
        itemView.tipLabel.text = @"抢购已结束";
        itemView.tipLabel.hidden = NO;
    }
    else
    {
        itemView.tipLabel.hidden = YES;
    }
}

@end
