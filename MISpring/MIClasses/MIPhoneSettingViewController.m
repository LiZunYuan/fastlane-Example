//
//  MIPhoneSettingViewController.m
//  MISpring
//
//  Created by Yujian Xu on 13-3-25.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIPhoneSettingViewController.h"
#import "MISmsSendModel.h"
#import "MIUserTelUpdateModel.h"
#import "MIAlipaySettingViewController.h"

#define MIPHONE_SETTING_INPUT_NUMBER 1
#define MIPHONE_SETTING_INPUT_CODE   2

@implementation MIPhoneSettingViewController
@synthesize inputPhoneNumField = _inputPhoneNumField;
@synthesize inputVeriCodeField = _inputVeriCodeField;
@synthesize getVeriCodeButton = _getVeriCodeButton;
@synthesize setPhoneNumButton = _setPhoneNumButton;
@synthesize counttingTimer = _counttingTimer;
@synthesize smsSendRequest = _smsSendRequest;
@synthesize userTelUpdateRequest = _userTelUpdateRequest;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _counter = 60;
        _randomVeriCode = arc4random() % 9000 + 1000;
        MILog(@"%d",_randomVeriCode);

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UILabel *inputPhoneNumLable = [[UILabel alloc] initWithFrame:CGRectMake(15, 5 + self.navigationBarHeight, SCREEN_WIDTH - 30, 30)];
    inputPhoneNumLable.backgroundColor = [UIColor clearColor];
    inputPhoneNumLable.font = [UIFont systemFontOfSize:16];
    inputPhoneNumLable.textColor = [UIColor darkGrayColor];
    inputPhoneNumLable.text = @"请输入你的手机号码";
    [self.view addSubview:inputPhoneNumLable];
    
    UIImage *textFiledBg = [[UIImage imageNamed:@"text_input_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    _inputPhoneNumField = [[UITextField alloc] initWithFrame:CGRectMake(10, inputPhoneNumLable.bottom, 165, 40)];
    _inputPhoneNumField.tag = MIPHONE_SETTING_INPUT_NUMBER;
    _inputPhoneNumField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 40)];
    _inputPhoneNumField.leftViewMode = UITextFieldViewModeAlways;
    _inputPhoneNumField.background = textFiledBg;
    _inputPhoneNumField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _inputPhoneNumField.placeholder = @"填写11位手机号码";
    _inputPhoneNumField.keyboardType = UIKeyboardTypeNumberPad;
    _inputPhoneNumField.delegate = self;
    [self.view addSubview:_inputPhoneNumField];
    
    _getVeriCodeButton = [[MICommonButton alloc] initWithFrame:CGRectMake(185, inputPhoneNumLable.bottom, 125, 36)];
    _getVeriCodeButton.centerY = _inputPhoneNumField.centerY;
    [_getVeriCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_getVeriCodeButton addTarget:self action:@selector(getVerificationCode:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_getVeriCodeButton];
    _getVeriCodeButton.enabled = NO;
    
    UILabel *inputVeriCodeLable = [[UILabel alloc] initWithFrame:CGRectMake(15, 75 + self.navigationBarHeight, SCREEN_WIDTH - 30, 30)];
    inputVeriCodeLable.backgroundColor = [UIColor clearColor];
    inputVeriCodeLable.font = [UIFont systemFontOfSize:16];
    inputVeriCodeLable.textColor = [UIColor darkGrayColor];
    inputVeriCodeLable.text = @"请输入验证码";
    [self.view addSubview:inputVeriCodeLable];
    
    _inputVeriCodeField = [[UITextField alloc] initWithFrame:CGRectMake(10, inputVeriCodeLable.bottom, SCREEN_WIDTH - 20, 40)];
    _inputVeriCodeField.tag = MIPHONE_SETTING_INPUT_CODE;
    _inputVeriCodeField.background = textFiledBg;
    _inputVeriCodeField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 40)];
    _inputVeriCodeField.leftViewMode = UITextFieldViewModeAlways;
    _inputVeriCodeField.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    _inputVeriCodeField.placeholder = @"先点击“获取验证码”按钮获取验证码";
    _inputVeriCodeField.keyboardType = UIKeyboardTypeNumberPad;
    _inputVeriCodeField.delegate = self;
    [self.view addSubview:_inputVeriCodeField];
    
    _setPhoneNumButton = [[MICommonButton alloc] initWithFrame:CGRectMake(15, 155 + self.navigationBarHeight, SCREEN_WIDTH - 30, 36)];
    [_setPhoneNumButton setTitle:@"绑定" forState:UIControlStateNormal];
    [_setPhoneNumButton addTarget:self action:@selector(setPhoneNumber:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_setPhoneNumButton];
    _setPhoneNumButton.enabled = NO;
    
    RTLabel *phoneNumSettingTip = [[RTLabel alloc] initWithFrame:CGRectMake(15, 220 + self.navigationBarHeight, SCREEN_WIDTH - 30, self.view.viewHeight - self.navigationBarHeight - 190)];
    phoneNumSettingTip.backgroundColor = [UIColor clearColor];
    phoneNumSettingTip.font = [UIFont systemFontOfSize:14.0];
    phoneNumSettingTip.lineBreakMode = kCTLineBreakByCharWrapping;
    phoneNumSettingTip.lineSpacing = 5.0;
    phoneNumSettingTip.text = [[NSString alloc] initWithFormat:@"<font size=16.0 color='#499d00'>提示：</font> \n为了保障您的账户和资金安全，请绑定手机"];
    [self.view addSubview:phoneNumSettingTip];
    
    if (self.showSkipBtn) {
        _skipBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 85, (self.navigationBarHeight - PHONE_NAVIGATION_BAR_ITEM_HEIGHT), 80, PHONE_NAVIGATION_BAR_ITEM_HEIGHT)];
        [_skipBtn setTitle:@"跳过" forState:UIControlStateNormal];
        [_skipBtn addTarget:self action:@selector(skipThisStep) forControlEvents:UIControlEventTouchUpInside];
        [self.navigationBar addSubview:_skipBtn];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationBar setBarTitle:@"绑定手机"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (_counttingTimer) {
        [_counttingTimer invalidate];
        _counttingTimer = nil;
    }
    
    if (_userTelUpdateRequest) {
        [_userTelUpdateRequest cancelRequest];
        _userTelUpdateRequest = nil;
    }
    
    if (_smsSendRequest) {
        [_smsSendRequest cancelRequest];
        _smsSendRequest = nil;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)skipThisStep
{
    [[MINavigator navigator] closePopViewControllerAnimated:NO];
}

