//
//  MIMallGetRequest.h
//  MISpring
//
//  Created by lsave on 13-3-16.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIBaseRequest.h"

@interface MIMallGetRequest : MIBaseRequest {
    
}

- (void) setQ: (NSString *) q;
- (void) setCid: (NSString *) cid;
- (void) setType: (NSNumber *) type;
- (void) setLetter: (NSString *) letter;
- (void) setPage:(NSInteger)page;
- (void) setPageSize:(NSInteger)pageSize;

@end
