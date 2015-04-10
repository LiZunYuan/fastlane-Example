//
//  MIUserAvatarUpdateModel.h
//  MISpring
//
//  Created by 曲俊囡 on 13-12-16.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MIUserAvatarUpdateModel : NSObject

@property (nonatomic, strong) NSNumber *success;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSString *data;

@end
