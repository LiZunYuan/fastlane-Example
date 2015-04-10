//
//  MIMyMizheViewController.h
//  MISpring
//
//  Created by XU YUJIAN on 13-1-25.
//  Copyright (c) 2013年 Husor Inc.. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MICustomerViewController.h"

@class MIUserGetModel;
@class MIUserGetRequest;

@interface MIMyMizheViewController : MIBaseViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    UIImageView *_userWall;                  //展示用户信息的背景图
    UIImageView *_userHead;                  //用户头像
    UILabel *_usernameLabel;                 //账户名信息
    UILabel *_accountLabel;                  //账户余额信息
    
    CGFloat _headerViewHeight;
    JSBadgeView *_updateBadgeView;
    UILabel *_loginBtnLabel;
    UILabel *_loginLabel;
}

@property (nonatomic, strong) UIImageView *userWall;
@property (nonatomic, strong) UIImageView *userHead;
@property (nonatomic, strong) UIImageView *levelImageView;
@property (nonatomic, strong) UILabel *usernameLabel;
@property (nonatomic, strong) UILabel *accountLabel;
@property (nonatomic, strong) UIImageView *vipCenterIndicator;
@property (nonatomic, strong) MIUserGetRequest *request;
@property (nonatomic, strong) UILabel *reminderLabel;

@property (nonatomic, strong) MICustomerViewController *customerServiceVC;
@property (nonatomic, strong) NSURL *customerServiceURL;

@end
