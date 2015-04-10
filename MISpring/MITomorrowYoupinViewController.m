//
//  MITomorrowYoupinViewController.m
//  MISpring
//
//  Created by 曲俊囡 on 14-7-31.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MITomorrowYoupinViewController.h"

@interface MITomorrowYoupinViewController ()

@end

@implementation MITomorrowYoupinViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.refreshTableView.refreshTitleImg.image = [UIImage imageNamed:@"txt_refresh_youpin"];
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
