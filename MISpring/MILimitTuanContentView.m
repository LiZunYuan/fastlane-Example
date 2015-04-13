//
//  MILimitTuanContentView.m
//  MISpring
//
//  Created by husor on 15-3-30.
//  Copyright (c) 2015年 Husor Inc. All rights reserved.
//

#import "MILimitTuanContentView.h"

@implementation MILimitTuanContentView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.viewWidth, self.viewWidth)];
        _imageView.backgroundColor = [UIColor clearColor];
        [self addSubview:_imageView];

        UIView *titleBg = [[UIView alloc] initWithFrame:CGRectMake(0, _imageView.bottom - 24, self.viewWidth, 24)];
        titleBg.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
        [self addSubview:titleBg];
        
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, _imageView.bottom - 24, self.viewWidth - 16, 24)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont systemFontOfSize:12];
        _titleLabel.textColor = [MIUtility colorWithHex:0xffffff];
        [self addSubview:_titleLabel];
        
        _tuanView = [[[NSBundle mainBundle] loadNibNamed:@"MILimitTuanView" owner:self options:nil] objectAtIndex:0];
        _tuanView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_tuanView];
        [_tuanView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.top.equalTo(_titleLabel.mas_bottom);
            make.width.equalTo(self.mas_width);
            make.height.equalTo(@100);
        }];
    }
    return self;
}

-(void)layoutSubviews
{
    if (self.model) {
        [_imageView sd_setImageWithURL:[NSURL URLWithString:_model.img] placeholderImage:[UIImage imageNamed:@"img_loading_daily1"]];
        _titleLabel.text = _model.title;
        _tuanView.priceLabel.text = [NSString stringWithFormat:@"%.2f", _model.price.floatValue / 100.0];
        _tuanView.priceOriLabel.text =  [NSString stringWithFormat:@"%.2f", _model.priceOri.floatValue / 100.0];
        CGSize size = [_tuanView.priceOriLabel.text sizeWithFont:_tuanView.priceOriLabel.font];
        UIView *line = [[UIView alloc]init];
        line.bounds = CGRectMake(0, 0,  size.width, 1);
        line.centerY = _tuanView.priceOriLabel.centerY;
        line.left = _tuanView.priceOriLabel.left;
        line.backgroundColor = [MIUtility colorWithHex:0x999999];
        [_tuanView addSubview:line];

        NSTimeInterval now = [[NSDate date] timeIntervalSince1970] + [MIConfig globalConfig].timeOffset;
        if (now < _model.startTime.doubleValue) {
            _tuanView.purchaseBgView.layer.borderColor = [MIUtility colorWithHex:0x8dbb1a].CGColor;
            _tuanView.customerLabel.text = @"即将开抢";
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:_model.startTime.integerValue];
            _tuanView.goBuyLabel.text = [NSString stringWithFormat:@"%@点开抢",[date stringForhh]];
            _tuanView.goBuyLabel.backgroundColor = [MIUtility colorWithHex:0x8dbb1a];
        }
        else if (now > _model.endTime.integerValue){
            NSString *clickColumn;
            float clicksVolumn = _model.clicks.floatValue + _model.volumn.floatValue;
            if (clicksVolumn >= 10000.0) {
                clickColumn = [[NSString alloc] initWithFormat:@"%.1f万人已抢", clicksVolumn / 10000.0];
            } else {
                clickColumn = [[NSString alloc] initWithFormat:@"%.f人已抢", clicksVolumn];
            }
            _tuanView.customerLabel.text = clickColumn;
            _tuanView.goBuyLabel.text = @"已结束";
            _tuanView.purchaseBgView.layer.borderColor = [MIUtility colorWithHex:0xbebebe].CGColor;
            _tuanView.goBuyLabel.backgroundColor = [MIUtility colorWithHex:0xbebebe];
        }
        else{
            NSString *clickColumn;
            float clicksVolumn = _model.clicks.floatValue + _model.volumn.floatValue;
            if (clicksVolumn >= 10000.0) {
                clickColumn = [[NSString alloc] initWithFormat:@"%.1f万人已抢", clicksVolumn / 10000.0];
            } else {
                clickColumn = [[NSString alloc] initWithFormat:@"%.f人已抢", clicksVolumn];
            }
            _tuanView.customerLabel.text = clickColumn;
            if (_model.status.integerValue != 1) {
                _tuanView.goBuyLabel.text = @"抢光了";
                _tuanView.purchaseBgView.layer.borderColor = [MIUtility colorWithHex:0xbebebe].CGColor;
                _tuanView.goBuyLabel.backgroundColor = [MIUtility colorWithHex:0xbebebe];
            }else{
                _tuanView.goBuyLabel.text = @"立即抢";
                _tuanView.purchaseBgView.layer.borderColor = [MIUtility colorWithHex:0xff8c24].CGColor;
                _tuanView.goBuyLabel.backgroundColor = [MIUtility colorWithHex:0xff8c24];
            }
        }
    }    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
