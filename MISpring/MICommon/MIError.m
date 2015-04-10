//
//  MIError.m
//  MISpring
//
//  Created by XU YUJIAN on 13-1-22.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIError.h"
#import "MIAppDelegate.h"

@implementation MIError

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (MIError*)errorWithRestInfo:(NSDictionary*)restInfo {
	NSNumber* errorCode = [restInfo objectForKey:@"err_code"];
	MILog(@"errorCode=%d,err_msg=%@", [errorCode intValue], [restInfo objectForKey:@"err_msg"]);
	MIError* error = [MIError errorWithDomain:MIZHEERROR_DOMAIN code:[errorCode intValue] userInfo:restInfo];
	return error;
}	

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (MIError*)errorWithNSError:(NSError*)error {
    
	MIError* myError = [MIError errorWithDomain:error.domain code:error.code userInfo:error.userInfo];
	MILog(@"code=%d", myError.code);
	return myError;
}
///////////////////////////////////////////////////////////////////////////////////////////////////
+ (MIError*)errorWithCode:(NSInteger)code errorMessage:(NSString*)errorMessage {
	NSMutableDictionary* userInfo = [[NSMutableDictionary alloc] initWithCapacity:2];
	[userInfo setObject:[NSString stringWithFormat:@"%ld", (long)code] forKey:@"error_code"];
    if (errorMessage) {
        [userInfo setObject:errorMessage forKey:@"error_msg"];
    }
	
	MIError* error = [MIError errorWithDomain:MIZHEERROR_DOMAIN code:code userInfo:userInfo];
	return error;
	
}
///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithDomain:(NSString *)domain code:(NSInteger)code userInfo:(NSDictionary *)dict {
	MILog(@"domain=%@,code=%d,userInfo=%@", domain, code, dict);
	if (self = [super initWithDomain:domain code:code userInfo:dict]) {
        
	}
	return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)methodForRestApi {
	NSDictionary* userInfo = self.userInfo;
	if (!userInfo) {
		return nil;
	}
	
	NSArray* requestArgs = [userInfo objectForKey:@"request_args"];
	if (!requestArgs) {
		return nil;
	}
	
	for (NSDictionary* pair in requestArgs) {
		if (NSOrderedSame == [@"method" compare:[pair objectForKey:@"key"]]) {
			return [pair objectForKey:@"value"];
		}
	}
	
	return nil;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)titleForError {
	NSString* title = [self.userInfo objectForKey:@"error_msg"];
    if (self.code == -1009) {
        title = @"网络未连接，请检查再试";
    } else {
        title = title ? title : @"网络服务错误，请稍后再试";
    }
	return title;
}

/*
 * 弹出错误title的HUD
 */
- (void)showHUD{
//    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    MIAppDelegate* delegate = (MIAppDelegate*)[UIApplication sharedApplication].delegate;
    UIWindow* window = delegate.window;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = [self titleForError];
    hud.margin = 10.f;
    hud.yOffset = -80.0f;
    hud.removeFromSuperViewOnHide = YES;
    
    [hud hide:YES afterDelay:1.5];
}

/**
 *	@brief	需要强制用户退出，重新登录的错误
 *
 *	@param 	errCode 2为session失效，100为用户不存在或禁用
 *
 *	@return	YES 为需要退出
 */
+ (BOOL)isNeedLoginAgainError:(NSInteger)errCode{
    return errCode == 2
    || errCode == 100;
}

@end
