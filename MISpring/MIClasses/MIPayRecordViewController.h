//
//  MIPayRecordViewController.h
//  MISpring
//
//  Created by Yujian Xu on 13-3-26.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIBaseViewController.h"
#import "MIPayGetRequest.h"
#import "MIOrderNoteView.h"

@interface MIPayRecordViewController : MIBaseViewController
{
    BOOL _hasMore;
    MIOrderNoteView *_orderNoteView;
}
@property (nonatomic, assign) BOOL hasMore;
@property (nonatomic, strong) MIOrderNoteView *orderNoteView;
@property (nonatomic, strong) NSMutableArray *payRecordArray;
@property (nonatomic, strong) MIPayGetRequest *request;


@end
