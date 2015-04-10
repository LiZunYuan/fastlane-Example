//
//  MITuanBrandDetailGetRequest.h
//  MISpring
//
//  Created by 曲俊囡 on 13-12-7.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIBaseRequest.h"

@interface MITuanBrandDetailGetRequest : MIBaseRequest

- (void)setAid:(NSInteger)aid;
- (void)setPage:(NSInteger)page;
- (void)setPageSize:(NSInteger)pageSize;

@end
