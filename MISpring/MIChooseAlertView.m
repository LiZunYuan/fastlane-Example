//
//  BBShippingAlertView.m
//  BeiBeiAPP
//
//  Created by 曲俊囡 on 14-8-16.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MIChooseAlertView.h"

@implementation MIChooseAlertView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (void)awakeFromNib
{
    self.bgView.layer.cornerRadius = 5;
    [self.goAheadButton grayBackgroudRedTexButton];
    [self.goBackToCartButton grayBackgroudRedTexButton];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(popViewAction:)];
    [self.alphaView addGestureRecognizer:tap];
    
    self.messageLabel.textAlignment = UITextAlignmentCenter;
}

- (IBAction)popViewAction:(id)sender {
    if ([_delegate respondsToSelector:@selector(closeShippingAlertView)])
    {
        [_delegate closeShippingAlertView];
    }
}
- (IBAction)goOnAction:(id)sender {
    if ([_delegate respondsToSelector:@selector(goAhead)])
    {
        [_delegate goAhead];
    }
}
- (IBAction)goBackToCartViewAction:(id)sender {
    if ([_delegate respondsToSelector:@selector(goBackToCart)])
    {
        [_delegate goBackToCart];
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
