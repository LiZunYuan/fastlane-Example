//
//  MITomorrowHeaderView.m
//  MISpring
//
//  Created by husor on 15-1-23.
//  Copyright (c) 2015年 Husor Inc. All rights reserved.
//

#import "MITomorrowHeaderView.h"

@implementation MITomorrowHeaderView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _tomorrowGirl = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"img_yugao_girl"]];
        _tomorrowGirl.backgroundColor = [UIColor clearColor];
        _tomorrowGirl.contentMode = UIViewContentModeScaleAspectFit;
        _tomorrowGirl.frame = CGRectMake(12, 32, 68, 76);
        [self addSubview:_tomorrowGirl];
        
        _emptyLabelBox = [[UIImageView alloc]initWithFrame:CGRectMake(_tomorrowGirl.right , _tomorrowGirl.top, self.viewWidth - _tomorrowGirl.right - 20 ,_tomorrowGirl.viewHeight)];
        _emptyLabelBox.image = [[UIImage imageNamed:@"bg_dialog_box"] resizableImageWithCapInsets:UIEdgeInsetsMake(30, 30, 10, 30) ];
        _emptyLabelBox.backgroundColor = [UIColor clearColor];
        [self addSubview:_emptyLabelBox];
        
        _emptyLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 2, _emptyLabelBox.viewWidth - 24, _emptyLabelBox.viewHeight - 4)];
        _emptyLabel.backgroundColor = [UIColor clearColor];
        _emptyLabel.numberOfLines = 0;
        _emptyLabel.font = [UIFont systemFontOfSize:13];
        _emptyLabel.textAlignment = NSTextAlignmentLeft;
        [_emptyLabelBox addSubview:_emptyLabel];
        
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, _tomorrowGirl.bottom + 32, self.viewWidth, 30)];
        _bgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_bgView];
        
        UIView *redLine = [[UIView alloc]initWithFrame:CGRectMake(12, 7, 2, 16)];
        redLine.backgroundColor = [MIUtility colorWithHex:0xff3d00];
        [_bgView addSubview:redLine];
        
        _sellingRecommend = [[UILabel alloc]initWithFrame:CGRectMake(redLine.right + 4, 0, self.viewWidth - redLine.right - 4, 30)];
        _sellingRecommend.backgroundColor = [UIColor whiteColor];
        _sellingRecommend.text = @"热卖好货抢先逛";
        _sellingRecommend.font = [UIFont systemFontOfSize:14];
        [_bgView addSubview:_sellingRecommend];
        
        _getMoreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _getMoreBtn.frame = CGRectMake(self.viewWidth - 80, 0, 80, 30);
        [_getMoreBtn setTitle:@"更多" forState:UIControlStateNormal];
        [_getMoreBtn setTitleColor:[MIUtility colorWithHex:0x999999] forState:UIControlStateNormal];
        _getMoreBtn.backgroundColor = [UIColor clearColor];
        _getMoreBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _getMoreBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        _getMoreBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 60, 0, 0);
        _getMoreBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        [_getMoreBtn setImage:[UIImage imageNamed:@"icon_yugao_more"] forState:UIControlStateNormal];
        _getMoreBtn.enabled = NO;
        [_bgView addSubview:_getMoreBtn];
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