- (void)settingTelSuccess
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];

    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"恭喜您，绑定手机成功!";
    hud.margin = 10.f;
    hud.yOffset = -80.f;
    hud.removeFromSuperViewOnHide = YES;

    [hud hide:YES afterDelay:1.3];

    [MIMainUser getInstance].phoneNum = _inputPhoneNumField.text;
    [[MIMainUser getInstance] persist];
    
    if (([MIMainUser getInstance].alipay == nil) || ([MIMainUser getInstance].alipay.length == 0))
    {
        [self miPopViewControllerWithAnimated:NO];
        MIAlipaySettingViewController *vc = [[MIAlipaySettingViewController alloc] init];
        vc.barTitle = @"绑定支付宝";
        vc.showSkipBtn = YES;
        [[MINavigator navigator] openPushViewController:vc animated:NO];
    } else {
        [self miPopViewControllerWithAnimated:YES];
    }
}

- (void)setPhoneNumber:(UIButton *)btn
{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.yOffset = -80.f;
        hud.removeFromSuperViewOnHide = YES;

        if (_userTelUpdateRequest) {
            [_userTelUpdateRequest cancelRequest];
            _userTelUpdateRequest = nil;
        }
        _userTelUpdateRequest = [[MIUserTelUpdateRequest alloc] init];
        [_userTelUpdateRequest setTel:_inputPhoneNumField.text];
        [_userTelUpdateRequest setCode:_inputVeriCodeField.text];

        __weak typeof(hud) bhud = hud;
        __weak typeof(self) weakSelf = self;
        _userTelUpdateRequest.onCompletion = ^(MIUserTelUpdateModel * model) {
            [bhud hide: YES];
            if ([model.success boolValue]) {
                [weakSelf settingTelSuccess];
            } else {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"绑定失败"
                                                                    message:model.message
                                                                   delegate:nil
                                                          cancelButtonTitle:@"确定"
                                                          otherButtonTitles:nil, nil];
                [alertView show];
            }
        };
        _userTelUpdateRequest.onError = ^(MKNetworkOperation* completedOperation, MIError* error) {
            [bhud hide: YES];
        };
        
        [_userTelUpdateRequest sendQuery];
    
}

- (void)getVerificationCode:(UIButton *)btn
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.yOffset = -80.f;
    hud.removeFromSuperViewOnHide = YES;

    if (_smsSendRequest) {
        [_smsSendRequest cancelRequest];
        _smsSendRequest = nil;
    }
    _smsSendRequest = [[MISMSSendRequest alloc] init];
    [_smsSendRequest setTel:_inputPhoneNumField.text];
    [_smsSendRequest setType:@"bind_phone"];

    __weak typeof(hud) bhud = hud;
    __weak typeof(self) weakSelf = self;
    _smsSendRequest.onCompletion = ^(MISmsSendModel * model) {
        [bhud hide: YES];
        if ([model.success boolValue]) {
            weakSelf.counttingTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:weakSelf selector:@selector(handleTimer:)  userInfo:nil  repeats:YES];
            [weakSelf.counttingTimer fire];
            btn.enabled = NO;
        } else {
            [weakSelf showSimpleHUD:model.message];
        }
    };
    _smsSendRequest.onError = ^(MKNetworkOperation* completedOperation, MIError* error) {
        [bhud hide: YES];
    };

    [_smsSendRequest sendQuery];
}

- (void)handleTimer: (NSTimer *) timer
{
    if (_counter > 0 ) {
        [_getVeriCodeButton setTitle:[NSString stringWithFormat:@"(%ld)获取验证码", (long)_counter] forState:UIControlStateDisabled];
        _counter--;
    } else {
        _counter = 60;
        [_counttingTimer invalidate];
        _counttingTimer = nil;
        [_getVeriCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        _getVeriCodeButton.enabled = [MIUtility validatorRange:NSMakeRange(11, 11) text:_inputPhoneNumField.text];
    }

}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *futureString = [textField.text stringByReplacingCharactersInRange:range withString:string];

    if (textField.tag == MIPHONE_SETTING_INPUT_NUMBER && ![_counttingTimer isValid]) {
        _getVeriCodeButton.enabled = [MIUtility validatorRange:NSMakeRange(11, 11) text:futureString];
    }

    if (textField.tag == MIPHONE_SETTING_INPUT_CODE) {
//        _setPhoneNumButton.enabled = [MIUtility validatorRange:NSMakeRange(4, 4) text:futureString];
        _setPhoneNumButton.enabled = YES;
    }
    
    return YES;
}

@end
