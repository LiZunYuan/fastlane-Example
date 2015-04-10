//
//  BBEmailBindViewController.h
//  BeiBeiAPP
//
//  Created by yujian on 14-10-22.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MIBaseViewController.h"
#import "MIBindEmailView.h"

@interface MIEmailBindViewController : MIBaseViewController<MIBindEmailDelegate>

- (id)initWithToken:(NSString *)token;

@property(nonatomic, strong) NSString *email;
@property(nonatomic, strong)UILabel *tipLabel;
@end
