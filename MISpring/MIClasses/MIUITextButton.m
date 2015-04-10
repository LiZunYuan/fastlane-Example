//
//  MIUITextButton.m
//  MISpring
//
//  Created by lsave on 13-3-26.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIUITextButton.h"

@implementation MIUITextButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIImage *barButton = [[UIImage imageNamed:@"barButtonLight.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
        UIImage *barButtonPressed = [[UIImage imageNamed:@"barButton.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
        [self setBackgroundImage:barButton forState:UIControlStateNormal];
        [self setBackgroundImage:barButtonPressed forState:UIControlStateHighlighted];
        
        [self setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setTitleShadowColor:[UIColor colorWithRed:0.71 green:0.33 blue:0 alpha:1] forState:UIControlStateNormal];
        
        [self.titleLabel setShadowOffset:CGSizeMake(0, -1)];
        self.titleLabel.font = [UIFont systemFontOfSize: 16];
        
    }
    return self;
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
