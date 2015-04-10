//
//  MIScreenbutton.m
//  MISpring
//
//  Created by 曲俊囡 on 14-5-16.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MIScreenbutton.h"

@implementation MIScreenbutton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _isSelected = NO;
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        self.titleLabel.textColor = [MIUtility colorWithHex:0x666666];
        [self setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _line = [[UIView alloc] initWithFrame:CGRectMake(0, self.viewHeight - 2, self.viewWidth, 2)];
        _line.hidden = YES;
        _line.backgroundColor = [MIUtility colorWithHex:0xff5500];
        [self addSubview: _line];
        [self reLoadButton];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)reLoadButton
{
    if (_isSelected)
    {
        [self setTitleColor:[MIUtility colorWithHex:0xff5500] forState:UIControlStateNormal];
        _line.hidden = NO;
        CGSize size = [self.titleLabel.text sizeWithFont:self.titleLabel.font];
        _line.viewWidth = size.width + 10;
        _line.centerX = self.viewWidth / 2;
    }
    else
    {
        [self setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _line.hidden = YES;
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
