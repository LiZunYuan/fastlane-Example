//
//  MIBeiBeiTeMaiGetRequest.h
//  MISpring
//
//  Created by husor on 14-10-14.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MIBaseRequest.h"

@interface MIBeiBeiTeMaiGetRequest : MIBaseRequest
- (void)setPage:(NSInteger)page;
- (void)setPageSize:(NSInteger)pageSize;
- (void)setCatId:(NSString *)catId;
- (void)setTag:(NSString *)tag;
- (void)setSort:(NSString *)sort;
- (void)setFilterSellout:(NSInteger )filterSellout;
@end
