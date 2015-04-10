//
//  MITuanTomorrowRequest.h
//  MISpring
//
//  Created by 曲俊囡 on 14-6-17.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MIBaseRequest.h"

@interface MITuanTomorrowRequest : MIBaseRequest

- (void)setPage:(NSInteger)page;
- (void)setPageSize:(NSInteger)pageSize;
- (void)setSubject:(NSString *)subject;
- (void)setCat:(NSString *)cat;

@end
