//
//  MITomorrowFooterView.m
//  MISpring
//
//  Created by husor on 15-1-27.
//  Copyright (c) 2015年 Husor Inc. All rights reserved.
//

#import "MITomorrowFooterView.h"

@implementation MITomorrowFooterView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.text = @"千万女性专属特卖会";
        titleLabel.font = [UIFont systemFontOfSize:12];
        titleLabel.textColor = [MIUtility colorWithHex:0x999999];
        CGSize size = [titleLabel.text sizeWithFont:titleLabel.font constrainedToSize:CGSizeMake(300, 20)];
        titleLabel.bounds = CGRectMake(0, 0, size.width + 8, 15);
        titleLabel.top = 12;
        titleLabel.centerX = self.centerX;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:titleLabel];
        
        UIView *leftLine = [[UIView alloc]initWithFrame:CGRectMake(24, self.centerY - 1, titleLabel.left - 24  - 8,1)];
        leftLine.backgroundColor = [MIUtility colorWithHex:0xcecece];
        [self addSubview:leftLine];
        
        UIView *rightLine = [[UIView alloc]initWithFrame:CGRectMake(titleLabel.right + 8, leftLine.top, leftLine.viewWidth, 1)];
        rightLine.backgroundColor = [MIUtility colorWithHex:0xcecece];
        [self addSubview:rightLine];
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
