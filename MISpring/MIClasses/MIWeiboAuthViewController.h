//
//  MIWeiboAuthViewController.h
//  MISpring
//
//  Created by Yujian Xu on 13-6-18.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIWeiboAuthViewController.h"
#import "MIAuthorizeDelegate.h"

@interface MIWeiboAuthViewController : MIModalWebViewController
{
    NSString *appRedirectURI;
    NSDictionary *authParams;
}

@property(nonatomic, weak) id<MIAuthorizeDelegate> delegate;

- (id)initWithAuthParams:(NSDictionary *)params delegate:(id<MIAuthorizeDelegate>)_delegate;

@end
