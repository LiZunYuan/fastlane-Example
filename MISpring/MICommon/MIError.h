//
//  MIError.h
//  MISpring
//
//  Created by XU YUJIAN on 13-1-22.
//  Copyright (c) 2013年 Husor Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MIZHEERROR_DOMAIN @"MiZhe"

@interface MIError : NSError {
}

/**
 * 返回用于展现给用户的错误提示标题
 */
- (NSString*)titleForError;

/**
 * 返回由Rest接口错误信息构建的错误对象.
 */
+ (MIError*)errorWithRestInfo:(NSDictionary*)restInfo;


/**
 * 返回由NSError构建的错误对象.
 */
+ (MIError*)errorWithNSError:(NSError*)error;

/**
 * 构造RRError错误。
 *
 * @param code 错误代码
 * @param errorMessage 错误信息
 *
 * 返回错误对象.
 */
+ (MIError*)errorWithCode:(NSInteger)code errorMessage:(NSString*)errorMessage;

/**
 * 返回调用Rest Api 的 method字段的值.
 */
- (NSString*)methodForRestApi;

/*
 * 弹出错误title的HUD
 */
- (void)showHUD;
+ (BOOL)isNeedLoginAgainError:(NSInteger)errCode;
@end
