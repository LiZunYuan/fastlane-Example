//
//  MIModalWebViewController.h
//  MISpring
//
//  Created by 徐 裕健 on 13-9-24.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIBaseViewController.h"

@interface MIModalWebViewController : MIBaseViewController<UIWebViewDelegate>
{
@protected
    UILabel*          _accountLabel;
    UIWebView*        _webView;
    NSString*         _webPageTitle;
    NSURL*            _loadingURL;
}

- (id)initWithURL:(NSURL*)URL;

@property (nonatomic, copy) NSString* webPageTitle;
@property (nonatomic, strong) NSURL *homeURL;
/**
 * The current web view URL. If the web view is currently loading a URL, then the loading URL is
 * returned instead.
 */
@property (nonatomic, readonly) NSURL*  URL;

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

@end
