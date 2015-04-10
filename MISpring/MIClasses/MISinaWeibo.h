//
//  MISinaWeibo.h
//  MISpring
//
//  Created by Yujian Xu on 13-6-18.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIWeiboAuthViewController.h"

@interface MISinaWeibo : NSObject<MIAuthorizeDelegate>
{
    BOOL ssoLoggingIn;
}

@property (nonatomic, copy) NSString *appKey;
@property (nonatomic, copy) NSString *appSecret;
@property (nonatomic, copy) NSString *appRedirectURI;
@property (nonatomic, copy) NSString *ssoCallbackScheme;

@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, strong) NSDate *expirationDate;
@property (nonatomic, strong) NSString *refreshToken;
@property (nonatomic, strong) NSInvocation *invocation;

+ (MISinaWeibo *) getInstance;

- (void)applicationDidBecomeActive;

- (BOOL)handleOpenURL:(NSURL *)url;

// Log in using OAuth Web authorization.
// If succeed, sinaweiboDidLogIn will be called.
- (void)logIn:(NSInvocation *) _invocation;

// Log out.
// If succeed, sinaweiboDidLogOut will be called.
- (void)logOut;

// Check if user has logged in, or the authorization is expired.
- (BOOL)isLoggedIn;
- (BOOL)isAuthorizeExpired;

- (void)logInDidFinishWithAuthInfo:(NSDictionary *)authInfo;

// isLoggedIn && isAuthorizeExpired
- (BOOL)isAuthValid;


@end
