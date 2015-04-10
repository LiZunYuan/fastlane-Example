//
//  MIYoupinHeaderView.m
//  MISpring
//
//  Created by husor on 15-3-26.
//  Copyright (c) 2015年 Husor Inc. All rights reserved.
//

#import "MIYoupinHeaderView.h"

@implementation MIYoupinHeaderView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.viewWidth, 360)];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.clipsToBounds = YES;
        _bgView.layer.cornerRadius = 3;
        [self addSubview:_bgView];
        
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(8, 8, self.viewWidth - 16, self.viewWidth - 16)];
        _imageView.backgroundColor = [UIColor clearColor];
        [_bgView addSubview:_imageView];
        
        _priceBgImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg_tag_price"]];
        _priceBgImg.bounds = CGRectMake(0, 0, 76, 76);
        _priceBgImg.right = _imageView.viewWidth - 8;
        _priceBgImg.bottom = _imageView.viewHeight - 8;
        [_imageView addSubview:_priceBgImg];
        
        _fengqiangLabel = [[UILabel alloc]init];
        _fengqiangLabel.backgroundColor = [UIColor clearColor];
        _fengqiangLabel.frame = CGRectMake(8, 20, 60, 18);
        _fengqiangLabel.text = @"疯抢价";
        _fengqiangLabel.textAlignment = NSTextAlignmentCenter;
        _fengqiangLabel.font = [UIFont systemFontOfSize:15];
        _fengqiangLabel.textColor = [MIUtility colorWithHex:0xffffff];
        [_priceBgImg addSubview:_fengqiangLabel];
        
        _priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, _fengqiangLabel.bottom + 3, 60, 15)];
        _priceLabel.backgroundColor = [UIColor clearColor];
        _priceLabel.textAlignment = NSTextAlignmentCenter;
        _priceLabel.font = [UIFont boldSystemFontOfSize:12];
        _priceLabel.textColor = [MIUtility colorWithHex:0xffffff];
        [_priceBgImg addSubview:_priceLabel];        
        
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, _imageView.bottom + 12, _bgView.viewWidth - 24, 36)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.numberOfLines  = 2;
        _titleLabel.textColor = [MIUtility colorWithHex:0x333333];
        [_bgView addSubview:_titleLabel];
        
        _subTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, _titleLabel.bottom + 12, _titleLabel.viewWidth, 30)];
        _subTitleLabel.backgroundColor = [UIColor clearColor];
        _subTitleLabel.font = [UIFont systemFontOfSize:11];
        _subTitleLabel.textColor = [MIUtility colorWithHex:0x666666];
        _subTitleLabel.numberOfLines = 2;
        [_bgView addSubview:_subTitleLabel];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize titleSize = [_titleLabel.text sizeWithFont:_titleLabel.font constrainedToSize:CGSizeMake(_titleLabel.viewWidth, 200)];
    CGSize subTitleSize = [_subTitleLabel.text sizeWithFont:_subTitleLabel.font constrainedToSize:CGSizeMake(_subTitleLabel.viewWidth, 200)];
    CGFloat titleLabelHeight = titleSize.height > 36 ? 36 : ceilf(titleSize.height);
    CGFloat subTitleLabelHeight = subTitleSize.height > 30 ? 30 : ceilf(subTitleSize.height);
    
    _titleLabel.viewHeight = titleLabelHeight;
    _subTitleLabel.top = _titleLabel.bottom + 12;
    _subTitleLabel.viewHeight = subTitleLabelHeight;
    _bgView.viewHeight = _subTitleLabel.bottom + 16;
}

- (CGFloat)getViewHeight {
    CGSize titleSize = [_titleLabel.text sizeWithFont:_titleLabel.font constrainedToSize:CGSizeMake(_titleLabel.viewWidth, 200)];
    CGSize subTitleSize = [_subTitleLabel.text sizeWithFont:_subTitleLabel.font constrainedToSize:CGSizeMake(_subTitleLabel.viewWidth, 200)];
    CGFloat titleLabelHeight = titleSize.height > 36 ? 36 : ceilf(titleSize.height);
    CGFloat subTitleLabelHeight = subTitleSize.height > 30 ? 30 : ceilf(subTitleSize.height);
    _titleLabel.viewHeight = titleLabelHeight;
    _subTitleLabel.top = _titleLabel.bottom + 12;
    _subTitleLabel.viewHeight = subTitleLabelHeight;
    _bgView.viewHeight = _subTitleLabel.bottom + 16;
    
    return _bgView.bottom;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
