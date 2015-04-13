//
//  MIPayApplyViewController.m
//  MISpring
//
//  Created by Yujian Xu on 13-3-22.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIPayApplyViewController.h"
#import "MIPayRecordViewController.h"
#import "MIPayApplyModel.h"
#import "MIPayApplyGetModel.h"
#import "MIChangePassViewController.h"
#import "MISmsSendModel.h"
#import "MIForgetPWDViewController.h"

@implementation MIPayApplyViewController
@synthesize maxAmount = _maxAmount;
@synthesize payApplySum = _payApplySum;
@synthesize alipayAccount = _alipayAccount;
@synthesize inputAmountField = _inputAmountField;
@synthesize inputPasswordField = _inputPasswordField;
@synthesize payApplyButton = _payApplyButton;
@synthesize jifenbao = _jifenbao;
@synthesize inputAmountLable = _inputAmountLable;
@synthesize payApplyTip = _payApplyTip;
@synthesize badgeImageView = _badgeImageView;
@synthesize payApplyRequest = _payApplyRequest;
@synthesize payApplyGetRequest = _payApplyGetRequest;
@synthesize inputCodeField = _inputCodeField;
@synthesize getCodeBtn = _getCodeBtn;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.navigationBar setBarTitle:@"我要提现"];
    
    if (self.alipayAccount == nil) {
        _alipayAccount = [MIMainUser getInstance].alipay;
    }
    
    UIButton *payRecordBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 85, (self.navigationBarHeight - PHONE_NAVIGATION_BAR_ITEM_HEIGHT), 80, PHONE_NAVIGATION_BAR_ITEM_HEIGHT)];
    [payRecordBtn setTitle:@"提现记录" forState:UIControlStateNormal];
    [payRecordBtn setTitleColor:MICommitButtonBackground forState:UIControlStateNormal];
    payRecordBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [payRecordBtn addTarget:self action:@selector(goPayRecord) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBar addSubview:payRecordBtn];
    
    UIImage* badgeImg = [UIImage imageNamed:@"badge"];
    _badgeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(305, self.navigationBarHeight - PHONE_NAVIGATION_BAR_ITEM_HEIGHT + 10, badgeImg.size.width, badgeImg.size.height)];
    _badgeImageView.image = badgeImg;
    _badgeImageView.hidden = YES;
    [self.view addSubview:_badgeImageView];
    
    UITapGestureRecognizer *resignFirstResponse = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignFirstResponse)];
    resignFirstResponse.delegate = self;
    [self.view addGestureRecognizer:resignFirstResponse];
    
    _counter = 60;
    
    //小提示
    _tipLabel = [[MIBBMarqueeView alloc] initWithFrame:CGRectMake(0, self.navigationBar.bottom, SCREEN_WIDTH, 24)];
    _tipLabel.lable.textColor = [MIUtility colorWithHex:0xe89e5d];
    _tipLabel.lable.font = [UIFont systemFontOfSize:11.0];
    _tipLabel.lable.textAlignment = UITextAlignmentCenter;
    _tipLabel.lable.top = 6;
    _tipLabel.backgroundColor = [MIUtility colorWithHex:0xfffceb];
    _tipLabel.hidden = YES;
    [self.view addSubview:_tipLabel];
    
    _backView = [[UIView alloc] initWithFrame:CGRectMake(0, _tipLabel.bottom, SCREEN_WIDTH, SCREEN_HEIGHT - PHONE_NAVIGATION_BAR_ITEM_HEIGHT - PHONE_STATUSBAR_HEIGHT - 24)];
    [self.view addSubview:_backView];
    
    //余额
    _inputAmountLable = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 20, 30)];
    _inputAmountLable.backgroundColor = [UIColor clearColor];
    _inputAmountLable.font = [UIFont systemFontOfSize:11.0];
    _inputAmountLable.textColor = MIColor666666;
    _inputAmountLable.text = @"可用余额";
    [_backView addSubview:_inputAmountLable];
    
    //提现金额栏
    UIView *amountView = [[UIView alloc] initWithFrame:CGRectMake(0, _inputAmountLable.bottom, SCREEN_WIDTH, 44)];
    amountView.backgroundColor = [UIColor whiteColor];
    UILabel *labelWithdraw = [[UILabel alloc] initWithFrame:CGRectMake(12, 14, 100, 15)];
    labelWithdraw.font = [UIFont systemFontOfSize:15.0];
    labelWithdraw.textColor = MIColor333333;
    labelWithdraw.text = @"提现金额";
    CGSize size = [labelWithdraw.text sizeWithFont:labelWithdraw.font];
    labelWithdraw.viewWidth = size.width + 12;
    labelWithdraw.centerY = amountView.viewHeight / 2;
    [amountView addSubview: labelWithdraw];
    
    _inputAmountField = [[UITextField alloc] initWithFrame:CGRectMake(labelWithdraw.right, 0, 160, 40)];
    _inputAmountField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 40)];
    _inputAmountField.leftViewMode = UITextFieldViewModeAlways;
    _inputAmountField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _inputAmountField.placeholder = @"请输入整数金额";
    _inputAmountField.font = [UIFont systemFontOfSize:13.0];
    _inputAmountField.returnKeyType = UIReturnKeyNext;
    _inputAmountField.keyboardType = UIKeyboardTypeNumberPad;
    _inputAmountField.delegate = self;
    _inputAmountField.centerY = amountView.viewHeight / 2;
    [amountView addSubview:_inputAmountField];
    
    _jifenbao = [[UILabel alloc] initWithFrame: CGRectMake(SCREEN_WIDTH - 140, 0, 100, 40)];
    _jifenbao.backgroundColor = [UIColor clearColor];
    _jifenbao.font = [UIFont systemFontOfSize:13];
    _jifenbao.textColor = [UIColor orangeColor];
    _jifenbao.textAlignment = UITextAlignmentRight;
    _jifenbao.text = @" = 0 集分宝";
    _jifenbao.centerY = amountView.viewHeight / 2;
    _jifenbao.right = SCREEN_WIDTH - 12;
    [amountView addSubview:_jifenbao];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(12, amountView.viewHeight - 1, SCREEN_WIDTH - 12, 0.6)];
    line.backgroundColor =  MINormalBackgroundColor;
    [amountView addSubview:line];
    
    [_backView addSubview:amountView];
    
    
    
    //手机验证栏
    UIView *codeView = [[UIView alloc] initWithFrame:CGRectMake(0, amountView.bottom, SCREEN_WIDTH, 44)];
    codeView.backgroundColor = [UIColor whiteColor];
    UILabel *labelCode = [[UILabel alloc] initWithFrame:CGRectMake(12, 14, 100, 15)];
    labelCode.font = [UIFont systemFontOfSize:15.0];
    labelCode.textColor = MIColor333333;
    labelCode.text = @"手机验证";
    labelCode.viewWidth = size.width + 12;
    labelCode.centerY = codeView.viewHeight / 2;
    [codeView addSubview: labelCode];
    
    _inputCodeField = [[UITextField alloc] initWithFrame:CGRectMake(labelCode.right, 0, 160, 40)];
    _inputCodeField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 40)];
    _inputCodeField.leftViewMode = UITextFieldViewModeAlways;
    _inputCodeField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _inputCodeField.placeholder = @"请输入短信验证码";
    _inputCodeField.font = [UIFont systemFontOfSize:13.0];
    _inputCodeField.delegate = self;
    _inputCodeField.centerY = codeView.viewHeight / 2;
    [codeView addSubview:_inputCodeField];
    
    _getCodeBtn = [[UIButton alloc] initWithFrame:CGRectMake(_inputCodeField.right, 0, 160, 30)];
    _getCodeBtn.clipsToBounds = YES;
    _getCodeBtn.layer.cornerRadius = 14;
    _getCodeBtn.layer.borderWidth = 1.0;
    [_getCodeBtn.layer setBorderColor:MICodeButtonBackground.CGColor];
    [_getCodeBtn setTitleColor:MICodeButtonBackground forState:UIControlStateNormal];
    [_getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    _getCodeBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
    _getCodeBtn.viewWidth = size.width * 1.3;
    _getCodeBtn.centerY = codeView.viewHeight / 2;
    _getCodeBtn.right = SCREEN_WIDTH - 12;
    [_getCodeBtn addTarget:self action:@selector(getVerificationCode:) forControlEvents:UIControlEventTouchUpInside];
    [codeView addSubview: _getCodeBtn];
    
    _inputCodeField.viewWidth = _getCodeBtn.left - _inputCodeField.left;
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(12, codeView.viewHeight - 1, SCREEN_WIDTH - 12, 0.6)];
    line2.backgroundColor = MINormalBackgroundColor;
    [codeView addSubview:line2];
    
    [_backView addSubview:codeView];
    
    //密码验证栏
    UIView *pwdView = [[UIView alloc] initWithFrame:CGRectMake(0, codeView.bottom, SCREEN_WIDTH, 44)];
    pwdView.backgroundColor = [UIColor whiteColor];
    
    UILabel *labelPwd = [[UILabel alloc] initWithFrame:CGRectMake(12, 14, 100, 15)];
    labelPwd.font = [UIFont systemFontOfSize:15.0];
    labelPwd.textColor = MIColor333333;
    labelPwd.text = @"密码验证";
    labelPwd.viewWidth = size.width + 12;
    labelPwd.centerY = pwdView.viewHeight / 2;
    [pwdView addSubview: labelPwd];
    
    NSString *forgetPassword = @"忘记密码？";
    CGSize labelSize = [forgetPassword sizeWithFont:[UIFont systemFontOfSize:12.0f]
                                  constrainedToSize:CGSizeMake(SCREEN_WIDTH - 20, 14)];
    UILabel *forgetPWD = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 20 - labelSize.width, 80 + self.navigationBarHeight, labelSize.width + 12, 16)];
    forgetPWD.centerY = pwdView.viewHeight / 2;
    forgetPWD.backgroundColor = [UIColor clearColor];
    forgetPWD.font = [UIFont systemFontOfSize:12.0];
    forgetPWD.textColor = [UIColor blueColor];
    forgetPWD.textAlignment = UITextAlignmentRight;
    forgetPWD.text = forgetPassword;
    forgetPWD.userInteractionEnabled = YES;
    [pwdView addSubview:forgetPWD];
    
    UITapGestureRecognizer *forgetPassWord = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goForgetPassWord)];
    [forgetPWD addGestureRecognizer:forgetPassWord];
    
    _inputPasswordField = [[UITextField alloc] initWithFrame:CGRectMake(labelPwd.right, 0, 160, 40)];
    //    _inputPasswordField.background = textFiledBg;
    _inputPasswordField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 40)];
    _inputPasswordField.leftViewMode = UITextFieldViewModeAlways;
    _inputPasswordField.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    _inputPasswordField.placeholder = @"请输入米折网密码";
    _inputPasswordField.font = [UIFont systemFontOfSize:13.0];
    _inputPasswordField.keyboardType = UIKeyboardTypeAlphabet;
    _inputPasswordField.returnKeyType = UIReturnKeyDone;
    _inputPasswordField.delegate = self;
    _inputPasswordField.secureTextEntry = YES;
    [pwdView addSubview:_inputPasswordField];
    _inputPasswordField.viewWidth = forgetPWD.left - _inputPasswordField.left;
    
    [_backView addSubview:pwdView];
    
    _payApplyButton = [[MICommonButton alloc] initWithFrame:CGRectMake(12, pwdView.bottom + 12, SCREEN_WIDTH - 24, 36)];
    [_payApplyButton setTitle:@"立即申请" forState:UIControlStateNormal];
    [_payApplyButton addTarget:self action:@selector(checkValidity) forControlEvents:UIControlEventTouchUpInside];
    [_backView addSubview:_payApplyButton];
    
    _payApplyTip = [[RTLabel alloc] initWithFrame:CGRectMake(12, _payApplyButton.bottom + 16, SCREEN_WIDTH - 24, self.view.viewHeight - self.navigationBarHeight - 190)];
    _payApplyTip.backgroundColor = [UIColor clearColor];
    _payApplyTip.font = [UIFont systemFontOfSize:13.0];
    _payApplyTip.lineBreakMode = kCTLineBreakByWordWrapping;
    _payApplyTip.lineSpacing = 5.0;
    _payApplyTip.text = [NSString stringWithFormat:@"<font size=16.0 color='#499d00'>提示：</font> \n当前收款支付宝账户为<font color='#499d00'>%@</font>，将提现到支付宝集分宝，1元=100集分宝，去淘宝购物可抵现金", _alipayAccount];
    [_backView addSubview:_payApplyTip];

    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.yOffset = -80.f;
    hud.removeFromSuperViewOnHide = YES;
    
    _payApplyGetRequest = [[MIPayApplyGetRequest alloc] init];
    __weak typeof(hud) bhud = hud;
    __weak typeof(self) weakSelf = self;
    _payApplyGetRequest.onCompletion = ^(MIPayApplyGetModel * model) {
        [bhud hide: YES];

        [MIMainUser getInstance].coin = model.coin;
        [MIMainUser getInstance].incomeSum = model.incomeSum;
        [MIMainUser getInstance].expensesSum = model.expensesSum;
        [[MIMainUser getInstance] persist];
        
        weakSelf.payApplySum = model.applySum.integerValue;
        CGFloat remainSum = (model.incomeSum.doubleValue - model.expensesSum.doubleValue) / 100.0;
        weakSelf.maxAmount = floorf(remainSum) - model.applySum.integerValue;
        weakSelf.inputAmountLable.text = [NSString stringWithFormat:@"可用余额%ld元", (long)weakSelf.maxAmount];
        
        if (model.tip && model.tip.length > 0) {
            weakSelf.tipLabel.hidden = NO;
            [weakSelf.tipLabel setLabelText:[NSString stringWithFormat:@"  %@", model.tip]];
            weakSelf.tipLabel.lable.top = 6;
            [weakSelf.tipLabel startTimer];
            weakSelf.backView.top = weakSelf.tipLabel.bottom;
        } else {
            weakSelf.tipLabel.hidden = YES;
            weakSelf.backView.top = weakSelf.navigationBar.bottom;
        }
        
        if (model.applySum.integerValue > 0) {
            weakSelf.payApplyTip.text = [NSString stringWithFormat:@"<font size=16.0 color='#499d00'>提示：</font> \n当前正在处理的提现金额为<font color='#499d00'> %ld </font>元，收款支付宝账户为<font color='#499d00'>%@</font>，将提现到支付宝集分宝，1元=100集分宝，去淘宝购物可抵现金", (long)model.applySum.integerValue, [MIMainUser getInstance].alipay];
        }
    };
    _payApplyGetRequest.onError = ^(MKNetworkOperation* completedOperation, MIError* error) {
        [bhud hide: YES];
    };
    
    [_payApplyGetRequest sendQuery];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([MIHeartbeat shareHeartbeat].heartBeatNewsMessage.pays.integerValue > 0) {
        self.badgeImageView.hidden = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (_counttingTimer) {
        [_counttingTimer invalidate];
        _counttingTimer = nil;
        _getCodeBtn.enabled = YES;
        [_getCodeBtn.layer setBorderColor:MICodeButtonBackground.CGColor];
        [_getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    }
    
    [_payApplyGetRequest cancelRequest];
    [_payApplyRequest cancelRequest];
    [_smsSendRequest cancelRequest];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [_smsSendRequest setType:@"withdraw"];
    
    __weak typeof(hud) bhud = hud;
    __weak typeof(self) weakSelf = self;
    NSString *num = [[MIMainUser getInstance].phoneNum substringWithRange:NSMakeRange([MIMainUser getInstance].phoneNum.length - 4, 4)];
    _smsSendRequest.onCompletion = ^(MISmsSendModel * model) {
        [bhud hide: YES];
        if ([model.success boolValue]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithMessage:[NSString stringWithFormat:@"验证码已发送到尾号为%@的手机", num]];
            [alertView show];
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
        [_getCodeBtn setTitle:[NSString stringWithFormat:@"(%ld)...", (long)_counter] forState:UIControlStateDisabled];
        [_getCodeBtn.layer setBorderColor:[UIColor grayColor].CGColor];
        [_getCodeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        _counter--;
    } else {
        _counter = 60;
        [_counttingTimer invalidate];
        _counttingTimer = nil;
        _getCodeBtn.enabled = YES;
        [_getCodeBtn.layer setBorderColor:MICodeButtonBackground.CGColor];
        [_getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    }
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[UIButton class]])
    {
        return NO;
    }
    return YES;
}

- (void)resignFirstResponse
{
    if ([_inputAmountField isFirstResponder]) {
        [_inputAmountField resignFirstResponder];
    }

    if ([_inputPasswordField isFirstResponder]) {
        [_inputPasswordField resignFirstResponder];
    }
    
    if ([_inputCodeField isFirstResponder]) {
        [_inputCodeField resignFirstResponder];
    }
}

- (void)payApplySuccess
{
    [MINavigator showSimpleHudWithTips:@"提现申请成功!"];
    [[MINavigator navigator] closePopViewControllerAnimated:NO];
    
    [self goPayRecord];
}

- (void)goPayApply
{    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.yOffset = -80.f;
    hud.removeFromSuperViewOnHide = YES;

    if (_payApplyRequest) {
        [_payApplyRequest cancelRequest];
        _payApplyRequest = nil;
    }
    _payApplyRequest = [[MIPayApplyRequest alloc] init];
    [_payApplyRequest setAmount:_inputAmountField.text];
    [_payApplyRequest setPassword:[MIUtility encryptUseDES:_inputPasswordField.text]];
    [_payApplyRequest setCode:_inputCodeField.text];

    __weak typeof(hud) bhud = hud;
    __weak typeof(self) weakSelf = self;
    _payApplyRequest.onCompletion = ^(MIPayApplyModel * model) {
        [bhud hide: YES];
        if ([model.success boolValue]) {
            [weakSelf payApplySuccess];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kShowGradeAlertView];
            [[NSUserDefaults standardUserDefaults] synchronize];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提现失败"
                                                                message:model.message
                                                               delegate:nil
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil, nil];
            [alertView show];
        }
    };
    _payApplyRequest.onError = ^(MKNetworkOperation* completedOperation, MIError* error) {
        [bhud hide: YES];
    };

    [_payApplyRequest sendQuery];
}

