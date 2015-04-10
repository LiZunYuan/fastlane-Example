//
//  MIPhoneSettingViewController.h
//  MISpring
//
//  Created by Yujian Xu on 13-3-25.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIBaseViewController.h"
#import "MISMSSendRequest.h"
#import "MIUserTelUpdateRequest.h"

@interface MIPhoneSettingViewController : MIBaseViewController <UITextFieldDelegate>
{
    NSTimer *_counttingTimer;
    NSInteger _counter;
    NSInteger _randomVeriCode;
    UITextField *_inputPhoneNumField;
    UITextField *_inputVeriCodeField;
    MICommonButton *_getVeriCodeButton;
    MICommonButton *_setPhoneNumButton;
}

@property (nonatomic, strong) NSTimer *counttingTimer;
@property (nonatomic, strong) UITextField *inputPhoneNumField;
@property (nonatomic, strong) UITextField *inputVeriCodeField;
@property (nonatomic, strong) MICommonButton *getVeriCodeButton;
@property (nonatomic, strong) MICommonButton *setPhoneNumButton;
@property (nonatomic, strong) MISMSSendRequest *smsSendRequest;
@property (nonatomic, strong) MIUserTelUpdateRequest *userTelUpdateRequest;
@property (nonatomic, strong) UIButton *skipBtn;
@property (nonatomic, assign) BOOL *showSkipBtn;

@end
