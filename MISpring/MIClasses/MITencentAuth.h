//
//  MITencentAuth.h
//  MISpring
//
//  Created by Yujian Xu on 13-6-19.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TencentOpenAPI/TencentOAuth.h"

@interface MITencentAuth : NSObject<TencentSessionDelegate, TCAPIRequestDelegate>

@property (strong, nonatomic) TencentOAuth *tencOAuth;
@property (nonatomic, strong) NSString *openID;
@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, strong) NSDate *expirationDate;
@property (nonatomic, strong) NSInvocation *invocation;

+ (MITencentAuth *) getInstance;

// Log in using OAuth Web authorization.
- (void)logIn:(NSInvocation *) _invocation;

// Log out.
- (void)logOut;

// isLoggedIn && isAuthorizeExpired
- (BOOL)isAuthValid;

@end
