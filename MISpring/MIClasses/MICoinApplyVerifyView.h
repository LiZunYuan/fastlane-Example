//
//  MICoinApplyVerifyView.h
//  BeiBeiAPP
//
//  Created by 曲俊囡 on 14-3-25.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MICoinModel.h"
#import "MISMSSendRequest.h"
#import "MIExchangeCoinApplyRequest.h"

@interface MICoinApplyVerifyView : UIView<UITextFieldDelegate>
{
    NSInteger _counter;
    NSInteger _randomVeriCode;
}

@property (nonatomic, strong) MICoinModel *coinModel;
@property (nonatomic, strong) NSTimer *counttingTimer;
@property (nonatomic, strong) MISMSSendRequest *smsSendRequest;
@property (nonatomic, strong) MIExchangeCoinApplyRequest *coinApplyRequest;

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *conformButton;
@property (weak, nonatomic) IBOutlet UIButton *getVerifyCodeButton;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;

- (IBAction)getVerificationCodeAction:(id)sender;

@end
