//
//  MILoginViewController.m
//  MISpring
//
//  Created by XU YUJIAN on 13-1-22.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MILoginViewController.h"
#import "MIThirdLoginViewController.h"
#import "MIUITextButton.h"
#import "MILoginRequest.h"
#import "MIUserAuthModel.h"
#import "MIUserGetRequest.h"
#import "MIHeartbeat.h"
#import "MIChangePassViewController.h"
#import "MIPhoneSettingViewController.h"
#import "MIAlipaySettingViewController.h"
#import "MIUserOpenAppAuthModel.h"
#import "MIUserOpenAppAuthRequest.h"
#import "MITencentAuth.h"
#import "MISinaWeibo.h"
#import "MIForgetPWDViewController.h"
#import "MIRegisterPhoneViewController.h"


#define EMAIL_INPUT_TEXTFIELD    1
#define PASSWORD_INPUT_TEXTFIELD 2

@implementation MILoginViewController
@synthesize loginView = _loginView;
@synthesize emailField = _emailField;
@synthesize passwdField = _passwdField;
@synthesize forgetPWD = _forgetPWD;
@synthesize taobaoLogin = _taobaoLogin;
@synthesize qqLogin = _qqLogin;
@synthesize weiboLogin = _weiboLogin;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationBar setBarLeftButtonItem:self selector:@selector(closeLoginView:) imageKey:@"navigationbar_btn_close"];
    [self.navigationBar setBarRightTextButtonItem:self selector:@selector(goRegostor:) title:@"注册"];
    [self.navigationBar setBarTitle:@"登录米折"];
    
    //登录信息界面
    self.loginView = [[UIView alloc] initWithFrame:CGRectMake(0, 15 + self.navigationBarHeight, SCREEN_WIDTH, 90)];
    self.loginView.backgroundColor = [UIColor whiteColor];
    UIImageView *accountImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 13, 19, 19)];
    accountImageView.image = [UIImage imageNamed:@"ic_register_account"];
    [self.loginView addSubview:accountImageView];
    
    UILabel *accountLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 40, 45)];
    accountLabel.font = [UIFont systemFontOfSize:16.0];
    accountLabel.text = @"账号";
    [self.loginView addSubview:accountLabel];
    
    UIImageView *passwordImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 58, 19, 19)];
    passwordImageView.image = [UIImage imageNamed:@"ic_register_code"];
    [self.loginView addSubview:passwordImageView];
    
    UILabel *passwordLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 45, 40, 45)];
    passwordLabel.font = [UIFont systemFontOfSize:16.0];
    passwordLabel.text = @"密码";
    [self.loginView addSubview:passwordLabel];
    
    //邮箱
    UITextField *emailTextField               = [[UITextField alloc] init];
    emailTextField.tag                        = EMAIL_INPUT_TEXTFIELD;
    emailTextField.frame                      = CGRectMake(80, 0, self.view.viewWidth - 80, 44);
    emailTextField.backgroundColor            = [UIColor clearColor];
    emailTextField.font                       = [UIFont systemFontOfSize:14];
    emailTextField.placeholder                = @"请输入手机号码/邮箱";
    emailTextField.clearButtonMode            = UITextFieldViewModeWhileEditing;
    emailTextField.autocapitalizationType     = UITextAutocapitalizationTypeNone;
    emailTextField.autocorrectionType         = UITextAutocorrectionTypeNo;
    emailTextField.keyboardType               = UIKeyboardTypeEmailAddress;
    emailTextField.returnKeyType              = UIReturnKeyNext;
    emailTextField.contentVerticalAlignment   = UIControlContentVerticalAlignmentCenter;
    self.emailField                           = emailTextField;
    self.emailField.delegate                  = self;
    [self.loginView addSubview:self.emailField];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(accountLabel.left, emailTextField.bottom, self.view.viewWidth - accountLabel.left, 1)];
    line.backgroundColor = [MIUtility colorWithHex:0xe5e5e5 alpha:0.75];
    [self.loginView addSubview:line];
    
    //密码
    UITextField *passwordTextField            = [[UITextField alloc] init];
    passwordTextField.tag                     = PASSWORD_INPUT_TEXTFIELD;
    passwordTextField.frame                   = CGRectMake(80, 45, self.view.viewWidth - 80 - 88, 45);
    passwordTextField.backgroundColor         = [UIColor clearColor];
    passwordTextField.font                    = [UIFont systemFontOfSize:14];
    passwordTextField.placeholder             = @"请输入密码";
    passwordTextField.autocapitalizationType  = UITextAutocapitalizationTypeAllCharacters;
    passwordTextField.keyboardType            = UIKeyboardTypeAlphabet;
    passwordTextField.returnKeyType           = UIReturnKeyGo;
    passwordTextField.secureTextEntry         = YES;
    passwordTextField.clearButtonMode         = UITextFieldViewModeWhileEditing;
    passwordTextField.autocapitalizationType  = UITextAutocapitalizationTypeNone;
    passwordTextField.autocorrectionType      = UITextAutocorrectionTypeNo;
    passwordTextField.contentVerticalAlignment   = UIControlContentVerticalAlignmentCenter;
    self.passwdField = passwordTextField;
    self.passwdField.delegate = self;
    [self.loginView addSubview:self.passwdField];
    
    [self.view addSubview:self.loginView];
    
    NSString *forgetPassword = @"忘记密码";
    _forgetPWD = [[UILabel alloc] initWithFrame:CGRectMake(0, 8, 80, 28)];
    _forgetPWD.backgroundColor = [UIColor clearColor];
    _forgetPWD.font = [UIFont systemFontOfSize:14.0];
    _forgetPWD.textColor = MICommitButtonBackground;
    _forgetPWD.layer.borderWidth = 0.6;
    _forgetPWD.layer.borderColor = MICommitButtonBackground.CGColor;
    _forgetPWD.layer.cornerRadius = 14;
    _forgetPWD.textAlignment = UITextAlignmentCenter;
    _forgetPWD.text = forgetPassword;
    _forgetPWD.userInteractionEnabled = YES;
    [self.view addSubview:_forgetPWD];
    UITapGestureRecognizer *forgetPassWord = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goForgetPassWord)];
    [_forgetPWD addGestureRecognizer:forgetPassWord];
    _forgetPWD.left = self.passwdField.right;
    _forgetPWD.centerY = passwordTextField.centerY;
    [self.loginView addSubview:_forgetPWD];
    
    [self.view addSubview:self.loginView];
    
    UIButton *loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 120 + self.navigationBarHeight, SCREEN_WIDTH - 20, 45)];
    loginBtn.clipsToBounds = YES;
    loginBtn.layer.cornerRadius = 3.0;
    [loginBtn setTitle:@"立即登录" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBtn setBackgroundColor:[MIUtility colorWithHex:0xff8c24]];
    [loginBtn addTarget:self action:@selector(submitButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    
    UIButton *smsLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    smsLoginBtn.backgroundColor = [UIColor clearColor];
    [smsLoginBtn setTitle:@"短信快捷登录" forState:UIControlStateNormal];
    smsLoginBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [smsLoginBtn setTitleColor:[MIUtility colorWithHex:0x666666] forState:UIControlStateNormal];
    smsLoginBtn.frame = CGRectMake(0, 0, 100, 14);
    smsLoginBtn.right = loginBtn.right + 8;
    smsLoginBtn.top = loginBtn.bottom + 12;
    [smsLoginBtn addTarget:self action:@selector(goToSMSLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:smsLoginBtn];
    
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    registerBtn.backgroundColor = [UIColor clearColor];
    [registerBtn setTitle:@"新用户注册" forState:UIControlStateNormal];
    registerBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [registerBtn setTitleColor:[MIUtility colorWithHex:0x666666] forState:UIControlStateNormal];
    registerBtn.frame = CGRectMake(0, 0, 100, 14);
    registerBtn.left = loginBtn.left - 14;
    registerBtn.top = loginBtn.bottom + 12;
    [registerBtn addTarget:self action:@selector(goRegostor:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerBtn];
    
    UILabel *otherConnetLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, self.view.viewHeight - 52 - 48, self.view.viewWidth - 140, 16)];
    otherConnetLabel.backgroundColor = [UIColor clearColor];
    otherConnetLabel.font = [UIFont systemFontOfSize:16];
    otherConnetLabel.textAlignment = UITextAlignmentLeft;
    otherConnetLabel.text = @"使用合作账号登录";
    otherConnetLabel.textColor = [UIColor grayColor];
    otherConnetLabel.textAlignment = UITextAlignmentCenter;
    [self.view addSubview:otherConnetLabel];
    UILabel *splitLineLeft = [[UILabel alloc] initWithFrame:CGRectMake(otherConnetLabel.left - 60, otherConnetLabel.centerY, 60, 1)];
    splitLineLeft.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.2];
    [self.view addSubview:splitLineLeft];
    
    UILabel *splitLineRight = [[UILabel alloc] initWithFrame:CGRectMake(otherConnetLabel.right, otherConnetLabel.centerY, 60, 1)];
    splitLineRight.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.2];
    [self.view addSubview:splitLineRight];
    
    float iconWhiteSpace = (self.view.viewWidth - 52 * 3)/4.0;
    _taobaoLogin = [[UIImageView alloc] initWithFrame:CGRectMake(iconWhiteSpace, self.view.viewHeight - 52 - 16, 52, 52)];
    _taobaoLogin.userInteractionEnabled = YES;
    _taobaoLogin.layer.cornerRadius = 5.0;
    _taobaoLogin.layer.masksToBounds = YES;
    _taobaoLogin.image = [UIImage imageNamed:@"img_login_taobao"];
    [self.view addSubview:_taobaoLogin];
    
    UITapGestureRecognizer *taobaoLoginTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goTaobaoLogin)];
    [_taobaoLogin addGestureRecognizer:taobaoLoginTap];
    
    _qqLogin = [[UIImageView alloc] initWithFrame:CGRectMake(iconWhiteSpace * 2 + 52, self.view.viewHeight - 52 - 16, 52, 52)];
    _qqLogin.userInteractionEnabled = YES;
    _qqLogin.clipsToBounds = YES;
    _qqLogin.layer.cornerRadius = 5.0;
    _qqLogin.image = [UIImage imageNamed:@"img_login_qq"];
    [self.view addSubview:_qqLogin];
    
    UITapGestureRecognizer *qqLoginTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goQQLogin)];
    [_qqLogin addGestureRecognizer:qqLoginTap];
    
    _weiboLogin = [[UIImageView alloc] initWithFrame:CGRectMake(iconWhiteSpace * 3 + 52 * 2, self.view.viewHeight - 52 - 16, 52, 52)];
    _weiboLogin.userInteractionEnabled = YES;
    _weiboLogin.clipsToBounds = YES;
    _weiboLogin.layer.cornerRadius = 5.0;
    _weiboLogin.image = [UIImage imageNamed:@"img_login_weibo"];
    [self.view addSubview:_weiboLogin];
    
    UITapGestureRecognizer *weiboLoginTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goWeiboLogin)];
    [_weiboLogin addGestureRecognizer:weiboLoginTap];
    
    _emailsSuffixTableView = [[MIEmailsSuffixTableView alloc] initWithFrame:CGRectMake(_emailField.left, 62 + self.navigationBarHeight, _emailField.viewWidth, 220) style:UITableViewStylePlain];
    self.emailsSuffixTableView.emailDelegate = self;
    self.emailsSuffixTableView.loadLocalData = YES;
    self.emailsSuffixTableView.emailAndPhone = YES;
    self.emailsSuffixTableView.alpha = 0;
    [self.view addSubview:self.emailsSuffixTableView];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)goToSMSLogin
{
    if ([self.emailField isFirstResponder]) {
        [self.emailField resignFirstResponder];
    }
    
    if ([self.passwdField isFirstResponder]) {
        [self.passwdField resignFirstResponder];
    }
    
    if (_loginRegisterDelegate && [_loginRegisterDelegate respondsToSelector:@selector(goToNextController:)]) {
        [_loginRegisterDelegate goToNextController:SMSLoginType];
    }
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [self.baseTableView reloadData];
    if ([MIMainUser getInstance].loginStatus == MILoginStatusNormalLogin) {
        [self closeLoginView:nil];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)goRegostor:(UIButton *)btn
{
    if ([self.emailField isFirstResponder]) {
        [self.emailField resignFirstResponder];
    }
    
    if ([self.passwdField isFirstResponder]) {
        [self.passwdField resignFirstResponder];
    }
    
    if (_loginRegisterDelegate && [_loginRegisterDelegate respondsToSelector:@selector(goToNextController:)]) {
        [_loginRegisterDelegate goToNextController:RegisterPhoneType];
    }
}

- (void)goForgetPassWord
{
    MIForgetPWDViewController *controller = [[MIForgetPWDViewController alloc] init];
    controller.email = self.emailField.text;
    [[MINavigator navigator] openModalViewController:controller animated:YES];
//    MIChangePassViewController* vc = [[MIChangePassViewController alloc] init];
//    vc.email = self.emailField.text;
//    [[MINavigator navigator] openModalViewController:vc animated:YES];
}

- (void)goTaobaoLogin
{
    MIThirdLoginViewController *vc = [[MIThirdLoginViewController alloc] initWithOrigin:@"taobao" delegate:self];
    [[MINavigator navigator] openModalViewController:vc animated:YES];
}

- (void)goQQLogin
{
    if ([TencentOAuth iphoneQQInstalled] && [TencentOAuth iphoneQQSupportSSOLogin])
    {
        SEL invoSelector = @selector(qqloginSuccess);
        NSMethodSignature* ms = [self methodSignatureForSelector:invoSelector];
        NSInvocation* invocation = [NSInvocation invocationWithMethodSignature:ms];
        [invocation setTarget:self];
        [invocation setSelector:invoSelector];
        [[MITencentAuth getInstance] logIn:invocation];
    } else {
        MIThirdLoginViewController *vc = [[MIThirdLoginViewController alloc] initWithOrigin:@"qq" delegate:self];
        [[MINavigator navigator] openModalViewController:vc animated:YES];
    }
}

- (void)goWeiboLogin
{
    SEL invoSelector = @selector(sinaLoginSuccess);
    NSMethodSignature* ms = [self methodSignatureForSelector:invoSelector];
    NSInvocation* invocation = [NSInvocation invocationWithMethodSignature:ms];
    [invocation setTarget:self];
    [invocation setSelector:invoSelector];
    [[MISinaWeibo getInstance] logIn:invocation];
}

- (void)closeLoginView: (id) event
{
    MI_CALL_DELEGATE_WITH_ARG(_loginRegisterDelegate, @selector(closeLoginView:), event);
}

#pragma mark - MIAuthorizeViewDelegate
-(void)authFinishedSuccess:(NSString *)token;
{
    if (token) {
        [[MINavigator navigator] closeModalViewController:NO completion:^{
            MIRegisterPhoneViewController* vc = [[MIRegisterPhoneViewController alloc] initWithToken:token];
            [MIMainUser getInstance].loginStatus = MILoginStatusThirdAccountLogin;
            [[MINavigator navigator] openModalViewController:vc animated:YES];
        }];
    } else {
        [self closeLoginView:nil];
    }
}

- (void)sinaLoginSuccess
{
    __weak typeof(self) weakSelf = self;
    [self showProgressHUD:nil];
    MIUserOpenAppAuthRequest *request = [[MIUserOpenAppAuthRequest alloc] init];
    request.onCompletion = ^(MIUserOpenAppAuthModel *model)
    {
        [weakSelf hideProgressHUD];
        if (model.success.boolValue) {
            if (model.token)
            {
                [weakSelf authFinishedSuccess:model.token];
            }
            else
            {
                [MIMainUser getInstance].loginStatus = MILoginStatusThirdAccountLogin;
                [MIMainUser getInstance].sessionKey = model.session;
                [[MIMainUser getInstance] persist];
                [weakSelf getUserInfo];
            }
        } else {
            [[[UIAlertView alloc] initWithMessage:model.message] show];
        }
    };
    
    request.onError = ^(MKNetworkOperation* completedOperation, MIError* error) {
        [weakSelf hideProgressHUD];
    };
    [request setSource:@"weibo"];
    NSString *token = nil;
    if ([MISinaWeibo getInstance].refreshToken == nil) {
        token = [NSString stringWithFormat:@"%@$%@",[MISinaWeibo getInstance].accessToken,@""];
    }
    else
    {
        token = [NSString stringWithFormat:@"%@$%@",[MISinaWeibo getInstance].accessToken,[MISinaWeibo getInstance].refreshToken];
    }
    NSString *code = [NSString stringWithFormat:@"%@|%@",token,[MISinaWeibo getInstance].userID];
    [request setCode:[MIUtility encryptUseDES:code]];
    [request sendQuery];
}

- (void)qqloginSuccess
{
    __weak typeof(self) weakSelf = self;
    [self showProgressHUD:nil];
    MIUserOpenAppAuthRequest *request = [[MIUserOpenAppAuthRequest alloc] init];
    request.onCompletion = ^(MIUserOpenAppAuthModel *model)
    {
        [weakSelf hideProgressHUD];
        if (model.success.boolValue) {
            if (model.token)
            {
                [weakSelf authFinishedSuccess:model.token];
            }
            else
            {
                [MIMainUser getInstance].loginStatus = MILoginStatusThirdAccountLogin;
                [MIMainUser getInstance].sessionKey = model.session;
                [[MIMainUser getInstance] persist];
                [weakSelf getUserInfo];
            }
        } else {
            [[[UIAlertView alloc] initWithMessage:model.message] show];
        }
    };
    
    request.onError = ^(MKNetworkOperation* completedOperation, MIError* error) {
        [weakSelf hideProgressHUD];
    };
    [request setSource:@"qq"];
    NSString *token = [NSString stringWithFormat:@"%@$%@",[MITencentAuth getInstance].tencOAuth.accessToken,@""];
    NSString *code = [NSString stringWithFormat:@"%@|%@",token,[MITencentAuth getInstance].tencOAuth.openId];
    [request setCode:[MIUtility encryptUseDES:code]];
    [request sendQuery];
}


#pragma mark - MICloseRegisterDelegate
- (void)closeLoginViewController:(id)event
{
    //注册成功即完成登录
    [self closeLoginView:event];
    MILog(@"MICloseRegisterDelegate");
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.tag == EMAIL_INPUT_TEXTFIELD) {
        [self.emailsSuffixTableView loadArrayDataWith:textField.text];
    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    if (textField.tag == EMAIL_INPUT_TEXTFIELD) {
        [self.passwdField becomeFirstResponder];
    } else if (textField.tag == PASSWORD_INPUT_TEXTFIELD) {
        [self submitButtonTouched:nil];
    }
    self.emailsSuffixTableView.alpha = 0;

    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.tag == EMAIL_INPUT_TEXTFIELD) {
        NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if ([text isEqualToString:@""])
        {
            self.emailsSuffixTableView.alpha = 0;
        }
        else
        {
            [self.emailsSuffixTableView loadArrayDataWith:text];
        }
    }
    return YES;
}
- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    self.emailsSuffixTableView.alpha = 0;
    return YES;
}

