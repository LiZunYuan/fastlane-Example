//
//  MIMallReloadRequest.h
//  MISpring
//
//  Created by Mac Chow on 13-3-27.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIBaseRequest.h"

@interface MIMallReloadRequest : MIBaseRequest

- (void) setType: (NSNumber *) type;
- (void) setLast: (NSNumber *) data;
- (void) setSummary: (NSNumber *) summary;

@end
