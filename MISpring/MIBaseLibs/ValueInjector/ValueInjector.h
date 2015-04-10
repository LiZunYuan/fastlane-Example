/*
  ValueInjector   1.0.7

  Created by Kelp on 12/5/6.
  Copyright (c) 2012 Kelp http://kelp.phate.org/
  MIT License

*/

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#define ValueInjectorTimeFormate @"yyyy/MM/dd HH:mm"

#pragma mark - ValueInjectorUtility
@interface ValueInjectorUtility : NSObject
+ (id)sharedInstance;
#if __has_feature(objc_arc)
@property (strong) NSDateFormatter *dateFormatter;
#else
@property (retain) NSDateFormatter *dateFormatter;
#endif
@end

@interface NSObject (ValueInjector)
- (id)injectFromObject:(NSObject *)object;
- (id)injectFromObject:(NSObject *)object arrayClass:(Class)cls;
- (id)injectCoreFromObject:(NSObject *)object arrayClass:(Class)cls;
- (id)injectFromdotNetDictionary:(NSArray *)object;
@end

@interface NSDictionary (ValueInjector)
- (id)initWithObject:(NSObject *)object;
@end