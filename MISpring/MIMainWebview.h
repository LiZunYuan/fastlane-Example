//
//  BBMainWebview.h
//  BeiBeiAPP
//
//  Created by 徐 裕健 on 14/10/28.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MIUserGetRequest.h"
#import "MIOverlayStatusView.h"
#import "MIGoTopView.h"

@interface MIMainWebview : UIView <UIWebViewDelegate,UIScrollViewDelegate,EGORefreshTableHeaderDelegate,MIOverlayStatusViewDelegate,MIGoTopViewDelegate>
{
@protected
    UIWebView*        _webView;
    
    NSURL*            _loadingURL;
    NSString*         _itemUrl;
    NSString*         _webPageTitle;
    
    SystemSoundID soundID;
    NSString *shareCallback;
    NSString *shakeCallback;
    NSString *loginCallback;
    MIGoTopView *_goTopView;
    BOOL shakeEnable;
    BOOL shareEnable;
    
    BOOL _loading;
    float _buttomPullDistance;
    float _lastscrollViewOffset;
}

- (id)initWithURL:(NSURL*)URL frame:(CGRect)frame;
- (void)willAppearView;
- (void)willDisappearView;

@property (nonatomic, strong) NSURL *homeURL;
@property (nonatomic, strong) NSURL *loadingURL;
@property (nonatomic, copy)   NSString *webPageTitle;
@property (nonatomic, copy)   NSString *itemImageUrl;
@property (nonatomic, strong) UIImageView *itemImageView;
@property (nonatomic, strong) MIOverlayStatusView *overlayView;
@property (nonatomic, strong) EGORefreshTableHeaderView *refreshTableView;
@property (nonatomic, strong) MIUserGetRequest *userInfoRequest;

/**
 * The current web view URL. If the web view is currently loading a URL, then the loading URL is
 * returned instead.
 */
@property (nonatomic, readonly) NSURL *URL;

- (void)shareAction:(id) params;
- (void)openURL:(NSURL*)URL;
- (void)openRequest:(NSURLRequest*)request;

- (void)reloadWebview;
- (void)loginSuccess;
- (void)shareSuccess;
- (void)motionBegan;
- (void)motionEnded;
- (void)motionCancelled;

@end
