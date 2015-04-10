//
//  MIRegisterViewController.h
//  MISpring
//
//  Created by Yujian Xu on 13-3-18.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MBProgressHUD.h"
#import "MIEmailsSuffixTableView.h"

@protocol MICloseRegisterDelegate <NSObject>

- (void)closeLoginViewController:(id)event;

@end

@interface MIRegisterViewController : MIBaseViewController<UITextFieldDelegate,MIChoosedEmailDelegate>
{
@private
    MBProgressHUD *_hud;
    NSString *_token;
}


@property (nonatomic, weak)   id<MICloseRegisterDelegate> delegate;
@property (nonatomic, strong) UITextField *emailField;
@property (nonatomic, strong) UITextField *passwdField;
@property (nonatomic, strong) NSString *emailText;
@property (nonatomic, strong) NSString *passwordText;
@property (nonatomic, strong) UIButton *registerBtn;

@property (nonatomic, strong) MIEmailsSuffixTableView *emailsSuffixTableView;

- (id)initWithToken:(NSString *)token;

@end