//
//  YouMiSpot.h
//  YouMiSDK
//
//  Created by 陈建峰 on 13-3-11.
//  Copyright (c) 2013年 YouMi Mobile Co. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YouMiWall.h"


// *** 重要 ***
// 当前提供一种尺寸的插播广告: 300*250 显示在屏幕正中央。
@interface YouMiSpot : NSObject

// 请求插播广告
//
// 在[YouMiConfig launchWithAppID:appSecret:]之后调用
//
+ (void)requestSpotADs:(BOOL)isRewarded;

// 显示插播广告
//
// 参数:
//        dismiss: 插播广告退出显示后执行的block代码
//
// 返回值:
//        显示成功返回 YES; 没显示返回 NO
// 说明:
//        无论是否显示成功，dismiss都会被调用到
//        没显示广告可能因为没有匹配的广告
//
// 例子:
// - (void)enterTheDoorButtonPressed:(id)sender {
//     [YouMiSpot showSpotDismiss:^() {
//         [self enterTheDoor];
//     }];
// }
//
+ (BOOL)showSpotDismiss:(void (^)())dismiss;

@end
