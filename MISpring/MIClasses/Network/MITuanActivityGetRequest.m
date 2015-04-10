//
//  MITuanActivityGetRequest.m
//  MISpring
//
//  Created by 曲俊囡 on 15/3/27.
//  Copyright (c) 2015年 Husor Inc. All rights reserved.
//

#import "MITuanActivityGetRequest.h"

@implementation MITuanActivityGetRequest

- (void)setCat:(NSString *)cat
{
    [self.fields setObject:cat forKey:@"cat"];
}

- (NSString *) getMethod
{
    return @"mizhe.tuan.activity.get";
}

- (NSString *) getType
{
    return @"static";
}

- (NSString *) getStaticURL
{
    return [NSString stringWithFormat:@"%@/tuan/activity/%@-%@-%@.html", [MIConfig globalConfig].staticApiURL, [self.fields objectForKey:@"cat"], [self.fields objectForKey:@"page"], [self.fields objectForKey:@"page_size"]];
}

@end
