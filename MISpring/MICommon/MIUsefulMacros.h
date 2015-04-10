//
//  MIUsefulMacros.h
//  MISpring
//
//  Created by XU YUJIAN on 13-1-17.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

//发版前必做:将log开关关掉
//#define MILog_DEBUG

#ifndef MILog_DEBUG
#define MILog(message, ...)
#else
#define MILog(message, ...) NSLog(@"[MiZhe]:%@", [NSString stringWithFormat:message, ##__VA_ARGS__])
#endif

#define MI_CALL_DELEGATE(_delegate, _selector) \
do { \
id _theDelegate = _delegate; \
if(_theDelegate != nil && [_theDelegate respondsToSelector:_selector]) { \
[_theDelegate performSelector:_selector]; \
} \
} while(0)

#define MI_CALL_DELEGATE_WITH_ARG(_delegate, _selector, _argument) \
do { \
id _theDelegate = _delegate; \
if(_theDelegate != nil && [_theDelegate respondsToSelector:_selector]) { \
[_theDelegate performSelector:_selector withObject:_argument]; \
} \
} while(0)

#define MI_CALL_DELEGATE_WITH_ARGS(_delegate, _selector, _arg1, _arg2) \
do { \
id _theDelegate = _delegate; \
if(_theDelegate != nil && [_theDelegate respondsToSelector:_selector]) { \
[_theDelegate performSelector:_selector withObject:_arg1 withObject:_arg2]; \
} \
} while(0)

#define MIPHONE_NAVIGATIONBAR_HEIGHT(_iosVersion,_height) \
do { \
if (_iosVersion >= 7.0) { \
    _height = 64; \
} \
else { \
 _height = 44; \
} \
} while(0)

#define IS_IOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define IOS7_STATUS_BAR_HEGHT (IS_IOS7 ? 20.0f : 0.0f)
/*
 * 通过RGB创建UIColor
 */
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

/////////////////////////////////////////////////////////////////////////////////////////
// 一些常用相关尺寸

#define MIColorNavigationBarBackground  [MIUtility colorWithHex:0xff8c24]
#define MINormalBackgroundColor [MIUtility colorWithHex:0xeeeeee]
#define MIColorGreen [MIUtility colorWithHex:0x7dcc08]
#define MILineColor [MIUtility colorWithHex:0xe4e4e4]
#define MIColor666666 [MIUtility colorWithHex:0x666666]
#define MIColor333333 [MIUtility colorWithHex:0x333333]
#define MIColor999999 [MIUtility colorWithHex:0x999999]
#define MICodeButtonBackground [MIUtility colorWithHex:0xfea555]
#define MICommitButtonBackground [MIUtility colorWithHex:0xfe7800]



/*
 * iPhone statusbar 高度
 */
#define PHONE_STATUSBAR_HEIGHT      20
#define HOTSPOT_STATUSBAR_HEIGHT    20
#define IS_HOTSPOT_ON       (CGRectGetHeight([UIApplication sharedApplication].statusBarFrame) == (PHONE_STATUSBAR_HEIGHT + HOTSPOT_STATUSBAR_HEIGHT))

/*
 * iPhone 默认导航条高度
 */
#define PHONE_NAVIGATION_BAR_ITEM_HEIGHT 44

/*
 * 搜索快捷入口 大小
 */
#define MISEARCH_SHORTCUT_SIZE CGSizeMake(610, 748)

/*
    置顶按钮的宽度与高度
 */
#define MISCROLL_TO_TOP_HEIGHT    40

/*
 *屏幕宽度
 */
#define SCREEN_WIDTH ([[UIScreen mainScreen]bounds].size.width)

/*
 *屏幕高度
 */

#define SCREEN_HEIGHT ([[UIScreen mainScreen]bounds].size.height)
/*
 * iPhone 屏幕尺寸
 */
#define PHONE_SCREEN_SIZE (CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - PHONE_STATUSBAR_HEIGHT))

// 获取系统版本号
#ifndef IOS_VERSION
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#endif
