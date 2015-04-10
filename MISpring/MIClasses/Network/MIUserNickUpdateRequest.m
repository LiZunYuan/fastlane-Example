//
//  MIUserNickUpdateRequest.m
//  MISpring
//
//  Created by 曲俊囡 on 13-12-19.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIUserNickUpdateRequest.h"

@implementation MIUserNickUpdateRequest

- (void)setNick:(NSString *)nick
{
    [self.fields setObject:nick forKey:@"nick"];
}
- (NSString *) getMethod {
    return @"mizhe.user.nick.update";
}

@end
