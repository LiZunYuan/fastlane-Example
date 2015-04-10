//
//  MIMallSearchRequest.h
//  MISpring
//
//  Created by Mac Chow on 13-3-21.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIBaseRequest.h"

@interface MIMallSearchRequest : MIBaseRequest<MIBaseWebApiProtocol> {
    
}

- (void) setQ: (NSString *) q;

@end
