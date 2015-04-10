//
//  MIMainUser.h
//  MISpring
//
//  Created by XU YUJIAN on 13-1-27.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSInteger
{
    MILoginStatusNotLogined  = 0,             //表示未登录
    MILoginStatusNormalLogin = 1,             //表示已经通过输入用户名密码登录
    MILoginStatusThirdAccountLogin = 2,       //表示已经通过第三方合作账号登录
}MILoginStatus;

@class MIUserGetModel;

@interface MIMainUser : NSObject<NSCoding>
{
    //表示用户的唯一ID
    NSNumber *_userId;
    
    // 登录时填写的登录帐号。
	NSString* _loginAccount;
    
    // 经过des加密的password。
	NSString* _DESPassword;
    
    // session key。
	NSString* _sessionKey;
	
	// 表示当前登录用户的状态。
    MILoginStatus _loginStatus;

    // 用户昵称
    NSString *_nickName;

    // 用户头像
    NSString *_headURL;

    // 用户支付宝账号
    NSString *_alipay;

    // 用户手机号码
    NSString *_phoneNum;

    // 用户返利收入，单位为分
    NSNumber *_incomeSum;

    // 用户消费金额，单位为分
    NSNumber *_expensesSum;

    // 用户米币数
    NSNumber *_coin;

    // 用户等级
    NSNumber *_grade;
    
    // 用户标签
    NSNumber *_userTag;
}

/**
 * 表示当前登录用户的状态。
 */
@property (nonatomic, assign) MILoginStatus loginStatus;

/**
 * 表示登录用户的唯一ID。
 */
@property (nonatomic, copy) NSNumber* userId;

/**
 * 表示登录时填写的登录帐号。
 */
@property (nonatomic, copy) NSString* loginAccount;

/*
 * 经过DES加密的password
 */
@property (nonatomic, copy) NSString* DESPassword;

/**
 * 表示session key。登录成功后获得。
 */
@property (nonatomic, copy) NSString* sessionKey;

@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *headURL;
@property (nonatomic, copy) NSString *alipay;
@property (nonatomic, copy) NSString *phoneNum;
@property (nonatomic, copy) NSNumber *incomeSum;
@property (nonatomic, copy) NSNumber *expensesSum;
@property (nonatomic, copy) NSNumber *coin;
@property (nonatomic, copy) NSNumber *grade;
@property (nonatomic, copy) NSNumber *userTag;


#pragma mark Public

/**
 * 创建一个Main User对象.
 * 首先从持久化层.初始化,如果没有的话,那么直接生成新的对象.
 */
+ (MIMainUser*)getInstance;

/**
 *	@brief	持久化存储用户信息
 *
 *	@param 	userInfo 	用户信息
 */
- (void)saveUserInfo:(MIUserGetModel *)userInfo;

/**
 * 持久化存档。
 */
- (void)persist;

/**
 * 登出动作，仅修改了MainUser的状态和数值。
 */
- (void)logout;

/**
 * 清空MainUser对象数据。一般在切换登录用户时，或者登出时使用。
 */
- (void) clear;

/*
 * 是否包含了登录信息，若包含可进行自动登录
 */
- (BOOL) checkLoginInfo;

// 一些相关目录

// App Document 路径
+ (NSString *)documentPath;

// 公共文件夹路径
+ (NSString *)commonPath;


@end
