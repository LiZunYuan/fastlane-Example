//
//  MITaskDetailViewController.h
//  MISpring
//
//  Created by 曲俊囡 on 14-5-26.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MIBaseViewController.h"
#import "MICoinEarnHistoryGetRequest.h"

@interface MITaskDetailViewController : MIBaseViewController
{
    BOOL _hasMore;
}


@property (nonatomic, strong) MICoinEarnHistoryGetRequest *request;
@property (nonatomic, strong) NSMutableArray *tuanArray;

@end
