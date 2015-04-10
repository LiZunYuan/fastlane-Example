//
//  Insert.h
//  yjfSDKDemo_beta1
//
//  Created by emaryjf on 13-2-5.
//  Copyright (c) 2013年 emaryjf. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YJFInterstitialDelegate <NSObject,NSURLConnectionDelegate>
@optional
-(void)openInterstitial:(int)_value;//1 插屏弹出成功  0 插屏弹出失败
-(void)closeInterstitial;//插屏关闭
-(void)getInterstitialDataSuccess;//获取数据成功
-(void)getInterstitialDataFail;//获取数据失败

@end



NSMutableString *interstitialPar;

@interface YJFInterstitial : NSObject<YJFInterstitialDelegate>
{
    id<YJFInterstitialDelegate> delegate;
    NSMutableArray *array;
    NSString *orientation;
  
}
@property (assign) id<YJFInterstitialDelegate> delegate;
@property (nonatomic, assign) UIViewController* viewController;
@property (nonatomic,retain) NSMutableData *receivedData;
@property (assign) NSString *uniquePath;
@property CGRect picFrame;
@property CGRect uiFrame;


+ (YJFInterstitial *)shareInstance;
+ (void)destroyDealloc;

-(id)initWithFrame:(CGRect)frame andPicFrame:(CGRect)picFrame andOrientation:(NSString *)orientations andDelegate:(id<YJFInterstitialDelegate>)_delegate;

/**
 *  展示广告
 */
- (void)show;
- (BOOL) isShow;
@end
