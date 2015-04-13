//
//  BB11111ViewController.m
//  BeiBeiAPP
//
//  Created by yujian on 14-10-22.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MIFindPasswordBackViewController.h"
#import "MIUserCodeSendRequest.h"
#import "MIUserCodeSendModel.h"
#import "MIUserPasswdUpdateRequest.h"
#import "MIUserPasswdUpdateModel.h"

@interface MIFindPasswordBackViewController ()
{
    MIFindBackView *_findBackView;
    MIUserCodeSendRequest *_codeRequest;
    MIUserPasswdUpdateRequest *_updateRequest;
    UIView *_bacView;
    NSInteger _counter;
}

@property (nonatomic, strong) MIFindBackView *findBackView;
@property (nonatomic, strong) NSTimer *counttingTimer;

@end

@implementation MIFindPasswordBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationBar setBarTitle:@"找回密码"];
    _bacView = [[UIView alloc] initWithFrame:CGRectMake(0, self.navigationBarHeight, self.view.viewWidth, self.view.viewHeight - self.navigationBarHeight)];
    [self.view sendSubviewToBack:_bacView];
    _bacView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:_bacView];
    
    [self.navigationBar setBarLeftButtonItem:self selector:@selector(closeFindPassword) imageKey:@"navigationbar_btn_close"];
    RTLabel *topLabel = [[RTLabel alloc] initWithFrame:CGRectMake(20, 8, self.view.viewWidth - 40, 40)];
    topLabel.font = [UIFont systemFontOfSize:12.0];
    topLabel.textAlignment = RTTextAlignmentCenter;
    topLabel.lineSpacing = 3;
    topLabel.text = [NSString stringWithFormat:@"<font color='#999999'>点击获取验证码。系统会给您账号所绑定或注册的手机号</font>%@<font color='#999999'>发送一条验证短信</font>",[_phoneNum getSimpleEmailString]];
    [_bacView addSubview:topLabel];
    
    _findBackView = [[[NSBundle mainBundle] loadNibNamed:@"MIFindBackView" owner:self options:nil] objectAtIndex:0];
    _findBackView.viewWidth = SCREEN_WIDTH;
    _findBackView.delegate = self;
    _findBackView.top = topLabel.bottom;
    [_findBackView.getCodeBtn addTarget:self action:@selector(getUserCode) forControlEvents:UIControlEventTouchUpInside];
    [_bacView addSubview:_findBackView];
    
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame = CGRectMake(10, 0, self.view.viewWidth - 20, 45);
    submitBtn.backgroundColor = MICommitButtonBackground;
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    submitBtn.clipsToBounds = YES;
    submitBtn.layer.cornerRadius = 3;
    submitBtn.top = _findBackView.bottom + 10;
    [submitBtn setTitle:@"确定" forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    [_bacView addSubview:submitBtn];
    
    __weak typeof(self) weakSelf = self;
    _codeRequest = [[MIUserCodeSendRequest alloc] init];
    _codeRequest.onCompletion = ^(MIUserCodeSendModel *model) {
        [weakSelf hideProgressHUD];
        if (model.success.boolValue) {
            weakSelf.counttingTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:weakSelf selector:@selector(handleTimer:)  userInfo:nil  repeats:YES];
            [weakSelf.counttingTimer fire];
            weakSelf.findBackView.getCodeBtn.userInteractionEnabled = NO;
            [weakSelf showSimpleHUD:model.message];
        } else {
            [[[UIAlertView alloc] initWithMessage:model.message] show];
        }
    };
    _codeRequest.onError = ^(MKNetworkOperation* completedOperation, MIError* error) {
        [weakSelf hideProgressHUD];
        MILog(@"error_msg=%@",error.description);
    };
    [_codeRequest setKey:@"find_password"];
    [_codeRequest setTel:self.phoneNum];
    
    _updateRequest = [[MIUserPasswdUpdateRequest alloc] init];
    _updateRequest.onCompletion = ^(MIUserPasswdUpdateModel * model) {
        [weakSelf hideProgressHUD];
        if ([model.success boolValue] == TRUE) {
            [MobClick event:kLogined];
            [weakSelf showSimpleHUD:@"修改成功" afterDelay:1];
            [weakSelf performSelector:@selector(closeFindPassword) withObject:nil afterDelay:1];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithMessage:model.message];
            [alertView show];
        }
    };
    _updateRequest.onError = ^(MKNetworkOperation* completedOperation, MIError* error) {
        [weakSelf hideProgressHUD];
    };
    
    _counter = 60;
}

- (void)handleTimer:(id)sender
{
    if (_counter > 0 ) {
        [_findBackView.getCodeBtn.layer setBorderColor:[MIUtility colorWithHex:0xcccccc].CGColor];
        [_findBackView.getCodeBtn setTitleColor:[MIUtility colorWithHex:0xcccccc] forState:UIControlStateNormal];
        [_findBackView.getCodeBtn setTitle:[NSString stringWithFormat:@"%ldS", (long)_counter] forState:UIControlStateNormal];
        _counter--;
    } else {
        _counter = 60;
        [_counttingTimer invalidate];
        _counttingTimer = nil;
        
        [_findBackView.getCodeBtn.layer setBorderColor:MICodeButtonBackground.CGColor];
        [_findBackView.getCodeBtn setTitleColor:MICodeButtonBackground forState:UIControlStateNormal];
        [_findBackView.getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        _findBackView.getCodeBtn.userInteractionEnabled = YES;
    }
}

- (void)getUserCode
{
    [self showProgressHUD:nil];
    [_codeRequest sendQuery];
}

- (void)closeFindPassword
{
    [[MINavigator navigator] closeModalViewController:YES completion:^{
        ;
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)confirmFindPassword:(id)event
{
    [self submit];
}

- (void)submit
{
    if (_findBackView.codeTextField.text && ![_findBackView.codeTextField.text isEqualToString:@""])
    {
        if (_findBackView.bNewPasswordTextField.text == nil || [_findBackView.bNewPasswordTextField.text isEqualToString:@""])
        {
            [self showSimpleHUD:@"请输入新密码" afterDelay:1];
            [_findBackView.bNewPasswordTextField becomeFirstResponder];
            return;
        } else if (![MIUtility validatorRange:NSMakeRange(6, 16) text:_findBackView.bNewPasswordTextField.text]) {
            MIButtonItem *cancelItem = [MIButtonItem itemWithLabel:@"知道了"];
            cancelItem.action = ^{
                [_findBackView.bNewPasswordTextField becomeFirstResponder];
            };
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"无效的输入" message:@"请输入6-16个字符长度的密码" cancelButtonItem:cancelItem otherButtonItems:nil, nil];
            [alertView show];
            return;
        }
        [self showProgressHUD:nil];
        NSString *pwd = [NSString stringWithFormat:@"%@   %@   %@",self.phoneNum,_findBackView.bNewPasswordTextField.text,_findBackView.codeTextField.text];
        NSString *encryptPWDUseDES = [MIUtility encryptUseDES:pwd];
        [_updateRequest setKey:encryptPWDUseDES];
        [_updateRequest sendQuery];
    }
    else
    {
        [self showSimpleHUD:@"请输入验证码" afterDelay:1];
        [_findBackView.codeTextField becomeFirstResponder];
        return;
    }
    
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
