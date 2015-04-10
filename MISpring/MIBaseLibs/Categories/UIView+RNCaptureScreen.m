//
//  UIView+RNCaptureScreen.m
//  RRSpring
//
//  Created by sheng siglea on 5/5/12.
//  Copyright (c) 2012 RenRen.com. All rights reserved.
//

#import "UIView+RNCaptureScreen.h"

@implementation UIView (RNCaptureScreen)

+ (UIImage *) screenImage:(UIView *)view {  
    UIImage *screenImage;  
    UIGraphicsBeginImageContext(view.frame.size);  
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];  
    screenImage = UIGraphicsGetImageFromCurrentImageContext();  
    UIGraphicsEndImageContext();  
    return screenImage;  
} 

+ (UIImage *) screenImage:(UIView *)view rect:(CGRect)rect {  
    CGPoint pt = rect.origin;  
    UIImage *screenImage;  
    UIGraphicsBeginImageContext(rect.size);  
    CGContextRef context = UIGraphicsGetCurrentContext();  
//    CGContextConcatCTM(context,  
//                       CGAffineTransformMakeTranslation(-(int)pt.x, -(int)pt.y));  
    [view.layer renderInContext:context];  
    screenImage = UIGraphicsGetImageFromCurrentImageContext();  
    UIGraphicsEndImageContext();  
    return screenImage;  
} 

@end
