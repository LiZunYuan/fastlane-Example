//
//  MIExchangeGetRecordRequest.h
//  MiZheHD
//
//  Created by haozi on 13-8-8.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIBaseRequest.h"

@interface MIExchangeGetRecordRequest : MIBaseRequest
- (void) setType: (NSString *) type;
- (void)setPage:(NSInteger)page;
- (void)setPageSize:(NSInteger)pageSize;
@end
