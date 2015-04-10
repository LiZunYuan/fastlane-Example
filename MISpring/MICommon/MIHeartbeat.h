//
//  MIHeartbeat.h
//  MISpring
//
//  Created by Yujian Xu on 13-3-11.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIPushBadgeGetRequest.h"
#import "MIPushBadgeGetModel.h"

@interface MIHeartbeat : NSObject
{
    NSTimer* _activateTimer;
    MIPushBadgeGetRequest* _pushBadgeGetRequest;
}

@property (nonatomic ,strong) MIPushBadgeGetModel* heartBeatNewsMessage;
@property (nonatomic ,strong) NSTimer* activateTimer;

+ (MIHeartbeat *)shareHeartbeat;
- (void)startActivate;
- (void)stopActivate;

- (void)pushNewMsgGet;

/*
 *判断此次心跳消息数，有任何新消息返回:YES，无任何新消息返回:NO;
 */
-(BOOL)hasNewOrderMessage;
-(BOOL)hasNewMessage;

@end
