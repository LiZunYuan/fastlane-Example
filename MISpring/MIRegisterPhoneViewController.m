//
//  BBQuickRegisterViewController.m
//  BeiBeiAPP
//
//  Created by yujian on 14-10-20.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MIRegisterPhoneViewController.h"

#import "MIUserCodeSendRequest.h"
#import "MIUserCodeSendModel.h"
#import "MIRegisterRequest.h"
#import "MIUserRegisterModel.h"

#import "MIUserQuickJoinRequest.h"
#import "MIUserQuickJoinModel.h"

//#import "BBEmailBindViewController.h"
//#import "BBRegisterViewController.h"
//#import "BBModalWebViewController.h"
#import "MIPhoneRegisterView.h"
#import "MIAppDelegate.h"
#import "MIUserGetRequest.h"
#import "MIUserGetModel.h"
#import "MIEmailBindViewController.h"

@interface MIRegisterPhoneViewController ()<MICloseRegisterDelegate>
{
    MIPhoneRegisterView *_phoneRegisterView;
    MIUserCodeSendRequest *_codeRequest;
    NSInteger _currentKeyboardHeight;
    UIScrollView *_scrollView;
    NSInteger _counter;
    NSString *_token;
    UIButton *_submitBtn;
}

@property (nonatomic, strong) NSTimer *counttingTimer;
@property (nonatomic, strong) MIPhoneRegisterView *phoneRegisterView;

@end

@implementation MIRegisterPhoneViewController

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (id)initWithToken:(NSString *)token
{
    self = [super init];
    if (self)
    {
        _token = token;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationBar setBarLeftButtonItem:self selector:@selector(closeRegisterView:) imageKey:@"navigationbar_btn_close"];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.navigationBarHeight, self.view.viewWidth, self.view.viewHeight - self.navigationBarHeight)];
    _scrollView.delegate = self;
    _scrollView.contentSize = CGSizeMake(self.view.viewWidth, self.view.viewHeight);
    [self.view addSubview:_scrollView];
    
    _phoneRegisterView = [[[NSBundle mainBundle]loadNibNamed:@"MIPhoneRegisterView" owner:self options:nil] objectAtIndex:0];
    _phoneRegisterView.delegate = self;
    _phoneRegisterView.frame = CGRectMake(0, 10, PHONE_SCREEN_SIZE.width, _phoneRegisterView.viewHeight);
    [_phoneRegisterView.getCodeBtn addTarget:self action:@selector(getUserCode) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_phoneRegisterView];
    
    
    _submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _submitBtn.frame = CGRectMake(10, 0, self.view.viewWidth - 20, 45);
    _submitBtn.backgroundColor = MICommitButtonBackground;
    _submitBtn.clipsToBounds = YES;
    _submitBtn.layer.cornerRadius = 3;
    _submitBtn.top = _phoneRegisterView.bottom + 10;
    if (_token)
    {
        [self.navigationBar setBarTitle:@"绑定手机"];
        [_submitBtn setTitle:@"立即开通" forState:UIControlStateNormal];
        [self.navigationBar setBarRightTextButtonItem:self selector:@selector(goToBind) title:@"绑定邮箱"];
        self.navigationBar.rightButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    }
    else
    {
        [self.navigationBar setBarTitle:@"快速注册"];
        [_submitBtn setTitle:@"立即注册" forState:UIControlStateNormal];
        
        [self.navigationBar setBarRightTextButtonItem:self selector:@selector(goLogin:) title:@"登录"];
        
        if ([MIConfig globalConfig].emailRegisterOpen.integerValue) {
            UIButton *emailRegisterButton = [UIButton buttonWithType:UIButtonTypeCustom];
            emailRegisterButton.frame = CGRectMake(10, 0, self.view.viewWidth - 20, 30);
            emailRegisterButton.backgroundColor = [UIColor clearColor];
            [emailRegisterButton addTarget:self action:@selector(goToEmailRegister) forControlEvents:UIControlEventTouchUpInside];
            [emailRegisterButton setTitle:@"邮箱注册>>" forState:UIControlStateNormal];
            [emailRegisterButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            emailRegisterButton.titleLabel.font = [UIFont systemFontOfSize:12.0];
            emailRegisterButton.bottom = _scrollView.frame.size.height;
            [_scrollView addSubview:emailRegisterButton];
        }
    }
    [_submitBtn addTarget:self action:@selector(quickRegister) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_submitBtn];
    
    __weak typeof(self) weakSelf = self;
    _codeRequest = [[MIUserCodeSendRequest alloc] init];
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
    _currentKeyboardHeight = 0;
    
    if (_token) {
        UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.view.viewWidth - 20, 30)];
        tipLabel.font = [UIFont systemFontOfSize:12.0];
        tipLabel.text = @"提示：您是通过第三方账号登录米折的，为了保障您的账号和资金安全，请先绑定手机号和设置密码";
        tipLabel.numberOfLines = 2;
        tipLabel.textColor = [MIUtility colorWithHex:0x999999];
        tipLabel.top = _submitBtn.bottom + 5;
        [_scrollView addSubview:tipLabel];
        [_codeRequest setKey:@"bind_phone_up_pass"];
    }
    else
    {
        [_codeRequest setKey:@"register"];
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
        
}

