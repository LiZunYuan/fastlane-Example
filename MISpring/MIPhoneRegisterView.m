//
//  BBPhoneRegisterView.m
//  BeiBeiAPP
//
//  Created by yujian on 14-10-20.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MIPhoneRegisterView.h"

@implementation MIPhoneRegisterView


- (void)awakeFromNib
{
    self.getCodeBtn.clipsToBounds = YES;
    self.getCodeBtn.layer.cornerRadius = 14;
    self.getCodeBtn.layer.borderWidth = 1.0;
    [self.getCodeBtn.layer setBorderColor:MICodeButtonBackground.CGColor];
    [self.getCodeBtn setTitleColor:MICodeButtonBackground forState:UIControlStateNormal];
    [self.getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    
    self.passwordTextField.secureTextEntry = YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _currentTextField = textField;
    if (_delegate && [_delegate respondsToSelector:@selector(textFieldBeginEditing:)]) {
        [_delegate textFieldBeginEditing:textField];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.phoneRegisterTextField) {
        [self.codeTextField becomeFirstResponder];
    } else if (textField == self.codeTextField) {
        [self.passwordTextField becomeFirstResponder];
    } else{
        [self.passwordTextField resignFirstResponder];
        MI_CALL_DELEGATE_WITH_ARG(_delegate, @selector(confirmRegister:), textField);
    }
    return YES;
}

//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
//{
//    if (textField == self.phoneRegisterTextField) {
//        [self returnCodeButton];
//    }
//    return YES;
//}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.phoneRegisterTextField) {
        [self returnCodeButton];
    }
    
    return YES;
}
- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    if (textField == self.phoneRegisterTextField) {
        [self returnCodeButton];
    }
    
    return YES;
}

// 还原 获取验证码 按钮
-(void)returnCodeButton
{
    if (_delegate || [_delegate respondsToSelector:@selector(stopHandleTimer)]) {
        [_delegate stopHandleTimer];
    }
    [self.getCodeBtn.layer setBorderColor:MICodeButtonBackground.CGColor];
    [self.getCodeBtn setTitleColor:MICodeButtonBackground forState:UIControlStateNormal];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
