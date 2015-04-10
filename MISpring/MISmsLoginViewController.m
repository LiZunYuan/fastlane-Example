//
//  BBSmsLoginViewController.m
//  BeiBeiAPP
//
//  Created by yujian on 15-3-11.
//  Copyright (c) 2015年 Husor Inc. All rights reserved.
//

#import "MISmsLoginViewController.h"
//#import "BBPhoneRegisterView.h"
#import "MIUserCodeSendRequest.h"
#import "MIUserCodeSendModel.h"
#import "MIUserAuthModel.h"
#import "MILoginRequest.h"
#import "MIAdService.h"
#import "MISmsRegisterViewController.h"
#import "MIPhoneRegisterView.h"
#import "MIUserGetRequest.h"
#import "MIUserGetModel.h"

@interface MISmsLoginViewController ()<MIRegisterPhoneDelegate>
{
    MIPhoneRegisterView     *_phoneRegisterView;
    MIUserCodeSendRequest        *_codeRequest;
    NSInteger               _counter;
}

@property (nonatomic, strong) NSTimer *counttingTimer;
@property (nonatomic, strong) MIPhoneRegisterView *phoneRegisterView;

@end

@implementation MISmsLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationBar setBarLeftButtonItem:self selector:@selector(closeLoginView:) imageKey:@"navigationbar_btn_close"];
    [self.navigationBar setBarTitle:@"短信快捷登录"];

    _phoneRegisterView = [[[NSBundle mainBundle]loadNibNamed:@"MIPhoneRegisterView" owner:self options:nil] objectAtIndex:0];
    _phoneRegisterView.clipsToBounds = YES;
    _phoneRegisterView.delegate = self;
    _phoneRegisterView.frame = CGRectMake(0, self.navigationBarHeight + 10, PHONE_SCREEN_SIZE.width, 90);
    [_phoneRegisterView.getCodeBtn addTarget:self action:@selector(getUserCode) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_phoneRegisterView];
    
    UIButton *loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, _phoneRegisterView.bottom + 8, SCREEN_WIDTH - 20, 45)];
    loginBtn.clipsToBounds = YES;
    loginBtn.layer.cornerRadius = 3.0;
    [loginBtn setTitle:@"立即登录" forState:UIControlStateNormal];
    loginBtn.backgroundColor = MICommitButtonBackground;
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(submitButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    
    __weak typeof(self) weakSelf = self;
    _codeRequest = [[MIUserCodeSendRequest alloc] init];
    [_codeRequest setKey:@"quick_login"];
    _codeRequest.onCompletion = ^(MIUserCodeSendModel *model) {
        [weakSelf hideProgressHUD];
        if (model.success.boolValue) {
            weakSelf.counttingTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:weakSelf selector:@selector(handleTimer:)  userInfo:nil  repeats:YES];
            [weakSelf.counttingTimer fire];
            weakSelf.phoneRegisterView.getCodeBtn.userInteractionEnabled = NO;
            [weakSelf showSimpleHUD:model.message];
        } else {
            [[[UIAlertView alloc] initWithMessage:model.message] show];
        }
    };
    _codeRequest.onError = ^(MKNetworkOperation* completedOperation, MIError* error) {
        [weakSelf hideProgressHUD];
        MILog(@"error_msg=%@",error.description);
    };
    
    _counter = 60;
    
}

- (void)clear
{
    _phoneRegisterView.phoneRegisterTextField.text = @"";
    _phoneRegisterView.codeTextField.text = @"";
}

- (void)handleTimer:(id)sender
{
    if (_counter > 0 ) {
        [_phoneRegisterView.getCodeBtn.layer setBorderColor:[MIUtility colorWithHex:0xcccccc].CGColor];
        [_phoneRegisterView.getCodeBtn setTitleColor:[MIUtility colorWithHex:0xcccccc] forState:UIControlStateNormal];
        [_phoneRegisterView.getCodeBtn setTitle:[NSString stringWithFormat:@"%ldS", (long)_counter] forState:UIControlStateNormal];
        _counter--;
    } else {
        _counter = 60;
        [self destoryTimer];
    }
}

- (void)getUserCode
{
    if (_phoneRegisterView.phoneRegisterTextField.text && ![_phoneRegisterView.phoneRegisterTextField.text isEqualToString:@""])
    {
        [_codeRequest setTel:_phoneRegisterView.phoneRegisterTextField.text];
        [self showProgressHUD:nil];
        [_codeRequest sendQuery];
    }
    else
    {
        [self showSimpleHUD:@"请输入手机号码" afterDelay:1];
    }
}

