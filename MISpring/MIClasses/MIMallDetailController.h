//
//  MIMallDetailController.h
//  MISpring
//
//  Created by Mac Chow on 13-4-1.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIBaseViewController.h"
#import "MIMallModel.h"
#import "CollapseClick.h"
#import "MICommonButton.h"
#import "MIMallInfoRequest.h"

@interface MIMallDetailController : MIBaseViewController<CollapseClickDelegate, UIWebViewDelegate>

@property(nonatomic, strong) MIMallInfoRequest * mallInfoReq;
@property(nonatomic, strong) MIMallModel * mall;
@property(nonatomic, strong) MIMallInfoModel * mallInfo;
@property(nonatomic, strong) UILabel * labelTitle;
@property(nonatomic, strong) UIImageView * imgLogo;
@property(nonatomic, strong) UILabel * labelCommission;
@property(nonatomic, strong) CollapseClick * accordion;

@property(nonatomic, strong) UITextView * textDesc;
@property(nonatomic, strong) UIWebView * webCommissionDesc;
@property(nonatomic, strong) UIWebView * webCommissionNote;
@property(nonatomic, strong) UILabel * textVisited;

-(id) initWithMallModel: (MIMallModel *) mall;

@end
