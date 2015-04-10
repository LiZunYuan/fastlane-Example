//
//  BBSmsRegisterViewController.m
//  BeiBeiAPP
//
//  Created by yujian on 15-3-11.
//  Copyright (c) 2015年 Husor Inc. All rights reserved.
//

#import "MISmsRegisterViewController.h"
#import "MIRegisterRequest.h"
#import "MIUserRegisterModel.h"
#import "MIAppDelegate.h"
#import "MIUserGetRequest.h"
#import "MIUserGetModel.h"

#define WhiteSpace  16

@interface MISmsRegisterViewController ()<UITextFieldDelegate>
{
    UILabel     *_phoneLabel;
    UITextField *_passwordTextField;
}

@end

@implementation MISmsRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationBar setBarLeftButtonItem:self selector:@selector(closeLoginView:) imageKey:@"navigationbar_btn_close"];
    [self.navigationBar setBarTitle:@"快速注册"];
    
    UIView *bacView = [[UIView alloc] initWithFrame:CGRectMake(0, self.navigationBarHeight + 8, self.view.viewWidth, 89)];
    bacView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bacView];
    
    UILabel *phoneTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 44, 44)];
    phoneTipLabel.text = @"手机号";
    phoneTipLabel.font = [UIFont systemFontOfSize:14.0];
    phoneTipLabel.textColor = [MIUtility colorWithHex:0X333333];
    [bacView addSubview:phoneTipLabel];
    
    UIImageView *phoneImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_login_phone"]];
    phoneImageView.center = CGPointMake(50/2, phoneTipLabel.centerY);
    [bacView addSubview:phoneImageView];
    
    _phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(108, 0, 111, 44)];
    _phoneLabel.backgroundColor = [UIColor clearColor];
    _phoneLabel.font = [UIFont systemFontOfSize:18.0];
    _phoneLabel.textColor = [MIUtility colorWithHex:0X333333];
    [bacView addSubview:_phoneLabel];
    
    UILabel *nonRegisterLabel = [[UILabel alloc] initWithFrame:CGRectMake(_phoneLabel.right + 4, _phoneLabel.bottom - 15, 100, 14)];
    nonRegisterLabel.textColor = [MIUtility colorWithHex:0x7dcc08];
    nonRegisterLabel.font = [UIFont systemFontOfSize:13.0];
    nonRegisterLabel.centerY = _phoneLabel.centerY;
    nonRegisterLabel.text = @"(尚未注册)";
    [bacView addSubview:nonRegisterLabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(50, 44, self.view.viewWidth - 40, 1)];
    lineView.backgroundColor = [MIUtility colorWithHex:0xe5e5e5 alpha:0.75];
    [bacView addSubview:lineView];
    
    UILabel *passwordTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, lineView.bottom, 44, 44)];
    passwordTipLabel.text = @"密  码";
    passwordTipLabel.font = [UIFont systemFontOfSize:14.0];
    [bacView addSubview:passwordTipLabel];
    
    UIImageView *passImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 19, 19)];
    passImageView.image = [UIImage imageNamed:@"ic_register_code"];
    passImageView.center = CGPointMake(50/2, passwordTipLabel.centerY);
    [bacView addSubview:passImageView];
    
    _passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(108, lineView.bottom, self.view.viewWidth - 100, 44)];
    _passwordTextField.placeholder = @"请设置密码（6-16个字符）";
    _passwordTextField.font = [UIFont systemFontOfSize:14.0];
    _passwordTextField.delegate = self;
    if (IOS_VERSION < 7.0) {
        _passwordTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    }
    _passwordTextField.secureTextEntry = YES;
    _passwordTextField.centerY = passwordTipLabel.centerY;
    [bacView addSubview:_passwordTextField];
    
    bacView.viewHeight = passwordTipLabel.bottom;
    
    UIButton *loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(8, bacView.bottom + 8, SCREEN_WIDTH - 16, 45)];
    loginBtn.clipsToBounds = YES;
    loginBtn.layer.cornerRadius = 3.0;
    [loginBtn setTitle:@"立即注册" forState:UIControlStateNormal];
    loginBtn.backgroundColor = MICommitButtonBackground;
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(submitButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.backgroundColor = [UIColor clearColor];
//    button.frame = CGRectMake(8, loginBtn.bottom + 12, SCREEN_WIDTH - 16, 12);
//    [button setTitle:@"注册即接受《贝贝网使用协议》" forState:UIControlStateNormal];
//    [button setTitleColor:BBColor858585 forState:UIControlStateNormal];
//    button.titleLabel.font = [UIFont systemFontOfSize:12.0];
//    [button addTarget:self action:@selector(goToagreement) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:button];
}

//- (void)goToagreement
//{
//    BBModalWebViewController* vc = [[BBModalWebViewController alloc] initWithURL:[NSURL URLWithString:[BBConfig globalConfig].agreementURL]];
//    
//    vc.webPageTitle = @"用户使用协议";
//    [self presentModalViewController:vc animated:YES];
//}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _phoneLabel.text = self.phoneText;
}

- (void)submitButtonTouched:(id)sender
{
    if(_passwordTextField.text == nil || [_passwordTextField.text isEqualToString:@""]){
        [self showSimpleHUD:@"请输入密码" afterDelay:1];
        [_passwordTextField becomeFirstResponder];
    } else if (![MIUtility validatorRange:NSMakeRange(6, 16) text:_passwordTextField.text]) {
        MIButtonItem *cancelItem = [MIButtonItem itemWithLabel:@"知道了"];
        cancelItem.action = ^{
            [_passwordTextField becomeFirstResponder];
        };
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"无效的输入" message:@"请输入6-16个字符长度的密码" cancelButtonItem:cancelItem otherButtonItems:nil, nil];
        [alertView show];
    }else {
        NSString *phoneAndPassword = [NSString stringWithFormat:@"%@   %@   %@",_phoneText,_passwordTextField.text,_codeText];
        NSString *encryptPWDUseDES = [MIUtility encryptUseDES:phoneAndPassword];
        if (encryptPWDUseDES == nil) {
            [self showSimpleHUD:@"系统出错了，请稍后再试"];
            return;
        }
        
        [self showProgressHUD:nil];
        __weak typeof(self) weakSelf = self;
        MIRegisterRequest *request = [[MIRegisterRequest alloc] init];
        NSString *password = _passwordTextField.text;
        [request setUserNameAndPassWord:encryptPWDUseDES];
        [request setChannelId:[MIConfig globalConfig].channelId];
        request.onCompletion = ^(MIUserRegisterModel * model) {
            [self hideProgressHUD];
            if ([model.success boolValue] == TRUE) {
                MIMainUser *mainUser = [MIMainUser getInstance];
                mainUser.sessionKey = model.data;
                mainUser.DESPassword = [MIUtility encryptUseDES:password];;
                [mainUser persist];
                [weakSelf getUserInfo];
            } else {
                [[[UIAlertView alloc] initWithMessage:model.message] show];
            }
        };
        request.onError = ^(MKNetworkOperation* completedOperation, MIError* error) {
            MILog(@"error_msg=%@",error.description);
            [self hideProgressHUD];
        };
        [request sendQuery];
    }
}

- (void)getUserInfo
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

- (void)clear
{
    _passwordTextField.text = @"";
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