-(void)dismissKeyboard
{
    [self.view endEditing:YES];
}

- (void)goToEmailRegister
{
    MIRegisterViewController *controller = [[MIRegisterViewController alloc] init];
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:^{
        
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
}

- (void)textFieldBeginEditing:(UITextField *)textField
{
    if (_currentKeyboardHeight != 0 && _phoneRegisterView.currentTextField != _phoneRegisterView.phoneRegisterTextField)
    {
        NSInteger dValue = _currentKeyboardHeight - (_scrollView.viewHeight - _submitBtn.bottom);
        if (dValue > 0) {
            [_scrollView setContentOffset:CGPointMake(0, dValue) animated:YES];
        }
    }
    else
    {
        [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}

-(void)keyboardDidHide:(NSNotification *)notification{
    [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

-(void)keyboardDidShow:(NSNotification *)notification{
    if (_phoneRegisterView.currentTextField)
    {
        NSDictionary* info = notification.userInfo;
        NSValue* kbFrameValue = [info valueForKey:UIKeyboardFrameEndUserInfoKey];
        _currentKeyboardHeight = [kbFrameValue CGRectValue].size.height;
        NSInteger dValue = _currentKeyboardHeight - (_scrollView.viewHeight - _submitBtn.bottom);
        if (_phoneRegisterView.currentTextField != _phoneRegisterView.phoneRegisterTextField && dValue > 0)
        {
            [_scrollView setContentOffset:CGPointMake(0, dValue) animated:YES];
        }
    }
}

- (void)goToBind
{
    [[MINavigator navigator] closeModalViewController:NO completion:^{
        if (_token)
        {
            MIEmailBindViewController *emailController = [[MIEmailBindViewController alloc] initWithToken:_token];
            [[MINavigator navigator] openPushViewController:emailController animated:YES];
        }
    }];
}

- (void)goLogin: (id)sender
{
    if ([_phoneRegisterView.phoneRegisterTextField isFirstResponder]) {
        [_phoneRegisterView.phoneRegisterTextField resignFirstResponder];
    }
    
    if ([_phoneRegisterView.passwordTextField isFirstResponder]) {
        [_phoneRegisterView.passwordTextField resignFirstResponder];
    }
//    if ([_phoneRegisterView.passwordSecondTextField isFirstResponder]) {
//        [_phoneRegisterView.passwordSecondTextField resignFirstResponder];
//    }
    if ([_phoneRegisterView.codeTextField isFirstResponder]) {
        [_phoneRegisterView.codeTextField resignFirstResponder];
    }
    
    if (_loginRegisterDelegate && [_loginRegisterDelegate respondsToSelector:@selector(goToNextController:)]) {
        [_loginRegisterDelegate goToNextController:LoginType];
    }
}

- (void)closeLoginViewController:(id)event
{
    if (_loginRegisterDelegate && [_loginRegisterDelegate respondsToSelector:@selector(closeLoginView:)]) {
        [_loginRegisterDelegate closeLoginView:event];
    } else {
        [[MINavigator navigator] closeModalViewController:YES completion:nil];
    }
}

- (void)closeRegisterView: (id) event
{
    if ([MIMainUser getInstance].loginStatus == MILoginStatusThirdAccountLogin) {
        [[MIMainUser getInstance] logout];
        [[MINavigator navigator] closeModalViewController:YES completion:nil];
    } else {
        [self closeLoginViewController:event];
    }
}



- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_codeRequest cancelRequest];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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

- (void)confirmRegister:(id)event
{
    [self quickRegister];
}

- (void)quickRegister
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
    else if(_phoneRegisterView.passwordTextField.text == nil || [_phoneRegisterView.passwordTextField.text isEqualToString:@""])
    {
        [self showSimpleHUD:@"请输入密码" afterDelay:1];
        [_phoneRegisterView.passwordTextField becomeFirstResponder];
    }
    else
    {
        NSString *phoneAndPassword = [NSString stringWithFormat:@"%@   %@   %@",_phoneRegisterView.phoneRegisterTextField.text,_phoneRegisterView.passwordTextField.text,_phoneRegisterView.codeTextField.text];
        NSString *encryptPWDUseDES = [MIUtility encryptUseDES:phoneAndPassword];
        if (encryptPWDUseDES == nil) {
            [self showSimpleHUD:@"系统出错了，请稍后再试"];
            return;
        }
        
        NSString *password = _phoneRegisterView.passwordTextField.text;
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
                    [MobClick event:kPhoneRegister];
                    NSNumber *time1 = [NSNumber numberWithInteger:[[NSUserDefaults standardUserDefaults] integerForKey:kActiveTime]];
                    NSNumber *time2 = [NSNumber numberWithInteger:[[NSDate date] timeIntervalSince1970]];
                    if ([time1 isSameDay:time2]) {
                        [MobClick event:kNowNewRegister];
                    }
                    MIMainUser *mainUser = [MIMainUser getInstance];
                    mainUser.sessionKey = model.data;
                    mainUser.DESPassword = [MIUtility encryptUseDES:password];
                    [mainUser persist];
                    [weakSelf getUserInfo:nil];
                    
                    if ([MIConfig globalConfig].notificationSource) {
                        [MobClick event:kNotifyNewRegister];
                    }
                } else {
                    [bhud hide:YES];
                    [[[UIAlertView alloc] initWithMessage:model.message] show];
                }
            };
            request.onError = ^(MKNetworkOperation* completedOperation, MIError* error) {
                MILog(@"error_msg=%@",error.description);
                [bhud hide:YES];
            };
            [request sendQuery];
        } else {
            //通过第三方登录进来，需要重新绑定邮箱
            MIUserQuickJoinRequest *request = [[MIUserQuickJoinRequest alloc] init];
            [request setBindType:@"bind_new_phone"];
            NSString *password = _phoneRegisterView.passwordTextField.text;
            NSString *phoneAndPassword2 = [NSString stringWithFormat:@"%@   %@   %@",_phoneRegisterView.phoneRegisterTextField.text,_phoneRegisterView.passwordTextField.text,_phoneRegisterView.codeTextField.text];
            NSString *encryptPWDUseDES2 = [MIUtility encryptUseDES:phoneAndPassword2];
            [request setEmailAndPwd:encryptPWDUseDES2];
            if (_token)
            {
                [request setToken:_token];
            }
            request.onCompletion = ^(MIUserQuickJoinModel * model) {
                if ([model.success boolValue] == TRUE) {
                    [MIMainUser getInstance].sessionKey = model.data;
                    [MIMainUser getInstance].DESPassword = [MIUtility encryptUseDES:password];
                    [[MIMainUser getInstance] persist];
                    [weakSelf performSelector:@selector(getUserInfo:) withObject:nil afterDelay:0.5];
                } else {
                    [bhud hide:YES];
                    [[[UIAlertView alloc] initWithMessage:model.message] show];
                }
            };
            request.onError = ^(MKNetworkOperation* completedOperation, MIError* error) {
                MILog(@"error_msg=%@",error.description);
                [bhud hide:YES];
            };
            [request sendQuery];
        }

    }
}

