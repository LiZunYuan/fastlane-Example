//
//  UIView+RNCaptureScreen.h
//  RRSpring
//
//  Created by sheng siglea on 5/5/12.
//  Copyright (c) 2012 RenRen.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface UIView (RNCaptureScreen)

/**
 * 截取整个View
 * @param 被截取的View
 */
+ (UIImage *) screenImage:(UIView *)view;

/**
 * 截取局部View
 * @param 被截取的View
 * @param 制定的区域
 */
+ (UIImage *) screenImage:(UIView *)view rect:(CGRect)rect;

@end
