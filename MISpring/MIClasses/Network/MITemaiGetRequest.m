//
//  MITemaiGetRequest.m
//  MISpring
//
//  Created by 曲俊囡 on 14-7-21.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MITemaiGetRequest.h"

@implementation MITemaiGetRequest

- (void) setPage:(NSInteger)page
{
    [self.fields setObject:[NSString stringWithFormat:@"%ld", (long)page] forKey:@"page"];
}
- (void) setPageSize:(NSInteger)pageSize
{
    [self.fields setObject:[NSString stringWithFormat:@"%ld", (long)pageSize] forKey:@"page_size"];
}

- (void)setCat:(NSString *)cat
{
    [self.fields setObject:[NSString stringWithFormat:@"%@", cat] forKey:@"cat"];
}
- (void)setTag:(NSString *)tag
{
    [self.fields setObject:[NSString stringWithFormat:@"%@", tag] forKey:@"tag"];
}
- (void)setSort:(NSString *)sort
{
    [self.fields setObject:[NSString stringWithFormat:@"%@", sort] forKey:@"sort"];
}
- (NSString *) getMethod
{
    return @"mizhe.temai.get";
}

- (NSString *) getType
{
    return @"static";
}
- (NSString *) getStaticURL
{
    return [NSString stringWithFormat:@"%@/temai/%@---%@-%@.html", [MIConfig globalConfig].staticApiURL, [self.fields objectForKey:@"cat"], [self.fields objectForKey:@"page"], [self.fields objectForKey:@"page_size"]];
}

@end
