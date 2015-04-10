//
//  BBLoginRegisterDelegate.h
//  BeiBeiAPP
//
//  Created by yujian on 15-2-10.
//  Copyright (c) 2015年 Husor Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    LoginType,
    RegisterPhoneType,
    SMSLoginType,
    SMSRegisterType,
}LoginContainerType;

@protocol MILoginRegisterDelegate <NSObject>

- (void)closeLoginView: (id) event;

@required
-(void) goToNextController:(LoginContainerType)type;

@end
