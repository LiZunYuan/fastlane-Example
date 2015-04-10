//
//  MIBBTuanViewController.m
//  MISpring
//
//  Created by husor on 14-10-16.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MIBBTuanViewController.h"

@interface MIBBTuanViewController ()
@end

@implementation MIBBTuanViewController

- (id) initWithURL: (NSURL*)URL
{
    if (self = [super initWithURL:URL]) {
        NSString *defaultUserAgent = [[NSUserDefaults standardUserDefaults] stringForKey:kDefaultUserAgent];
        NSDictionary *dictionnary = [[NSDictionary alloc] initWithObjectsAndKeys:defaultUserAgent, @"UserAgent", nil];
        [[NSUserDefaults standardUserDefaults] registerDefaults:dictionnary];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationBar setBarTitle:@"商品详情"];
    [self.view bringSubviewToFront:self.navigationBar];
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
