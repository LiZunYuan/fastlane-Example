//
//  UIImage+MIAdditions.h
//  MISpring
//
//  Created by Yujian Xu on 13-4-14.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (MIAdditions)

// 缩放图片
+ (UIImage *)scaleImage:(UIImage *)image scaleToSize:(CGSize)size;
//截取部分图像
+ (UIImage*)getSubImage:(UIImage *)img rect:(CGRect)rect;
//中间拉伸自动宽高
+ (UIImage*)middleStretchableImageWithKey:(NSString*)key ;

+ (UIImage *) createRoundedRectImage:(UIImage*)image size:(CGSize)size cornerRadius:(CGFloat)radius;

// 缩放图片并且剧中截取
+ (UIImage *)middleScaleImage:(UIImage *)image scaleToSize:(CGSize)size;
//等比缩放到多少倍
+ (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize;
//等比例缩放
+(UIImage*)scaleToSize:(UIImage*)image size:(CGSize)size;
//旋转图片
+ (UIImage*)loadImage:(UIImage*)image rotateByDegree:(float)degree;

@end
