//
//  BBEmailBindViewController.m
//  BeiBeiAPP
//
//  Created by yujian on 14-10-22.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MIEmailBindViewController.h"
#import "MIUserQuickJoinRequest.h"
#import "MIUserQuickJoinModel.h"
#import "MIRegisterPhoneViewController.h"

#import "MIAdService.h"
#import "MIAppDelegate.h"
#import "MIUserGetRequest.h"
#import "MIQuickJoinRequest.h"

@interface MIEmailBindViewController ()
{
    MIBindEmailView *_bindEmailView;
    NSString *_token;
}

@end

@implementation MIEmailBindViewController

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
    _bindEmailView = [[[NSBundle mainBundle] loadNibNamed:@"MIBindEmailView" owner:self options:nil] objectAtIndex:0];
    _bindEmailView.delegate = self;
    _bindEmailView.frame = CGRectMake(0, 10 + self.navigationBarHeight, self.view.viewWidth, 90);
    [self.view addSubview:_bindEmailView];
    
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame = CGRectMake(10, 0, self.view.viewWidth - 20, 45);
    submitBtn.backgroundColor = MICommitButtonBackground;
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    submitBtn.clipsToBounds = YES;
    submitBtn.layer.cornerRadius = 3;
    submitBtn.top = _bindEmailView.bottom + 10;
    [submitBtn setTitle:@"立即绑定" forState:UIControlStateNormal];

    [self.navigationBar setBarTitle:@"绑定邮箱"];
    _bindEmailView.emailTextField.placeholder = @"请输入邮箱";
    [submitBtn addTarget:self action:@selector(quickBind) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:submitBtn];
    
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.view.viewWidth - 20, 30)];
    tipLabel.font = [UIFont systemFontOfSize:12.0];
    tipLabel.text = @"提示：您是通过第三方账号登录米折的，为了保障您的账号和资金安全，请先绑定手机号或邮箱";
    tipLabel.numberOfLines = 2;
    tipLabel.textColor = [MIUtility colorWithHex:0x999999];
    tipLabel.top = submitBtn.bottom + 5;
    [self.view addSubview:tipLabel];
    _tipLabel = tipLabel;
    if ([MIMainUser getInstance].loginStatus == MILoginStatusThirdAccountLogin) {
        _tipLabel.hidden = NO;
    }else{
        _tipLabel.hidden = YES;
    }
    
    if (_token) {
        [self.navigationBar setBarRightTextButtonItem:self selector:@selector(goToRegister) title:@"绑定手机"];
        self.navigationBar.rightButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    }
}

- (void)goToRegister
{
    if (_token)
    {
        [[MINavigator navigator] closePopViewControllerAnimated:NO];
        MIRegisterPhoneViewController *controller = [[MIRegisterPhoneViewController alloc] initWithToken:_token];
        [[MINavigator navigator] openModalViewController:controller animated:YES];
    }
}


- (void)confirmBindEmail:(id)event
{
    [self quickBind];
}

- (void)quickBind
{
    if (![MIUtility validatorEmail:_bindEmailView.emailTextField.text] && ![MIUtility validatorNumeric:_bindEmailView.emailTextField.text])
    {
        MIButtonItem *cancelItem = [MIButtonItem itemWithLabel:@"知道了"];
        cancelItem.action = ^{
            [_bindEmailView.emailTextField becomeFirstResponder];
        };
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"无效的输入" message:@"您输入的手机号或邮箱不符合规范" cancelButtonItem:cancelItem otherButtonItems:nil, nil];
        [alertView show];
        return;
    }
    
    MIUserQuickJoinRequest *request = [[MIUserQuickJoinRequest alloc] init];
    NSString *phoneAndPassword = [NSString stringWithFormat:@"%@   %@",_bindEmailView.emailTextField.text,_bindEmailView.passwordTextField.text];
    NSString *encryptPWDUseDES = [MIUtility encryptUseDES:phoneAndPassword];
    __weak typeof(self) weakSelf = self;
    [request setEmailAndPwd:encryptPWDUseDES];
    NSString *password = _bindEmailView.passwordTextField.text;
    if (_token)
    {
        [request setToken:_token];
    }
    request.onCompletion = ^(MIUserQuickJoinModel * model) {
        [self hideProgressHUD];
        if ([model.success boolValue] == TRUE) {
            [MIMainUser getInstance].sessionKey = model.data;
            [MIMainUser getInstance].DESPassword = [MIUtility encryptUseDES:password];
            [[MIMainUser getInstance] persist];
            [weakSelf performSelector:@selector(getUserInfo) withObject:nil afterDelay:0.5];
        } else {
            [[[UIAlertView alloc] initWithMessage:model.message] show];
        }
    };
    request.onError = ^(MKNetworkOperation* completedOperation, MIError* error) {
        MILog(@"error_msg=%@",error.description);
        [self hideProgressHUD];
    };
    [self showProgressHUD:nil];
    [request sendQuery];
}

- (void)getUserInfo
{
    MIUserGetRequest *request = [[MIUserGetRequest alloc] init];
    request.onCompletion = ^(MIUserGetModel * model) {
        [MIMainUser getInstance].loginStatus = MILoginStatusNormalLogin;
        [[MIAdService sharedManager] clearCache];
        [[MIMainUser getInstance] saveUserInfo:model];
        [[MINavigator navigator] closePopViewControllerAnimated:YES];
    };
    
    request.onError = ^(MKNetworkOperation* completedOperation, MIError* error) {
        [error showHUD];
        //[weakSelf showSimpleHUD:@"网络繁忙，授权失败"];
    };
    [request sendQuery];
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
