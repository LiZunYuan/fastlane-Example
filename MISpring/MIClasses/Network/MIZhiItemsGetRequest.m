//
//  MIZhiItemsGetRequest.m
//  MISpring
//
//  Created by 徐 裕健 on 13-10-23.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIZhiItemsGetRequest.h"

@implementation MIZhiItemsGetRequest
- (void)setCat:(NSString *)cat
{
    if (cat != nil) {
        [self.fields setObject:cat forKey:@"cat"];
    } else {
        [self.fields setObject:@"" forKey:@"cat"];
    }
}
- (void)setTag:(NSString *)tag
{
    [self.fields setObject:tag forKey:@"tag"];
}
- (void) setPage:(NSInteger)page
{
    [self.fields setObject:[NSString stringWithFormat:@"%ld", (long)page] forKey:@"page"];
}
- (void) setPageSize:(NSInteger)pageSize
{
    [self.fields setObject:[NSString stringWithFormat:@"%ld", (long)pageSize] forKey:@"page_size"];
}
- (NSString *) getMethod
{
    return @"mizhe.zhi.items.get";
}

- (NSString *) getType
{
    return @"static";
}
- (NSString *) getStaticURL
{
    return [NSString stringWithFormat:@"%@/zhi/%@-%@-%@-%@.html", [MIConfig globalConfig].staticApiURL, [self.fields objectForKey:@"cat"], [self.fields objectForKey:@"tag"], [self.fields objectForKey:@"page"], [self.fields objectForKey:@"page_size"]];
}
@end
