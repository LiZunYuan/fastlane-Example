//
//  BBOverlayView.h
//  BeiBeiAPP
//
//  Created by yujian on 14-8-7.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MIOverlayStatusView;

@protocol MIOverlayStatusViewDelegate <NSObject>


@optional
- (void)reloadTableViewDataSource:(MIOverlayStatusView *)overView;

@end

//提示状态机
typedef enum MIOverlayStatusInfo {
    MIOverlayStatusRemove = 1,    //无提示
    MIOverlayStatusLoading,       //加载中
    MIOverlayStatusEmpty,         //数据空
    MIOverlayStatusError,         //网络错误
    MIOverlayStatusReload,        //重新加载
}MIOverlayStatusInfo;

#pragma mark - MIEmptyNoteView
@interface MIOverlayStatusView : UIView {
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
- (void)setOverlayStatus:(MIOverlayStatus )newStatus labelText:(NSString *)desc;

@property (nonatomic, weak) id<MIOverlayStatusViewDelegate> delegate;
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