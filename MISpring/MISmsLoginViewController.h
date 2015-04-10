//
//  BBSmsLoginViewController.h
//  BeiBeiAPP
//
//  Created by yujian on 15-3-11.
//  Copyright (c) 2015年 Husor Inc. All rights reserved.
//

#import "MIBaseViewController.h"
#import "MILoginRegisterDelegate.h"

@interface MISmsLoginViewController : MIBaseViewController

@property (nonatomic, weak) id<MILoginRegisterDelegate> loginRegisterDelegate;

- (void)passValueToNextController:(UIViewController *)controller;

- (void)clear;

@end
