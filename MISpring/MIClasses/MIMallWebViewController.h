//
//  MIMallWebViewController.h
//  MISpring
//
//  Created by Mac Chow on 13-4-12.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIMallModel.h"

@interface MIMallWebViewController : MIWebViewController

@property(nonatomic, strong) UIView * loginView;
@property(nonatomic, strong) MIMallModel * mall;

@property(nonatomic, strong) NSRegularExpression * rxUid;

@property(nonatomic, assign) BOOL showDetailIcon;
@property(nonatomic, strong) NSString * defaultUA;

- (id) initWithURL:(NSURL *)URL mall: (MIMallModel *) mall;

@end
