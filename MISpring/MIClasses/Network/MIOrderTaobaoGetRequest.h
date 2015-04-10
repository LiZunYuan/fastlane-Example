//
//  MIOrderTaobaoGetRequest.h
//  MISpring
//
//  Created by Yujian Xu on 13-3-18.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIBaseRequest.h"

@interface MIOrderTaobaoGetRequest : MIBaseRequest

- (void)setPage:(NSInteger)page;
- (void)setPageSize:(NSInteger)pageSize;

@end
