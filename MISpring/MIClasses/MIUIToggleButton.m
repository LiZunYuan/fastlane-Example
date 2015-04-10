//
//  MIUIToggleButton.m
//  MISpring
//
//  Created by lsave on 13-3-22.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIUIToggleButton.h"

@implementation MIUIToggleButton

@synthesize group = _group;
@synthesize value = _value;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIImage *buttonImage = [[UIImage imageNamed:@"greyButton.png"]
                                resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
        UIImage *buttonImageHighlight = [[UIImage imageNamed:@"blueButtonToggled.png"]
                                         resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];

        
        [self setBackgroundImage:buttonImage forState:UIControlStateNormal];
        [self setBackgroundImage:buttonImageHighlight forState:UIControlStateHighlighted];
        [self setBackgroundImage:buttonImageHighlight forState:UIControlStateSelected];
        [self setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [self setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setTitleShadowColor:[UIColor colorWithRed:0.13 green:0.32 blue:0.54 alpha:1] forState:UIControlStateSelected];
        
        [self.titleLabel setShadowOffset:CGSizeMake(0, -0.5)];
        self.titleLabel.font = [UIFont systemFontOfSize: 13];
        [self setShowsTouchWhenHighlighted:YES];
        
        [self addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)buttonClicked:(UIButton *)btn
{
    for (__weak id subView in [[self superview] subviews]) {
        if ([subView isKindOfClass: [MIUIToggleButton class]]) {
            subView = (MIUIToggleButton *) subView;
            [subView setSelected:NO];
        }
    }
    [btn setSelected: ![btn isSelected]];
}

-(void) setGroup:(NSString *)group andValue: (NSString *) value
{
    _group = group;
    _value = value;
}

@end
