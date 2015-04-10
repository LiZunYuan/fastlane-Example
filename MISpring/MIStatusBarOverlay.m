//
//  MIStatusBarOverlay.m
//  MISpring
//
//  Created by husor on 14-10-29.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MIStatusBarOverlay.h"

@implementation MIStatusBarOverlay

-(id)init
{
    self = [super init];
    if (self) {
        self.frame = [UIApplication sharedApplication].statusBarFrame ;
        self.backgroundColor = [UIColor blackColor];
        self.windowLevel = UIWindowLevelStatusBar + 1.0f;
        self.alpha = 0.0f;
        self.hidden = YES;
        
        _messageLabel = [[UILabel alloc]initWithFrame:self.bounds];
        _messageLabel.backgroundColor = [UIColor blackColor];
        _messageLabel.textColor = [UIColor whiteColor];
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:_messageLabel];
    }
    return self;
}

-(void)showMessage:(NSString *)message
{
    self.hidden = NO;
    _messageLabel.text = message;
    [UIView animateWithDuration:.3 animations:^{
        self.alpha = 1.0f;
    } completion:^(BOOL finished){
        [self hide];
    }];
}

-(void)hide
{
    [UIView animateWithDuration:0 delay:3.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.alpha = 0.0f;
    } completion:^(BOOL finished) {
        _messageLabel.text = @"";
        self.hidden = YES;
    }];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
