//
//  MIZhiTagModel.m
//  MIZheZhi
//
//  Created by 曲俊囡 on 14-2-17.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MIZhiTagModel.h"

@implementation MIZhiTagModel

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        self.tagKey = [decoder decodeObjectForKey:@"tagKey"];
        self.tagName = [decoder decodeObjectForKey:@"tagName"];
    }
    return self;
}
///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)encodeWithCoder:(NSCoder*)encoder {
    [encoder encodeObject:self.tagKey forKey:@"tagKey"];
    [encoder encodeObject:self.tagName forKey:@"tagName"];
}

@end