- (void) goPayRecord
{
    if ([MIHeartbeat shareHeartbeat].heartBeatNewsMessage.pays.integerValue > 0) {
        self.badgeImageView.hidden = YES;

        MIPushBadgeClearRequest * request = [[MIPushBadgeClearRequest alloc] init];
        request.onCompletion = ^(id result) {
            if ([MIUtility isNotificationTypeBadgeEnable]) {
                NSInteger applicationIconBadgeNumber = [UIApplication sharedApplication].applicationIconBadgeNumber - [MIHeartbeat shareHeartbeat].heartBeatNewsMessage.pays.integerValue;
                [UIApplication sharedApplication].applicationIconBadgeNumber = applicationIconBadgeNumber;
            }

            [MIHeartbeat shareHeartbeat].heartBeatNewsMessage.pays = [NSNumber numberWithInteger:0];
        };
        [request setPaysOrders];
        [request sendQuery];
    }
    
    MIPayRecordViewController *vc = [[MIPayRecordViewController alloc] init];
    [[MINavigator navigator] openPushViewController:vc animated:YES];
}

- (void)goForgetPassWord
{
//    MIChangePassViewController* vc = [[MIChangePassViewController alloc] init];
//    [[MINavigator navigator] openModalViewController:vc animated:YES];
    MIForgetPWDViewController *vc = [[MIForgetPWDViewController alloc] init];
    [[MINavigator navigator] openPushViewController:vc animated:YES];
}

