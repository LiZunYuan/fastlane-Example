//
//  MISMSSendRequest.h
//  MISpring
//
//  Created by Yujian Xu on 13-4-13.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIBaseRequest.h"

@interface MISMSSendRequest : MIBaseRequest

- (void) setText: (NSString *) text;
- (void) setTel: (NSString *) tel;
- (void) setType: (NSString *) type;
@end
