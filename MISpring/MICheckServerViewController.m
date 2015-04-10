//
//  MICheckServerViewController.m
//  MISpring
//
//  Created by husor on 14-10-28.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MICheckServerViewController.h"
#import "MIAppDelegate.h"

@interface MICheckServerViewController ()
{
    MKNetworkEngine * _catsEngine;
}

@end

@implementation MICheckServerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.hidden = YES;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 100, 111, 98)];
    imageView.centerX = self.view.viewWidth/2;
    imageView.image = [UIImage imageNamed:@"ic_server_error"];
    [self.view addSubview:imageView];
    
    self.view.backgroundColor = [MIUtility colorWithHex:0xedffff];
    UILabel *titleLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    titleLabel1.backgroundColor = [UIColor clearColor];
    titleLabel1.font = [UIFont systemFontOfSize:20];
    titleLabel1.textColor = [MIUtility colorWithHex:0x666666];
    titleLabel1.top = imageView.bottom + 10;
    titleLabel1.textAlignment = UITextAlignmentCenter;
    titleLabel1.text = @"米粉们的热情太高了，";
    [self.view addSubview:titleLabel1];
    
    
    UILabel *titleLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    titleLabel2.backgroundColor = [UIColor clearColor];
    titleLabel2.textColor = [MIUtility colorWithHex:0x666666];
    titleLabel2.font = [UIFont systemFontOfSize:20];
    titleLabel2.top = titleLabel1.bottom;
    titleLabel2.textAlignment = UITextAlignmentCenter;
    titleLabel2.text = @"请给服务器君一点时间吧！";
    [self.view addSubview:titleLabel2];
    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.frame = CGRectMake(62.5, titleLabel2.bottom + 10, 90, 30);
//    button.backgroundColor = [UIColor whiteColor];
//    [button setTitle:@"一会回来" forState:UIControlStateNormal];
//    [button setTitleColor:[MIUtility colorWithHex:0x999999] forState:UIControlStateNormal];
//    button.layer.borderColor = [MIUtility colorWithHex:0xb2e8e8].CGColor;
//    button.layer.borderWidth = 2.0;
//    button.clipsToBounds = YES;
//    button.layer.cornerRadius = 2.0;
//    [button addTarget:self action:@selector(tryAgain:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:button];
    
    
    UIButton *reCheckBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    reCheckBtn.frame = CGRectMake(60+90+15, titleLabel2.bottom + 10, 90, 30);
    reCheckBtn.backgroundColor = [MIUtility colorWithHex:0xff6700];
    [reCheckBtn setTitle:@"再试一次" forState:UIControlStateNormal];
    [reCheckBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    reCheckBtn.clipsToBounds = YES;
    reCheckBtn.layer.cornerRadius = 2;
    reCheckBtn.centerX = self.view.viewWidth/2;
    [reCheckBtn addTarget:self action:@selector(checkServer:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:reCheckBtn];
}

- (void)checkServer:(UIButton *)reCheckBtn
{
    reCheckBtn.backgroundColor = [MIUtility colorWithHex:0xeb6303];
    [MIAppDelegate sendCheckServerRequest:^(NSInteger status) {
        if (status !=0 && [MINavigator navigator].lockOpenController) {
            [MINavigator navigator].lockOpenController = NO;
            [[MINavigator navigator] closePopViewControllerAnimated:NO];
        }
    }];
}

//-(void)tryAgain:(UIButton *)btn
//{
//    btn.backgroundColor = [MIUtility colorWithHex:0xededed];
//}


- (void)viewDidAppear:(BOOL)animated
{
}

- (void)viewDidDisappear:(BOOL)animated
{
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
