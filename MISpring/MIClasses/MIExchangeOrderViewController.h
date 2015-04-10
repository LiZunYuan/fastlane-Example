//
//  MIExchangeOrderViewController.h
//  MISpring
//
//  Created by 贺晨超 on 13-8-28.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MIExchangeGetRecordRequest.h"
#import "MIExchangeGetModel.h"
#import "MIExchangeOrderModel.h"
#import "MIOrderNoteView.h"

@interface MIExchangeOrderViewController : MIBaseViewController{
    BOOL _hasMore;
    NSInteger _currentPage;
    MIOrderNoteView *_orderNoteView;
}

@property (nonatomic, strong) NSMutableArray *recordArray;
@property (nonatomic, strong) MIExchangeGetRecordRequest *request;
@property (nonatomic, strong) MIOrderNoteView *orderNoteView;

@end
