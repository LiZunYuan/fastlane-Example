//
//  MIMainScreenTabBar.m
//  MISpring
//
//  Created by Yujian Xu on 13-3-11.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIMainScreenTabBar.h"

#define BADGE_LEFT 298
#define BADGE_TOP  5

@interface MIMainScreenTabBar (RSMainScreenTabBarPrivate)
- (void)initializationTabs;
- (void)updateTabs;
- (void)setTabOfIndex:(NSInteger)index selected:(BOOL)selected;

- (void)tapHandle:(UITapGestureRecognizer *)tapRecognizer;

@end

@implementation MIMainScreenTabBar
@synthesize barDelegate;
@synthesize backgroundView = _bakcgroundView;
@synthesize badgeImageView = _badgeImageView;
@synthesize normalTabs = _normalTabs;
@synthesize selectedTabs = _selectedTabs;
@synthesize textLabelTabs = _textLabelTabs;
@synthesize currentTabIndex = _currentTabIndex;
@synthesize selfSize = _selfSize;
@synthesize bShowBadge = _bShowBadge;

#pragma mark -

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _selfSize =  CGSizeMake(SCREEN_WIDTH, TABBAR_HEIGHT);
        self.backgroundColor = [UIColor clearColor];

        _backgroundView = [[UIImageView alloc] init];
        _backgroundView.frame = CGRectMake(0, 0, _selfSize.width, _selfSize.height);
        _backgroundView.backgroundColor = [MIUtility colorWithHex:0xfcfcfc];
        [self addSubview:_backgroundView];

        UIView *splitLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _selfSize.width, 0.6)];
        splitLine.backgroundColor = [MIUtility colorWithHex:0xdddddd];
        [_backgroundView addSubview:splitLine];
        
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandle:)];
        [self addGestureRecognizer:tapRecognizer];

        [self initializationTabs];
    }
    return self;
}

- (void)initializationTabs{
    
    // initialization normal tabs view
    UIImage *homePageImage = [UIImage imageNamed:@"btn_nav_home"];
    UIImageView *homePageButton = [[UIImageView alloc] initWithImage:homePageImage];
    [self.normalTabs addObject:homePageButton];

    UIImage *brandImage = [UIImage imageNamed:@"btn_nav_pinpai"];
    UIImageView *brandButton = [[UIImageView alloc] initWithImage:brandImage];
    [self.normalTabs addObject:brandButton];
    
    UIImage *zhiImage = [UIImage imageNamed:@"btn_nav_10yuangou"];
    UIImageView *mallsButton = [[UIImageView alloc] initWithImage:zhiImage];
    [self.normalTabs addObject:mallsButton];
    
    UIImage *rebateImage = [UIImage imageNamed:@"btn_nav_youpinhui"];
    UIImageView *taobaoButton =[[UIImageView alloc] initWithImage:rebateImage];
    [self.normalTabs addObject:taobaoButton];

    UIImage *userImage = [UIImage imageNamed:@"btn_nav_wode"];
    UIImageView *userButton = [[UIImageView alloc] initWithImage:userImage];
    [self.normalTabs addObject:userButton];

    UIImage *homePageHLImage = [UIImage imageNamed:@"btn_nav_home_selected"];
    UIImageView *homePageHLButton = [[UIImageView alloc] initWithImage:homePageHLImage];
    [self.selectedTabs addObject:homePageHLButton];
    
    UIImage *brandHLImage = [UIImage imageNamed:@"btn_nav_pinpai_selected"];
    UIImageView *brandHLButton = [[UIImageView alloc] initWithImage:brandHLImage];
    [self.selectedTabs addObject:brandHLButton];
    
    UIImage *zhiHLImage = [UIImage imageNamed:@"btn_nav_10yuangou_selected"];
    UIImageView *zhiHLButton = [[UIImageView alloc] initWithImage:zhiHLImage];
    [self.selectedTabs addObject:zhiHLButton];

    UIImage *rebateHLImage = [UIImage imageNamed:@"btn_nav_youpinhui_selected"];
    UIImageView *rebateHLButton = [[UIImageView alloc] initWithImage:rebateHLImage];
    [self.selectedTabs addObject:rebateHLButton];
    
    UIImage *userHLImage = [UIImage imageNamed:@"btn_nav_wode_selected"];
    UIImageView *userHLButton = [[UIImageView alloc] initWithImage:userHLImage];
    [self.selectedTabs addObject:userHLButton];

    UILabel *homePage = [[UILabel alloc] init];
    homePage.text = @"首页";
    [self.textLabelTabs addObject:homePage];
    
    UILabel *beiBei = [[UILabel alloc] init];
    beiBei.text = @"品牌特卖";
    [self.textLabelTabs addObject:beiBei];

    UILabel *brand = [[UILabel alloc] init];
    brand.text = @"10元购";
    [self.textLabelTabs addObject:brand];
    
    UILabel *taobao = [[UILabel alloc] init];
    taobao.text = @"优品惠";
    [self.textLabelTabs addObject:taobao];

    UILabel *user = [[UILabel alloc] init];
    user.text = @"我的";
    [self.textLabelTabs addObject:user];

    NSInteger idx;
    for (idx = 0; idx < self.normalTabs.count; idx ++) {
        UIImageView *normalTab = [self.normalTabs objectAtIndex:idx];
        UIImageView *selectedTab = [self.selectedTabs objectAtIndex:idx];
        CGRect tabFrame = CGRectIntegral(CGRectMake(idx * TABBAR_ITEM_WIDTH + (TABBAR_ITEM_WIDTH - normalTab.image.size.width)/2,
                                                    (_selfSize.height - normalTab.image.size.height -14)/2,
                                                    normalTab.image.size.width,
                                                    normalTab.image.size.height));
        normalTab.frame = tabFrame;
        selectedTab.frame = tabFrame;

        UILabel *label = [self.textLabelTabs objectAtIndex:idx];
        CGRect labFrame = CGRectMake(idx * TABBAR_ITEM_WIDTH, normalTab.bottom + 5, TABBAR_ITEM_WIDTH, 12);
        label.frame = labFrame;
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:11];
        label.textAlignment = UITextAlignmentCenter;
        [self addSubview:normalTab];
        [self addSubview:selectedTab];
        [self addSubview:label];
    }

    UIImage* badgeImg = [UIImage imageNamed:@"badge"];
    _badgeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(BADGE_LEFT, BADGE_TOP, badgeImg.size.width, badgeImg.size.height)];
    _badgeImageView.image = badgeImg;
    _badgeImageView.hidden = YES;
    [self addSubview:_badgeImageView];
}

