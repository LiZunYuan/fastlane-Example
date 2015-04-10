//
//  MIZhiCatModel.m
//  MISpring
//
//  Created by 徐 裕健 on 13-10-23.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIZhiCatModel.h"

@implementation MIZhiCatModel
@synthesize catKey = _catKey;
@synthesize catName = _catName;

#pragma mark NSCoding methods
///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        self.catKey = [decoder decodeObjectForKey:@"catKey"];
        self.catName = [decoder decodeObjectForKey:@"catName"];
    }
    return self;
}
///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)encodeWithCoder:(NSCoder*)encoder {
    [encoder encodeObject:self.catKey forKey:@"catKey"];
    [encoder encodeObject:self.catName forKey:@"catName"];
}
@end
