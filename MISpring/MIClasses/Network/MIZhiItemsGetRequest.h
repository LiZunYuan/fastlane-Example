//
//  MIZhiItemsGetRequest.h
//  MISpring
//
//  Created by 徐 裕健 on 13-10-23.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIBaseRequest.h"

@interface MIZhiItemsGetRequest : MIBaseRequest
- (void)setCat:(NSString *)cat;
- (void)setTag:(NSString *)tag;
- (void)setPage:(NSInteger)page;
- (void)setPageSize:(NSInteger)pageSize;
@end
