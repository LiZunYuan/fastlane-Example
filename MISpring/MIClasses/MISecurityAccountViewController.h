//
//  MISecurityAccountViewController.h
//  MISpring
//
//  Created by 曲俊囡 on 13-11-13.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIBaseViewController.h"
#import "MIUserGetRequest.h"

@interface MISecurityAccountViewController : MIBaseViewController

@property (nonatomic, strong) MIUserGetRequest *request;
@property (nonatomic, strong) UILabel *remindLabel;
@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) UIView *contentview;

@end
