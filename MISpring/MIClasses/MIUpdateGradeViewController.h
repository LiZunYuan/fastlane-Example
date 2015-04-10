//
//  MIUpdateGradeViewController.h
//  MISpring
//
//  Created by 曲俊囡 on 13-11-21.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIBaseViewController.h"
#import "MIVipModel.h"
#import "MIPartnerGetRequest.h"
#import "MIUserVIPApplyRequest.h"

@interface MIUpdateGradeViewController : MIBaseViewController

@property (nonatomic, assign) NSInteger indexOfGrade;
@property (nonatomic, strong) MIVipModel *vipModel;

@property (nonatomic, strong) UIView *mainBackgroundView;
@property (nonatomic, strong) RTLabel *reminderLabel;
@property (nonatomic, strong) RTLabel *numOfRebateFriendsLabel;
@property (nonatomic, strong) UILabel *currentNumOfRebateFriendsLabel;
@property (nonatomic, strong) RTLabel *incomeOfRebateLabel;
@property (nonatomic, strong) UILabel *currentIncomeOfRebateLabel;

@property (nonatomic, strong) MIPartnerGetRequest *request;
@property (nonatomic, strong) MIUserVIPApplyRequest *applyRequest;

@end
