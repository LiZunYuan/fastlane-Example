//
//  BBTextButton.m
//  BeiBeiAPP
//
//  Created by 曲俊囡 on 14-4-3.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MITextButton.h"

@implementation MITextButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void)awakeFromNib
{
    self.layer.cornerRadius = 4;
}
//- (void)redBackgroundWhiteTextButton
//{
//    UIImage *barButton = [[UIImage imageNamed:@"button_red"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
//    UIImage *barButtonPressed = [[UIImage imageNamed:@"button_red_selected"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
//    [self setBackgroundImage:barButton forState:UIControlStateNormal];
//    [self setBackgroundImage:barButtonPressed forState:UIControlStateHighlighted];
//    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//}
//- (void)whiteBackgroundRedTextButton
//{
//    UIImage *barButton = [[UIImage imageNamed:@"button_redline"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
//    UIImage *barButtonPressed = [[UIImage imageNamed:@"button_redline_selected"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
//    [self setBackgroundImage:barButton forState:UIControlStateNormal];
//    [self setBackgroundImage:barButtonPressed forState:UIControlStateHighlighted];
//    [self setTitleColor:[MIUtility colorWithHex:0xff4965] forState:UIControlStateNormal];
//}
- (void)grayBackgroudRedTexButton
{
    UIImage *barButton = [[UIImage imageNamed:@"button_tips_normal"] resizableImageWithCapInsets:UIEdgeInsetsMake(1, 1, 1, 1)];
    UIImage *barButtonPressed = [[UIImage imageNamed:@"button_tips_highlighted"] resizableImageWithCapInsets:UIEdgeInsetsMake(1, 1, 1, 1)];
    [self setBackgroundImage:barButton forState:UIControlStateNormal];
    [self setBackgroundImage:barButtonPressed forState:UIControlStateHighlighted];
    [self setTitleColor:[MIUtility colorWithHex:0xff4965] forState:UIControlStateNormal];
}

- (void)whiteBackgroundOriageTexAndBorder
{
    self.clipsToBounds = YES;
    self.layer.cornerRadius = 2;
    self.layer.borderWidth = 1;
    self.layer.borderColor = [MIUtility colorWithHex:0xfea555].CGColor;
    [self setTitleColor:[MIUtility colorWithHex:0xff8c24] forState:UIControlStateNormal];
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
