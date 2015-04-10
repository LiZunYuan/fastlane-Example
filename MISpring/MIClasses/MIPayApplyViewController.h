//
//  MIPayApplyViewController.h
//  MISpring
//
//  Created by Yujian Xu on 13-3-22.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIBaseViewController.h"
#import "MIPayApplyRequest.h"
#import "MIPayApplyGetRequest.h"
#import "MIPushBadgeClearRequest.h"
#import "MIHeartbeat.h"
#import "MISMSSendRequest.h"
#import "MIBBMarqueeView.h"

@interface MIPayApplyViewController : MIBaseViewController <UIGestureRecognizerDelegate, UITextFieldDelegate>

@property (nonatomic, assign) NSInteger maxAmount;      //最大可提现的金额
@property (nonatomic, assign) NSInteger payApplySum;
@property (nonatomic, strong) NSString *alipayAccount;  //支付宝账户
@property (nonatomic, strong) UITextField *inputAmountField;
@property (nonatomic, strong) UITextField *inputPasswordField;
@property (nonatomic, strong) UITextField *inputCodeField;
@property (nonatomic, strong) UIButton *payApplyButton;
@property (nonatomic, strong) UIButton *getCodeBtn;
@property (nonatomic, strong) UILabel *jifenbao;
@property (nonatomic, strong) UILabel *inputAmountLable;
@property (nonatomic, strong) RTLabel *payApplyTip;
@property (nonatomic, strong) UIImageView *badgeImageView;
@property (nonatomic, strong) MIPayApplyRequest *payApplyRequest;
@property (nonatomic, strong) MIPayApplyGetRequest *payApplyGetRequest;
@property (nonatomic, strong) MISMSSendRequest *smsSendRequest;
@property (nonatomic, strong) NSTimer *counttingTimer;
@property (nonatomic, assign) NSInteger counter;
@property (nonatomic, strong) MIBBMarqueeView *tipLabel;
@property (nonatomic, strong) UIView *backView;//除了tip的所有

@end
