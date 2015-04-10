//
//  MITdjDetailsViewController.h
//  MISpring
//
//  Created by 徐 裕健 on 13-9-25.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "TopIOSClient.h"
#import "MIOrderNoteView.h"

@interface MITdjDetailsViewController : MIBaseViewController<UIWebViewDelegate>

@property (nonatomic, assign) BOOL isJhsRebate;

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) NSMutableURLRequest *urlRequest;

@property (nonatomic, strong) NSString *iid;
@property (nonatomic, strong) NSString *productTitle;
@property (nonatomic, strong) NSString *picUrl;

////////
@property(nonatomic, strong) UILabel *virtualTips;
@property(nonatomic, strong) UIView *virtualView;
@property(nonatomic, strong) NSArray *keywordsArray;

-(id) initWithNumiid: (NSString *) numiid;

@end
