//
//  MITaobaoOrderViewController.h
//  MISpring
//
//  Created by Yujian Xu on 13-3-18.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIBaseViewController.h"
#import "MIOrderTaobaoCoinAwardRequest.h"
#import "MIOrderNoteView.h"

@class MIOrderTaobaoGetRequest;

@interface MITaobaoOrderViewController : MIBaseViewController
{
    BOOL _hasMore;
    NSInteger _currentPage;
    MIOrderNoteView *_orderNoteView;
}
@property (nonatomic, assign) BOOL hasMore;
@property (nonatomic, strong) MIOrderNoteView *orderNoteView;
@property (nonatomic, strong) NSMutableArray *taobaoOrdersArray;
@property (nonatomic, strong) MIOrderTaobaoGetRequest *request;
@property (nonatomic, strong) MIOrderTaobaoCoinAwardRequest *awardRequest;


@end