- (void)checkValidity
{
    NSString *errorMsg;
    NSString *amount = _inputAmountField.text;
    NSString *password = _inputPasswordField.text;
    NSString *code = _inputCodeField.text;
    if ((amount == nil) || (amount.length == 0)) {
        errorMsg = @"请输入提现金额";
        [_inputAmountField becomeFirstResponder];
    } else if ((password == nil) || (password.length == 0)) {
        [_inputPasswordField becomeFirstResponder];
        errorMsg = @"请输入米折网密码";
    } else if (code == nil || code.length == 0) {
        [_inputCodeField becomeFirstResponder];
        errorMsg = @"请输入短信验证码";
    }
    
    if (errorMsg == nil) {
        NSString *DESPassword = [MIMainUser getInstance].DESPassword;
        if (DESPassword != nil && DESPassword.length > 0) {
            if ([password isEqualToString:[MIUtility decryptUseDES:DESPassword]]) {
                [self goPayApply];
                return;
            } else {
                _inputPasswordField.text = nil;
                [_inputPasswordField becomeFirstResponder];
                errorMsg = @"密码错误，请重新输入";
            }
        } else {
            [self goPayApply];
            return;
        }
    }

    if (errorMsg != nil) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"无效输入"
                                                            message:errorMsg
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil, nil];
        [alertView show];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self checkValidity];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (![textField isEqual:_inputAmountField]) {
        return YES;
    }
    
    NSString *futureString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if ((futureString == nil) || (futureString.length == 0)) {
        _jifenbao.text = @" = 0 集分宝";
        return YES;
    }
    
    NSString *errorMsg;
    NSInteger number = [futureString integerValue];
    if ([MIUtility validatorNumeric:futureString]) {
        if (number > _maxAmount) {
            errorMsg = @"可用余额不足，1元起提现";
        } else if (number < 1) {
            errorMsg = @"请输入大于等于1的整数金额";
            [_inputAmountField becomeFirstResponder];
        }
    } else {
        [_inputAmountField becomeFirstResponder];
        errorMsg = @"请输入正确的提现金额";
    }

    if (errorMsg != nil) {
        _inputAmountField.text = nil;
        _jifenbao.text = @" = 0 集分宝";
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"无效输入"
                                                            message:errorMsg
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil, nil];
        [alertView show];
        return NO;
    } else {
        _jifenbao.text = [NSString stringWithFormat:@" = %ld 集分宝", (long)number*100];
        return YES;
    }
}

@end
