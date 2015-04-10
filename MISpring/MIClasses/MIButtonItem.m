//
//  MIButtonItem.m
//  Shibui
//
//  Created by Jiva DeVoe on 1/12/11.
//  Copyright 2011 Random Ideas, LLC. All rights reserved.
//

#import "MIButtonItem.h"

@implementation MIButtonItem
@synthesize label;
@synthesize action;

+(id)item
{
    return [[self alloc] init];
}

+(id)itemWithLabel:(NSString *)inLabel
{
    MIButtonItem *newItem = [self item];
    [newItem setLabel:inLabel];
    return newItem;
}

@end

