
//
//  MIPageBaseRequest.m
//  MISpring
//
//  Created by husor on 14-12-4.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MIPageBaseRequest.h"

@interface MIPageBaseRequest()
{
    NSString *_format;
}

@end

@implementation MIPageBaseRequest

- (void) setPage:(NSInteger)page
{
    [self.fields setObject:@(page) forKey:@"page"];
}

- (void) setPageSize:(NSInteger)pageSize
{
    [self.fields setObject:@(pageSize) forKey:@"page_size"];
}

- (void) setFormat:(NSString *)staticFormat
{
    _format = staticFormat;
    if (_format) {
        self.type = @"static";
    }
}

- (NSString *)getType
{
    if (_format) {
        return @"static";
    }
    return nil;
}

- (NSString *) getStaticURL
{
    NSNumber *page = [self.fields objectForKey:@"page"];
    NSNumber *pageSize = [self.fields objectForKey:@"page_size"];
    return [NSString stringWithFormat:_format, page.integerValue, pageSize.integerValue];
}

@end
