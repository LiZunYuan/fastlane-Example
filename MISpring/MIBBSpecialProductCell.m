//
//  MIBBSpecialProductCell.m
//  MISpring
//
//  Created by husor on 14-10-16.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MIBBSpecialProductCell.h"
#import "MITuanItemModel.h"
#import "MIBBBrandViewController.h"

@implementation MIBBSpecialProductCell
@synthesize itemView1;
@synthesize itemView2;

- (id) initWithreuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        itemView1 = [[MIBBProductItemView alloc] initWithFrame:CGRectMake(8, 4, 148, 196)];
        [self addSubview: itemView1];
        
        itemView2 = [[MIBBProductItemView alloc] initWithFrame:CGRectMake(itemView1.right + 8, itemView1.top, itemView1.viewWidth, itemView1.viewHeight)];
        [self addSubview: itemView2];
    }
    return self;
}

- (void)updateCellView:(MIBBProductItemView *)itemView tuanModel:(id)model
{
    MIMartshowItemModel *itemModel = (MIMartshowItemModel *)model;
    [itemView.indicatorView startAnimating];
    if (itemModel.stock.integerValue == 0) {
        itemView.selloutImg.hidden = NO;
    } else {
        itemView.selloutImg.hidden = YES;
    }
    
    NSString *imgUrl = [NSString stringWithFormat:@"%@%@",itemModel.img,@"!320x320.jpg"];
    [itemView.itemImage sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"img_loading_daily1"]];
    itemView.anewImageView.hidden = YES;
    itemView.description.text = itemModel.title;
    
    NSInteger price = itemModel.price.integerValue / 100;
    NSString *decimal = [NSString stringWithFormat:@"%ld",((long)itemModel.price.integerValue%100)/100];
    itemView.price.text = [[NSString alloc] initWithFormat:@"<font size=20.0>%ld</font><font size=12.0>.%@</font>", (long)price, decimal];
    itemView.price.textAlignment = NSTextAlignmentLeft;
    itemView.price.viewWidth = ceilf(itemView.price.optimumSize.width) + 10;
    itemView.priceOriLabel.text = itemModel.priceOri.priceValue;
    
    if (itemModel.discount.integerValue >= 100) {
        itemView.priceOriLabel.hidden = YES;
        itemView.discountLabel.hidden = YES;
    } else {
        itemView.priceOriLabel.hidden = NO;
        itemView.discountLabel.hidden = NO;
        itemView.priceOriLabel.left = itemView.price.right;
        CGSize expectedSize = [itemView.priceOriLabel.text sizeWithFont:itemView.priceOriLabel.font];
        itemView.priceOriLabel.viewWidth = expectedSize.width + 2;
        itemView.discountLabel.text = itemModel.discount.discountValue;
    }}

@end
