//
//  MIAlipaySettingViewController.h
//  MISpring
//
//  Created by Yujian Xu on 13-3-22.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIBaseViewController.h"

@interface MIAlipaySettingViewController : MIBaseViewController <UITextFieldDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UITextField *inputNameField;
@property (nonatomic, strong) UITextField *inputAlipayAccountField;
@property (nonatomic, strong) MICommonButton *alipaySettingButton;
@property (nonatomic, copy) NSString *barTitle;
@property (nonatomic, strong) UIButton *skipBtn;
@property (nonatomic, assign) BOOL *showSkipBtn;

@end