-(void)destoryTimer
{
    [_counttingTimer invalidate];
    _counttingTimer = nil;
    
    [_phoneRegisterView.getCodeBtn.layer setBorderColor:MICodeButtonBackground.CGColor];
    [_phoneRegisterView.getCodeBtn setTitleColor:MICodeButtonBackground forState:UIControlStateNormal];
    [_phoneRegisterView.getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    _phoneRegisterView.getCodeBtn.userInteractionEnabled = YES;
}

- (void)submitButtonTouched:(id)sender
{
    [self confirmRegister:nil];
}

- (void)confirmRegister:(id)event
{
    if (_phoneRegisterView.phoneRegisterTextField.text == nil || [_phoneRegisterView.phoneRegisterTextField.text isEqualToString:@""])
    {
        [self showSimpleHUD:@"请输入手机号码" afterDelay:1];
        [_phoneRegisterView.phoneRegisterTextField becomeFirstResponder];
    }
    else if(_phoneRegisterView.codeTextField.text == nil || [_phoneRegisterView.codeTextField.text isEqualToString:@""])
    {
        [self showSimpleHUD:@"请输入验证码" afterDelay:1];
        [_phoneRegisterView.codeTextField becomeFirstResponder];
    }
    else
    {
        NSString *phoneAndPassword = [NSString stringWithFormat:@"%@   %@   %@",_phoneRegisterView.phoneRegisterTextField.text,_phoneRegisterView.codeTextField.text,@"quick_login"];
        NSString *encryptPWDUseDES = [MIUtility encryptUseDES:phoneAndPassword];
        if (encryptPWDUseDES == nil) {
            [self showSimpleHUD:@"系统出错了，请稍后再试"];
            return;
        }
        
        [self showProgressHUD:nil];
        __weak typeof(self) weakSelf = self;
        MILoginRequest *request = [[MILoginRequest alloc] init];
        [request setUserNameAndPassWord:encryptPWDUseDES];
        request.onCompletion = ^(MIUserAuthModel * model) {
            [weakSelf hideProgressHUD];
            
            if ([model.success boolValue]) {
                [MobClick event:kLogined];
                MIMainUser *mainUser = [MIMainUser getInstance];
                mainUser.loginStatus = MILoginStatusNormalLogin;
                [[MIAdService sharedManager] clearCache];
                mainUser.sessionKey = model.data;
                mainUser.phoneNum = weakSelf.phoneRegisterView.phoneRegisterTextField.text;
                [mainUser persist];
                [weakSelf performSelector:@selector(getUserInfo:) withObject:nil afterDelay:0.5];
            } else if (![model.data isEqual:[NSNull null]] && [model.data isEqualToString:@"register"]){
                if (_loginRegisterDelegate && [_loginRegisterDelegate respondsToSelector:@selector(goToNextController:)]) {
                    [_loginRegisterDelegate goToNextController:SMSRegisterType];
                }
            } else {
                UIAlertView *alertView = [[UIAlertView alloc] initWithMessage:model.message];
                [alertView show];
            }
        };
        request.onError = ^(MKNetworkOperation* completedOperation, MIError* error) {
            [weakSelf hideProgressHUD];
        };
        
        [request sendQuery];
    }
}



- (void)getUserInfo:(id)sender
{
    __weak typeof(self) weakSelf = self;
    MIUserGetRequest *request = [[MIUserGetRequest alloc] init];
    request.onCompletion = ^(MIUserGetModel * model) {
        [weakSelf hideProgressHUD];
        [MIMainUser getInstance].loginStatus = MILoginStatusNormalLogin;
        [[MIMainUser getInstance] saveUserInfo:model];
        [weakSelf closeLoginView:nil];
    };
    
    request.onError = ^(MKNetworkOperation* completedOperation, MIError* error) {
        [error showHUD];
        [weakSelf hideProgressHUD];
    };
    [self showProgressHUD:nil];
    [request sendQuery];
}

- (void)passValueToNextController:(UIViewController *)controller
{
    if ([controller isMemberOfClass:[MISmsRegisterViewController class]]){
        MISmsRegisterViewController *toController = (MISmsRegisterViewController *)controller;
        toController.phoneText = _phoneRegisterView.phoneRegisterTextField.text;
        toController.codeText = _phoneRegisterView.codeTextField.text;
    }
}

- (void)textFieldBeginEditing:(UITextField *)textField
{
    
}

- (void)stopHandleTimer
{
    [self destoryTimer];
}

- (void)goLogin
{
    if (_loginRegisterDelegate && [_loginRegisterDelegate respondsToSelector:@selector(goToNextController:)]) {
        [_loginRegisterDelegate goToNextController:LoginType];
    }
}

- (void)closeLoginView: (id) event
{
    MI_CALL_DELEGATE_WITH_ARG(_loginRegisterDelegate, @selector(closeLoginView:), event);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
