//
//  MIPageBaseRequest.h
//  MISpring
//
//  Created by husor on 14-12-4.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MIBaseRequest.h"

@interface MIPageBaseRequest : MIBaseRequest

- (void)setPage:(NSInteger)page;
- (void)setPageSize:(NSInteger)pageSize;

- (void) setFormat:(NSString *)staticFormat;

@end
