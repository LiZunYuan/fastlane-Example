//
//  MIHeartbeat.m
//  MISpring
//
//  Created by Yujian Xu on 13-3-11.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIHeartbeat.h"

#define MIAPP_HEART_BEAT_INTERVAL 10*60

@implementation MIHeartbeat
@synthesize heartBeatNewsMessage = _heartBeatNewsMessage;
@synthesize activateTimer = _activateTimer;

static MIHeartbeat *_heartbeat = nil;

+(MIHeartbeat *)shareHeartbeat {
    @synchronized(self){
        if (nil == _heartbeat) {
            _heartbeat = [[MIHeartbeat alloc] init];
            return _heartbeat;
        }
    }
    return _heartbeat;
}

- (id)init {
    self = [super init];
    if (self != nil) {

    }
    return self;
}

+ (id) allocWithZone:(NSZone*) zone
{
	@synchronized(self) {
		if (_heartbeat == nil) {
			_heartbeat = [super allocWithZone:zone];  // assignment and return on first allocation
			return _heartbeat;
		}
	}
	return nil;
}

- (id) copyWithZone:(NSZone*) zone
{
	return _heartbeat;
}

-(void)dealloc {
    [self.activateTimer invalidate];
    self.activateTimer = nil;
}

- (void)startActivate {
    if (self.activateTimer != nil){
        [self.activateTimer invalidate];
        self.activateTimer = nil;
    }
    self.activateTimer = [NSTimer scheduledTimerWithTimeInterval: MIAPP_HEART_BEAT_INTERVAL
                                                     target: self
                                                   selector: @selector(pushNewMsgGet)
                                                   userInfo: nil
                                                    repeats: YES];
    [self.activateTimer fire];
}

- (void)stopActivate {
    [_pushBadgeGetRequest cancelRequest];
    _pushBadgeGetRequest = nil;

    if ([self.activateTimer isValid]) {
        [self.activateTimer invalidate];
        self.activateTimer = nil;
    }

    self.heartBeatNewsMessage.count = [NSNumber numberWithInteger:0];
    self.heartBeatNewsMessage.tbOrders = [NSNumber numberWithInteger:0];
    self.heartBeatNewsMessage.mallOrders = [NSNumber numberWithInteger:0];
    self.heartBeatNewsMessage.pays = [NSNumber numberWithInteger:0];
    self.heartBeatNewsMessage.msgs = [NSNumber numberWithInteger:0];
    if ([MIUtility isNotificationTypeBadgeEnable]) {
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:MiNotificationNewsMessageDidUpdate object:self.heartBeatNewsMessage userInfo:nil];
}

- (void)pushNewMsgGet {

    [_pushBadgeGetRequest cancelRequest];
    _pushBadgeGetRequest = nil;

    //必须是链接了网络且用户已登录才会轮询
    if([[Reachability reachabilityForInternetConnection] isReachable] && [[MIMainUser getInstance] checkLoginInfo]){
        _pushBadgeGetRequest = [[MIPushBadgeGetRequest alloc] init];

        __weak typeof(self) weakSelf = self;
        _pushBadgeGetRequest.onCompletion = ^(MIPushBadgeGetModel * model) {
            
            weakSelf.heartBeatNewsMessage = model;
            if (model.count.integerValue > 0) {
                if ([MIUtility isNotificationTypeBadgeEnable]) {
                    [UIApplication sharedApplication].applicationIconBadgeNumber = model.count.integerValue;
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:MiNotificationNewsMessageDidUpdate object:model userInfo:nil];
            }

            if (![[MIMainUser getInstance] checkLoginInfo] && [weakSelf.activateTimer isValid]) {
                [weakSelf.activateTimer invalidate];
                weakSelf.activateTimer = nil;
            }
        };
        _pushBadgeGetRequest.onError = ^(MKNetworkOperation* completedOperation, MIError* error) {
            if (![[MIMainUser getInstance] checkLoginInfo] && [weakSelf.activateTimer isValid]) {
                [weakSelf.activateTimer invalidate];
                weakSelf.activateTimer = nil;
            }
        };
        
        [_pushBadgeGetRequest sendQuery];
        MILog(@"TIMER:keepActiveNewMsg");
    }
}

-(BOOL)hasNewOrderMessage{
    return  (self.heartBeatNewsMessage.tbOrders.integerValue + self.heartBeatNewsMessage.pays.integerValue) != 0;
}

-(BOOL)hasNewMessage{
    return  (self.heartBeatNewsMessage.msgs.integerValue != 0);
}
@end