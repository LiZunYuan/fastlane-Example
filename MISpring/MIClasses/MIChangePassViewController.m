//
//  MIChangePassViewController.m
//  MISpring
//
//  Created by yujian on 14-5-27.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MIChangePassViewController.h"
#import "MICommonButton.h"
#import "MIMainUser.h"
#import "MIUserForgetModel.h"
#import "MIUserForgetRequest.h"
@interface MIChangePassViewController ()

@end

@implementation MIChangePassViewController
@synthesize emailField = _emailField;


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationBar setBarLeftButtonItem:self selector:@selector(closeLoginView:) imageKey:@"navigationbar_btn_close"];
    [self.navigationBar setBarTitle:@"忘记密码"];
    
    UIImage *textFiledBg = [[UIImage imageNamed:@"text_input_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    self.emailField = [[UITextField alloc] initWithFrame:CGRectMake(10, 10 + self.navigationBarHeight, PHONE_SCREEN_SIZE.width - 20, 40)];
    self.emailField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 40)];
    self.emailField.leftViewMode = UITextFieldViewModeAlways;
    self.emailField.background = textFiledBg;
    self.emailField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    if([MIMainUser getInstance].loginAccount)
    {
        self.emailField.text = [MIMainUser getInstance].loginAccount;
    } else {
        self.emailField.text = self.email;
    }
    self.emailField.placeholder = @"请输入您的注册邮箱";
    self.emailField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.emailField.keyboardType = UIKeyboardTypeDefault;
    self.emailField.delegate = self;
    self.emailField.returnKeyType = UIReturnKeyDone;
    [self.view addSubview:self.emailField];
    [self.emailField becomeFirstResponder];
    
    MICommonButton *btn = [[MICommonButton alloc] initWithFrame:CGRectMake(10, 60 + self.navigationBarHeight, SCREEN_WIDTH - 20, 36)];
    [btn turnRed];
    [btn setTitle:@"取回密码" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(submitButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    _emailsSuffixTableView = [[MIEmailsSuffixTableView alloc] initWithFrame:CGRectMake(_emailField.left, 57 + self.navigationBarHeight, _emailField.viewWidth, 220) style:UITableViewStylePlain];
    self.emailsSuffixTableView.emailDelegate = self;
    self.emailsSuffixTableView.alpha = 0;
    [self.view addSubview:self.emailsSuffixTableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)submitButtonTouched:(UIButton *)btn
{
    if (self.emailField.text.length == 0) {
        [self showSimpleHUD:@"请先输入注册邮箱"];
    } else if (![MIUtility validatorEmail:self.emailField.text]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithMessage:@"请输入正确的邮箱地址，例如 example@example.com"];
        [alertView show];
    } else {
        [self showProgressHUD:nil];
        
        __weak typeof(self) weakSelf = self;
        self.forgetRequest = [[MIUserForgetRequest alloc] init];
        [self.forgetRequest setEmail:self.emailField.text];
        self.forgetRequest.onCompletion = ^(MIUserForgetModel * model) {
            [weakSelf hideProgressHUD];
            if ([model.success boolValue] == TRUE) {
                [MIUtility checkForEmail:weakSelf.emailField.text message:@"成功发送找回密码邮件，请登录邮箱及时查收"];
            } else {
                [weakSelf showSimpleHUD:model.message];
            }
        };
        self.forgetRequest.onError = ^(MKNetworkOperation* completedOperation, MIError* error) {
            [weakSelf hideProgressHUD];
        };
        
        [self.forgetRequest sendQuery];
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
    [self.emailsSuffixTableView loadArrayDataWith:text];
    
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


- (void)closeLoginView: (id) event
{
    [[MINavigator navigator] closeModalViewController:YES completion:^{
 
    }];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)finishChoosingEmail:(NSString *)text
{
    self.emailField.text = text;
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
