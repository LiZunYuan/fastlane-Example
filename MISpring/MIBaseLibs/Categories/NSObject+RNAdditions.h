//
//  NSObject+RNAdditions.h
//  MISpring
//
//  Created by XU YUJIAN on 13-1-17.
//  Copyright (c) 2013年 MiZhe Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (RNAdditions)

/*
 NSDictionary
 NSArray
 NSSet
 is nil OR zero element
 */
+ (BOOL)isEmptyContainer:(NSObject *)o;

@end
