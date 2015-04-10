//
//  BBDoubleItemTableViewCell.m
//  BeiBeiAPP
//
//  Created by yujian on 14-11-19.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MIFavorDoubleItemTableViewCell.h"
#import "NSDate+NSDateExt.h"
//#import "BBMsItemModel.h"

@implementation MIFavorDoubleItemTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        _itemView1 = [[MIFavorDoubleItem alloc] initWithFrame:CGRectMake(8, 4, (self.viewWidth - 24) / 2, 196)];
        [self addSubview: _itemView1];
        
        _itemView2 = [[MIFavorDoubleItem alloc] initWithFrame:CGRectMake(_itemView1.right + 8, _itemView1.top, _itemView1.viewWidth, _itemView1.viewHeight)];
        [self addSubview: _itemView2];
    }
    return self;
}

- (void)updateCellView:(MIFavorDoubleItem *)itemView tuanModel:(MIFavorItemModel *)model
{
    itemView.model = model;
    
    NSString *desc = [model.title stringByReplacingOccurrencesOfString:@"【" withString:@"["];
    desc = [desc stringByReplacingOccurrencesOfString:@"，" withString:@","];
    itemView.favorTitleLabel.text = [desc stringByReplacingOccurrencesOfString:@"】" withString:@"]"];
    double nowInterval = [[NSDate date] timeIntervalSince1970] + [MIConfig globalConfig].timeOffset;
    int gmtEnd = model.endTime.intValue;
    int gmtBegin = model.startTime.intValue;
    
    itemView.favorPriceLabel.viewWidth = 142; //重新指定最大的宽度以获取rtlabel的optimumSize
    
    if (self.type == MartshowItemFavorType)
    {
        itemView.priceView.hidden = NO;
        itemView.favorPriceLabel.text = model.price.priceValue;
        NSInteger price = model.price.integerValue / 100;
        NSString *decimal = model.price.pointValue;
        itemView.favorPriceLabel.text = [[NSString alloc] initWithFormat:@"<font size=15.0>%ld</font><font size=12.0>%@</font>", (long)price, decimal];
        itemView.favorPriceLabel.textAlignment = NSTextAlignmentLeft;
        itemView.favorPriceLabel.viewWidth = ceilf(itemView.favorPriceLabel.optimumSize.width) + 10;
        
        itemView.originPriceLabel.text = model.priceOri.priceValue;
        
        itemView.originPriceLabel.left = itemView.favorPriceLabel.right - 5;
        itemView.discountLabel.text = model.discount.discountValue;
        [itemView.itemImageView sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:[UIImage imageNamed:@"img_loading_daily1"]];
    }
    else
    {
        itemView.priceView.hidden = YES;
        [itemView.itemImageView sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:[UIImage imageNamed:@"img_loading_daily1"]];
    }
    
    itemView.tipImageView.hidden = YES;
    if (nowInterval < gmtBegin)
    {
        itemView.tipLabel.hidden = NO;
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:gmtBegin];
        itemView.tipLabel.text = [NSString stringWithFormat:@"%@开抢",[date stringForYyyymmddhhmm]];
        itemView.tipLabel.hidden = NO;
    }
    else if (nowInterval > gmtEnd)
    {
        itemView.tipLabel.hidden = NO;
        itemView.tipLabel.text = @"抢购已结束";
        itemView.tipLabel.hidden = NO;
    }
    else
    {
        itemView.tipLabel.hidden = YES;
    }
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
