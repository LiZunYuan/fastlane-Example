//
//  MIInviteFriendsViewController.h
//  MISpring
//
//  Created by Yujian Xu on 13-6-16.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIBaseViewController.h"

@class MIPartnerGetRequest;
@class MIPartnerGetModel;

@interface MIInviteFriendsViewController : MIBaseViewController
{
    NSTimer* activateTimer;
}

@property (nonatomic, strong) UIView *awardBgView;
@property (nonatomic, strong) UIView *shareToFriendsView;
@property (nonatomic, strong) UIView *awardRuleView;
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;
@property (nonatomic, strong) RTLabel *totalAwardLabel;
@property (nonatomic, strong) RTLabel *validAwardLabel;
@property (nonatomic, strong) UILabel *shareLinkLabel;
@property (nonatomic, strong) MIPartnerGetRequest *partnerGetRequest;
@property (nonatomic, strong) MIPartnerGetModel *partnerGetModel;

@end
