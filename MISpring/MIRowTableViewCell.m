//
//  MIRowTableViewCell.m
//  MISpring
//
//  Created by 曲俊囡 on 15/3/27.
//  Copyright (c) 2015年 Husor Inc. All rights reserved.
//

#import "MIRowTableViewCell.h"
#import "NSString+MIImageAppending.h"

@implementation MIRowTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.titleLabel.textColor = MIColor666666;
    self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping | NSLineBreakByTruncatingTail;
    
    self.tuanBuyButton = [[MITuanBuyButton alloc] initWithFrame:CGRectMake(0, 0, 68, 45)];
    [self.contentView addSubview:self.tuanBuyButton];
    [self.tuanBuyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-12);
        make.bottom.equalTo(self.oriPriceLabel.mas_bottom);
        make.height.equalTo(@45);
        make.width.equalTo(@68);
    }];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 130.5, PHONE_SCREEN_SIZE.width, 0.5)];
    line.backgroundColor = MINormalBackgroundColor;
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-0.5);
        make.height.equalTo(@(0.5));
        make.width.equalTo(self);
    }];
}


-(void) layoutSubviews
{
    MITuanItemModel *model = self.model;
    [self.itemImageView sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:[UIImage imageNamed:@"img_loading_daily1"]];
    
    self.priceLabel.text = [NSString stringWithFormat:@"%.2f",model.price.floatValue/100];
    CGSize size = [self.priceLabel.text sizeWithFont:self.priceLabel.font constrainedToSize:CGSizeMake(200, self.priceLabel.viewHeight)];
    self.priceLabel.viewWidth = size.width;
    
    self.oriPriceLabel.text = model.priceOri.priceValue;
    self.oriPriceLabel.strikeThroughEnabled = YES;
    size = [self.oriPriceLabel.text sizeWithFont:self.oriPriceLabel.font constrainedToSize:CGSizeMake(200, self.oriPriceLabel.viewHeight)];
    self.oriPriceLabel.viewWidth = size.width;
    
    self.titleLabel.text = model.title;
    
    double nowInterval = [[NSDate date] timeIntervalSince1970] + [MIConfig globalConfig].timeOffset;
    
    if (model.startTime.integerValue <= nowInterval && model.endTime.integerValue > nowInterval)
    {
        if (model.status.integerValue)
        {
            self.tuanBuyButton.type = TuanBuyButtonNormalType;
            NSString *clickColumn;
            float clicksVolumn = _model.clicks.floatValue + _model.volumn.floatValue;
            if (clicksVolumn >= 10000.0) {
                clickColumn = [[NSString alloc] initWithFormat:@"%.1f万人已抢", clicksVolumn / 10000.0];
            } else {
                clickColumn = [[NSString alloc] initWithFormat:@"%.f人已抢", clicksVolumn];
            }
            self.tuanBuyButton.topLabel.text = clickColumn;
            self.tuanBuyButton.buttonLabel.text = @"立即抢";
            self.sellOutImageView.hidden = YES;
        }
        else
        {
            self.tuanBuyButton.type = TuanBuyButtonSelloutType;
            self.tuanBuyButton.topLabel.text = @"已抢光";
            NSString *clickColumn;
            float clicksVolumn = _model.clicks.floatValue + _model.volumn.floatValue;
            if (clicksVolumn >= 10000.0) {
                clickColumn = [[NSString alloc] initWithFormat:@"%.1f万人已抢", clicksVolumn / 10000.0];
            } else {
                clickColumn = [[NSString alloc] initWithFormat:@"%.f人已抢", clicksVolumn];
            }
            self.tuanBuyButton.buttonLabel.text =clickColumn;
            self.tuanBuyButton.percent = 0;
            self.sellOutImageView.hidden = NO;
        }
    }
    else if (model.startTime.integerValue > nowInterval)
    {
        self.sellOutImageView.hidden = YES;
        self.tuanBuyButton.percent = 0;
        self.tuanBuyButton.type = TuanBuyButtonWillSellType;
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:model.startTime.integerValue];
        self.tuanBuyButton.topLabel.text = @"即将开抢";
        self.tuanBuyButton.buttonLabel.text = [NSString stringWithFormat:@"%@点开抢",[date stringForhh]];
    }
    else
    {
        self.sellOutImageView.hidden = YES;
        self.tuanBuyButton.percent = 0;
        self.tuanBuyButton.type = TuanBuyButtonSelloutType;
        self.tuanBuyButton.topLabel.text = @"已结束";
        self.tuanBuyButton.buttonLabel.text = [NSString stringWithFormat:@"%.0f人已抢",(model.volumn.floatValue + model.clicks.floatValue)];
    }
    
}

- (void)updateCellView:(MITuanItemModel *)model
{
    self.model = model;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
