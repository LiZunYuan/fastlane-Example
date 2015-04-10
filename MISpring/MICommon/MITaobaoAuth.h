//
//  MITaobaoAuth.h
//  MISpring
//
//  Created by 徐 裕健 on 13-9-4.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MITaobaoAuthViewController.h"

@interface MITaobaoAuth : NSObject<MIAuthorizeDelegate>

@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) TopAuth *topAuth;
@property (nonatomic, copy)   NSString *userid;
@property (nonatomic, copy)   NSDate *expirationDate;
@property (nonatomic, copy)   NSDate *refreshTokenDate;

+ (MITaobaoAuth *) getInstance;

// Log in using OAuth Web authorization.
- (void)logIn:(NSString *) _url title:(NSString *) _title;

// Log out.
- (void)logOut;

// isLoggedIn && isAuthorizeExpired
- (BOOL)isAuthValid;


@end
