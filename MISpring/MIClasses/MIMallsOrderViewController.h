//
//  MIMallsOrderViewController.h
//  MISpring
//
//  Created by Yujian Xu on 13-3-19.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIBaseViewController.h"
#import "MIOrderNoteView.h"
#import "SegmentedSwitchView.h"
#import "MIOrderMallGetRequest.h"
#import "MIOrderMallCoinAwardRequest.h"

@interface MIMallsOrderViewController : MIBaseViewController<SegmentedSwitchViewDelegate>
{
    BOOL _hasMore;
    NSInteger _currentPage;
    MIOrderNoteView *_orderNoteView;
}
@property (nonatomic, assign) BOOL hasMore;
@property (nonatomic, strong) MIOrderNoteView *orderNoteView;
@property (nonatomic, strong) SegmentedSwitchView *segmentedSwitchView;

@property (nonatomic, strong) NSMutableArray *mallOrdersArray;
@property (nonatomic, strong) MIOrderMallGetRequest *request;
@property (nonatomic, strong) MIOrderMallCoinAwardRequest *awardRequest;

@end
