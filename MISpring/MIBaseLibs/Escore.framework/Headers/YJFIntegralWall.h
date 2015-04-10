//
//  HelpViewController.h
//  yjfSDKDemo_beta1
//
//  Created by emaryjf on 13-5-14.
//  Copyright (c) 2013年 emaryjf. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YJFIntegralWallDelegate <NSObject>
@optional
-(void)OpenIntegralWall:(int)_value;//1 打开成功  0 打开失败
-(void)CloseIntegralWall;//墙关闭

-(void)getYjfScore:(int)_score  status:(int)_value unit:(NSString *) unit;//获取积分1 消耗成功  0 消耗失败
-(void)consumptionYjfScore:(int)_score status:(int)_value;//消耗积分 //1 消耗成功  0 消耗失败
@end

@interface YJFIntegralWall : UIViewController<UIWebViewDelegate,NSURLConnectionDelegate,UIAlertViewDelegate>

@property (assign) id<YJFIntegralWallDelegate> delegate;
@property (assign) UIWebView *YJFIntegralWallWebView;
//@property (assign) UIButton *backBut;
@property (assign) UIActivityIndicatorView  *progressInd;

- (BOOL) isScoreShow;

@end
