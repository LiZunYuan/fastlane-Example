//
//  MIUserFavorBrandGetRequest.h
//  MISpring
//
//  Created by yujian on 14-12-15.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MIBaseRequest.h"

@interface MIUserFavorBrandGetRequest : MIBaseRequest

- (void) setPage:(NSInteger)page;
- (void) setPageSize:(NSInteger)pageSize;

@end
