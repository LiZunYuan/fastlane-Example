//
//  NSObject+RNAdditions.m
//  MISpring
//
//  Created by XU YUJIAN on 13-1-17.
//  Copyright (c) 2013年 MiZhe Inc. All rights reserved.
//

#import "NSObject+RNAdditions.h"

@implementation NSObject (RNAdditions)

+ (BOOL)isEmptyContainer:(NSObject *)o{
	if (o==nil) {
		return YES;
	}
	if (o==NULL) {
		return YES;
	}
	if (o==[NSNull null]) {
		return YES;
	}
    if ([o isKindOfClass:[NSDictionary class]]) {
		return [((NSDictionary *)o) count]<=0;			
	}
	if ([o isKindOfClass:[NSArray class]]) {
		return [((NSArray *)o) count]<=0;			
	}
    if ([o isKindOfClass:[NSSet class]]) {
		return [((NSSet *)o) count]<=0;			
	}
	return NO;
}

@end
