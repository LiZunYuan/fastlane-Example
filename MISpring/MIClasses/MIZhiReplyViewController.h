//
//  MIZhiReplyViewController.h
//  MISpring
//
//  Created by 曲俊囡 on 13-10-24.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIBaseViewController.h"
#import "MICommentAddRequest.h"
#import "MICommentModel.h"

typedef enum _COMMENT_TYPE{
    COMMENT_TYPE_TUAN = 1,
    COMMENT_TYPE_ZHI = 2,
    COMMENT_TYPE_SHAI = 3,
} CommentType;

@protocol MICommentDelegate <NSObject>

@optional
- (void)finishSendComment:(MICommentModel *)model;

@end

@interface MIZhiReplyViewController : MIBaseViewController<UITextViewDelegate,MICommentDelegate>

@property (nonatomic, weak)id<MICommentDelegate> delegate;

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger toUid;
@property (nonatomic, assign) NSInteger itemId;
@property (nonatomic, assign) NSInteger commentId;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) UIView *commentBackgroundView;
@property (nonatomic, strong) UITextView *inputText;
@property (nonatomic, strong) RTLabel *placeHolderLabel;
@property (nonatomic, strong) UILabel *captionLimitLabel;
@property(nonatomic, strong) MICommentAddRequest *commentAddRequest;

-(void)updateCaptionLimitTips;

@end
