//
//  MIBrandTomorrowRequest.h
//  MISpring
//
//  Created by 曲俊囡 on 14-6-17.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MIBaseRequest.h"

@interface MIBrandTomorrowRequest : MIBaseRequest

- (void)setCat:(NSString *)cat;
- (void)setPage:(NSInteger)page;
- (void)setPageSize:(NSInteger)pageSize;

@end
