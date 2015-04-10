//
//  MIBBMartshowItemGetRequest.m
//  MISpring
//
//  Created by husor on 14-10-16.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MIBBMartshowItemGetRequest.h"

@implementation MIBBMartshowItemGetRequest
- (NSString *) getMethod
{
    return @"mizhe.beibei.martshow.item.get";
}

- (void)setTag:(NSString *)tag
{
    [self.fields setObject:tag forKey:@"tag"];
}

- (NSString *) getHttpType {
    return @"GET";
}

- (NSString *) getType
{
    return @"static";
}

- (void)setFielter:(NSString *)fielter
{
    [self.fields setObject:fielter forKey:@"fielter"];
}

- (void)setIsSellOut:(NSNumber *)sellout
{
    [self.fields setObject:sellout forKey:@"sellout"];
}

- (NSString *) getStaticURL
{
    if ([self.fields objectForKey:@"tag"] && [self.fields objectForKey:@"fielter"])
    {
        if ([self.fields objectForKey:@"sellout"]) {
            return [NSString stringWithFormat:@"http://sapi.beibei.com/martshow/item/%@-%@-%@-%@-%@-%@.html",[self.fields objectForKey:@"event_id"], [self.fields objectForKey:@"page"], [self.fields objectForKey:@"page_size"],[self.fields objectForKey:@"fielter"],[self.fields objectForKey:@"sellout"],[self.fields objectForKey:@"tag"]];
        }
        return [NSString stringWithFormat:@"http://sapi.beibei.com/martshow/item/%@-%@-%@-%@--%@.html", [self.fields objectForKey:@"event_id"], [self.fields objectForKey:@"page"], [self.fields objectForKey:@"page_size"],[self.fields objectForKey:@"fielter"],[self.fields objectForKey:@"tag"]];
    }
    else if([self.fields objectForKey:@"fielter"])
    {
        if ([self.fields objectForKey:@"sellout"]) {
            return [NSString stringWithFormat:@"http://sapi.beibei.com/martshow/item/%@-%@-%@-%@-%@-.html", [self.fields objectForKey:@"event_id"], [self.fields objectForKey:@"page"], [self.fields objectForKey:@"page_size"],[self.fields objectForKey:@"fielter"],[self.fields objectForKey:@"sellout"]];
        }
        return [NSString stringWithFormat:@"http://sapi.beibei.com/martshow/item/%@-%@-%@-%@--.html", [self.fields objectForKey:@"event_id"], [self.fields objectForKey:@"page"], [self.fields objectForKey:@"page_size"],[self.fields objectForKey:@"fielter"]];
    }
    else if([self.fields objectForKey:@"sellout"])
    {
        return [NSString stringWithFormat:@"http://sapi.beibei.com/martshow/item/%@-%@-%@--%@-.html", [self.fields objectForKey:@"event_id"], [self.fields objectForKey:@"page"], [self.fields objectForKey:@"page_size"],[self.fields objectForKey:@"sellout"]];
    }
    return [NSString stringWithFormat:@"http://sapi.beibei.com/martshow/item/%@-%@-%@-.html",  [self.fields objectForKey:@"event_id"], [self.fields objectForKey:@"page"], [self.fields objectForKey:@"page_size"]];
}

- (void) setPage:(NSInteger)page
{
    [self.fields setObject:@(page) forKey:@"page"];
}

- (void) setPageSize:(NSInteger)pageSize
{
    [self.fields setObject:@(pageSize) forKey:@"page_size"];
}

- (void)setEventId:(NSInteger)eventId
{
    [self.fields setObject:@(eventId) forKey:@"event_id"];
}

@end
