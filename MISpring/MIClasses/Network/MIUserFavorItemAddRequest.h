//
//  MIUserFavorItemAddRequest.h
//  MISpring
//
//  Created by yujian on 14-12-15.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MIBaseRequest.h"

@interface MIUserFavorItemAddRequest : MIBaseRequest

- (void)setIid:(NSNumber *)iid;  //客户端需要传item_id[团购中tuan_id, 品牌团中brand_id(大于等于1亿)

@end
