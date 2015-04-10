//
//  MIVipModel.m
//  MISpring
//
//  Created by 曲俊囡 on 13-11-20.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIVipModel.h"

@implementation MIVipModel

@synthesize grade = _grade;
@synthesize extraRate = _extraRate;
@synthesize doubleCoin = _doubleCoin;
@synthesize halfCoupon = _halfCoupon;
@synthesize inviteSum = _inviteSum;
@synthesize incomeSum = _incomeSum;

#pragma mark NSCoding methods
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self != nil)
    {
        self.grade = [aDecoder decodeObjectForKey:@"grade"];
        self.extraRate = [aDecoder decodeObjectForKey:@"extraRate"];
        self.doubleCoin = [aDecoder decodeObjectForKey:@"doubleCoin"];
        self.halfCoupon = [aDecoder decodeObjectForKey:@"halfCoupon"];
        self.inviteSum = [aDecoder decodeObjectForKey:@"inviteSum"];
        self.incomeSum = [aDecoder decodeObjectForKey:@"incomeSum"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder*)encoder
{
    [encoder encodeObject:self.grade forKey:@"grade"];
    [encoder encodeObject:self.extraRate forKey:@"extraRate"];
    [encoder encodeObject:self.doubleCoin forKey:@"doubleCoin"];
    [encoder encodeObject:self.halfCoupon forKey:@"halfCoupon"];
    [encoder encodeObject:self.inviteSum forKey:@"inviteSum"];
    [encoder encodeObject:self.incomeSum forKey:@"incomeSum"];
}

@end
