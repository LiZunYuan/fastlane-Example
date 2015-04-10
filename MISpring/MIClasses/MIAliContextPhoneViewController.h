//
//  MIAliContextPhoneViewController.h
//  MISpring
//
//  Created by 曲俊囡 on 13-11-13.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIBaseViewController.h"
#import "MISMSSendRequest.h"
#import "MIAlipayUpdateRequest.h"

@interface MIAliContextPhoneViewController : MIBaseViewController
{
    NSTimer *_counttingTimer;
    NSInteger _counter;
    NSInteger _randomVeriCode;
    UITextField *_inputPasswordField;
    UITextField *_inputVeriCodeField;
    MICommonButton *_getVeriCodeButton;
    MICommonButton *_setPhoneNumButton;
}

@property (nonatomic, copy) NSString *realName;
@property (nonatomic, copy) NSString *aliPayAccount;
@property (nonatomic, strong) NSTimer *counttingTimer;
@property (nonatomic, strong) UITextField *inputPasswordField;
@property (nonatomic, strong) UITextField *inputVeriCodeField;
@property (nonatomic, strong) MICommonButton *getVeriCodeButton;
@property (nonatomic, strong) MICommonButton *setPhoneNumButton;
@property (nonatomic, strong) MISMSSendRequest *smsSendRequest;
@property (nonatomic, strong) MIAlipayUpdateRequest *alipayUpdateRequest;




@end
