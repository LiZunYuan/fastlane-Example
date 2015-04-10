//
//  MIUserAvatarUpdateRequest.m
//  MISpring
//
//  Created by 曲俊囡 on 13-12-16.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIUserAvatarUpdateRequest.h"

@implementation MIUserAvatarUpdateRequest

- (void)setAvatarUrl:(NSString *)avatarUrl
{
    [self.fields setObject:avatarUrl forKey:@"avatar_url"];
}
- (NSString *) getMethod {
    return @"mizhe.user.avatar.update";
}
@end
