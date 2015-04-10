//
//  MIThirdLoginViewController.h
//  MISpring
//
//  Created by XU YUJIAN on 13-1-22.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIError.h"

@protocol MIAuthorizeViewDelegate <NSObject>

@required
-(void)authFinishedSuccess:(NSString *)token;

@optional
-(void)authFinishedFailure:(MIError *)error;
-(void)authWebViewDidCancel;

@end

@interface MIThirdLoginViewController : MIModalWebViewController {
}

//@property(nonatomic, strong) NSString *webViewTitle;
@property(nonatomic, weak) id<MIAuthorizeViewDelegate> delegate;
@property(nonatomic, strong) NSString *event;

- (id)initWithOrigin:(NSString *)origin delegate:(id<MIAuthorizeViewDelegate>)delegate;

@end
