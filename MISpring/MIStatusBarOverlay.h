//
//  MIStatusBarOverlay.h
//  MISpring
//
//  Created by husor on 14-10-29.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MIStatusBarOverlay : UIWindow
{
    UILabel *_messageLabel;
}
-(void)showMessage:(NSString *)message;
-(void)hide;

@end
