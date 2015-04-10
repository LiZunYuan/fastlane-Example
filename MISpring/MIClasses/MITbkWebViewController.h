//
//  MITbkWebViewController.h
//  MISpring
//
//  Created by lsave on 13-3-27.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "TopIOSClient.h"
#import "MITbkMobileItemsConvertRequest.h"
#import "MITbkRebateAuthGetRequest.h"

@interface MITbkWebViewController : MIWebViewController

@property(nonatomic, strong) UILabel * titleLabel;
@property(nonatomic, strong) UILabel * rebateLabel1;
@property(nonatomic, strong) UILabel * rebateLabel2;
@property(nonatomic, strong) UILabel * hiddenLabel;
@property(nonatomic, strong) UILabel * loginTips;
@property(nonatomic, strong) UIView * loginView;
@property(nonatomic, strong) UIView *tipsView;

@property(nonatomic, assign) BOOL loadAnyway;
@property(nonatomic, assign) NSInteger origin;
@property(nonatomic, strong) NSString *clickUrl;
@property(nonatomic, strong) NSString *tips;
@property(nonatomic, strong) NSString *webTitle;
@property(nonatomic, strong) NSString *productTitle;
@property(nonatomic, strong) NSString *numiid;
@property(nonatomic, strong) NSString *tuanNumiid;
@property(nonatomic, strong) NSString *brandNumiid;
@property(nonatomic, strong) NSString *zhiNumiid;
@property(nonatomic, strong) NSArray *keywordsArray;
@property(nonatomic, strong) NSString *topSessionKey;
@property(nonatomic, strong) TopIOSClient *topClient;
@property(nonatomic, strong) NSString *topRebateSessionKey;
@property(nonatomic, strong) TopIOSClient *topRebateClient;

@property(nonatomic, strong) MITbkMobileItemsConvertRequest *tbkItemsConvertRequest;
@property(nonatomic, strong) MITbkRebateAuthGetRequest *tbkRebateAuthGetRequest;


@end
