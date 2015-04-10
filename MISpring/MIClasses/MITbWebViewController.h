//
//  MITbWebViewController.h
//  MISpring
//
//  Created by lsave on 13-3-27.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//


@interface MITbWebViewController : MIWebViewController

@property(nonatomic, assign) NSInteger origin;
@property(nonatomic, strong) UILabel *titleLabel;
//@property(nonatomic, strong) UIView *tipsView;
@property(nonatomic, strong) NSString *tag;
//@property(nonatomic, strong) NSString *tips;
@property(nonatomic, strong) NSString *productTitle;
@property(nonatomic, strong) NSString *numiid;
@property(nonatomic, strong) NSString *tuanNumiid;
@property(nonatomic, strong) NSString *brandNumiid;
@property(nonatomic, strong) NSString *originalUrl;
@property(nonatomic, strong) MIGetTbkClickRequest *getTbkClickUrlRequest;

@end
