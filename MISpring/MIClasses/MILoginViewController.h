//
//  MILoginViewController.h
//  MISpring
//
//  Created by XU YUJIAN on 13-1-22.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "MIRegisterViewController.h"
#import "MIThirdLoginViewController.h"
#import "MIEmailsSuffixTableView.h"
#import "MILoginRegisterDelegate.h"

@interface MILoginViewController : MIBaseViewController <UITextFieldDelegate,
                                                         MICloseRegisterDelegate,
                                                         MIAuthorizeViewDelegate,MIChoosedEmailDelegate>
{
@private
    UIImageView *_taobaoLogin;
    UIImageView *_qqLogin;
    UIImageView *_weiboLogin;
    MBProgressHUD *_hud;
}

@property (nonatomic, strong) UIView *loginView;
@property (nonatomic, strong) UITextField *emailField;
@property (nonatomic, strong) UITextField *passwdField;
@property (nonatomic, strong) UIImageView *taobaoLogin;
@property (nonatomic, strong) UIImageView *qqLogin;
@property (nonatomic, strong) UIImageView *weiboLogin;
@property (nonatomic, strong) UILabel *forgetPWD;

@property (nonatomic, strong) MIEmailsSuffixTableView *emailsSuffixTableView;

@property (nonatomic, weak) id<MILoginRegisterDelegate> loginRegisterDelegate;


@end
