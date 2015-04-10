//
//  MIChangePassViewController.h
//  MISpring
//
//  Created by yujian on 14-5-27.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MIBaseViewController.h"
#import "MIUserForgetRequest.h"
#import "MIEmailsSuffixTableView.h"

@interface MIChangePassViewController : MIBaseViewController<UITextFieldDelegate,MIChoosedEmailDelegate>

@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) UITextField *emailField;
@property (nonatomic, strong) MIUserForgetRequest *forgetRequest;
@property (nonatomic, strong) MIEmailsSuffixTableView *emailsSuffixTableView;


@end
