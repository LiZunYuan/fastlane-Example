//
//  BBForgetPWDViewController.h
//  BeiBeiAPP
//
//  Created by 徐 裕健 on 14-5-11.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MIBaseViewController.h"
#import "MIUserForgetRequest.h"
#import "MIEmailsSuffixTableView.h"


@interface MIForgetPWDViewController : MIBaseViewController<UITextFieldDelegate,MIChoosedEmailDelegate>

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) MIUserForgetRequest *forgetRequest;
@property (nonatomic, strong) NSString *email;

@property (nonatomic, strong) MIEmailsSuffixTableView *emailsSuffixTableView;

@end
