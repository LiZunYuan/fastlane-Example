//
//  MIAlipaySettingViewController.m
//  MISpring
//
//  Created by Yujian Xu on 13-3-22.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIAlipaySettingViewController.h"
#import "MIAliContextPhoneViewController.h"

@implementation MIAlipaySettingViewController
@synthesize inputNameField = _inputNameField;
@synthesize inputAlipayAccountField = _inputAlipayAccountField;
@synthesize alipaySettingButton = _alipaySettingButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.navigationBar setBarTitle:self.barTitle];

    UITapGestureRecognizer *resignFirstResponse = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignFirstResponse)];
    resignFirstResponse.delegate = self;
    [self.view addGestureRecognizer:resignFirstResponse];
    
    UILabel *inputNameLable = [[UILabel alloc] initWithFrame:CGRectMake(15, 5 + self.navigationBarHeight, SCREEN_WIDTH - 30, 30)];
    inputNameLable.backgroundColor = [UIColor clearColor];
    inputNameLable.font = [UIFont systemFontOfSize:16];
    inputNameLable.textColor = [UIColor darkGrayColor];
    inputNameLable.text = @"我的真实姓名";
    [self.view addSubview:inputNameLable];
    
    UIImage *textFiledBg = [[UIImage imageNamed:@"text_input_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    _inputNameField = [[UITextField alloc] initWithFrame:CGRectMake(10, inputNameLable.bottom, SCREEN_WIDTH - 20, 40)];
    _inputNameField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 40)];
    _inputNameField.leftViewMode = UITextFieldViewModeAlways;
    _inputNameField.background = textFiledBg;
    _inputNameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _inputNameField.placeholder = @"输入您的真实姓名";
    _inputNameField.keyboardType = UIKeyboardTypeNamePhonePad;
    _inputNameField.returnKeyType = UIReturnKeyNext;
    _inputNameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _inputNameField.delegate = self;
    [self.view addSubview:_inputNameField];
    
    UILabel *inputAlipayLable = [[UILabel alloc] initWithFrame:CGRectMake(15, 75 + self.navigationBarHeight, SCREEN_WIDTH - 30, 30)];
    inputAlipayLable.backgroundColor = [UIColor clearColor];
    inputAlipayLable.font = [UIFont systemFontOfSize:16];
    inputAlipayLable.textColor = [UIColor darkGrayColor];
    inputAlipayLable.lineBreakMode = NSLineBreakByCharWrapping;
    inputAlipayLable.numberOfLines = 0;
    inputAlipayLable.text = @"收款支付宝账户";
    [self.view addSubview:inputAlipayLable];
    
    NSString *forgetAccount = @"忘记账户？";
    CGSize labelSize = [forgetAccount sizeWithFont:[UIFont systemFontOfSize:14.0f]
                                 constrainedToSize:CGSizeMake(300, 30)];
    UILabel *_forgetAccount = [[UILabel alloc] initWithFrame:CGRectMake(300 - labelSize.width, 75 + self.navigationBarHeight, labelSize.width + 10, 30)];
    _forgetAccount.backgroundColor = [UIColor clearColor];
    _forgetAccount.font = [UIFont systemFontOfSize:14.0];
    _forgetAccount.textColor = [UIColor blueColor];
    _forgetAccount.textAlignment = UITextAlignmentRight;
    _forgetAccount.text = forgetAccount;
    _forgetAccount.userInteractionEnabled = YES;
    [self.view addSubview:_forgetAccount];
    
    UITapGestureRecognizer *forgetPassWord = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goForgetAccount)];
    [_forgetAccount addGestureRecognizer:forgetPassWord];
    
    _inputAlipayAccountField = [[UITextField alloc] initWithFrame:CGRectMake(10, inputAlipayLable.bottom, SCREEN_WIDTH - 20, 40)];
    _inputAlipayAccountField.background = textFiledBg;
    _inputAlipayAccountField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 40)];
    _inputAlipayAccountField.leftViewMode = UITextFieldViewModeAlways;
    _inputAlipayAccountField.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    _inputAlipayAccountField.placeholder = @"无需密码，请放心填写";
    _inputAlipayAccountField.returnKeyType = UIReturnKeyDone;
    _inputAlipayAccountField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _inputAlipayAccountField.delegate = self;
    [self.view addSubview:_inputAlipayAccountField];
    
    _alipaySettingButton = [[MICommonButton alloc] initWithFrame:CGRectMake(10, 155 + self.navigationBarHeight, SCREEN_WIDTH - 20, 36)];
    [_alipaySettingButton setTitle:@"下一步" forState:UIControlStateNormal];
    [_alipaySettingButton addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_alipaySettingButton];
    
    RTLabel *alipaySettingTip = [[RTLabel alloc] initWithFrame:CGRectMake(10, 205 + self.navigationBarHeight, SCREEN_WIDTH - 20, self.view.viewHeight - self.navigationBarHeight - 190)];
    alipaySettingTip.backgroundColor = [UIColor clearColor];
    alipaySettingTip.font = [UIFont systemFontOfSize:14.0];
    alipaySettingTip.lineBreakMode = kCTLineBreakByCharWrapping;
    alipaySettingTip.lineSpacing = 5.0;
    alipaySettingTip.text = [[NSString alloc] initWithFormat:@"<font size=16.0 color='#499d00'>提示：</font> \n您还没设置过收款支付宝账户，请填写已通过实名认证的支付宝账户，否则无法正常收款。"];
    [self.view addSubview:alipaySettingTip];
    
    if (self.showSkipBtn) {
        _skipBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 85, (self.navigationBarHeight - PHONE_NAVIGATION_BAR_ITEM_HEIGHT), 80, PHONE_NAVIGATION_BAR_ITEM_HEIGHT)];
        [_skipBtn setTitle:@"跳过" forState:UIControlStateNormal];
        [_skipBtn addTarget:self action:@selector(skipThisStep) forControlEvents:UIControlEventTouchUpInside];
        [self.navigationBar addSubview:_skipBtn];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)skipThisStep
{
    [[MINavigator navigator] closePopViewControllerAnimated:NO];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[UIButton class]] || [touch.view isKindOfClass:[UILabel class]])
    {
        return NO;
    }
    return YES;
}

