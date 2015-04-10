//
//  MIRegisterViewController.m
//  MISpring
//
//  Created by Yujian Xu on 13-3-18.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIRegisterViewController.h"
#import "MIRegisterRequest.h"
#import "MIUserRegisterModel.h"
#import "MIUITextButton.h"
#import "MIUserGetRequest.h"
#import "MIQuickJoinRequest.h"
#import "MIUserQuickJoinModel.h"
#import "MIEmailRegisterView.h"

#define EMAIL_INPUT_TEXTFIELD    1
#define PASSWORD_INPUT_TEXTFIELD 2

@interface MIRegisterViewController ()
{
    MIEmailRegisterView *_emailRegisterView;
}

@end

@implementation MIRegisterViewController
@synthesize emailField = _emailField;
@synthesize passwdField = _passwdField;
@synthesize registerBtn = _registerBtn;
@synthesize emailText = _emailText;
@synthesize passwordText = _passwordText;
@synthesize delegate = _delegate;

- (id)initWithToken:(NSString *)token
{
    self = [super init];
    if (self)
    {
        _token = token;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.navigationBar setBarLeftButtonItem:self selector:@selector(clickClose) imageKey:@"navigationbar_btn_close"];
    //    邮箱注册界面
    _emailRegisterView = [[[NSBundle mainBundle] loadNibNamed:@"MIEmailRegisterView" owner:self options:nil] objectAtIndex:0];
    _emailRegisterView.frame = CGRectMake(0, self.navigationBarHeight + 20, _emailRegisterView.viewWidth, _emailRegisterView.viewHeight);
    [self.view addSubview:_emailRegisterView];
    
    self.emailField = _emailRegisterView.emailTextField;
    self.emailField.delegate = self;
    self.emailField.tag = EMAIL_INPUT_TEXTFIELD;
    self.passwdField = _emailRegisterView.emailPasswdTextField;
    self.passwdField.delegate = self;
    self.passwdField.tag = PASSWORD_INPUT_TEXTFIELD;
    //    self.passwdCheckField = _emailRegisterView.passwdCheckTextField;
    //    self.passwdCheckField.delegate = self;
    //    self.passwdCheckField.tag = PASSWORD_CHECK_TEXTFIELD;
    
    [self.navigationBar setBarTitle:@"邮箱注册"];
    
    NSString *registerBtnTitle;
    if ([MIMainUser getInstance].loginStatus == MILoginStatusNotLogined) {
        registerBtnTitle = @"免费注册";
        [self.navigationBar setBarTitle:@"注册米折"];
//        [self.navigationBar setBarRightTextButtonItem:self selector:@selector(goLogin:) title:@"登录"];
    } else {
        //从第三方登录进来只需要绑定邮箱及设置密码
        registerBtnTitle = @"立即绑定";
        [self.navigationBar setBarTitle:@"绑定邮箱"];
        RTLabel *accountSettingTip = [[RTLabel alloc] initWithFrame:CGRectMake(10, 180 + self.navigationBarHeight, SCREEN_WIDTH - 20, self.view.viewHeight - self.navigationBarHeight - 180)];
        accountSettingTip.backgroundColor = [UIColor clearColor];
        accountSettingTip.font = [UIFont systemFontOfSize:14.0];
        accountSettingTip.lineBreakMode = kCTLineBreakByCharWrapping;
        accountSettingTip.lineSpacing = 5.0;
        accountSettingTip.text = [[NSString alloc] initWithFormat:@"<font size=18.0 color='#499d00'>提示：</font> \n你是通过第三方账号快捷登录米折网，为了保障你的账号和资金安全，请绑定邮箱和设置密码"];
        [self.view addSubview:accountSettingTip];
    }
    
    self.registerBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, _emailRegisterView.bottom + 20, SCREEN_WIDTH - 20, 40)];
    self.registerBtn.backgroundColor = MICommitButtonBackground;
    [self.registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.registerBtn.clipsToBounds = YES;
    self.registerBtn.layer.cornerRadius = 3;
    [self.registerBtn setTitle:registerBtnTitle forState:UIControlStateNormal];
    [self.registerBtn addTarget:self action:@selector(submitButtonTouched) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.registerBtn];
    
    _emailsSuffixTableView = [[MIEmailsSuffixTableView alloc] initWithFrame:CGRectMake(_emailField.left, 62 + self.navigationBarHeight, self.view.right - _emailField.left, 220) style:UITableViewStylePlain];
    _emailsSuffixTableView.right = self.view.right;
    self.emailsSuffixTableView.emailDelegate = self;
    self.emailsSuffixTableView.alpha = 0;
    [self.view addSubview:self.emailsSuffixTableView];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
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

- (void)closeRegisterView:(id)event
{
    if ([MIMainUser getInstance].loginStatus == MILoginStatusThirdAccountLogin) {
        [[MIMainUser getInstance] logout];
        [[MINavigator navigator] closeModalViewController:YES completion:nil];
    } else {
        BOOL animated = NO;
        if (![self.registerBtn.titleLabel.text isEqualToString:@"免费注册"]) {
            animated = YES;
        }
        [[MINavigator navigator] closeModalViewController:animated completion:^{
            MI_CALL_DELEGATE_WITH_ARG(_delegate, @selector(closeLoginViewController:), event);
        }];
    }
}

- (void)clickClose {
    [[MINavigator navigator] closeModalViewController:YES completion:^{
    }];
}

- (void)goLogin: (id)sender
{
    if ([self.emailField isFirstResponder]) {
        [self.emailField resignFirstResponder];
    }
    
    if ([self.passwdField isFirstResponder]) {
        [self.passwdField resignFirstResponder];
    }
    
    [[MINavigator navigator] closeModalViewController:YES completion:nil];
}

#pragma mark - Validator text field protocol
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
        [self submitButtonTouched];
    }
    self.emailsSuffixTableView.alpha = 0;

    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.tag == EMAIL_INPUT_TEXTFIELD) {
        NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
        [self.emailsSuffixTableView loadArrayDataWith:text];
    }
    return YES;
}
- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    self.emailsSuffixTableView.alpha = 0;
    return YES;
}

