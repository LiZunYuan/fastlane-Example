//
//  MIOrderMallGetRequest.h
//  MISpring
//
//  Created by Yujian Xu on 13-4-3.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIBaseRequest.h"

@interface MIOrderMallGetRequest : MIBaseRequest

- (void)setStatus:(NSInteger)status;
- (void)setPage:(NSInteger)page;
- (void)setPageSize:(NSInteger)pageSize;

@end
