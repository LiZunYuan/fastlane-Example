//
//  MINavigator.h
//  MISpring
//
//  Created by Yujian Xu on 13-3-11.
//  Copyright (c) 2013年 Husor Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIMainScreenViewController.h"

@interface MINavigator : NSObject

@property (nonatomic, strong) UINavigationController *navigationController;
@property (nonatomic, assign) BOOL  lockOpenController;

+ (MINavigator*)navigator;

// 打开新界面，默认为有动画效果的push方式
- (BOOL)openPushViewController:(UIViewController*)viewController animated:(BOOL)animate;

// 关闭新界面，默认为有动画效果的pop方式
- (UIViewController*)closePopViewControllerAnimated:(BOOL)animate;

// 关闭新界面到指定界面，默认为有动画效果的pop方式
- (NSArray*)closePopViewControllerAtIndex:(NSUInteger)index animated:(BOOL)animate;

// 关闭所有新界面，默认为有动画效果的pop方式
- (NSArray*)closePopViewControllerToRootWithAnimated:(BOOL)animate;

// 打开模态界面，默认为有动画效果
- (BOOL)openModalViewController:(UIViewController*)viewController animated:(BOOL)animate;

// 关闭模态界面
- (BOOL)closeModalViewController:(BOOL)animate completion:(void (^)(void))completion;

// 清空全部界面
- (void)removeAllViewControllers;

//
- (void)popToRootViewController:(BOOL)animate;
// 回到根VC
- (BOOL)popToRootViewControllerWithAnimated:(BOOL)animated;

// 页面跳转
- (BOOL)goMainScreenFromNullByIndex:(MainScreenIndex)screenIndex info:(NSDictionary*)info;
- (BOOL)goMainScreenFromAnyByIndex:(MainScreenIndex)screenIndex info:(NSDictionary*)info;

// 打开taobao web页面
+ (void)openTbWebViewControllerWithURL:(NSURL*)url desc:(NSString *)desc;
// 打开taobao web/detail页面
+ (void)openTbViewControllerWithNumiid:(NSString*)numiid desc:(NSString *)desc;
// 打开登录界面
+ (void)openLoginViewController;
// 打开绑定邮箱界面
+ (void)openBindEmailViewController;
// 打开主界面
+ (void)openMainViewController:(NSInteger)index;
// 打开设置界面
+ (void)openSettingViewController;
// 打开新手指南界面
+ (void)openGuideViewController:(BOOL)fromSetting;

+ (void)showSimpleHudWithTips:(NSString *)tips;
+ (void)showSimpleHudWithTips:(NSString *)tips afterDelay:(NSTimeInterval)delay;
+ (BOOL)openShortCutWithDictInfo:(NSDictionary *)dictInfo;
+ (void)showShareActionSheetWithUrl:(NSString *)url title:(NSString *)title desc:(NSString *)desc comment:(NSString *)comment image:(UIImageView *)imageView smallImg:(NSString *)smallImg largeImg:(NSString *)largeImg inView:(UIView *)view platform:(NSString *)platform;
+ (void)showSimpleHudTips:(NSString *)tips;

- (void)openScanViewController:(NSString *)str;

@end