- (void)getUserInfo:(NSDictionary *)dic
{
    __weak typeof(self) weakSelf = self;
    MIUserGetRequest *request = [[MIUserGetRequest alloc] init];
    request.onCompletion = ^(MIUserGetModel * model) {
        [_hud hide:YES];
        [MIMainUser getInstance].loginStatus = MILoginStatusNormalLogin;
        [[MIMainUser getInstance] saveUserInfo:model];
        [weakSelf closeRegisterView:nil];
    };
    
    request.onError = ^(MKNetworkOperation* completedOperation, MIError* error) {
        [error showHUD];
        [_hud hide:YES];
        //[weakSelf showSimpleHUD:@"网络繁忙，授权失败"];
    };
    [request sendQuery];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

-(void)destoryTimer
{
    [_counttingTimer invalidate];
    _counttingTimer = nil;
    
    [_phoneRegisterView.getCodeBtn.layer setBorderColor:MICodeButtonBackground.CGColor];
    [_phoneRegisterView.getCodeBtn setTitleColor:MICodeButtonBackground forState:UIControlStateNormal];
    [_phoneRegisterView.getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    _phoneRegisterView.getCodeBtn.userInteractionEnabled = YES;
}

-(void)stopHandleTimer
{
    [self destoryTimer];
}

#pragma mark - UIScrollViewDelegate Methods
//滚动控件的委托方法
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [super scrollViewDidScroll:scrollView];
    [_phoneRegisterView.currentTextField resignFirstResponder];
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
