//
//  MITemaiViewController.h
//  MISpring
//
//  Created by 曲俊囡 on 14-7-22.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MITuanBaseViewController.h"
#import "MITemaiGetRequest.h"
#import "MITemaiGetModel.h"
#import "MITenTemaiBaseViewController.h"

@interface MITemaiViewController : MITenTemaiBaseViewController

@property (nonatomic, strong) MITemaiGetRequest *request;

@end
