//
//  BBFindBackView.m
//  BeiBeiAPP
//
//  Created by yujian on 14-10-22.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MIFindBackView.h"

@implementation MIFindBackView

- (void)awakeFromNib
{
    self.getCodeBtn.clipsToBounds = YES;
    self.getCodeBtn.layer.cornerRadius = 2;
    self.getCodeBtn.layer.borderWidth = 1.0;
    [self.getCodeBtn.layer setBorderColor:MICodeButtonBackground.CGColor];
    [self.getCodeBtn setTitleColor:MICodeButtonBackground forState:UIControlStateNormal];
    [self.getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    
    self.bNewPasswordTextField.secureTextEntry = YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.codeTextField) {
        [self.bNewPasswordTextField becomeFirstResponder];
    } else if (textField == self.bNewPasswordTextField) {
        [self.bNewPasswordTextField resignFirstResponder];
        MI_CALL_DELEGATE_WITH_ARG(_delegate, @selector(confirmFindPassword:), textField);
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
