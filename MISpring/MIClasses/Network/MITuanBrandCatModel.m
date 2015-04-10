//
//  MITuanBrandCatModel.m
//  MISpring
//
//  Created by 曲俊囡 on 13-12-6.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MITuanBrandCatModel.h"

@implementation MITuanBrandCatModel
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
