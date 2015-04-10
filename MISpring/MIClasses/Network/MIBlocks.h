//
//  MIBlocks_h.h
//  MISpring
//
//  Created by XU YUJIAN on 13-1-29.
//  Copyright (c) 2013年 Husor Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIError.h"

typedef void (^onProgressBlock)(double progress);
typedef void (^onCompletionBlock)(id result);
typedef void (^onErrorBlock) (MKNetworkOperation* completedOperation, MIError* error);
