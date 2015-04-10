//
//  MITuanTomorrowRequest.m
//  MISpring
//
//  Created by 曲俊囡 on 14-6-17.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MITuanTomorrowRequest.h"

@implementation MITuanTomorrowRequest

- (void) setPage:(NSInteger)page
{
    [self.fields setObject:[NSString stringWithFormat:@"%ld", (long)page] forKey:@"page"];
}
- (void) setPageSize:(NSInteger)pageSize
{
    [self.fields setObject:[NSString stringWithFormat:@"%ld", (long)pageSize] forKey:@"page_size"];
}
- (void)setSubject:(NSString *)subject
{
    [self.fields setObject:[NSString stringWithFormat:@"%@", subject] forKey:@"subject"];
}
- (void)setCat:(NSString *)cat
{
    [self.fields setObject:[NSString stringWithFormat:@"%@", cat] forKey:@"cat"];
}

- (NSString *) getMethod {
    return @"mizhe.tuan.tomorrow.get";
}

- (NSString *) getType
{
    return @"static";
}
- (NSString *) getStaticURL
{
    return [NSString stringWithFormat:@"%@/tuan/tomorrow/%@-%@---%@-%@.html", [MIConfig globalConfig].staticApiURL, [self.fields objectForKey:@"subject"], [self.fields objectForKey:@"cat"], [self.fields objectForKey:@"page"], [self.fields objectForKey:@"page_size"]];
}

@end
