//
//  MIZhiDetailViewController.h
//  MISpring
//
//  Created by 曲俊囡 on 13-10-23.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIBaseViewController.h"

#import "MIZhiItemModel.h"
#import "MIZhiItemDetailGetRequest.h"
#import "MICommentsGetRequest.h"
#import "MIZhiItemVoteAddRequest.h"
#import "MIZhiReplyViewController.h"
#import "MIZhiItemDetailGetModel.h"
#import "MIZhiReportSubmitRequest.h"
#import "MIZhiVoteGetRequest.h"

@interface MIZhiDetailViewController : MIBaseViewController<UIWebViewDelegate,MICommentDelegate,UIGestureRecognizerDelegate>

@property(nonatomic, strong) MIZhiItemDetailGetModel *detailModel;
@property(nonatomic, strong) MIZhiItemModel *zhiModel;
@property(nonatomic, strong) NSString *zid;
@property(nonatomic, strong) NSString *cat;

@property(nonatomic, strong) MIZhiItemDetailGetRequest *detailGetRequest;
@property(nonatomic, strong) MICommentsGetRequest *commentsGetRequest;
@property(nonatomic, strong) MIZhiItemVoteAddRequest *voteAddRequest;
@property(nonatomic, strong) MIZhiReportSubmitRequest *reportRequest;
@property(nonatomic, strong) MIZhiVoteGetRequest *voteGetRequest;

@property(nonatomic, strong) UIView *toolView;
@property(nonatomic, strong) UIWebView *webView;
@property(nonatomic, strong) UILabel *buyLabel;

@property (nonatomic, assign) BOOL failToGetComments;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) CGFloat lastscrollViewOffset;

@property(nonatomic, strong) UIImageView *popupImageView;
@property(nonatomic, strong) UIView *popupImageViewContainer;

- (id)initWithItem:(MIZhiItemModel *)item;

@end
