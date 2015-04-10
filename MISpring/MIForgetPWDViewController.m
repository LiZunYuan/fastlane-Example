//
//  BBForgetPWDViewController.m
//  BeiBeiAPP
//
//  Created by 徐 裕健 on 14-5-11.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MIForgetPWDViewController.h"
#import "MIUserForgetModel.h"
#import "MIFindPasswordBackViewController.h"

@implementation MIForgetPWDViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationBar setBarTitle:@"忘记密码"];
    [self.navigationBar setBarLeftButtonItem:self selector:@selector(closeForgetPWDView) imageKey:@"navigationbar_btn_close"];
    
    UIView *forgetPasswordView = [[UIView alloc] initWithFrame:CGRectMake(0, 10 + self.navigationBarHeight, self.view.viewWidth, 45)];
    forgetPasswordView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 13, 19, 19)];
    imageView.image = [UIImage imageNamed:@"ic_register_account"];
    [forgetPasswordView addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 45)];
    label.font = [UIFont systemFontOfSize:14.0];
    label.text = @"账号";
    label.left = imageView.right+5;
    [forgetPasswordView addSubview:label];
    
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - label.right - 5, 45)];
    _textField.leftViewMode = UITextFieldViewModeAlways;
    _textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _textField.font = [UIFont systemFontOfSize:14.0];
    _textField.placeholder = @"请输入需要找回的手机号码/邮箱";
    _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _textField.keyboardType = UIKeyboardTypeDefault;
    _textField.delegate = self;
    _textField.returnKeyType = UIReturnKeyDone;
    [_textField becomeFirstResponder];
    _textField.left = label.right + 5;
    [forgetPasswordView addSubview:_textField];
    
    [self.view addSubview:forgetPasswordView];
    
    UIButton *loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 60 + self.navigationBarHeight, SCREEN_WIDTH - 20, 45)];
    loginBtn.clipsToBounds = YES;
    loginBtn.layer.cornerRadius = 3;
    [loginBtn setTitle:@"找回密码" forState:UIControlStateNormal];
    loginBtn.backgroundColor = MICommitButtonBackground;
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(submitButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    loginBtn.top = forgetPasswordView.bottom + 10;
    [self.view addSubview:loginBtn];
    
    _emailsSuffixTableView = [[MIEmailsSuffixTableView alloc] initWithFrame:CGRectMake(_textField.left, 57 + self.navigationBarHeight, _textField.viewWidth, 220) style:UITableViewStylePlain];
    self.emailsSuffixTableView.emailDelegate = self;
    self.emailsSuffixTableView.alpha = 0;
    [self.view addSubview:self.emailsSuffixTableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _textField.text = self.email;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.forgetRequest cancelRequest];
}

- (void)closeForgetPWDView
{
    [[MINavigator navigator] closeModalViewController:YES completion:nil];
}
- (void)submitButtonTouched:(UIButton *)btn
{
    if (self.textField.text.length == 0) {
        [self showSimpleHUD:@"请先输入需要找回的手机号码/邮箱"];
    } else if ([MIUtility validatorNumeric:self.textField.text]) {
        MIFindPasswordBackViewController *controller = [[MIFindPasswordBackViewController alloc] init];
        controller.phoneNum = self.textField.text;
        [self presentViewController:controller animated:YES completion:nil];
    } else if ([MIUtility validatorEmail:self.textField.text]){
        [self showProgressHUD:nil];
        
        __weak typeof(self) weakSelf = self;
        NSString *mail = self.textField.text;
        self.forgetRequest = [[MIUserForgetRequest alloc] init];
        [self.forgetRequest setEmail:mail];
        self.forgetRequest.onCompletion = ^(MIUserForgetModel * model) {
            [weakSelf hideProgressHUD];
            if ([model.success boolValue] == TRUE) {
                [MIUtility checkForEmail:mail message:@"成功发送找回密码邮件，请登录邮箱及时查收" label:@"去查收"];
            } else {
                [weakSelf showSimpleHUD:model.message];
            }
        };
        self.forgetRequest.onError = ^(MKNetworkOperation* completedOperation, MIError* error) {
            [weakSelf hideProgressHUD];
        };
        
        [self.forgetRequest sendQuery];

    } else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithMessage:@"您输入的手机号或邮箱有误"];
        [alertView show];
    }
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.text.length > 0) {
        [textField resignFirstResponder];
        [self submitButtonTouched:nil];
    }
    self.emailsSuffixTableView.alpha = 0;

    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSRange foundObj=[text rangeOfString:@"@" options:NSCaseInsensitiveSearch];
    if(foundObj.length > 0 )
    {
        [self.emailsSuffixTableView loadArrayDataWith:text];
    }
    else
    {
        self.emailsSuffixTableView.alpha = 0;
    }
    return YES;
}
- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    self.emailsSuffixTableView.alpha = 0;
    return YES;
}

-(void)keyboardWillShow:(NSNotification *)notification{
    NSDictionary* info = notification.userInfo;
    NSValue* kbFrameValue = [info valueForKey:UIKeyboardFrameEndUserInfoKey];
    
    [UIView animateWithDuration:[[info valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        self.emailsSuffixTableView.viewHeight = self.view.viewHeight - self.navigationBarHeight - 57 - ([kbFrameValue CGRectValue].size.height);
    } completion:^(BOOL finished){
        
    }];
}

- (void)finishChoosingEmail:(NSString *)text
{
    self.textField.text = text;
    self.emailsSuffixTableView.alpha = 0;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
