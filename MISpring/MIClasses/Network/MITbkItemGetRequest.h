//
//  MITbkItemGetRequest.h
//  MISpring
//
//  Created by lsave on 13-3-18.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIBaseRequest.h"

@interface MITbkItemGetRequest : MIBaseRequest {
    
}

- (void) setQ: (NSString *) q;
- (void) setSort: (NSString *) sort;
- (void) setIsTmall: (NSString *) isTmall;
- (void) setPage: (NSInteger) page;
- (void) setPageSize:(NSInteger)pageSize;
- (void) setMinPrice:(NSString *)minPrice;
- (void) setMaxPrice:(NSString *)maxPrice;

@end
