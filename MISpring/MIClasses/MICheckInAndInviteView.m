//
//  MICheckInAndInviteView.m
//  MISpring
//
//  Created by 曲俊囡 on 14-5-23.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MICheckInAndInviteView.h"
#import "MIInviteFriendsViewController.h"


@implementation MICheckInAndInviteView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIButton *checkinBtn = [self buttonWithFrame:CGRectMake(0, 0, 160, self.viewHeight)];
        [checkinBtn addTarget:self action:@selector(goCheckin) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:checkinBtn];
        
        UIButton *inviteFriendsBtn = [self buttonWithFrame:CGRectMake(160, 0, 160, self.viewHeight)];
        [inviteFriendsBtn addTarget:self action:@selector(goInviteFriends) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:inviteFriendsBtn];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(frame.size.width/2, 5, 1, self.viewHeight - 14)];
        line.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.3];
        [self addSubview:line];
    }
    return self;
}

- (UIButton *)buttonWithFrame:(CGRect)frame
{
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    
    NSString *title;
    NSString *iconName;
    if (frame.origin.x == 0) {
        iconName = @"ic_checkin";
        title = @"签到领米币";
    } else {
        iconName = @"ic_invite";
        title = @"邀请奖现金";
    }
    
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor: [UIColor whiteColor] forState: UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    
//    [button setBackgroundImage:[[UIImage imageNamed:btnImgName] resizableImageWithCapInsets:UIEdgeInsetsMake(30, 2, 15, 2)] forState:UIControlStateNormal];
//    [button setBackgroundImage:[[UIImage imageNamed:[NSString stringWithFormat:@"%@_hl", btnImgName]]resizableImageWithCapInsets:UIEdgeInsetsMake(30, 2, 15, 2)] forState:UIControlStateHighlighted];
    
    UIImage *image = [UIImage imageNamed:iconName];
    [button setImage:image forState:UIControlStateNormal];
    CGFloat spacing = 5;
    [button setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, spacing, spacing)];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0.0, spacing, spacing, 0.0)];
    
    button.backgroundColor = [UIColor clearColor];
    return button;
}

- (void)goCheckin
{
    [MobClick event:kCheckin];
    
    [MINavigator openTbWebViewControllerWithURL:[NSURL URLWithString:[MIConfig globalConfig].checkinURL] desc:@"每日签到"];
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
