//
//  MIMainScreenTabBar.h
//  MISpring
//
//  Created by Yujian Xu on 13-3-11.
//  Copyright (c) 2013年 Husor Inc.. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TABBAR_HEIGHT     48
#define TABBAR_ITEM_WIDTH SCREEN_WIDTH/5.0

@protocol  MIMainScreenTabBarDelegate;

@interface MIMainScreenTabBar : UIView
{
    UIImageView *_backgroundView;
    NSMutableArray *_normalTabs;
    NSMutableArray *_selectedTabs;
    NSMutableArray *_textLabelTabs;
    NSInteger _currentTabIndex;
    CGFloat _animationDuration;
    CGSize _selfSize;
}

- (void)showBadge:(BOOL)showBadge;
- (void)setSelectTabIndex:(NSInteger)index animated:(BOOL)animated;

@property (nonatomic, assign) CGSize selfSize;
@property (nonatomic, strong) UIImageView *backgroundView;
@property (nonatomic, strong) UIImageView *badgeImageView;
@property (nonatomic, strong) NSMutableArray *normalTabs;
@property (nonatomic, strong) NSMutableArray *selectedTabs;
@property (nonatomic, strong) NSMutableArray *textLabelTabs;
@property (nonatomic, assign) NSInteger currentTabIndex;
@property (nonatomic, assign) BOOL bShowBadge;
@property (nonatomic, weak) id<MIMainScreenTabBarDelegate> barDelegate;

@end

@protocol MIMainScreenTabBarDelegate <NSObject>

- (BOOL)mainScreenTabBar:(MIMainScreenTabBar *)tabBar didSelectIndex:(NSInteger)index animated:(BOOL)animated;

@end

