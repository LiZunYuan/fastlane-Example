//
//  MITbkItemClickRequest.h
//  MISpring
//
//  Created by 徐 裕健 on 13-12-17.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIBaseRequest.h"

@interface MITbkItemClickRequest : MIBaseRequest
- (void)setIids:(NSString *)iids;
- (void)setTimes:(NSString *)times;
@end
