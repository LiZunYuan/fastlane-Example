//
//  MICoinEarnHistoryGetRequest.h
//  MISpring
//
//  Created by 曲俊囡 on 14-5-26.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MIBaseRequest.h"

@interface MICoinEarnHistoryGetRequest : MIBaseRequest

- (void)setPage:(NSInteger)page;
- (void)setPageSize:(NSInteger)pageSize;

@end
