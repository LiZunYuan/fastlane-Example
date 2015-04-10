//
//  MIAddTaskView.m
//  MISpring
//
//  Created by 曲俊囡 on 14-5-23.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MIAddTaskView.h"
#import "MIInviteFriendsViewController.h"
#import "MITaskViewController.h"

@implementation MIAddTaskView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIButton *checkinBtn = [self buttonWithFrame:CGRectMake(0, 0, 106, self.viewHeight) bgImgName:@"bg_my_header_seperate_line"];
        [checkinBtn addTarget:self action:@selector(goCheckin) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:checkinBtn];
        
        UIButton *inviteFriendsBtn = [self buttonWithFrame:CGRectMake(106, 0, 106, self.viewHeight) bgImgName:@"bg_my_header_seperate_line"];
        [inviteFriendsBtn addTarget:self action:@selector(goInviteFriends) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:inviteFriendsBtn];
        
        UIButton *taskBtn = [self buttonWithFrame:CGRectMake(106 * 2, 0, 108, self.viewHeight) bgImgName:@"bg_my_header_background"];
        [taskBtn addTarget:self action:@selector(goToTask) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:taskBtn];
    }
    return self;
}

- (UIButton *)buttonWithFrame:(CGRect)frame bgImgName:(NSString *) btnImgName
{
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    
    NSString *title;
    NSString *iconName;
    if (frame.origin.x == 0) {
        iconName = @"ic_checkin_big";
        title = @"签到领米币";
    }
    else if (frame.origin.x == 106)
    {
        iconName = @"ic_invite_big";
        title = @"邀请奖现金";
    }
    else {
        iconName = @"ic_task_receive_orange";
        title = @"天天赚米币";
    }
    
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor: [MIUtility colorWithHex:0xffaa53] forState: UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    
    [button setBackgroundImage:[[UIImage imageNamed:btnImgName] resizableImageWithCapInsets:UIEdgeInsetsMake(16, 1.5, 16, 1.5)] forState:UIControlStateNormal];
    [button setBackgroundImage:[[UIImage imageNamed:[NSString stringWithFormat:@"%@_hl", btnImgName]]resizableImageWithCapInsets:UIEdgeInsetsMake(16, 1.5, 16, 1.5)] forState:UIControlStateHighlighted];
    
    UIImage *image = [UIImage imageNamed:iconName];
    [button setImage:image forState:UIControlStateNormal];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0.0, 39.0, 25.0, 0.0)];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(20.0, -15.0, 0.0, 5.0)];
    
    button.backgroundColor = [UIColor clearColor];
    return button;
}

- (void)goCheckin
{
    if ([MIMainUser getInstance].loginStatus == MILoginStatusNotLogined) {
        //尚未登录，提示用户先登录
        [self goLogin];
    } else {
        [MobClick event:kCheckin];
        
        NSString *checkinPath = [MIUtility trustLoginWithUrl:[MIConfig globalConfig].checkinURL];
        [MINavigator openTbWebViewControllerWithURL:[NSURL URLWithString:checkinPath] desc:@"每日签到"];
    }
}

- (void)goInviteFriends
{
    if ([MIMainUser getInstance].loginStatus == MILoginStatusNotLogined) {
        //尚未登录，提示用户先登录
        [self goLogin];
    } else {
        [MobClick event:kInvited];
        MIInviteFriendsViewController* vc = [[MIInviteFriendsViewController alloc] init];
        [[MINavigator navigator] openPushViewController:vc animated:YES];
    }
}
- (void)goToTask
{
    if ([MIMainUser getInstance].loginStatus == MILoginStatusNotLogined) {
        //尚未登录，提示用户先登录
        [self goLogin];
    } else {
        [MobClick event:kDoTasks];
        
        MITaskViewController *taskVC = [[MITaskViewController alloc] initWithNibName:@"MITaskViewController" bundle:nil];
        [[MINavigator navigator] openPushViewController:taskVC animated:YES];
    }
}

- (void)goLogin
{
    [MINavigator openLoginViewController];
    [MIConfig globalConfig].isHiddenReminderView = NO;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
