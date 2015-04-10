//
//  NSKeyedUnarchiver+ExceptionCatch.m
//  MISpring
//
//  Created by XU YUJIAN on 13-1-17.
//  Copyright (c) 2013年 MiZhe Inc. All rights reserved.
//

#import "NSKeyedUnarchiver+ExceptionCatch.h"
#import <objc/runtime.h>


@implementation NSKeyedUnarchiver (CatchExceptions)


+ (id)unarchiveObjectWithData:(NSData*)data
                  exception_p:(NSException**)exception_p {
    id object = nil ;
    
    
    @try {
        // Note: Since methods were swapped, this is invoking the original method
        object = [NSKeyedUnarchiver unarchiveObjectWithData:data] ;
    }
    @catch (NSException* exception) {
        if (exception_p) {
            *exception_p = exception ;
        }
    }
    @finally{
    }
    
    return object ;
}

+ (id)unarchiveObjectWithFile:(NSString *)path
                  exception_p:(NSException**)exception_p {
    id object = nil ;
    
    
    @try {
        // Note: Since methods were swapped, this is invoking the original method
        object = [NSKeyedUnarchiver unarchiveObjectWithFile:path] ;
    }
    @catch (NSException* exception) {
        if (exception_p) {
            *exception_p = exception ;
        }
    }
    @finally{
    }
    
    return object ;
}

@end