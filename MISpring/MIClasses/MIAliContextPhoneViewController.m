//
//  MIAliContextPhoneViewController.m
//  MISpring
//
//  Created by 曲俊囡 on 13-11-13.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIAliContextPhoneViewController.h"
#import "MISmsSendModel.h"
#import "MIUserAlipayUpdateModel.h"
#import "MIChangePassViewController.h"
#import "MIForgetPWDViewController.h"

#define MIPHONE_SETTING_INPUT_CODE   2

@interface MIAliContextPhoneViewController ()

@end

@implementation MIAliContextPhoneViewController
@synthesize inputPasswordField = _inputPasswordField;
@synthesize inputVeriCodeField = _inputVeriCodeField;
@synthesize getVeriCodeButton = _getVeriCodeButton;
@synthesize setPhoneNumButton = _setPhoneNumButton;
@synthesize counttingTimer = _counttingTimer;
@synthesize smsSendRequest = _smsSendRequest;
@synthesize alipayUpdateRequest = _alipayUpdateRequest;

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


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (_counttingTimer) {
        [_counttingTimer invalidate];
        _counttingTimer = nil;
    }
    
    if (_smsSendRequest) {
        [_smsSendRequest cancelRequest];
        _smsSendRequest = nil;
    }
    
    if (_alipayUpdateRequest) {
        [_alipayUpdateRequest cancelRequest];
        _alipayUpdateRequest = nil;
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.navigationBar setBarTitle:@"安全验证"];
    
    UILabel *inputVeriCodeLable = [[UILabel alloc] initWithFrame:CGRectMake(15, 5 + self.navigationBarHeight, SCREEN_WIDTH - 20, 30)];
    inputVeriCodeLable.backgroundColor = [UIColor clearColor];
    inputVeriCodeLable.font = [UIFont systemFontOfSize:16];
    inputVeriCodeLable.textColor = [UIColor darkGrayColor];
    inputVeriCodeLable.text = @"请输入验证码";
    [self.view addSubview:inputVeriCodeLable];
    
    UIImage *textFiledBg = [[UIImage imageNamed:@"text_input_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    _inputVeriCodeField = [[UITextField alloc] initWithFrame:CGRectMake(10, inputVeriCodeLable.bottom, 165, 40)];
    _inputVeriCodeField.tag = MIPHONE_SETTING_INPUT_CODE;
    _inputVeriCodeField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 40)];
    _inputVeriCodeField.leftViewMode = UITextFieldViewModeAlways;
    _inputVeriCodeField.background = textFiledBg;
    _inputVeriCodeField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _inputVeriCodeField.placeholder = @"输入验证码";
    _inputVeriCodeField.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:_inputVeriCodeField];
    
    _getVeriCodeButton = [[MICommonButton alloc] initWithFrame:CGRectMake(185, inputVeriCodeLable.bottom, 125, 36)];
    _getVeriCodeButton.centerY = _inputVeriCodeField.centerY;
    [_getVeriCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_getVeriCodeButton addTarget:self action:@selector(getVerificationCode:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_getVeriCodeButton];
    
    UILabel *inputMiZheCodeLable = [[UILabel alloc] initWithFrame:CGRectMake(15, 75 + self.navigationBarHeight, SCREEN_WIDTH - 20, 30)];
    inputMiZheCodeLable.backgroundColor = [UIColor clearColor];
    inputMiZheCodeLable.font = [UIFont systemFontOfSize:16];
    inputMiZheCodeLable.textColor = [UIColor darkGrayColor];
    inputMiZheCodeLable.text = @"请输入米折密码";
    [self.view addSubview:inputMiZheCodeLable];
    
    NSString *forgetPassword = @"忘记密码？";
    CGSize labelSize = [forgetPassword sizeWithFont:[UIFont systemFontOfSize:14.0f]
                                  constrainedToSize:CGSizeMake(300, 14)];
    UILabel *forgetPWD = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 20 - labelSize.width, 80 + self.navigationBarHeight, labelSize.width + 12, 16)];
    forgetPWD.centerY = inputMiZheCodeLable.centerY;
    forgetPWD.backgroundColor = [UIColor clearColor];
    forgetPWD.font = [UIFont systemFontOfSize:14.0];
    forgetPWD.textColor = [UIColor blueColor];
    forgetPWD.textAlignment = UITextAlignmentRight;
    forgetPWD.text = forgetPassword;
    forgetPWD.userInteractionEnabled = YES;
    [self.view addSubview:forgetPWD];
    
    UITapGestureRecognizer *forgetPassWord = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goForgetPassWord)];
    [forgetPWD addGestureRecognizer:forgetPassWord];
    
    _inputPasswordField = [[UITextField alloc] initWithFrame:CGRectMake(10, inputMiZheCodeLable.bottom, SCREEN_WIDTH - 20, 40)];
    _inputPasswordField.background = textFiledBg;
    _inputPasswordField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 40)];
    _inputPasswordField.leftViewMode = UITextFieldViewModeAlways;
    _inputPasswordField.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    _inputPasswordField.placeholder = @"输入米折密码";
    _inputPasswordField.keyboardType = UIKeyboardTypeAlphabet;
    _inputPasswordField.secureTextEntry = YES;
    [self.view addSubview:_inputPasswordField];
    
    _setPhoneNumButton = [[MICommonButton alloc] initWithFrame:CGRectMake(15, 155 + self.navigationBarHeight, SCREEN_WIDTH - 30, 36)];
    [_setPhoneNumButton setTitle:@"立即绑定" forState:UIControlStateNormal];
    [_setPhoneNumButton addTarget:self action:@selector(setAlipayAccount:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_setPhoneNumButton];
    
    RTLabel *phoneNumSettingTip = [[RTLabel alloc] initWithFrame:CGRectMake(15, 205 + self.navigationBarHeight, SCREEN_WIDTH - 30, self.view.viewHeight - self.navigationBarHeight - 190)];
    phoneNumSettingTip.backgroundColor = [UIColor clearColor];
    phoneNumSettingTip.font = [UIFont systemFontOfSize:14.0];
    phoneNumSettingTip.lineBreakMode = kCTLineBreakByCharWrapping;
    phoneNumSettingTip.lineSpacing = 5.0;
    phoneNumSettingTip.text = [[NSString alloc] initWithFormat:@"<font size=16.0 color='#499d00'>提示：</font> \n为了保障您的账户和资金安全，设置支付宝账号需手机及密码验证。"];
    [self.view addSubview:phoneNumSettingTip];
}

