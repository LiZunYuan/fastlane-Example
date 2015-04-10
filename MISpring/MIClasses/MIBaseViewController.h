//
//  MIBaseViewController.h
//  MISpring
//
//  Created by Yujian Xu on 13-3-11.
//  Copyright (c) 2013年 Husor Inc.. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "YAPanBackController.h"
#import "MICustomNavigationBar.h"

typedef enum MIExtendedEdge {
    MIExtendedEdgeNone = 0,
    MIExtendedEdgeTop  = 1 << 0,
    MIExtendedEdgeLeft = 1 << 1,
    MIExtendedEdgeBottom = 1 << 2,
    MIExtendedEdgeRight  = 1 << 3,
    MIExtendedEdgeAll  = MIExtendedEdgeTop | MIExtendedEdgeLeft | MIExtendedEdgeBottom | MIExtendedEdgeRight
}MIExtendedEdge;

//提示状态机
typedef enum MIOverlayStatus {
    EOverlayStatusRemove = 1,    //无提示
    EOverlayStatusLoading,       //加载中
    EOverlayStatusEmpty,         //数据空
    EOverlayStatusError,         //网络错误
    EOverlayStatusReload,        //重新加载
}MIOverlayStatus;

#define kOverlayImageHeight 125
#define kOverlayTextHeight 60

@class MIOverlayView;

@interface MIBaseViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, EGORefreshTableHeaderDelegate>
{
    // 提示view
    MIOverlayView *_overlayView;

    BOOL _needRefreshView;
    BOOL _loading;
    UIScrollView *_baseScrollView;
    UITableView *_baseTableView;
    MBProgressHUD *_progresshud;
    EGORefreshTableHeaderView *_refreshTableView;
    
    YAPanBackController *_panBackController;
}

@property (nonatomic, assign) BOOL loading;
@property (nonatomic, assign) BOOL needRefreshView;
@property (nonatomic, assign) float navigationBarHeight;
@property (nonatomic, assign) CGFloat buttomPullDistance;
@property (nonatomic, strong) MIOverlayView *overlayView;
@property (nonatomic, strong) UIScrollView *baseScrollView;
@property (nonatomic, strong) UITableView *baseTableView;
@property (nonatomic, strong) MICustomNavigationBar *navigationBar;
@property (nonatomic, strong) EGORefreshTableHeaderView *refreshTableView;
@property (nonatomic, assign) BOOL hasStatusBarHotSpot;

// 状态栏高度变化
- (void)handleUIApplicationWillChangeStatusBarFrameNotification:(NSNotification*)notification;

// 重新布局self.view
- (void)relayoutView;

// 设置状态
- (void)setOverlayStatus:(MIOverlayStatus )newStatus labelText:(NSString *)desc;

// 显示提示
- (void)showSimpleHUD:(NSString *)tip;

- (void)showSimpleHUD:(NSString *)tip afterDelay:(NSTimeInterval)delay;

- (void)showProgressHUD:(NSString *)tip;
- (void)hideProgressHUD;
//下拉开始重新加载时调用的方法
- (void)reloadTableViewDataSource;

//上拉继续加载更多时调用的方法
- (void)loadMoreTableViewDataSource;

//完成加载时调用的方法
- (void)finishLoadTableViewData;

//加载失败时调用的方法
- (void)failLoadTableViewData;


+ (UIBarButtonItem *)navigationBackButtonItemWithTarget:(id)target action:(SEL)action;
- (void)miPopToPreviousViewController;
- (void)miPopToViewControllerAtIndex:(NSUInteger)index;
- (void)miPopViewControllerWithAnimated:(BOOL)animated;

@end


#pragma mark - MIEmptyNoteView
@interface MIOverlayView : UIView {
    // 状态
    MIOverlayStatus _overlayStatus;
    // 图片
    UIImageView *_imgView;
    // label
    UILabel *_label;
    // 加载文本
    NSString *_loadingText;
    // 空数据文本
    NSString *_emptyText;
    // 加载出错文本
    NSString *_errorText;
    // 菊花
    UIActivityIndicatorView *_indicatorView;
    // 是否支持动画,淡入淡出
    BOOL _animate;
}

// 状态机切换
- (void)suitForStatus:(MIOverlayStatus)status labelText:(NSString *)desc;

@property (nonatomic, assign) MIOverlayStatus status;
@property (nonatomic, retain) UIImageView *imgView;
@property (nonatomic, retain) UILabel *label;
@property (nonatomic, copy) NSString *loadingText;
@property (nonatomic, copy) NSString *reloadText;
@property (nonatomic, copy) NSString *emptyText;
@property (nonatomic, copy) NSString *errorText;
@property (nonatomic, retain) UIActivityIndicatorView *indicatorView;
@property (nonatomic, assign) BOOL animate;

@end
