//
//  MITemaiGetRequest.h
//  MISpring
//
//  Created by 曲俊囡 on 14-7-21.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MIPageBaseRequest.h"

@interface MITemaiGetRequest : MIPageBaseRequest

- (void)setPage:(NSInteger)page;
- (void)setPageSize:(NSInteger)pageSize;
- (void)setCat:(NSString *)cat;
- (void)setTag:(NSString *)tag;
- (void)setSort:(NSString *)sort;




@end
