//
//  MIMainScreenViewController.h
//  MISpring
//
//  Created by Yujian Xu on 13-3-12.
//  Copyright (c) 2013年 Husor Inc.. All rights reserved.
//

#import "MIBaseViewController.h"
#import "MIMainScreenTabBar.h"

typedef enum _MainScreenIndex : NSInteger{
    MAIN_SCREEN_INDEX_HOMEPAGE = 0,
    MAIN_SCREEN_INDEX_BRAND,
    MAIN_SCREEN_INDEX_GROUPON,
    MAIN_SCREEN_INDEX_YOUPIN,
    MAIN_SCREEN_INDEX_USER,
} MainScreenIndex;

@interface MIMainScreenViewController : MIBaseViewController <MIMainScreenTabBarDelegate>
{
    BOOL _transiting;

    // 标签栏
    MIMainScreenTabBar *_tabBar;
    // 当前显示的视图
    MIBaseViewController *_currentViewController;
    // 当前显示viewController的索引
    MainScreenIndex _currentViewControllerIndex;
}

// 标签栏
@property (nonatomic, strong) MIMainScreenTabBar *tabBar;
// 当前显示的viewController索引
@property (nonatomic, assign) MainScreenIndex currentViewControllerIndex;

- (id)initWithIndex:(MainScreenIndex)index;

@end
