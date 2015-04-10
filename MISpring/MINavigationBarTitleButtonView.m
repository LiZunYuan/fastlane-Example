//
//  MINavigationBarTitleButtonView.m
//  MISpring
//
//  Created by 曲俊囡 on 15/3/30.
//  Copyright (c) 2015年 Husor Inc. All rights reserved.
//

#import "MINavigationBarTitleButtonView.h"

@implementation MINavigationBarTitleButtonView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [super initWithFrame:frame];
        
        
        _titleLabel = [[UILabel alloc] init];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.textColor = [MIUtility colorWithHex:0x333333];
        self.titleLabel.frame = CGRectMake(0, 0, 160, PHONE_NAVIGATION_BAR_ITEM_HEIGHT);
        self.titleLabel.textAlignment = UITextAlignmentCenter;
        self.titleLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:_titleLabel];
        
        _screenImageView = [[UIImageView alloc] init];
        [self.screenImageView setImage:[UIImage imageNamed:@"the_drop_down"]];
        self.screenImageView.frame = CGRectMake(0, 0, 16, 16);
        self.screenImageView.contentMode = UIViewContentModeCenter;
        self.screenImageView.centerY = self.titleLabel.centerY;
        [self addSubview:self.screenImageView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showScreenView)];
        [self addGestureRecognizer:tap];
        
    }
    return self;
}
// 设置导航条标题
- (void)setBarTitle: (NSString *) title textSize:(CGFloat) size
{
    self.titleLabel.text = title;
    self.titleLabel.font = [UIFont systemFontOfSize:size];
    self.titleLabel.minimumFontSize = (size - 2);
    CGFloat width = [title sizeWithFont:[UIFont systemFontOfSize:size]].width;
    self.titleLabel.viewWidth = width;
    self.titleLabel.centerX = self.viewWidth / 2;
    self.screenImageView.left = self.titleLabel.right + 4;
}

- (void)showScreenView
{
    if (!_hasShowScreenView)
    {
        self.screenImageView.image = [UIImage imageNamed:@"Up_arrow"];
        _hasShowScreenView = YES;
    }
    else
    {
        self.screenImageView.image = [UIImage imageNamed:@"the_drop_down"];
        _hasShowScreenView = NO;
    }
    if (_showScreenViewBlock){
        _showScreenViewBlock(_hasShowScreenView);
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
