//
//  MIPushTokenUpdateModel.h
//  MISpring
//
//  Created by lsave on 13-4-15.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIBaseRequest.h"

@interface MIPushTokenUpdateModel : NSObject

@property (nonatomic, strong) NSString *data;
@property (nonatomic, strong) NSNumber *success;
@property (nonatomic, strong) NSString *message;

@end
