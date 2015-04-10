//
//  MITaskViewController.h
//  MISpring
//
//  Created by 曲俊囡 on 14-5-26.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MIBaseViewController.h"
#import "MICoinEarnGetRequest.h"
#import <immobSDK/immobView.h>
#import<Escore/YJFInitServer.h>
#import<Escore/YJFAdWall.h>
#import<Escore/YJFIntegralWall.h>


@interface MITaskViewController : MIBaseViewController<immobViewDelegate,YJFIntegralWallDelegate>

@property (nonatomic, retain) immobView *adView_adWall;

@property (nonatomic, strong) MICoinEarnGetRequest *request;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet RTLabel *taskTotalIncomeLabel;
@property (weak, nonatomic) IBOutlet RTLabel *exchangeLabel;
@property (weak, nonatomic) IBOutlet RTLabel *detailLabel;

@property (weak, nonatomic) IBOutlet UIButton *firstButton;
@property (weak, nonatomic) IBOutlet UIButton *secondButton;
@property (weak, nonatomic) IBOutlet UIButton *thirdButton;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (strong, nonatomic) IBOutlet UIView *ruleBgView;
@property (weak, nonatomic) IBOutlet UIView *ruleView;
@property (weak, nonatomic) IBOutlet UIImageView *line;
@property (weak, nonatomic) IBOutlet UIButton *okButton;

- (IBAction)goToTaskRoom:(id)sender;
- (IBAction)hiddenRuleView:(id)sender;

@end
