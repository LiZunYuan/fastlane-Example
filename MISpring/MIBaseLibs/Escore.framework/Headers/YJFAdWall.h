//
//  YJFAdWallViewController.h
//  YJF_iosSDK_Html
//
//  Created by emaryjf on 13-12-21.
//  Copyright (c) 2013年 emaryjf. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YJFAdWallDelegate <NSObject>
@optional
-(void)OpenAdWall:(int)_value;//1 打开成功  0 打开失败
-(void)CloseAdWall;//墙关闭
@end

@interface YJFAdWall : UIViewController<UIWebViewDelegate,NSURLConnectionDataDelegate,UIAlertViewDelegate>

@property (nonatomic,retain) NSMutableData *receiveData;
@property (assign) id<YJFAdWallDelegate> delegate;
@property (assign) UIWebView *adWallWebView;
//@property (assign) UIButton *backBut;
@property (assign) UIActivityIndicatorView *progressInd;
- (BOOL) isAdShow;

@end
