//
//  MIRegisterRequest.m
//  MISpring
//
//  Created by Yujian Xu on 13-3-25.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIRegisterRequest.h"

@implementation MIRegisterRequest

- (id)init {
    self = [super init];

    return self;
}

- (void) setUserNameAndPassWord: (NSString *) userNameAndPassWord
{
    [self.fields setObject:userNameAndPassWord forKey:@"passport"];
}

- (void) setChannelId: (NSString *)channelId
{
    [self.fields setObject:channelId forKey:@"bd"];
}

- (NSString *) getMethod {
    return @"mizhe.user.register";
}

@end
