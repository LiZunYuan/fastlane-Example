//
//  MIExchangePayViewController.m
//  MISpring
//
//  Created by 贺晨超 on 13-8-27.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIExchangePayViewController.h"
#import "MISmsSendModel.h"
#import "MIExchangeCoinApplyModel.h"

#define MIPHONE_SETTING_INPUT_NUMBER 1
#define MIPHONE_SETTING_INPUT_CODE   2


@implementation MIExchangePayViewController

@synthesize counttingTimer = _counttingTimer;
@synthesize phoneFirstField = _phoneFirstField;
@synthesize phoneSecondField = _phoneSecondField;
@synthesize codeField = _codeField;
@synthesize codeButton = _codeButton;
@synthesize coinButton = _coinButton;
@synthesize moneyButton = _moneyButton;
@synthesize request = _request;
@synthesize payNum = _payNum;
@synthesize gid = _gid;

- (void) loadView
{
    [super loadView];
    
    _counter = 60;
    _randomVeriCode = arc4random() % 9000 + 1000;
    MILog(@"_randomVeriCode=%d",_randomVeriCode);
    
    _phoneFirstField = [[UITextField alloc] initWithFrame:CGRectMake(15, 5 + self.navigationBarHeight, 290, 42)];
    _phoneFirstField.backgroundColor              = [UIColor clearColor];
    _phoneFirstField.placeholder                  = @"输入要充值的手机号码";
    _phoneFirstField.keyboardType                 = UIKeyboardTypeNumberPad;
    _phoneFirstField.font                         = [UIFont systemFontOfSize:16];
    _phoneFirstField.returnKeyType                = UIReturnKeyNext;
    _phoneFirstField.clearButtonMode              = UITextFieldViewModeWhileEditing;
    _phoneFirstField.autocapitalizationType       = UITextAutocapitalizationTypeNone;
    _phoneFirstField.autocorrectionType           = UITextAutocorrectionTypeNo;
    _phoneFirstField.contentVerticalAlignment     = UIControlContentVerticalAlignmentCenter;
    
    UIImage *phoneFirstFieldBg = [[UIImage imageNamed:@"text_input_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    _phoneFirstField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 40)];
    _phoneFirstField.leftViewMode = UITextFieldViewModeAlways;
    _phoneFirstField.background = phoneFirstFieldBg;
    
    _phoneFirstField.tag = MIPHONE_SETTING_INPUT_NUMBER;
    [self.view addSubview:_phoneFirstField];
    
    _phoneSecondField = [[UITextField alloc] initWithFrame:CGRectMake(15, 47 + self.navigationBarHeight, 290, 42)];
    _phoneSecondField.backgroundColor              = [UIColor clearColor];
    _phoneSecondField.placeholder                  = @"再次输入要充值的手机号码";
    _phoneSecondField.keyboardType                 = UIKeyboardTypeNumberPad;
    _phoneSecondField.font                         = [UIFont systemFontOfSize:16];
    _phoneSecondField.returnKeyType                = UIReturnKeyNext;
    _phoneSecondField.clearButtonMode              = UITextFieldViewModeWhileEditing;
    _phoneSecondField.autocapitalizationType       = UITextAutocapitalizationTypeNone;
    _phoneSecondField.autocorrectionType           = UITextAutocorrectionTypeNo;
    _phoneSecondField.contentVerticalAlignment     = UIControlContentVerticalAlignmentCenter;
    
    UIImage *phoneSecondFieldBg = [[UIImage imageNamed:@"text_input_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    _phoneSecondField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 40)];
    _phoneSecondField.leftViewMode = UITextFieldViewModeAlways;
    _phoneSecondField.background = phoneSecondFieldBg;
    [self.view addSubview:_phoneSecondField];
    
    _codeField = [[UITextField alloc] initWithFrame:CGRectMake(15, 89 + self.navigationBarHeight, 145, 42)];
    _codeField.backgroundColor              = [UIColor clearColor];
    _codeField.placeholder                  = @"输入验证码";
    _codeField.keyboardType                 = UIKeyboardTypeNumberPad;
    _codeField.tag                          = MIPHONE_SETTING_INPUT_CODE;
    _codeField.font                         = [UIFont systemFontOfSize:16];
    _codeField.clearButtonMode              = UITextFieldViewModeWhileEditing;
    _codeField.autocapitalizationType       = UITextAutocapitalizationTypeNone;
    _codeField.autocorrectionType           = UITextAutocorrectionTypeNo;
    _codeField.contentVerticalAlignment     = UIControlContentVerticalAlignmentCenter;
    
    UIImage *codeFieldBg = [[UIImage imageNamed:@"text_input_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    _codeField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 40)];
    _codeField.leftViewMode = UITextFieldViewModeAlways;
    _codeField.background = codeFieldBg;
    [self.view addSubview: _codeField];
    
    _codeButton = [MICommonButton buttonWithType:UIButtonTypeCustom];
    _codeButton.frame = CGRectMake(165, 89 + self.navigationBarHeight, 137, 36);
    _codeButton.centerY = _codeField.centerY;
    [_codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_codeButton addTarget:self action:@selector(getVerificationCode:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_codeButton];
    
    _coinButton = [MICommonButton buttonWithType:UIButtonTypeCustom];
    _coinButton.frame = CGRectMake(18, 150 + self.navigationBarHeight, 137, 36);
    [_coinButton setTitle:[NSString stringWithFormat:@"使用%d米币", _payNum] forState:UIControlStateNormal];
    [_coinButton addTarget:self action:@selector(useMb:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_coinButton];
    
    _moneyButton = [MICommonButton buttonWithType:UIButtonTypeCustom];
    _moneyButton.frame = CGRectMake(165, 150 + self.navigationBarHeight, 137, 36);
    [_moneyButton setTitle:[NSString stringWithFormat:@"使用余额%d元", _payNum/100] forState:UIControlStateNormal];
    [_moneyButton addTarget:self action:@selector(useMoney:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_moneyButton];
    
    RTLabel * noteLabel = [[RTLabel alloc] initWithFrame:CGRectMake(20, 200 + self.navigationBarHeight, 280, self.view.viewHeight - 200)];
    noteLabel.lineBreakMode = kCTLineBreakByWordWrapping;
    noteLabel.backgroundColor = [UIColor clearColor];
    noteLabel.textColor = [UIColor grayColor];
    noteLabel.font = [UIFont systemFontOfSize:14.0];
    NSString *tips = [NSString stringWithFormat:@"此卡为中国内地手机在线充值，面值为%d元，可支持移动、联通、电信。请认真填写要充值的手机号码，因填写错误导致的损失请自行承担。申请兑换后，话费充值将在一个工作日内处理。", _payNum/100];
    noteLabel.text = [[NSString alloc] initWithFormat:@"<font size=16.0 color='#499d00'>提示：</font> \n%@", tips];
    [self.view addSubview:noteLabel];
    
    MIMainUser *user = [MIMainUser getInstance];
    if (user.coin.doubleValue >= _payNum) {
        _coinButton.enabled = YES;
    } else {
        _coinButton.enabled = NO;
    }
    
    if ((user.incomeSum.doubleValue - user.expensesSum.doubleValue) >= _payNum) {
        _moneyButton.enabled = YES;
    } else {
        _moneyButton.enabled = NO;
    }
    
    UITapGestureRecognizer *resignFirstResponse = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignFirstResponse)];
    resignFirstResponse.delegate = self;
    [self.view addGestureRecognizer:resignFirstResponse];
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
    if ([_phoneFirstField isFirstResponder]) {
        [_phoneFirstField resignFirstResponder];
    }
    
    if ([_phoneSecondField isFirstResponder]) {
        [_phoneSecondField resignFirstResponder];
    }
    
    if ([_codeField isFirstResponder]) {
        [_codeField resignFirstResponder];
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationBar setBarTitle: @"申请兑换话费" textSize:20.0];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    if (_counttingTimer) {
        [_counttingTimer invalidate];
        _counttingTimer = nil;
    }
}

- (void)feeApplySuccess
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kShowGradeAlertView];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    MIButtonItem *affirmItem = [MIButtonItem itemWithLabel:@"确定"];
    affirmItem.action = ^{
        [self miPopToPreviousViewController];
    };
    
    UIAlertView *loginAlertView = [[UIAlertView alloc] initWithTitle:@"申请兑换成功"
                                                             message:@"你可以在“兑换记录”中查看受理状态"
                                                    cancelButtonItem:nil
                                                    otherButtonItems:affirmItem, nil];
    [loginAlertView show];
}

-(void)useMb:(UIButton *)sender{
    if (_codeField.text.integerValue != _randomVeriCode) {
        [self showSimpleHUD:@"验证码错误"];
    } else {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.yOffset = - 80.0f;
        hud.removeFromSuperViewOnHide = YES;
        __weak typeof(hud) bhud = hud;
        __weak typeof(self) wSelf = self;

        if (_request) {
            [_request cancelRequest];
            _request = nil;
        }
        
        _request = [[MIExchangeCoinApplyRequest alloc] init];
        _request.onCompletion = ^(MIExchangeCoinApplyModel *model) {
            [bhud hide: YES];
            
            if ([model.success boolValue]) {
                NSInteger origin = [MIMainUser getInstance].coin.integerValue;
                [MIMainUser getInstance].coin = [NSNumber numberWithInt:(origin - wSelf.payNum)];
                [[MIMainUser getInstance] persist];
                [wSelf feeApplySuccess];
            } else {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"兑换失败"
                                                                    message:model.message
                                                                   delegate:nil
                                                          cancelButtonTitle:@"确定"
                                                          otherButtonTitles:nil, nil];
                [alertView show];
            }
        };

        _request.onError = ^(MKNetworkOperation* completedOperation, MIError* error) {
            [bhud hide: YES];
        };
        
        [_request setGid: _gid ];
        [_request setNum: _phoneFirstField.text];
        [_request setPay:2];
        [_request sendQuery];
    }
}

-(void)useMoney:(UIButton *)sender{
    if (_codeField.text.integerValue != _randomVeriCode) {
        [self showSimpleHUD:@"验证码错误"];
    } else {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.yOffset = -80.0f;
        hud.removeFromSuperViewOnHide = YES;
        __weak typeof(hud) bhud = hud;
        __weak typeof(self) wSelf = self;
        
        if (_request) {
            [_request cancelRequest];
            _request = nil;
        }
        
        _request = [[MIExchangeCoinApplyRequest alloc] init];
        _request.onCompletion = ^(MIExchangeCoinApplyModel *model) {
            [bhud hide: YES];
            
            if ([model.success boolValue]) {
                double expensesSum = [MIMainUser getInstance].expensesSum.doubleValue - wSelf.payNum;
                [MIMainUser getInstance].expensesSum = [NSNumber numberWithDouble:expensesSum];
                [[MIMainUser getInstance] persist];
                [wSelf feeApplySuccess];
            } else {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"兑换失败"
                                                                    message:model.message
                                                                   delegate:nil
                                                          cancelButtonTitle:@"确定"
                                                          otherButtonTitles:nil, nil];
                [alertView show];
            }
        };
        
        _request.onError = ^(MKNetworkOperation* completedOperation, MIError* error) {
            [bhud hide: YES];
        };
        
        [_request setGid: _gid ];
        [_request setNum: _phoneFirstField.text];
        [_request setPay:1];
        [_request sendQuery];
    }
}

- (void)getVerificationCode:(UIButton *)btn
{
    if(_phoneFirstField != nil && _phoneFirstField.text.length != 0 && _phoneSecondField != nil && _phoneSecondField.text.length != 0 && [_phoneFirstField.text isEqualToString: _phoneSecondField.text]){
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.yOffset = - 80.0f;
        hud.removeFromSuperViewOnHide = YES;
        
        if (_smsSendRequest) {
            [_smsSendRequest cancelRequest];
            _smsSendRequest = nil;
        }
        _smsSendRequest = [[MISMSSendRequest alloc] init];
        [_smsSendRequest setTel:[MIMainUser getInstance].phoneNum];
        [_smsSendRequest setText:[NSString stringWithFormat:@"%d", _randomVeriCode]];
        [_smsSendRequest setType:@"validate"];
        
        __weak typeof(self) weakSelf = self;
        __weak typeof(hud) bhud = hud;
        _smsSendRequest.onCompletion = ^(MISmsSendModel * model) {
            [bhud hide: YES];
            
            if ([model.success boolValue]) {
                [weakSelf showSimpleHUD:@"验证码已发送至绑定手机"];
                
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
    } else if (![_phoneFirstField.text isEqualToString: _phoneSecondField.text]){
        [self showSimpleHUD:@"两次输入的手机号不一致"];
    } else {
        [self showSimpleHUD:@"请输入手机号"];
    }
}

- (void)handleTimer: (NSTimer *) timer
{
    if (_counter > 0 ) {
        [_codeButton setTitle:[NSString stringWithFormat:@"(%ds)重新获取", _counter] forState:UIControlStateDisabled];
        _counter--;
    } else {
        _counter = 60;
        [_counttingTimer invalidate];
        _counttingTimer = nil;
        [_codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        _codeButton.enabled = [MIUtility validatorRange:NSMakeRange(11, 11) text:_phoneFirstField.text];
    }
    
}

@end