-(void)keyboardWillShow:(NSNotification *)notification{
    if (self.emailsSuffixTableView.emailSuffixArray.count) {
        NSDictionary* info = notification.userInfo;
        NSValue* kbFrameValue = [info valueForKey:UIKeyboardFrameEndUserInfoKey];
        
        [UIView animateWithDuration:[[info valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
            self.emailsSuffixTableView.viewHeight = self.view.viewHeight - self.navigationBarHeight - 62 - [kbFrameValue CGRectValue].size.height;
        } completion:^(BOOL finished){
            
        }];
    }
}
#pragma mark - Submit button

- (BOOL)validatorTextField:(UITextField *)validatorTextField
{
    BOOL success = NO;
    NSString *errorMsg = @"";
    if ([validatorTextField isEqual:self.emailField]) {
        success = [MIUtility validatorEmail:validatorTextField.text];
        errorMsg = @"请输入正确的邮箱地址，例如 example@example.com";
    } else if ([validatorTextField isEqual:self.passwdField]) {
        success = [MIUtility validatorRange:NSMakeRange(6, 16) text:validatorTextField.text];
        errorMsg = @"请输入6-16个字符长度的密码";
    }
    
    if (success == NO) {
        MIButtonItem *cancelItem = [MIButtonItem itemWithLabel:@"知道了"];
        cancelItem.action = ^{
            [validatorTextField becomeFirstResponder];
        };
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"无效的输入" message:errorMsg cancelButtonItem:cancelItem otherButtonItems:nil, nil];
        [alertView show];
    }
    
    return success;
}

