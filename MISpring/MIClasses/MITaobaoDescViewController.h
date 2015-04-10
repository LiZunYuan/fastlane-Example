//
//  MITaobaoDescViewController.h
//  MISpring
//
//  Created by 徐 裕健 on 13-9-25.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIBaseViewController.h"

@interface MITaobaoDescViewController : MIBaseViewController<UIWebViewDelegate>

@property(nonatomic, strong) UIWebView *webview;
@property(nonatomic, strong) NSString *desc;
@property(nonatomic, strong) UIActivityIndicatorView* loadingIndicator;

-(id) initWithDesc: (NSString *) desc;

@end
