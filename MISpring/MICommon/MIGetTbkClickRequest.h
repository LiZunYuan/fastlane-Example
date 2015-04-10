//
//  MIGetTbkClickRequest.h
//  MISpring
//
//  Created by 徐 裕健 on 14-6-1.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MITbkMobileItemsConvertRequest.h"

@interface MIGetTbkClickRequest : MIBaseRequest

@property(nonatomic, strong) MITbkMobileItemsConvertRequest *tbkItemsConvertRequest;
@property(nonatomic, strong) NSString *tag;
@property(nonatomic, strong) NSString *numiid;

@property (nonatomic, copy) void(^onCompletionHandler)(NSString *tbkUrl);
@property (nonatomic, copy) void(^onErrorHandler)();

- (id)initWithTag:(NSString *)tag numiid:(NSString *)iid;
//- (void)sendQuery;
//- (void)cancelRequest;

@end
