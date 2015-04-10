//
//  MIMallGetRequest.m
//  MISpring
//
//  Created by lsave on 13-3-16.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIMallGetRequest.h"
#import "MIMallGetModel.h"

@implementation MIMallGetRequest

- (id)init {
    self = [super init];
    
    return self;
}
- (void) setQ: (NSString *) q {
    [self.fields setObject:q forKey:@"q"];
}
- (void) setCid: (NSString *) cid {
    [self.fields setObject:cid forKey:@"cid"];
}
- (void) setType:(NSNumber *) type {
    [self.fields setObject:type forKey:@"type"];
}
- (void) setLetter: (NSString *) letter {
    [self.fields setObject:letter forKey:@"letter"];
}
- (void) setPage:(NSInteger)page
{
    [self.fields setObject:[NSString stringWithFormat:@"%d", page] forKey:@"page"];
}
- (void) setPageSize:(NSInteger)pageSize
{
    [self.fields setObject:[NSString stringWithFormat:@"%d", pageSize] forKey:@"page_size"];
}

- (NSString *) getMethod {
    return @"mizhe.mall.get";
}

@end


