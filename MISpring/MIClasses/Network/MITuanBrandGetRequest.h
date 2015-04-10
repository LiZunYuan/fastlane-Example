//
//  MITuanBrandGetRequest.h
//  MISpring
//
//  Created by 曲俊囡 on 13-12-7.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIBaseRequest.h"

@interface MITuanBrandGetRequest : MIBaseRequest


- (void)setCat:(NSString *)cat;
- (void)setPage:(NSInteger)page;
- (void)setPageSize:(NSInteger)pageSize;

@end
