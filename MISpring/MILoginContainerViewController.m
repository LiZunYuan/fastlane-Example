//
//  BBLoginContainerViewController.m
//  BeiBeiAPP
//
//  Created by yujian on 15-2-10.
//  Copyright (c) 2015年 Husor Inc. All rights reserved.
//

#import "MILoginContainerViewController.h"
#import "MILoginViewController.h"
#import "MIRegisterViewController.h"
#import "MIAlipaySettingViewController.h"
#import "MIPhoneSettingViewController.h"
#import "MIHeartbeat.h"
#import "MIRegisterPhoneViewController.h"
#import "MISmsLoginViewController.h"
#import "MISmsRegisterViewController.h"

@interface MILoginContainerViewController ()<MILoginRegisterDelegate>
{
    UIViewController *_currentViewController;
}

@end

@implementation MILoginContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    MILoginViewController *loginViewController = [[MILoginViewController alloc] init];
    loginViewController.loginRegisterDelegate = self;
    [self addChildViewController:loginViewController];
    
    MIRegisterPhoneViewController *phoneRegisterController = [[MIRegisterPhoneViewController alloc] init];
    phoneRegisterController.loginRegisterDelegate = self;
    [self addChildViewController:phoneRegisterController];
    
    MISmsLoginViewController *smsLoginController = [[MISmsLoginViewController alloc] init];
    smsLoginController.loginRegisterDelegate = self;
    [self addChildViewController:smsLoginController];
    
    MISmsRegisterViewController *smsRegisterController = [[MISmsRegisterViewController alloc] init];
    smsRegisterController.loginRegisterDelegate = self;
    [self addChildViewController:smsRegisterController];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (_currentViewController == nil) {
        _currentViewController = [self.childViewControllers objectAtIndex:self.containerType];
        [self.view addSubview:_currentViewController.view];
        if (IOS_VERSION < 7.0) {
            _currentViewController.view.top = 0;
        }
    }
}

-(void) goToNextController:(LoginContainerType)type
{
    [self transitionToChildController:type];
}

- (void)transitionToChildController:(LoginContainerType)type
{
    UIViewController *controller = [self.childViewControllers objectAtIndex:type];
    self.containerType = type;
    if (IOS_VERSION < 7.0) {
        controller.view.top = 0;
    }
    
    //此方法用于清空下一个跳转的controller中的数据
    if ([controller respondsToSelector:@selector(clear)]) {
        [controller performSelector:@selector(clear) withObject:nil];
    }
    
    //passValueToNextController此方法用于container中的controller中间传值
    if ([_currentViewController respondsToSelector:@selector(passValueToNextController:)]){
        [_currentViewController performSelector:@selector(passValueToNextController:) withObject:controller];
    }
    
    [self transitionFromViewController:_currentViewController toViewController:controller duration:0.5f options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
    } completion:^(BOOL finished) {
        _currentViewController = controller;
    }];
}

- (void)closeLoginView: (id) event
{
    [[MINavigator navigator] closeModalViewController:YES completion:^{
        
        if (event == nil) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kAdsDataHasUpdated];
            [[MIHeartbeat shareHeartbeat] startActivate];  //启动更新冒泡的心跳
            MIMainUser *mainUser = [MIMainUser getInstance];
            
            NSMutableArray *loginSuccessUsers = nil;
            if (![[NSUserDefaults standardUserDefaults] objectForKey:@"LoginSuccessUsers"])
            {
                loginSuccessUsers = [[NSMutableArray alloc] initWithCapacity:10];
            }
            else
            {
                loginSuccessUsers = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"LoginSuccessUsers"]];
            }
            
            if ([mainUser.loginAccount hasSuffix:@"@open.mizhe"])
            {
                if (![loginSuccessUsers containsObject:mainUser.phoneNum])
                {
                    [loginSuccessUsers addObject:mainUser.phoneNum];
                    [[NSUserDefaults standardUserDefaults] setObject:loginSuccessUsers forKey:@"LoginSuccessUsers"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
            }
            else
            {
                if (mainUser.phoneNum && mainUser.phoneNum.length != 0) {
                    if (![loginSuccessUsers containsObject:mainUser.phoneNum])
                    {
                        [loginSuccessUsers addObject:mainUser.phoneNum];
                        [[NSUserDefaults standardUserDefaults] setObject:loginSuccessUsers forKey:@"LoginSuccessUsers"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    }
                }
                
                if (mainUser.loginAccount && ![loginSuccessUsers containsObject:mainUser.loginAccount])
                {
                    [loginSuccessUsers addObject:mainUser.loginAccount];
                    [[NSUserDefaults standardUserDefaults] setObject:loginSuccessUsers forKey:@"LoginSuccessUsers"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
            }

            
            if ((mainUser.phoneNum == nil) || (mainUser.phoneNum.length == 0))
            {
                MIPhoneSettingViewController *vc = [[MIPhoneSettingViewController alloc] init];
                vc.showSkipBtn = YES;
                [[MINavigator navigator] openPushViewController:vc animated:NO];
            }
            else if ((mainUser.alipay == nil) || (mainUser.alipay.length == 0))
            {
                MIAlipaySettingViewController *vc = [[MIAlipaySettingViewController alloc] init];
                vc.barTitle = @"绑定支付宝";
                vc.showSkipBtn = YES;
                [[MINavigator navigator] openPushViewController:vc animated:NO];
            }
            else
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:MiNotifyUserHasLogined object:nil];
            }
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
