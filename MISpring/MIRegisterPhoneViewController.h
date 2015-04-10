//
//  BBRegisterViewController.h
//  BeiBeiAPP
//
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MIBaseViewController.h"
#import "MIPhoneRegisterView.h"
#import "MILoginRegisterDelegate.h"

@interface MIRegisterPhoneViewController : MIBaseViewController<MIRegisterPhoneDelegate>
{
@private
    MBProgressHUD *_hud;
}

@property (nonatomic, weak) id<MILoginRegisterDelegate> loginRegisterDelegate;

- (id)initWithToken:(NSString *)token;

@end
