//
//  MIExchangePayViewController.h
//  MISpring
//
//  Created by 贺晨超 on 13-8-27.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIBaseViewController.h"
#import "MISMSSendRequest.h"
#import "MIExchangeCoinApplyRequest.h"

@interface MIExchangePayViewController : MIBaseViewController<UIGestureRecognizerDelegate>{
    NSInteger _randomVeriCode;
    NSInteger _counter;
}
@property (nonatomic, strong) NSTimer *counttingTimer;
@property (strong, nonatomic) UITextField *phoneFirstField;
@property (strong, nonatomic) UITextField *phoneSecondField;
@property (strong, nonatomic) UITextField *codeField;
@property (strong, nonatomic) MICommonButton *codeButton;
@property (strong, nonatomic) MICommonButton *coinButton;
@property (strong, nonatomic) MICommonButton *moneyButton;
@property (nonatomic, strong) MISMSSendRequest *smsSendRequest;
@property (nonatomic, strong) MIExchangeCoinApplyRequest *request;
@property (nonatomic, assign) int payNum;
@property (nonatomic, assign) int gid;

@end
