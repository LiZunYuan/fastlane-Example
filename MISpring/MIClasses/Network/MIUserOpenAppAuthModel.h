//
//  MIUserOpenAppAuthModel.h
//  MISpring
//
//  Created by yujian on 14-7-16.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MIBaseRequest.h"

@interface MIUserOpenAppAuthModel : MIBaseRequest

@property (nonatomic, strong) NSNumber *success;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *session;

@end
