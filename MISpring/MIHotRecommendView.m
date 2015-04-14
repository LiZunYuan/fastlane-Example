//
//  MIHotRecommendView.m
//  MISpring
//
//  Created by husor on 15-3-25.
//  Copyright (c) 2015年 Husor Inc. All rights reserved.
//

#import "MIHotRecommendView.h"

@implementation MIHotRecommendView

-(void)layoutSubviews
{
    [super layoutSubviews];
    [self.hotImageView sd_setImageWithURL:[NSURL URLWithString:_model.img] placeholderImage:[UIImage imageNamed:@"img_loading_daily1"]];
    NSString *desc = [_model.title stringByReplacingOccurrencesOfString:@"【" withString:@"["];
    desc = [desc stringByReplacingOccurrencesOfString:@"，" withString:@","];
    self.titleLabel.text = [desc stringByReplacingOccurrencesOfString:@"】" withString:@"]"];
    self.titleLabel.textColor = [MIUtility colorWithHex:0x666666];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.numberOfLines = 2;
    self.freeDeliveryLabel.textColor = [MIUtility colorWithHex:0xffffff];
    self.purchaseView.layer.cornerRadius = 1.5;
    self.purchaseView.layer.borderWidth = 1;
    self.purchaseView.clipsToBounds = YES;
    self.customersLabel.textColor = [MIUtility colorWithHex:0x666666];
    self.goBuyLabel.textColor = [MIUtility colorWithHex:0xffffff];
    self.goBuyLabel.textAlignment = NSTextAlignmentCenter;
    self.priceLabel.font = [UIFont boldSystemFontOfSize:15];
    self.priceLabel.textColor = [MIUtility colorWithHex:0x333333];
    self.oriPriceLabel.textColor = [MIUtility colorWithHex:0x999999];
    self.priceLabel.text = [NSString stringWithFormat:@"%.2f",_model.price.floatValue / 100.0];
    self.oriPriceLabel.text = [NSString stringWithFormat:@"%.2f",_model.priceOri.floatValue / 100.0];
    self.rmbLabel.textColor = [MIUtility colorWithHex:0x333333];
    self.rmb.textColor = [MIUtility colorWithHex:0x999999];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [MIUtility colorWithHex:0x999999];
    CGSize size = [self.oriPriceLabel.text sizeWithFont:self.oriPriceLabel.font];
    line.bounds = CGRectMake(0, 0, size.width, 1);
    line.centerY = self.oriPriceLabel.centerY;
    line.left = self.oriPriceLabel.left;
    [self addSubview:line];
    
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970] + [MIConfig globalConfig].timeOffset;
    if (now < _model.startTime.doubleValue) {
        self.purchaseView.layer.borderColor = [MIUtility colorWithHex:0x8dbb1a].CGColor;
        self.customersLabel.text = @"即将开抢";
        self.selloutImage.hidden = YES;
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:_model.startTime.integerValue];
        self.goBuyLabel.text = [NSString stringWithFormat:@"%@点开抢",[date stringForhh]];
        self.goBuyLabel.backgroundColor = [MIUtility colorWithHex:0x8dbb1a];
    }
    else if (now > _model.endTime.integerValue){
        NSString *clickColumn;
        float clicksVolumn = _model.clicks.floatValue + _model.volumn.floatValue;
        if (clicksVolumn >= 10000.0) {
            clickColumn = [[NSString alloc] initWithFormat:@"%.1f万人已抢", clicksVolumn / 10000.0];
        } else {
            clickColumn = [[NSString alloc] initWithFormat:@"%.f人已抢", clicksVolumn];
        }

        self.customersLabel.text = clickColumn;
        self.selloutImage.hidden = YES;
        self.goBuyLabel.text = @"已结束";
        self.purchaseView.layer.borderColor = [MIUtility colorWithHex:0xbebebe].CGColor;
        self.goBuyLabel.backgroundColor = [MIUtility colorWithHex:0xbebebe];
    }
    else{
        NSString *clickColumn;
        float clicksVolumn = _model.clicks.floatValue + _model.volumn.floatValue;
        if (clicksVolumn >= 10000.0) {
            clickColumn = [[NSString alloc] initWithFormat:@"%.1f万人已抢", clicksVolumn / 10000.0];
        } else {
            clickColumn = [[NSString alloc] initWithFormat:@"%.f人已抢", clicksVolumn];
        }

        self.customersLabel.text = clickColumn;
        if (_model.status.integerValue != 1) {
            self.goBuyLabel.text = @"抢光了";
            self.selloutImage.hidden = NO;
            self.purchaseView.layer.borderColor = [MIUtility colorWithHex:0xbebebe].CGColor;
            self.goBuyLabel.backgroundColor = [MIUtility colorWithHex:0xbebebe];
        }else{
            self.goBuyLabel.text = @"立即抢";
            self.selloutImage.hidden = YES;
            self.purchaseView.layer.borderColor = [MIUtility colorWithHex:0xff8c24].CGColor;
            self.goBuyLabel.backgroundColor = [MIUtility colorWithHex:0xff8c24];
        }
    }
    [self layoutIfNeeded];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
