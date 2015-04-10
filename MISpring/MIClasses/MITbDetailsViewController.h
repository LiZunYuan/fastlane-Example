//
//  MITbDetailsViewController.h
//  MISpring
//
//  Created by 徐 裕健 on 13-9-25.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "TopIOSClient.h"
#import "MIOrderNoteView.h"
#import "MITbkItemModel.h"
#import "MITbkItemDetailGetRequest.h"
#import "MITbkMobileItemsConvertRequest.h"
#import "MITbkRebateAuthGetRequest.h"

@interface MITbDetailsViewController : MIBaseViewController<UIWebViewDelegate>

@property(nonatomic, strong) MIOrderNoteView *orderNoteView;
@property(nonatomic, strong) UILabel * loginTips;
@property(nonatomic, strong) UIView * loginView;

@property(nonatomic, strong) TopIOSClient *topClient;
@property(nonatomic, strong) NSString *topSessionKey;
@property(nonatomic, strong) MITbkItemDetailGetRequest *tbkItemDetailRequest;
@property(nonatomic, strong) MITbkMobileItemsConvertRequest *tbkItemsConvertRequest;
@property(nonatomic, strong) MITbkRebateAuthGetRequest *tbkRebateAuthGetRequest;

@property(nonatomic, assign) BOOL isJhsRebate;
@property(nonatomic, assign) BOOL tbkConvertting;
@property(nonatomic, assign) BOOL tbkConvertFailed;
@property(nonatomic, assign) BOOL tbkRebateAuthorize;

@property(nonatomic, strong) NSArray *keywordsArray;

@property(nonatomic, strong) NSString *iid;
@property(nonatomic, strong) NSString *clickUrl;
@property (nonatomic, strong) MITbkItemModel *itemModel;

-(id) initWithNumiid: (NSString *) numiid;

@end
