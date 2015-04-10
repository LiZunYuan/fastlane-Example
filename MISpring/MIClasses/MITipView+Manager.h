//
//  MITipView+Manager.h
//  MiZheHD
//
//  Created by 遇 见 on 8/16/13.
//  Copyright 2013 Husor Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MITipView.h"

@interface MITipView (Manager)

// 显示内容区提示
+ (void)showContentOperateTipInView:(UIView *)inView tipKey:(NSString *)tip imgKey:(NSString *)img type:(MITipType)type;
+ (void)showAlertTipWithKey:(NSString *)tip message:(NSString *)msg;

@end