- (void)goForgetPassWord
{
//    MIChangePassViewController* vc = [[MIChangePassViewController alloc] init];
//    [[MINavigator navigator] openModalViewController:vc animated:YES];
    MIForgetPWDViewController *controller = [[MIForgetPWDViewController alloc] init];
    [[MINavigator navigator] openModalViewController:controller animated:YES];
}

- (void)settingAlipaySuccess
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
    
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"恭喜您，设置成功!";
    hud.margin = 10.f;
    hud.yOffset = -80.f;
    hud.removeFromSuperViewOnHide = YES;
    
    [hud hide:YES afterDelay:1.3];
    
    [MIMainUser getInstance].alipay = self.aliPayAccount;
    [MIMainUser getInstance].nickName = self.realName;
    [[MIMainUser getInstance] persist];
    
    [self miPopToViewControllerAtIndex:3];
}

- (void)setAlipayAccount:(UIButton *)btn
{
    if (![self passwordIsCorrect]) {
        [self showSimpleHUD:@"请输入正确的米折密码"];
    } else if(_inputVeriCodeField.text == nil || _inputVeriCodeField.text.length == 0) {
        [self showSimpleHUD:@"请输入验证码"];
    } else {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.yOffset = -80.f;
        hud.removeFromSuperViewOnHide = YES;

        if (_alipayUpdateRequest) {
            [_alipayUpdateRequest cancelRequest];
            _alipayUpdateRequest = nil;
        }
        _alipayUpdateRequest = [[MIAlipayUpdateRequest alloc] init];
        [_alipayUpdateRequest setName:self.realName];
        [_alipayUpdateRequest setAlipay:self.aliPayAccount];
        [_alipayUpdateRequest setPassword:_inputPasswordField.text];
        [_alipayUpdateRequest setCode:_inputVeriCodeField.text];
        __weak typeof(hud) bhud = hud;
        __weak typeof(self) weakSelf = self;
        _alipayUpdateRequest.onCompletion = ^(MIUserAlipayUpdateModel * model) {
            [bhud hide: true];

            if ([model.success boolValue]) {
                [weakSelf settingAlipaySuccess];
            } else {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"设置失败"
                                                                    message:model.message
                                                                   delegate:nil
                                                          cancelButtonTitle:@"确定"
                                                          otherButtonTitles:nil, nil];
                [alertView show];
            }
        };
        _alipayUpdateRequest.onError = ^(MKNetworkOperation* completedOperation, MIError* error) {
            [bhud hide: true];
        };
        
        [_alipayUpdateRequest sendQuery];
    }
}

- (BOOL)passwordIsCorrect {
    NSString *passWordText = self.inputPasswordField.text;
    if (passWordText.length <= 0) {
        //密码不能为空
        return NO;
    }
    
    NSString *password = [MIMainUser getInstance].DESPassword;
    if (password != nil && password.length > 0) {
        return [passWordText isEqualToString:[MIUtility decryptUseDES:password]];
    } else {
        //通过第三方登录没有密码不用在本地校验
        return YES;
    }
}

- (void)getVerificationCode:(UIButton *)btn
{
    if ([MIMainUser getInstance].phoneNum == nil) {
        [self showSimpleHUD:@"请先绑定手机号" afterDelay:1];
        return;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.yOffset = -80.f;
    hud.removeFromSuperViewOnHide = YES;
    
    if (_smsSendRequest) {
        [_smsSendRequest cancelRequest];
        _smsSendRequest = nil;
    }
    _smsSendRequest = [[MISMSSendRequest alloc] init];
    [_smsSendRequest setTel:[MIMainUser getInstance].phoneNum];
    [_smsSendRequest setType:@"bind_alipay"];
    
    __weak typeof(hud) bhud = hud;
    __weak typeof(self) weakSelf = self;
    _smsSendRequest.onCompletion = ^(MISmsSendModel * model) {
        [bhud hide: YES];
        if ([model.success boolValue]) {
            weakSelf.counttingTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:weakSelf selector:@selector(handleTimer:)  userInfo:nil  repeats:YES];
            [weakSelf.counttingTimer fire];
            btn.enabled = NO;
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithMessage:model.message];
            [alertView show];
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
        _getVeriCodeButton.enabled = YES;
        [_getVeriCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
