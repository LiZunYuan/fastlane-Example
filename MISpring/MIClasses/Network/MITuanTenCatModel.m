//
//  MITuanTenCatModel.m
//  MiZheHD
//
//  Created by haozi on 13-8-5.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MITuanTenCatModel.h"

@implementation MITuanTenCatModel
@synthesize catId = _catId;
@synthesize catName = _catName;

#pragma mark NSCoding methods
///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        self.catId = [decoder decodeObjectForKey:@"catId"];
        self.catName = [decoder decodeObjectForKey:@"catName"];
    }
    return self;
}
///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)encodeWithCoder:(NSCoder*)encoder {
    [encoder encodeObject:self.catId forKey:@"catId"];
    [encoder encodeObject:self.catName forKey:@"catName"];
}
@end
