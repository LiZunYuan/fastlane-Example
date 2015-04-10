//
//  MIBBMartshowItemGetRequest.h
//  MISpring
//
//  Created by husor on 14-10-16.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MIBaseRequest.h"

@interface MIBBMartshowItemGetRequest : MIBaseRequest
- (void)setEventId:(NSInteger)eventId;
- (void)setPage:(NSInteger)page;
- (void)setPageSize:(NSInteger)pageSize;
- (void)setTag:(NSString *)tag;
- (void)setFielter:(NSString *)fielter;
- (void)setIsSellOut:(NSNumber *)sellout;

@end
