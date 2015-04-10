//
//  UserMessage.h
//  InsetDemo
//
//  Created by emaryjf on 13-1-25.
//  Copyright (c) 2013年 emaryjf. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface YJFUserMessage : NSObject


@property (nonatomic,copy) NSString *yjfUserAppId;
@property (nonatomic,copy) NSString *yjfChannel;
@property (nonatomic,copy) NSString *yjfUserDevId;
@property (nonatomic,copy) NSString *yjfAppKey;
@property (nonatomic,copy) NSString *yjfCoop_info;

@property (nonatomic,copy) NSString *yjfSid;

+ (YJFUserMessage *)shareInstance;

@end
