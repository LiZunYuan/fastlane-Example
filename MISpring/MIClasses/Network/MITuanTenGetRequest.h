//
//  MITuanTenGetRequest.h
//  MISpring
//
//  Created by Yujian Xu on 13-3-26.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIBaseRequest.h"
#import "MIPageBaseRequest.h"

@interface MITuanTenGetRequest : MIPageBaseRequest

- (void)setPage:(NSInteger)page;
- (void)setPageSize:(NSInteger)pageSize;
- (void)setSubject:(NSString *)subject;
- (void)setCat:(NSString *)cat;
//- (void)setTag:(NSString *)tag;
//- (void)setSort:(NSString *)sort;

@end