- (void)resignFirstResponse
{
    if ([_inputNameField isFirstResponder]) {
        [_inputNameField resignFirstResponder];
    }
    
    if ([_inputAlipayAccountField isFirstResponder]) {
        [_inputAlipayAccountField resignFirstResponder];
    }
}

- (void)goForgetAccount
{
    MIButtonItem *cancelItem = [MIButtonItem itemWithLabel:@"取消"];
    cancelItem.action = nil;
    
    MIButtonItem *affirmItem = [MIButtonItem itemWithLabel:@"好"];
    affirmItem.action = ^{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[MIConfig globalConfig].findAlipayAccountURL]];
    };
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"即将打开Safari前往淘宝查看支付宝账户信息"
                                               cancelButtonItem:cancelItem
                                               otherButtonItems:affirmItem, nil];
    [alertView show];
}

- (void)confirm
{
    NSString *errorMsg;
    if ([_inputNameField isFirstResponder]) {
        [_inputNameField resignFirstResponder];
    }
    if ([_inputAlipayAccountField isFirstResponder]) {
        [_inputAlipayAccountField resignFirstResponder];
    }
    
    if (_inputNameField == nil || _inputNameField.text.length == 0) {
        errorMsg = @"请输入您的真实姓名";
        [_inputNameField becomeFirstResponder];
    } else if (_inputAlipayAccountField == nil || _inputAlipayAccountField.text.length == 0)
    {
        errorMsg = @"请输入支付宝账户";
        [_inputAlipayAccountField becomeFirstResponder];
    }
    
    if (errorMsg != nil) {
        [self showSimpleHUD:errorMsg];
    } else {
        MIAliContextPhoneViewController *contextPhoneView = [[MIAliContextPhoneViewController alloc] init];
        contextPhoneView.aliPayAccount = _inputAlipayAccountField.text;
        contextPhoneView.realName = _inputNameField.text;
        [[MINavigator navigator] openPushViewController:contextPhoneView animated:YES];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (textField == _inputNameField) {
        [_inputAlipayAccountField becomeFirstResponder];
    } else if (textField == _inputAlipayAccountField) {
        [self confirm];
    }

    return YES;
}

@end
