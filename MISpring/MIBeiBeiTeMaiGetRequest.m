//
//  MIBeiBeiTeMaiGetRequest.m
//  MISpring
//
//  Created by husor on 14-10-14.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MIBeiBeiTeMaiGetRequest.h"

@implementation MIBeiBeiTeMaiGetRequest

- (void) setPage:(NSInteger)page
{
    [self.fields setObject:[NSString stringWithFormat:@"%ld", (long)page] forKey:@"page"];
}
- (void) setPageSize:(NSInteger)pageSize
{
    [self.fields setObject:[NSString stringWithFormat:@"%ld", (long)pageSize] forKey:@"page_size"];
}
- (void)setCatId:(NSString *)catId
{
    [self.fields setObject:[NSString stringWithFormat:@"%@", catId] forKey:@"cat_id"];
}
- (void)setTag:(NSString *)tag
{
    [self.fields setObject:[NSString stringWithFormat:@"%@", tag] forKey:@"tag"];
}
- (void)setSort:(NSString *)sort
{
    [self.fields setObject:[NSString stringWithFormat:@"%@", sort] forKey:@"sort"];
}
- (void)setFilterSellout:(NSInteger )filterSellout
{
    [self.fields setObject:[NSString stringWithFormat:@"%ld",(long)filterSellout] forKey:@"filter_sellout"];
}
- (NSString *) getMethod
{
    return @"mizhe.beibei.temai.get";
}

- (NSString *) getType
{
    return @"static";
}
- (NSString *) getStaticURL
{
    NSString *cat = [self.fields objectForKey:@"cat_id"];
    if ([cat isEqualToString:@"all"] || [cat isEqualToString:@""]) {
                return [NSString stringWithFormat:@"http://sapi.beibei.com/youpin/%@-%@-%@-%@.html", [self.fields objectForKey:@"page"], [self.fields objectForKey:@"page_size"],[self.fields objectForKey:@"sort"],[self.fields objectForKey:@"filter_sellout"]];
    }
    else{
        return [NSString stringWithFormat:@"http://sapi.beibei.com/youpin/search/%@-%@-%@.html", [self.fields objectForKey:@"page"], [self.fields objectForKey:@"page_size"],[self.fields objectForKey:@"cat_id"]];
    }
}

@end
