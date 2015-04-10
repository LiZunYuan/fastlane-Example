//
//  MITaobaoAuthViewController.h
//  MISpring
//
//  Created by 徐 裕健 on 13-9-3.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIBaseViewController.h"
#import "MIAuthorizeDelegate.h"
#import "TopIOSClient.h"

@interface MITaobaoAuthViewController : MIWebViewController
{
//    MINavigationBar*  _naviBar;
//    TopIOSClient *_topClient;
    NSString *appRedirectURI;
    NSDictionary *authParams;
}

@property(nonatomic, weak) id<MIAuthorizeDelegate> delegate;

- (id)initWithDelegate:(id<MIAuthorizeDelegate>)_delegate;

@end
