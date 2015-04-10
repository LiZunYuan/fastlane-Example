//
//  NSDictionary+RNAdditions.m
//  MISpring
//
//  Created by XU YUJIAN on 13-1-17.
//  Copyright (c) 2013年 MiZhe Inc. All rights reserved.
//

#import "NSDictionary+RNAdditions.h"

@implementation NSDictionary (RNAdditions)

-(NSString *)stringForKey:(NSString *)key withDefault:(NSString *)defVal{
    return [[self allKeys] containsObject:key] ? [self objectForKey:key] : defVal;
}

-(CGFloat)floatForKey:(NSString *)key withDefault:(CGFloat)defVal{
    @try {
        return [[self objectForKey:key] floatValue];
    }
    @catch (NSException *exception) {
        return defVal;
    }
}

-(NSTimeInterval)timeIntervalForKey:(NSString *)key withDefault:(NSTimeInterval)defVal{
    @try {
        return [[self objectForKey:key] doubleValue];
    }
    @catch (NSException *exception) {
        return defVal;
    }
}

-(NSInteger)intForKey:(NSString *)key withDefault:(NSInteger)defVal{
    @try {
        return [[self objectForKey:key] intValue];
    }
    @catch (NSException *exception) {
        return defVal;
    }
}

-(long long)longLongForKey:(NSString *)key withDefault:(long long)defVal{
    @try {
        return [[self objectForKey:key] longLongValue];
    }
    @catch (NSException *exception) {
        return defVal;
    }
}

-(long)longForKey:(NSString *)key withDefault:(long)defVal{
    @try {
        return [[self objectForKey:key] longValue];
    }
    @catch (NSException *exception) {
        return defVal;
    }
}

-(int)intValueForKey:(NSString *)key withDefault:(int)defVal{
    @try {
        return [[self objectForKey:key] intValue];
    }
    @catch (NSException *exception) {
        return defVal;
    }
}


- (NSString*)queryString {
	NSMutableString* buffer = [[NSMutableString alloc] initWithCapacity:0];
	for (id key in self) {
		NSString* value = [NSString stringWithFormat:@"%@",[self objectForKey:key]];
		value = [value urlEncode2:NSUTF8StringEncoding];
		[buffer appendString:[NSString stringWithFormat:@"&%@=%@", key, value]];
	}
	NSString* ret = [buffer substringFromIndex:1];
	[buffer release];
	return ret;
}

@end
