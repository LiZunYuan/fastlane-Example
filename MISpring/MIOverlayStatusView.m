//
//  MIOverlayView.m
//  BeiBeiAPP
//
//  Created by yujian on 14-8-7.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MIOverlayStatusView.h"

#pragma mark - MIEmptyTipView
@interface MIOverlayStatusView (private)
// 重置图片
- (void)resetImgWithName:(NSString *)name;

@end

@implementation MIOverlayStatusView
//@synthesize status = _overlayStatus;
@synthesize imgView = _imgView;
@synthesize label = _label;
@synthesize loadingText = _loadingText;
@synthesize emptyText = _emptyText;
@synthesize errorText = _errorText;
@synthesize indicatorView = _indicatorView;
@synthesize animate = _animate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = NO;
        self.loadingText = NSLocalizedString(@"加载中...", @"加载中...");
        self.reloadText = NSLocalizedString(@"点击屏幕，重新加载", @"点击屏幕，重新加载");
        self.emptyText = NSLocalizedString(@"暂无内容", @"暂无内容");
        self.errorText = NSLocalizedString(@"网络不给力，请稍后再试", @"网络不给力，请稍后再试");
        self.alpha = 0;
        self.animate = YES;
        self.status = EOverlayStatusRemove;
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reloadTableViewDataSource)];
        [self addGestureRecognizer:tapGestureRecognizer];
    }
    return self;
}

- (void)reloadTableViewDataSource
{
    if (_delegate && [_delegate respondsToSelector:@selector(reloadTableViewDataSource:)])
    {
        [_delegate reloadTableViewDataSource:self];
    }
    
    
    
}


// 状态机切换
- (void)suitForStatus:(MIOverlayStatus)status  labelText:(NSString *)desc{
    self.status = status;
    
    if (status == EOverlayStatusLoading) {
        [self.indicatorView startAnimating];
    }
    else {
        if ([self.indicatorView isAnimating]) {
            [self.indicatorView stopAnimating];
        }
    }
    
    switch (status) {
        case EOverlayStatusLoading:
            self.userInteractionEnabled = NO;
            [self resetImgWithName:nil];
            self.label.text = (desc ? desc : _loadingText);
            break;
            
        case EOverlayStatusReload:
            self.userInteractionEnabled = YES;
            self.label.text = (desc ? desc : _reloadText);
            [self resetImgWithName:@"overlay_error"];
            break;
            
        case EOverlayStatusEmpty:
            self.userInteractionEnabled = NO;
            self.label.text = (desc ? desc : _emptyText);
            [self resetImgWithName:@"order_not_found"];
            break;
            
        case EOverlayStatusError:
            self.userInteractionEnabled = NO;
            self.label.text = (desc ? desc : _errorText);
            [self resetImgWithName:@"overlay_error"];
            break;
            
        case EOverlayStatusRemove:
            self.userInteractionEnabled = NO;
            self.label.text = nil;
            [self resetImgWithName:nil];
            break;
            
        default:
            break;
    }
}

- (UIImageView *)imgView {
    if (_imgView == nil) {
        NSInteger navigationBarHeight;
        MIPHONE_NAVIGATIONBAR_HEIGHT(IOS_VERSION, navigationBarHeight);
        
        CGRect newFrame = CGRectMake(0, (self.viewHeight - kOverlayImageHeight - kOverlayTextHeight) / 2 - navigationBarHeight, self.viewWidth, kOverlayImageHeight);
        _imgView = [[UIImageView alloc] initWithFrame:newFrame];
        _imgView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_imgView];
    }
    
    return _imgView;
}

- (UILabel *)label {
    if (_label == nil) {
        NSInteger navigationBarHeight;
        MIPHONE_NAVIGATIONBAR_HEIGHT(IOS_VERSION, navigationBarHeight);
        
        CGRect newFrame = CGRectMake(0, (self.viewHeight - kOverlayImageHeight - kOverlayTextHeight) / 2 + kOverlayImageHeight - navigationBarHeight, self.viewWidth, kOverlayTextHeight);
        _label = [[UILabel alloc] initWithFrame:newFrame];
        _label.backgroundColor = [UIColor clearColor];
        _label.font = [UIFont systemFontOfSize:14.0];
        _label.adjustsFontSizeToFitWidth = YES;
        _label.minimumScaleFactor = 10 / [UIFont labelFontSize];
        _label.numberOfLines = 0;
        _label.textAlignment = NSTextAlignmentCenter;
        _label.textColor = [UIColor grayColor];
        [self addSubview:_label];
    }
    
    return _label;
}

- (UIActivityIndicatorView *)indicatorView {
    if (_indicatorView == nil) {
        NSInteger navigationBarHeight;
        MIPHONE_NAVIGATIONBAR_HEIGHT(IOS_VERSION, navigationBarHeight);
        
        CGFloat indicatorWidth = 30;
        CGRect newFrame = CGRectMake((self.viewWidth - indicatorWidth) / 2,
                                     (self.viewHeight - kOverlayImageHeight - kOverlayTextHeight) / 2 + kOverlayImageHeight - indicatorWidth - navigationBarHeight,
                                     indicatorWidth,
                                     indicatorWidth);
        _indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:newFrame];
        _indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        
        [self addSubview:_indicatorView];
    }
    
    return _indicatorView;
}

// 重置图片
- (void)resetImgWithName:(NSString *)name {
    [self.imgView setImage:[UIImage imageNamed:name]];
}

- (void)setOverlayStatus:(MIOverlayStatus )newStatus labelText:(NSString *)desc
{
    [self suitForStatus:newStatus labelText:desc];
    // 设置alpha
    CGFloat finalAlpha = newStatus == EOverlayStatusRemove ? 0 : 1;
    
    [self.superview bringSubviewToFront:self];
    if (!self.animate) {
        self.alpha = finalAlpha;
    }else {
        [UIView animateWithDuration:0.3 animations:^(){
            self.alpha = finalAlpha;
        }];
    }
}
@end
