//
//  BBSmsRegisterViewController.h
//  BeiBeiAPP
//
//  Created by yujian on 15-3-11.
//  Copyright (c) 2015年 Husor Inc. All rights reserved.
//

#import "MIBaseViewController.h"
#import "MILoginRegisterDelegate.h"

@interface MISmsRegisterViewController : MIBaseViewController

@property (nonatomic, weak) id<MILoginRegisterDelegate> loginRegisterDelegate;

@property (nonatomic, strong) NSString *phoneText;
@property (nonatomic, strong) NSString *codeText;

@end
