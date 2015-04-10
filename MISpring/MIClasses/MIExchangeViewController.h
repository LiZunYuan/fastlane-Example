//
//  MIExchangeViewController.h
//  MISpring
//
//  Created by 贺晨超 on 13-8-26.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIBaseViewController.h"
#import "MICoinApplyVerifyView.h"
#import "MIExchangeCoinsGetRequest.h"
#import "MIExchangeCoinsGetModel.h"

@interface MIExchangeViewController : MIBaseViewController<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *data;
@property (strong, nonatomic) UILabel *headerCoinTips;
@property (strong, nonatomic) MICoinApplyVerifyView *veriCodeView;
@property (strong, nonatomic) MIExchangeCoinsGetRequest *request;

@end
