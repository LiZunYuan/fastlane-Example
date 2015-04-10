//
//  UIDevice+UIDeviceExt.h
//  MISpring
//
//  Created by XU YUJIAN on 13-1-17.
//  Copyright (c) 2013年 Husor Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKitDefines.h>

@interface UIDevice (IdentifierAddition)

// 获取MAC地址
+ (NSString *)macAddress;
// 设备是否是iPad
+ (BOOL)isDeviceiPad;
// 获取机器型号
+ (NSString *)machineModel;
// 获取机器型号名称
+ (NSString *)machineModelName;
// 对低端机型的判断
+ (BOOL)isLowLevelMachine;
// 设备可用空间
// freespace/1024/1024/1024 = B/KB/MB/14.02GB
+(NSNumber *)freeSpace;
// 设备总空间
+(NSNumber *)totalSpace;
// 获取运营商信息
+ (NSString *)carrierName;
// 获取运营商代码
+ (NSString *)carrierCode;
//获取电池电量
+ (CGFloat) getBatteryValue;
//获取电池状态
+ (NSInteger) getBatteryState;
// 是否能发短信 不准确
+ (BOOL) canDeviceSendMessage;
// 去除导航条的全平尺寸
+ (CGSize)screenSize;
// 屏幕宽(去掉statusbar)
+ (CGFloat)screenWidth;
// 屏幕高(去掉statusbar)
+ (CGFloat)screenHeight;

// 屏幕高度（包含statusbar）
+ (CGFloat)mainScreenHeight;

// 内存信息
+ (NSUInteger)freeMemory;
+ (NSUInteger)usedMemory;
// 判断是否是iphone5
+ (BOOL)isIphone5;
// 判断是否是1136的retina4寸屏幕
+ (BOOL)isRetina4inch;

@end
