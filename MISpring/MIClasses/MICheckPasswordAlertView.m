//
//  MICheckPasswordAlertView.m
//
//  Created by Luke on 21/09/2012.
//  Modified By YUJIAN XU 26/03/2013
//  Copyright (c) 2012 Luke Stringer. All rights reserved.
//
//  https://github.com/stringer630/ShakingAlertView
//

//  This code is distributed under the terms and conditions of the MIT license.
//
//  Copyright (c) 2012 Luke Stringer
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "MICheckPasswordAlertView.h"


@interface MICheckPasswordAlertView ()
// Private property as other instances shouldn't interact with this directly
@property (nonatomic, strong) UITextField *passwordField;
@end

// Enum for alert view button index
typedef enum {
    ShakingAlertViewButtonIndexDismiss = 0,
    ShakingAlertViewButtonIndexSuccess = 10
} ShakingAlertViewButtonIndex;

@implementation MICheckPasswordAlertView

#pragma mark - Constructors

- (id)initWithAlert{
    
    self = [super initWithTitle:@"米折网密码（安全验证）"     
                        message:nil // password field will go here
                       delegate:self 
              cancelButtonTitle:@"取消" 
              otherButtonTitles:@"好", nil];
    if (self) {
        self.alertViewStyle = UIAlertViewStyleSecureTextInput;
    }
    return self;
}

// Override show method to add the password field
- (void)show {
    
    // Textfield for the password
    UITextField *passwordField = [self textFieldAtIndex:0];
    passwordField.secureTextEntry = YES;
    passwordField.enablesReturnKeyAutomatically = YES;
    passwordField.placeholder = @"请输入密码，以确保安全";    
    passwordField.returnKeyType = UIReturnKeyDone;
    passwordField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    // Set delegate
    passwordField.delegate = self;
    
    // Set as property
    self.passwordField = passwordField;

    // Show alert
    [super show];
    
    // present keyboard for text entry
    [_passwordField performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.1]; 
    
}

- (void)animateIncorrectPassword {
    // Clear the password field
    _passwordField.text = nil;
    
    // Animate the alert to show that the entered string was wrong
    // "Shakes" similar to OS X login screen
    CGAffineTransform moveRight = CGAffineTransformTranslate(CGAffineTransformIdentity, 20, 0);
    CGAffineTransform moveLeft = CGAffineTransformTranslate(CGAffineTransformIdentity, -20, 0);
    CGAffineTransform resetTransform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, 0);
    
    [UIView animateWithDuration:0.1 animations:^{
        // Translate left
        self.transform = moveLeft;
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.1 animations:^{
            
            // Translate right
            self.transform = moveRight;
            
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.1 animations:^{
                
                // Translate left
                self.transform = moveLeft;
                
            } completion:^(BOOL finished) {
                
                [UIView animateWithDuration:0.1 animations:^{
                    
                    // Translate to origin
                    self.transform = resetTransform;
                }];
            }];
            
        }];
    }];

}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    // If "Enter" button pressed on alert view then check password
    if (buttonIndex == alertView.firstOtherButtonIndex) {
        
        if ([self enteredTextIsCorrect]) {
            
            // Hide keyboard
            [self.passwordField resignFirstResponder];
            
            // Dismiss with success
            [alertView dismissWithClickedButtonIndex:ShakingAlertViewButtonIndexSuccess animated:YES];
        }
        
        // If incorrect then animate
        else {
            [self animateIncorrectPassword];

        }
    }
}


// Overide to customise when alert is dimsissed
- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated {

    // Only dismiss for ShakingAlertViewButtonIndexDismiss or ShakingAlertViewButtonIndexSuccess
    // This means we don't dissmis for the case where "Enter" button is pressed and password is incorrect
    switch (buttonIndex) {
        case ShakingAlertViewButtonIndexSuccess:
            [super dismissWithClickedButtonIndex:ShakingAlertViewButtonIndexSuccess animated:animated];
            if (self.onCorrectPassword) {
                _onCorrectPassword(_passwordField.text);
                _onCorrectPassword = nil;
            }
            break;
        case ShakingAlertViewButtonIndexDismiss:
            [super dismissWithClickedButtonIndex:ShakingAlertViewButtonIndexDismiss animated:animated];
            if (self.onDismissalWithoutPassword) {
                _onDismissalWithoutPassword();
                _onDismissalWithoutPassword = nil;
            }
            break;
        default:
            break;
    }

}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.firstOtherButtonIndex == buttonIndex) {
        if (self.onCorrectPassword) {
            _onCorrectPassword(_passwordField.text);
            _onCorrectPassword = nil;
        }
    } else {
        if (self.onDismissalWithoutPassword) {
            _onDismissalWithoutPassword();
            _onDismissalWithoutPassword = nil;
        }
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {    
    // Check password
    if ([self enteredTextIsCorrect]) {
        
        // Hide keyboard
        [self.passwordField resignFirstResponder];
        // Dismiss with success
        [self dismissWithClickedButtonIndex:ShakingAlertViewButtonIndexSuccess animated:YES];
        
        return YES;
    }
    
    // Password is incorrect to so animate
    [self animateIncorrectPassword];
    return NO;
}

- (BOOL)enteredTextIsCorrect {
    NSString *passWordText = _passwordField.text;
    if (passWordText.length <= 0) {
        //密码不能为空
        return NO;
    }

    NSString *password = [MIMainUser getInstance].DESPassword;
    if (password != nil && password.length > 0) {
        return [_passwordField.text isEqualToString:[MIUtility decryptUseDES:password key:[MIConfig globalConfig].desKey]];
    } else {
        //通过第三方登录没有密码不用在本地校验
        return YES;
    }
}

@end
