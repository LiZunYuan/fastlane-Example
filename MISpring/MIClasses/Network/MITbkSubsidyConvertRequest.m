//
//  MITbkSubsidyConvertRequest.m
//  MISpring
//
//  Created by lsave on 13-3-29.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MITbkSubsidyConvertRequest.h"

@implementation MITbkSubsidyConvertRequest

- (void) setNumIid: (NSString *) numIid
{
    [self.fields setObject:numIid forKey:@"num_iid"];
}

- (NSString *) getMethod {
    return @"mizhe.tbk.subsidy.convert";
}

@end
