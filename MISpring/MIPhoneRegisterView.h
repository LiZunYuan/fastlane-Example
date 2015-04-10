//
//  BBPhoneRegisterView.h
//  BeiBeiAPP
//
//  Created by yujian on 14-10-20.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MIRegisterPhoneDelegate <NSObject>

- (void)confirmRegister:(id)event;

- (void)textFieldBeginEditing:(UITextField *)textField;

- (void)stopHandleTimer;
@end

@interface MIPhoneRegisterView : UIView<UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UITextField *phoneRegisterTextField;
@property (nonatomic, weak) IBOutlet UITextField *passwordTextField;
@property (nonatomic, weak) IBOutlet UITextField *codeTextField;
@property (nonatomic, weak) IBOutlet UIButton *getCodeBtn;

@property (nonatomic, strong) UITextField *currentTextField;
@property (nonatomic, weak) id<MIRegisterPhoneDelegate> delegate;

@end
