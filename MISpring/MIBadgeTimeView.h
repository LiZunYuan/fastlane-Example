//
//  BBBadgeTimeView.h
//  BeiBeiAPP
//
//  Created by yujian on 14-10-17.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MIBadgeTimeView : UIView

//@property (nonatomic, assign) NSInteger leftTime;
@property (nonatomic, strong) UILabel *hourBadgeView;
@property (nonatomic, strong) UILabel *miniteBadgeView;
@property (nonatomic, strong) UILabel *secondBadgeView;

@end
