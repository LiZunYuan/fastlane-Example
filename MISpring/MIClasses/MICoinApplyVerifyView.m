//
//  MICoinApplyVerifyView.m
//  BeiBeiAPP
//
//  Created by 曲俊囡 on 14-3-25.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MICoinApplyVerifyView.h"
#import "MIExchangeOrderViewController.h"
#import "MIExchangeCoinApplyModel.h"
#import "MISmsSendModel.h"

@implementation MICoinApplyVerifyView
@synthesize coinModel,counttingTimer,smsSendRequest,coinApplyRequest,bgView,tipsLabel,cancelButton,conformButton,codeTextField,getVerifyCodeButton;

- (void)awakeFromNib
{
    _counter = 60;    
    _randomVeriCode = arc4random() % 9000 + 1000;
    MILog(@"_randomVeriCode=%d",_randomVeriCode);
    
    bgView.layer.borderColor = [MIUtility colorWithHex:0xe5e5e5].CGColor;
    bgView.layer.borderWidth = 0.6;
    bgView.layer.cornerRadius = 5;
    
    codeTextField.layer.borderColor = [MIUtility colorWithHex:0xe5e5e5].CGColor;
    codeTextField.layer.borderWidth = 0.6;
    codeTextField.layer.cornerRadius = 2;
    codeTextField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, 30)];
    codeTextField.leftViewMode = UITextFieldViewModeAlways;
    codeTextField.keyboardType = UIKeyboardTypeNumberPad;

    getVerifyCodeButton.backgroundColor = [MIUtility colorWithHex:0xeeb654];
    getVerifyCodeButton.layer.cornerRadius = 3;
    getVerifyCodeButton.clipsToBounds = YES;
    
    NSInteger len = [MIMainUser getInstance].phoneNum.length;
    NSInteger index = len > 4 ? (len - 4) : 0;
    NSString *phone = [[MIMainUser getInstance].phoneNum substringFromIndex:index];
    NSString *tips = [NSString stringWithFormat:@"为了保证您的资金安全，兑换集分宝需要通过手机验证。验证码将发送到尾号为%@的手机。", phone];
    tipsLabel.text = tips;
}

- (IBAction)getVerificationCodeAction:(id)sender {
    [self.getVerifyCodeButton setBackgroundColor:[MIUtility colorWithHex:0xf2f2f2]];
    [self.getVerifyCodeButton setTitleColor:[MIUtility colorWithHex:0x999999] forState:UIControlStateNormal];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.yOffset = -80.f;
    hud.removeFromSuperViewOnHide = YES;
    
    if (self.smsSendRequest) {
        [self.smsSendRequest cancelRequest];
        self.smsSendRequest = nil;
    }
    self.smsSendRequest = [[MISMSSendRequest alloc] init];
    [self.smsSendRequest setTel:[MIMainUser getInstance].phoneNum];
    [self.smsSendRequest setType:@"exchange"];
    
    __weak typeof(self) weakSelf = self;
    __weak typeof(hud) bhud = hud;
    self.smsSendRequest.onCompletion = ^(MISmsSendModel * model) {
        [bhud hide: YES];
        
        if ([model.success boolValue]) {
            [MINavigator showSimpleHudWithTips:@"验证码已发送，请注意查收"];
            
            weakSelf.getVerifyCodeButton.enabled = NO;
            weakSelf.counttingTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:weakSelf selector:@selector(handleTimer:)  userInfo:nil  repeats:YES];
            [weakSelf.counttingTimer fire];
        } else {
            [MINavigator showSimpleHudWithTips:model.message];
        }
    };
    self.smsSendRequest.onError = ^(MKNetworkOperation* completedOperation, MIError* error) {
        [bhud hide: YES];
    };
    
    [self.smsSendRequest sendQuery];
}
- (void)handleTimer:(id) sender
{
    if (_counter > 0 ) {
        [self.getVerifyCodeButton setTitle:[NSString stringWithFormat:@"(%ld)重新获取", (long)_counter] forState:UIControlStateDisabled];
        _counter--;
    } else {
        _counter = 60;
        [self.counttingTimer invalidate];
        self.counttingTimer = nil;
        [self.getVerifyCodeButton setBackgroundColor:[MIUtility colorWithHex:0xeeb654]];
        [self.getVerifyCodeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.getVerifyCodeButton setTitle:@"重新获取" forState:UIControlStateNormal];
        self.getVerifyCodeButton.enabled = YES;
    }
}
- (IBAction)cancelPayOrderAction:(id)sender {
    if (self.smsSendRequest.operation.isExecuting) {
        [self.smsSendRequest cancelRequest];
    }
    
    self.alpha = 0;
    [self.codeTextField resignFirstResponder];
}
- (IBAction)conformPayActionOrder:(id)sender {
    if (self.codeTextField.text && self.codeTextField.text.length) {
        [self coinApply];
    } else {
        [MINavigator showSimpleHudWithTips:@"请输入验证码"];
    }
}

- (void)coinApply
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.yOffset = -80.f;
    hud.removeFromSuperViewOnHide = YES;
    
    if (self.coinApplyRequest) {
        [self.coinApplyRequest cancelRequest];
        self.coinApplyRequest = nil;
    }
    
    __weak typeof(hud) bhud = hud;
    __weak typeof(self) wSelf = self;
    self.coinApplyRequest = [[MIExchangeCoinApplyRequest alloc] init];
    self.coinApplyRequest.onCompletion = ^(MIExchangeCoinApplyModel *model) {
        [bhud hide: YES];
        
        if ([model.success boolValue]) {
            NSInteger origin = [MIMainUser getInstance].coin.integerValue;
            [MIMainUser getInstance].coin = @(origin - wSelf.coinModel.coins.integerValue);
            [[MIMainUser getInstance] persist];
            [wSelf successToConform];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"兑换失败"
                                                                message:model.message
                                                               delegate:nil
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil, nil];
            [alertView show];
        }
    };
    
    self.coinApplyRequest.onError = ^(MKNetworkOperation* completedOperation, MIError* error) {
        [bhud hide: YES];
    };
    
    [self.coinApplyRequest setGid:self.coinModel.gid.integerValue];
    [self.coinApplyRequest setPay:2];
    [self.coinApplyRequest setcode:self.codeTextField.text];
    [self.coinApplyRequest sendQuery];
}
- (void)successToConform
{
    self.alpha = 0;
    [self.codeTextField resignFirstResponder];
    [MINavigator showSimpleHudWithTips:@"您的申请已受理!"];
    
    MIExchangeOrderViewController *vc = [[MIExchangeOrderViewController alloc] init];
    [[MINavigator navigator] openPushViewController:vc animated:YES];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.codeTextField.text && self.codeTextField.text.length) {
        [self coinApply];
    } else {
        [MINavigator showSimpleHudWithTips:@"请先输入验证码"];
    }
    
    return YES;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
