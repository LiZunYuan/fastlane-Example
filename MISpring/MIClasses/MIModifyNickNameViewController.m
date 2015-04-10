//
//  MIModifyNickNameViewController.m
//  MISpring
//
//  Created by 曲俊囡 on 13-12-19.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIModifyNickNameViewController.h"
#import "MIUserNickUpdateModel.h"

@interface MIModifyNickNameViewController ()

@end

@implementation MIModifyNickNameViewController

- (id)initWithNickName:(NSString *)aNickName
{
    self = [super init];
    if (self) {
        // Custom initialization
        _nickName = aNickName;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationBar setBarTitle: @"修改昵称"];
    
    UIButton *myTaobaoBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 60 -10, (self.navigationBarHeight - PHONE_NAVIGATION_BAR_ITEM_HEIGHT) + (PHONE_NAVIGATION_BAR_ITEM_HEIGHT - 30) / 2, 60, 30)];
    [myTaobaoBtn setTitle:@"保存" forState:UIControlStateNormal];
    [myTaobaoBtn setTitleColor:[MIUtility colorWithHex:0x333333] forState:UIControlStateNormal];
    [myTaobaoBtn addTarget:self action:@selector(finishModifyNickName) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBar addSubview:myTaobaoBtn];
    
    UIImage *textFiledBg = [[UIImage imageNamed:@"text_input_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 10 + self.navigationBarHeight, PHONE_SCREEN_SIZE.width - 20, 40)];
    _textField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 40)];
    _textField.leftViewMode = UITextFieldViewModeAlways;
    _textField.background = textFiledBg;
    _textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _textField.placeholder = @"请输入昵称";
    _textField.text = self.nickName;
    _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _textField.keyboardType = UIKeyboardTypeDefault;
    _textField.delegate = self;
    _textField.returnKeyType = UIReturnKeyDone;
    [self.view addSubview:_textField];
    [_textField becomeFirstResponder];
    
    UILabel *reminderLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.textField.bottom + 10, self.view.viewWidth - 20, 20)];
    reminderLabel.backgroundColor = [UIColor clearColor];
    reminderLabel.textAlignment = NSTextAlignmentCenter;
    reminderLabel.text = @"限2-10个字，支持中英文、数字、下划线";
    reminderLabel.textColor = [UIColor darkGrayColor];
    reminderLabel.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:reminderLabel];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [_request cancelRequest];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self finishModifyNickName];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}

- (void)finishModifyNickName
{
    if (!self.textField.text.length || !self.textField.text || self.textField.text.length < 2 || self.textField.text.length > 10)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"无效输入"
                                                            message:@"限2-10个字，支持中英文、数字、下划线"
                                                           delegate:nil
                                                  cancelButtonTitle:@"知道了"
                                                  otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.removeFromSuperViewOnHide = YES;
    hud.yOffset = -100.0f;
    __weak typeof(self) weakSelf = self;
    _request = [[MIUserNickUpdateRequest alloc] init];
    _request.onCompletion = ^(MIUserNickUpdateModel *model) {
        [hud setHidden:YES];
        [weakSelf finishLoadData:model];
    };
    _request.onError = ^(MKNetworkOperation* completedOperation, MIError* error) {
        [hud setHidden:YES];
        MILog(@"error_msg=%@",error.description);
    };
    
    [_request setNick:self.textField.text];
    [_request sendQuery];

}
- (void)finishLoadData:(MIUserNickUpdateModel *)model
{    
    if (model.success.boolValue)
    {
        [self showSimpleHUD:@"成功修改昵称" afterDelay:1.0];
        [MIMainUser getInstance].nickName = self.textField.text;
        [[MIMainUser getInstance] persist];
        [self performSelector:@selector(popView) withObject:nil afterDelay:1.0];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"修改昵称失败"
                                                            message:model.message
                                                           delegate:nil
                                                  cancelButtonTitle:@"知道了"
                                                  otherButtonTitles:nil, nil];
        [alertView show];
    }
}
- (void)popView
{
    [[MINavigator navigator] closePopViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
