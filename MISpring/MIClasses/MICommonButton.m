//
//  MICommonButton.m
//  MISpring
//
//  Created by Yujian Xu on 13-3-27.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MICommonButton.h"

@implementation MICommonButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame: frame];
    if (self) {
        UIImage *buttonImage = [[UIImage imageNamed:@"orangeButton.png"]
                                resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
        UIImage *buttonImageHighlight = [[UIImage imageNamed:@"orangeButtonHighlight.png"]
                                         resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
        UIImage *buttonImageDisabled = [[UIImage imageNamed:@"greyButton.png"]
                                         resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
        
        
        [self setBackgroundImage:buttonImage forState:UIControlStateNormal];
        [self setBackgroundImage:buttonImageHighlight forState: UIControlStateHighlighted];
        [self setBackgroundImage:buttonImageHighlight forState: UIControlStateSelected];        
        
        [self setBackgroundImage:buttonImageDisabled forState:UIControlStateDisabled];
        
        [self setTitleColor: [UIColor lightGrayColor] forState: UIControlStateDisabled];
        [self setTitleShadowColor: [UIColor whiteColor] forState: UIControlStateDisabled];
        
        [self setTitleShadowColor: [UIColor colorWithWhite:0.3 alpha:0.3] forState: UIControlStateNormal];
        self.titleLabel.shadowOffset = CGSizeMake(-0.6, -0.6);
        
    }
    return self;
}

- (void) turnBlue
{
    UIImage *buttonImage = [[UIImage imageNamed:@"blueButton.png"]
                            resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    UIImage *buttonImageHighlight = [[UIImage imageNamed:@"blueButtonHighlight.png"]
                                     resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    
    
    [self setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [self setBackgroundImage:buttonImageHighlight forState:UIControlStateHighlighted];
    [self setBackgroundImage:buttonImageHighlight forState: UIControlStateSelected];
}

- (void) turnGreen
{
    UIImage *buttonImage = [[UIImage imageNamed:@"greenButton.png"]
                            resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    UIImage *buttonImageHighlight = [[UIImage imageNamed:@"greenButtonHighlight.png"]
                                     resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    
    
    [self setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [self setBackgroundImage:buttonImageHighlight forState:UIControlStateHighlighted];
    [self setBackgroundImage:buttonImageHighlight forState: UIControlStateSelected]; 
}

- (void) turnRed
{
    UIImage *buttonImage = [[UIImage imageNamed:@"redButton.png"]
                            resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    UIImage *buttonImageHighlight = [[UIImage imageNamed:@"redButtonHighlight.png"]
                                     resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    
    
    [self setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [self setBackgroundImage:buttonImageHighlight forState:UIControlStateHighlighted];
    [self setBackgroundImage:buttonImageHighlight forState: UIControlStateSelected]; 
}

- (void ) turnOrange
{
    UIImage *buttonImage = [[UIImage imageNamed:@"orangeButton.png"]
                            resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    UIImage *buttonImageHighlight = [[UIImage imageNamed:@"orangeButtonHighlight.png"]
                                     resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    
    
    [self setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [self setBackgroundImage:buttonImageHighlight forState:UIControlStateHighlighted];
    [self setBackgroundImage:buttonImageHighlight forState: UIControlStateSelected];
}

- (void) turnWhite
{
    UIImage *buttonImage = [[UIImage imageNamed:@"whiteButton.png"]
                            resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    UIImage *buttonImageHighlight = [[UIImage imageNamed:@"whiteButtonHighlight.png"]
                                     resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    
    
    [self setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [self setBackgroundImage:buttonImageHighlight forState:UIControlStateHighlighted];
    [self setBackgroundImage:buttonImageHighlight forState: UIControlStateSelected]; 
}
- (void) turnGrey
{
    UIImage *buttonImage = [[UIImage imageNamed:@"greyButton.png"]
                            resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    UIImage *buttonImageHighlight = [[UIImage imageNamed:@"greyButtonHighlight.png"]
                                     resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    
    
    [self setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [self setBackgroundImage:buttonImageHighlight forState:UIControlStateHighlighted];
    [self setBackgroundImage:buttonImageHighlight forState: UIControlStateSelected];
    
    [self setTitleColor: [UIColor grayColor] forState: UIControlStateNormal];
    [self setTitleShadowColor: [UIColor lightGrayColor] forState: UIControlStateDisabled];
    
    [self setTitleShadowColor: [UIColor whiteColor] forState: UIControlStateNormal];
    self.titleLabel.shadowOffset = CGSizeMake(-0.6, -0.6);
}
- (void) turnBlack
{
    UIImage *buttonImage = [[UIImage imageNamed:@"blackButton.png"]
                            resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    UIImage *buttonImageHighlight = [[UIImage imageNamed:@"blackButtonHighlight.png"]
                                     resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    
    
    [self setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [self setBackgroundImage:buttonImageHighlight forState:UIControlStateHighlighted];
    [self setBackgroundImage:buttonImageHighlight forState: UIControlStateSelected]; 
}
- (void) turnTan
{
    UIImage *buttonImage = [[UIImage imageNamed:@"tanButton.png"]
                            resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    UIImage *buttonImageHighlight = [[UIImage imageNamed:@"tanButtonHighlight.png"]
                                     resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    
    
    [self setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [self setBackgroundImage:buttonImageHighlight forState:UIControlStateHighlighted];
    [self setBackgroundImage:buttonImageHighlight forState: UIControlStateSelected]; 
}

@end
