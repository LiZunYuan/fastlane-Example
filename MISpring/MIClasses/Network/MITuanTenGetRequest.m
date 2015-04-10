//
//  MITuanTenGetRequest.m
//  MISpring
//
//  Created by Yujian Xu on 13-3-26.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MITuanTenGetRequest.h"

/**
 url格式：m.mizhe.com/tuan/{subject}-{cat}-{tag}-{sort}-{page}-{page_size}.html
 subject: all, 9kuai9, 19kuai9，temai，10yuan，youpin
 cat: 类别
 tag: 标签, 目前未传
 sort: 排序, 目前未传
 
 新增的subject类别含义分别是
 all:为空或者all均为返回十元购和优品惠的商品
 temai:表示获取所有米折特卖的商品，包括10元购／优品惠／品牌特卖
 10yuan:表示获取10元购的商品
 youpin:表示获取优品惠的商品
 
 接口返回的商品类型type，以区分10元购／优品惠／品牌特卖的商品（1、10yuan 2、youpin 3、brand）
 */

@implementation MITuanTenGetRequest
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
//- (void)setTag:(NSString *)tag
//{
//    [self.fields setObject:[NSString stringWithFormat:@"%@", tag] forKey:@"tag"];
//}
//- (void)setSort:(NSString *)sort
//{
//    [self.fields setObject:[NSString stringWithFormat:@"%@", sort] forKey:@"sort"];
//}
- (NSString *) getMethod
{
    return @"mizhe.tuan.ten.get";
}

- (NSString *) getType
{
    return @"static";
}
- (NSString *) getStaticURL
{
    return [NSString stringWithFormat:@"%@/tuan/%@-%@---%@-%@.html", [MIConfig globalConfig].staticApiURL, [self.fields objectForKey:@"subject"], [self.fields objectForKey:@"cat"], [self.fields objectForKey:@"page"], [self.fields objectForKey:@"page_size"]];
}
@end