-(void)keyboardWillShow:(NSNotification *)notification{
    NSDictionary* info = notification.userInfo;
    NSValue* kbFrameValue = [info valueForKey:UIKeyboardFrameEndUserInfoKey];
    
    [UIView animateWithDuration:[[info valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        self.emailsSuffixTableView.viewHeight = self.view.viewHeight - self.navigationBarHeight - 62 - ([kbFrameValue CGRectValue].size.height);
    } completion:^(BOOL finished){
        
    }];
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

- (void)submitButtonTouched
{
    NSString* email = [self.emailField text];
    NSString* password = [self.passwdField text];
    if (email == nil || password == nil || [email length] <= 0 || [password length] <= 0) {
        [self showSimpleHUD:@"请输入完整信息"];
        return;
    }

    if (![self validatorTextField:self.emailField] || ![self validatorTextField:self.passwdField]) {
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
    if ([MIMainUser getInstance].loginStatus == MILoginStatusNotLogined) {
        MIRegisterRequest *request = [[MIRegisterRequest alloc] init];
        [request setUserNameAndPassWord:encryptPWDUseDES];
        [request setChannelId:[MIConfig globalConfig].channelId];
        request.onCompletion = ^(MIUserRegisterModel * model) {
            if ([model.success boolValue] == TRUE) {
                [MobClick event:kNewRegister];
                NSNumber *time1 = [NSNumber numberWithInteger:[[NSUserDefaults standardUserDefaults] integerForKey:kActiveTime]];
                NSNumber *time2 = [NSNumber numberWithInteger:[[NSDate date] timeIntervalSince1970]];
                if ([time1 isSameDay:time2]) {
                    [MobClick event:kNowNewRegister];
                }

                MIMainUser *mainUser = [MIMainUser getInstance];
                mainUser.sessionKey = model.data;
                mainUser.loginAccount = [email lowercaseString];
                mainUser.DESPassword = [MIUtility encryptUseDES:password];
                [mainUser persist];
                [weakSelf getUserInfo];
                
                if ([MIConfig globalConfig].notificationSource) {
                    [MobClick event:kNotifyNewRegister];
                }
            } else {
                [bhud hide:YES];
                [weakSelf showAlertView:model.message];
            }
        };
        request.onError = ^(MKNetworkOperation* completedOperation, MIError* error) {
            MILog(@"error_msg=%@",error.description);
            [bhud hide:YES];
        };
        [request sendQuery];
    } else {
        MIQuickJoinRequest *request = [[MIQuickJoinRequest alloc] init];
        [request setUserNameAndPassWord:encryptPWDUseDES];
        [request setToken:_token];
        request.onCompletion = ^(MIUserQuickJoinModel * model) {
            if ([model.success boolValue] == TRUE) {
                [MobClick event:kNewRegister];
                
                MIMainUser *mainUser = [MIMainUser getInstance];
                mainUser.loginAccount = [email lowercaseString];
                mainUser.DESPassword = [MIUtility encryptUseDES:password];
                mainUser.sessionKey = model.data;
                [mainUser persist];
                [weakSelf performSelector:@selector(getUserInfo) withObject:nil afterDelay:0.5];
            } else {
                [bhud hide:YES];
                [weakSelf showAlertView:model.message];
            }
        };
        request.onError = ^(MKNetworkOperation* completedOperation, MIError* error) {
            MILog(@"error_msg=%@",error.description);
            [bhud hide:YES];
        };
        [request sendQuery];
    }
}

- (void)getUserInfo
{
    __weak typeof(self) weakSelf = self;
    MIUserGetRequest *_request = [[MIUserGetRequest alloc] init];
    _request.onCompletion = ^(MIUserGetModel * model) {
        [_hud hide:YES];
        [MIMainUser getInstance].loginStatus = MILoginStatusNormalLogin;
        [[MIMainUser getInstance] saveUserInfo:model];
        [weakSelf closeRegisterView:nil];
    };

    _request.onError = ^(MKNetworkOperation* completedOperation, MIError* error) {
        [_hud hide:YES];
    };
    [_request sendQuery];
}

- (void)showAlertView:(NSString *)message
{
    NSString *alertMessage = message;
    if (!alertMessage) {
        alertMessage = @"当前网络繁忙，请稍后再试";
    }
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                        message:alertMessage
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
