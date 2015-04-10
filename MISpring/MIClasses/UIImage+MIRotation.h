//
//  UIImage+MIRotation.h
//  MISpring
//
//  Created by 曲俊囡 on 13-12-13.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (MIRotation)

- (UIImage *)imageRotatedByRadians:(CGFloat)radians;
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;

@end
