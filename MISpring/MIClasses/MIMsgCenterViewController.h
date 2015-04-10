//
//  MIMsgCenterViewController.h
//  MISpring
//
//  Created by 徐 裕健 on 14-1-3.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MIBaseViewController.h"
#import "MICommentReceiveGetRequest.h"
#import "MIOrderNoteView.h"

@interface MIMsgCenterViewController : MIBaseViewController{
    BOOL _hasMore;
    NSInteger _currentPage;
    MIOrderNoteView *_tipsView;
}

@property (nonatomic, strong) NSMutableArray *commentsArray;
@property (nonatomic, strong) MICommentReceiveGetRequest *request;
@property (nonatomic, strong) MIOrderNoteView *tipsView;

@end
