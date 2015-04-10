//
//  MINavigationBar.h
//  MiZheHD
//
//  Created by 徐 裕健 on 13-7-18.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface MICustomNavigationBar : UIView
{
    UIImage *_bgImage;
}

@property(nonatomic, strong) UIImage* bgImage;
@property(nonatomic, strong) UILabel *leftLabel;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UIButton *leftButton;
@property(nonatomic, strong) UIButton *closeButton;
@property(nonatomic, strong) UIButton *rightButton;
@property(nonatomic, assign) BOOL disableRoundedCorner;

// 设置导航条背景图片
- (void)setNavigationBarWithImageKey:(NSString *)imageKey;
// 清空导航条的背景图片，使恢复到系统默认状态
- (void)clearNavigationBarImage;
// 在导航条下方添加阴影
- (void)dropShadowWithOffset:(CGSize)offset
                      radius:(CGFloat)radius
                       color:(UIColor *)color
                     opacity:(CGFloat)opacity;
- (void)setBarTitle: (NSString *) title textSize:(CGFloat) size;
- (void)setBarTitle:(NSString *)title;
- (void)setBarLeftTitle: (NSString *) title textSize:(CGFloat) size;
- (void)setBarTitle: (NSString *) title textSize:(CGFloat) size textColor:(UIColor *)color;
- (void)setBarLeftButtonItem:(id)target selector:(SEL)sel imageKey:(NSString *)image;
- (void)setBarCloseTextButtonItem:(id)target selector:(SEL)sel title:(NSString *)title;
- (void)setBarRightButtonItem:(id)target selector:(SEL)sel imageKey:(NSString *)image;
- (void)setBarRightTextButtonItem:(id)target selector:(SEL)sel title:(NSString *)title;

- (void)setBarTitleImage:(NSString *)imageName;

- (void)setBarTitleLabelFrame:(CGRect)frame;

@end
