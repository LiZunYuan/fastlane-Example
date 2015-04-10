//
//  MIWebViewController.h
//  MISpring
//
//  Created by XU YUJIAN on 13-1-25.
//  Copyright (c) 2013年 Husor Inc.. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import "NJKWebViewProgress.h"


@interface MIWebViewController : MIBaseViewController <UIWebViewDelegate, NJKWebViewProgressDelegate>
{
    SystemSoundID soundID;
    NSString *shareCallback;
    NSString *shakeCallback;
    NSString *loginCallback;
    BOOL shakeEnable;
    BOOL shareEnable;
    NJKWebViewProgress *_progressProxy;
    
    
@protected
    UIWebView*        _webView;

    NSURL*            _loadingURL;
    NSString*         _itemUrl;
    NSString*         _webPageTitle;
}

- (id)initWithURL:(NSURL*)URL;
@property (nonatomic, strong) NSString *webTitle;
@property (nonatomic, copy)   NSString* webPageTitle;
@property (nonatomic, strong) NSURL *homeURL;
@property (nonatomic, strong) UIImageView *itemImageView;
//@property (nonatomic,strong) UIProgressView *progressView;
@property (nonatomic, strong)UIView *progressView;
@property (nonatomic,assign) CGFloat scrollOffSet;
/**
 * The current web view URL. If the web view is currently loading a URL, then the loading URL is
 * returned instead.
 */
@property (nonatomic, readonly) NSURL*  URL;

- (void)shareAction:(id) params;

/**
 * Navigate to the given URL.
 */
- (void)openURL:(NSURL*)URL;

/**
 * Load the given request using UIWebView's loadRequest:.
 *
 * @param request  A URL request identifying the location of the content to load.
 */
- (void)openRequest:(NSURLRequest*)request;

- (void)reloadHomeUrl;

@end