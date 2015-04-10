//
//  MIVIPCenterViewController.h
//  MISpring
//
//  Created by 曲俊囡 on 13-11-20.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIBaseViewController.h"
#import "MIUserVIPLevelRequest.h"

@interface MIVIPCenterViewController : MIBaseViewController

@property (nonatomic, strong) UIView *firstView;
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *nickNameLabel;
@property (nonatomic, strong) UIImageView *circleImageView;
@property (nonatomic, strong) UIImageView *currentGradeImageView;
@property (nonatomic, strong) UILabel *gradeLabel;
@property (nonatomic, strong) UILabel *privilegeLabel;
@property (nonatomic, strong) UITableView *gradeTableView;
@property (nonatomic, strong) MIUserVIPLevelRequest *request;
@property (nonatomic, strong) NSArray *vips;

@end

