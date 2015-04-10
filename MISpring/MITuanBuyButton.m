//
//  MITuanBuyButton.m
//  MISpring
//
//  Created by 曲俊囡 on 15/3/27.
//  Copyright (c) 2015年 Husor Inc. All rights reserved.
//

#import "MITuanBuyButton.h"

#define MIColorGray [MIUtility colorWithHex:0xbebebe]
#define MIColorBuyButtonGreen [MIUtility colorWithHex:0x8dbb1a]

#define TopHeightPer    (7.0/(7.0 + 10.0))


@implementation MITuanBuyButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        self.layer.cornerRadius = 4;
        self.layer.borderWidth = 1;
        self.layer.borderColor = MIColorNavigationBarBackground.CGColor;
        
        self.topLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.viewWidth, self.viewHeight * TopHeightPer)];
        self.topLabel.textColor = MIColor666666;
        self.topLabel.backgroundColor = [UIColor clearColor];
        self.topLabel.font = [UIFont systemFontOfSize:9];
        self.topLabel.text = @"135人已抢";
        self.topLabel.textAlignment = UITextAlignmentCenter;
        [self addSubview:_topLabel];
        
        
        self.buttonLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.topLabel.bottom, self.viewWidth, self.viewHeight * (1 - TopHeightPer))];
        self.buttonLabel.textColor = [UIColor whiteColor];
        self.buttonLabel.font = [UIFont boldSystemFontOfSize:14];
        self.buttonLabel.textAlignment = UITextAlignmentCenter;
        self.buttonLabel.text = @"立即抢";
        self.buttonLabel.backgroundColor = MIColorNavigationBarBackground;
        [self addSubview:_buttonLabel];
        
        self.type = TuanBuyButtonNormalType;
        
        [self bringSubviewToFront:self.topLabel];
    }
    return self;
}

- (void)setType:(TuanBuyButtonType)type
{
    _type = type;
    if (_type == TuanBuyButtonNormalType)
    {
        self.layer.borderColor = MIColorNavigationBarBackground.CGColor;
        self.buttonLabel.backgroundColor = MIColorNavigationBarBackground;
        self.topLabel.textColor = MIColor666666;
    }
    else if (_type == TuanBuyButtonSelloutType)
    {
        self.layer.borderColor = MIColorGray.CGColor;
        self.buttonLabel.backgroundColor = MIColorGray;
        self.topLabel.textColor = MIColor666666;
    }
    else
    {
        self.layer.borderColor = MIColorGreen.CGColor;
        self.buttonLabel.backgroundColor = MIColorGreen;
        self.topLabel.textColor = MIColor666666;
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
