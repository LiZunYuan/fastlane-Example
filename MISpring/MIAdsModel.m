//
//  MIAdsModel.m
//  MISpring
//
//  Created by husor on 14-11-12.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MIAdsModel.h"
#import "MIAdService.h"

@implementation MIAdsModel

- (NSDictionary *)toJsonObject
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    NSArray *adKeys = [MIAdService sharedManager].adKeys;
    for (NSString *key in adKeys) {
        id value = [self valueForKey:key];
        if (value != nil) {
            [dict setObject:value forKey:key];
        }
    }
    if (self.latestConfigTime != nil) {
        [dict setObject:self.latestConfigTime forKey:@"latestConfigTime"];
    }

    return dict;
}


@end
