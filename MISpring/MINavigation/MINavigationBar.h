//
//  MINavigationBar.h
//  MISpring
//
//  Created by Yujian Xu on 13-3-11.
//  Copyright (c) 2013年 Husor Inc.. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface UINavigationBar (UINavigationBarCategory)


//// 设置导航条背景图片
//- (void)setNavigationBarWithImageKey:(NSString *)imageKey;
//// 清空导航条的背景图片，使恢复到系统默认状态
//- (void)clearNavigationBarImage;
@end

@interface MINavigationBar : UINavigationBar
{
    UIImage* _bgImage;
}

@property(nonatomic, strong) UIImage* bgImage;

// 设置导航条背景图片
- (void)setNavigationBarWithImageKey:(NSString *)imageKey;
// 清空导航条的背景图片，使恢复到系统默认状态
- (void)clearNavigationBarImage;
// 在导航条下方添加阴影
- (void)dropShadowWithOffset:(CGSize)offset
                      radius:(CGFloat)radius
                       color:(UIColor *)color
                     opacity:(CGFloat)opacity;
// 绘制圆角
//- (void) drawRoundedCorner: (CGPoint)point withRadius:(CGFloat)radius
//        withTransformation:(CGAffineTransform)transform;
- (void)setNaviTitle: (NSString *) title textSize:(CGFloat) size;

@end
