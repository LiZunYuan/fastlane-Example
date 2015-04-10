//
//  MIAuthorizeDelegate.h
//  MISpring
//
//  Created by 徐 裕健 on 13-9-4.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MIAuthorizeDelegate <NSObject>

@required
-(void)authFinishedSuccess;

@optional
-(void)authFinishedFailure:(MIError *)error;
-(void)authWebViewDidCancel;

@end