- (void)submitButtonTouched:(UIButton *)btn
{
    NSString* email = [self.emailField text];
    NSString* password = [self.passwdField text];
    
    self.emailsSuffixTableView.alpha = 0;
    
    if (email == nil || password == nil || [email length] <= 0 || [password length] <= 0) {
        [self showSimpleHUD:@"请输入完整信息"];
        return;
    }
    
    if (![MIUtility validatorEmail:self.emailField.text] && ![MIUtility validatorNumeric:self.emailField.text]) {
        MIButtonItem *cancelItem = [MIButtonItem itemWithLabel:@"知道了"];
        cancelItem.action = ^{
            [self.emailField becomeFirstResponder];
        };
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"无效的输入" message:@"您输入的手机号或邮箱不符合规范" cancelButtonItem:cancelItem otherButtonItems:nil, nil];
        [alertView show];
        return;
    }
    
    NSMutableString *emailAndPassword = [NSMutableString string];
    [emailAndPassword appendString:email];
    [emailAndPassword appendFormat:@"%@%@",@"   ",password];
    NSString *encryptPWDUseDES = [MIUtility encryptUseDES:emailAndPassword];
    if (encryptPWDUseDES == nil) {
        [self showSimpleHUD:@"系统出错了，请稍后再试"];
        return;
    }
    
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.removeFromSuperViewOnHide = YES;
    _hud.yOffset = -80.0f;
    
    __weak typeof(self) weakSelf = self;
    __weak typeof(_hud) bhud = _hud;
    MILoginRequest *request = [[MILoginRequest alloc] init];
    [request setUserNameAndPassWord:encryptPWDUseDES];
    request.onCompletion = ^(MIUserAuthModel * model) {
        if ([model.success boolValue] == TRUE) {
            [MobClick event:kLogined];
            
            MIMainUser *mainUser = [MIMainUser getInstance];
            mainUser.loginStatus = MILoginStatusNormalLogin;
            mainUser.sessionKey = model.data;
            mainUser.loginAccount = [email lowercaseString];
            mainUser.DESPassword = [MIUtility encryptUseDES:password];
            [mainUser persist];
            [weakSelf performSelector:@selector(getUserInfo) withObject:nil afterDelay:0.5];
        } else {
            [bhud hide:YES];
            [weakSelf showAlertView:model.message];
        }
    };
    request.onError = ^(MKNetworkOperation* completedOperation, MIError* error) {
        [bhud hide:YES];
    };
    
    [request sendQuery];
}


- (void)getUserInfo
{
    __weak typeof(self) weakSelf = self;
    __weak typeof(_hud) bhud = _hud;
    
    MIUserGetRequest *_request = [[MIUserGetRequest alloc] init];
    _request.onCompletion = ^(MIUserGetModel * model) {
        [bhud hide:YES];
        [[MIMainUser getInstance] saveUserInfo:model];
        [weakSelf closeLoginView:nil];
    };
    
    _request.onError = ^(MKNetworkOperation* completedOperation, MIError* error) {
        [bhud hide:YES];
        [[MIMainUser getInstance] logout];
    };
    [_request sendQuery];
}

- (void)showAlertView:(NSString *)message
{
    if (!message) {
        message = @"当前网络繁忙，请稍后再试";
    }
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
    [alertView show];
}

- (void)finishChoosingEmail:(NSString *)text
{
    self.emailField.text = text;
    self.emailsSuffixTableView.alpha = 0;
}

@end
