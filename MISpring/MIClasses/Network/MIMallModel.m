//
//  MIMallModel.m
//  MISpring
//
//  Created by lsave on 13-3-18.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIMallModel.h"

@implementation MIMallModel

@synthesize mallId = _mallId;
@synthesize name = _name;
@synthesize seoName = _seoName;
@synthesize pinyin = _pinyin;
@synthesize mode = _mode;
@synthesize summary = _summary;
@synthesize cate = _cate;
@synthesize commission = _commission;
@synthesize mobileCommission = _mobileCommission;
@synthesize commissionType = _commissionType;
@synthesize type = _type;
@synthesize pos = _pos;
@synthesize logo = _logo;
@synthesize gmtModified = _gmtModified;

#pragma mark NSCoding methods
///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        self.mallId = [decoder decodeObjectForKey:@"mallId"];
        self.name = [decoder decodeObjectForKey:@"name"];
        self.seoName= [decoder decodeObjectForKey:@"seoName"];
        self.pinyin = [decoder decodeObjectForKey:@"pinyin"];
        self.mode = [decoder decodeObjectForKey:@"mode"];
        self.summary = [decoder decodeObjectForKey:@"summary"];
        self.cate = [decoder decodeObjectForKey:@"cate"];
        self.commission = [decoder decodeObjectForKey:@"commission"];
        self.mobileCommission = [decoder decodeObjectForKey:@"mobileCommission"];
        self.commissionType = [decoder decodeObjectForKey:@"commissionType"];
        self.type = [decoder decodeObjectForKey:@"type"];
        self.pos = [decoder decodeObjectForKey:@"pos"];
        self.logo = [decoder decodeObjectForKey:@"logo"];
        self.gmtModified = [decoder decodeObjectForKey:@"gmtModified"];
    }
    return self;
}
///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)encodeWithCoder:(NSCoder*)encoder {
    [encoder encodeObject:self.mallId forKey:@"mallId"];
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.seoName forKey:@"seoName"];
    [encoder encodeObject:self.pinyin forKey:@"pinyin"];
    [encoder encodeObject:self.mode forKey:@"mode"];
    [encoder encodeObject:self.summary forKey:@"summary"];
    [encoder encodeObject:self.cate forKey:@"cate"];
    [encoder encodeObject:self.commission forKey:@"commission"];
    [encoder encodeObject:self.mobileCommission forKey:@"mobileCommission"];
    [encoder encodeObject:self.commissionType forKey:@"commissionType"];
    [encoder encodeObject:self.type forKey:@"type"];
    [encoder encodeObject:self.pos forKey:@"pos"];
    [encoder encodeObject:self.logo forKey:@"logo"];
    [encoder encodeObject:self.gmtModified forKey:@"gmtModified"];
}

@end
