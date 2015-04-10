//
//  MIAppConfigRequest.m
//  MISpring
//
//  Created by 徐 裕健 on 13-12-6.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIAppConfigRequest.h"

@implementation MIAppConfigRequest

- (NSString *) getMethod {
    return @"mizhe.app.config";
}

- (NSString *) getType
{
    return @"static";
}

- (NSString *) getStaticURL
{
    return [NSString stringWithFormat:@"%@/resource/app_config-iPhone-%@.html", [MIConfig globalConfig].staticApiURL, [MIConfig globalConfig].version];
}

@end
