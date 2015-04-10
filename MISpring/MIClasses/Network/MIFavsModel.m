//
//  MIFavsModel.m
//  MiZheHD
//
//  Created by 徐 裕健 on 13-8-3.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIFavsModel.h"

@implementation MIFavsModel
@synthesize iid;
@synthesize name;
@synthesize domain;
@synthesize deletable;
@synthesize commission;
@synthesize commissionType;
@synthesize type;
@synthesize mallType;
@synthesize logo;

#pragma mark NSCoding methods
///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        self.iid = [decoder decodeObjectForKey:@"iid"];
        self.name = [decoder decodeObjectForKey:@"name"];
        self.domain= [decoder decodeObjectForKey:@"domain"];
        self.deletable = [decoder decodeObjectForKey:@"deletable"];
        self.commission = [decoder decodeObjectForKey:@"commission"];
        self.commissionType = [decoder decodeObjectForKey:@"commissionType"];
        self.commissionMode = [decoder decodeObjectForKey:@"commissionMode"];
        self.type = [decoder decodeObjectForKey:@"type"];
        self.mallType = [decoder decodeObjectForKey:@"mallType"];
        self.logo = [decoder decodeObjectForKey:@"logo"];
    }
    return self;
}
///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)encodeWithCoder:(NSCoder*)encoder {
    [encoder encodeObject:self.iid forKey:@"iid"];
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.domain forKey:@"domain"];
    [encoder encodeObject:self.deletable forKey:@"deletable"];
    [encoder encodeObject:self.commission forKey:@"commission"];
    [encoder encodeObject:self.commissionType forKey:@"commissionType"];
    [encoder encodeObject:self.commissionMode forKey:@"commissionMode"];
    [encoder encodeObject:self.type forKey:@"type"];
    [encoder encodeObject:self.mallType forKey:@"mallType"];
    [encoder encodeObject:self.logo forKey:@"logo"];
}


@end
