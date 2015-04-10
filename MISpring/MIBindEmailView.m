//
//  BBBindEmailView.m
//  BeiBeiAPP
//
//  Created by yujian on 14-10-22.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MIBindEmailView.h"

@implementation MIBindEmailView


- (void)awakeFromNib
{
    self.passwordTextField.secureTextEntry = YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.emailTextField) {
        [self.passwordTextField becomeFirstResponder];
    } else {
        [self.passwordTextField resignFirstResponder];
        MI_CALL_DELEGATE_WITH_ARG(_delegate, @selector(confirmBindEmail:), textField);
    }
    return YES;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
