//
//  MIMallStaff.h
//  MISpring
//
//  Created by Mac Chow on 13-4-11.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIMallModel.h"

@interface MIMallBO : NSObject

+ (MIMallBO *) getInstance;

@property (nonatomic, assign) dispatch_queue_t ioQueue;

- (void) getMallsWithForceReload:(BOOL)reload WithMobileOnly:(BOOL)mobileOnly WithAtLeast:(NSUInteger)atleast callback:(void (^)(NSArray * malls)) cb;
- (void) getMallById: (NSUInteger) mallId withForceReload:(BOOL)reload callback:(void (^)(MIMallModel *mall)) cb;
- (void) getMallsWithMobileOnly:(BOOL)mobileOnly AtLeast:(NSUInteger)atleast callback:(void (^)(NSArray * malls)) cb;

@end