- (NSMutableArray *)normalTabs{
    if (_normalTabs == nil) {
        _normalTabs = [[NSMutableArray alloc] initWithCapacity:5];
    }

    return _normalTabs;
}

- (NSMutableArray *)selectedTabs{
    if (_selectedTabs == nil) {
        _selectedTabs = [[NSMutableArray alloc] initWithCapacity:5];
    }

    return _selectedTabs;
}

- (NSMutableArray *)textLabelTabs{
    if (_textLabelTabs == nil) {
        _textLabelTabs = [[NSMutableArray alloc] initWithCapacity:5];
    }

    return _textLabelTabs;
}

- (void)layoutSubviews{
    for (NSInteger idx = 0; idx < self.normalTabs.count; idx ++) {
        [self setTabOfIndex:idx selected:(idx == self.currentTabIndex)];
    }
}

- (void)showBadge:(BOOL)showBadge{
    _bShowBadge = showBadge;
    _badgeImageView.hidden = !_bShowBadge;
}

- (void)updateTabs{
    for (NSInteger idx = 0; idx < self.normalTabs.count; idx ++) {
        [self setTabOfIndex:idx selected:(idx == self.currentTabIndex)];
    }
}

- (void)setTabOfIndex:(NSInteger)index selected:(BOOL)selected{
    if (self.normalTabs.count > index) {
        UIView *normalTab = [self.normalTabs objectAtIndex:index];
        UIView *selectTab = [self.selectedTabs objectAtIndex:index];
        UILabel *textTab = [self.textLabelTabs objectAtIndex:index];
        
        if (selected) {
            normalTab.alpha = 0.0;
            selectTab.alpha = 1.0;
            textTab.textColor = [MIUtility colorWithHex:0xfe7800];
        } else {
            normalTab.alpha = 1.0;
            selectTab.alpha = 0.0;
            textTab.textColor = [MIUtility colorWithHex:0x666666];
        }
    }
}

- (void)setSelectTabIndex:(NSInteger)index animated:(BOOL)animated{
    if (self.currentTabIndex == index) {
        return;
    }

    if (self.barDelegate && [self.barDelegate respondsToSelector:@selector(mainScreenTabBar:didSelectIndex:animated:)]) {
        if ([self.barDelegate mainScreenTabBar:self didSelectIndex:index animated:animated]) {
            self.currentTabIndex = index;
            [self setNeedsLayout];
        }
    }
    if (self.textLabelTabs.count > index) {
        UILabel *textLabel = (UILabel *)[self.textLabelTabs objectAtIndex:index];
        [MobClick event:kMainTabsClicks label:textLabel.text];
    }
}

#pragma mark -  手势处理
- (void)tapHandle:(UITapGestureRecognizer *)tapRecognizer{
    if (tapRecognizer.state != UIGestureRecognizerStateRecognized) {
        return;
    }

    CGPoint location = [tapRecognizer locationInView:self];

    NSInteger selectIdx = self.currentTabIndex;

    for (NSInteger idx = 0; idx < self.normalTabs.count; idx ++) {
        CGRect idxThumbFrame = CGRectMake(idx * TABBAR_ITEM_WIDTH,
                                          0,
                                          TABBAR_ITEM_WIDTH,
                                          TABBAR_HEIGHT);
        if (CGRectContainsPoint(idxThumbFrame, location)) {
            selectIdx = idx;
            break;
        }
    }

    [self setSelectTabIndex:selectIdx animated:NO];
}

@end
