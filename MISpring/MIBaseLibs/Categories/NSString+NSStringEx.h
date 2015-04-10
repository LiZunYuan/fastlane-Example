//
//  NSString+NSStringEx.h
//  MISpring
//
//  Created by XU YUJIAN on 13-1-17.
//  Copyright (c) 2013年 Husor Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <CommonCrypto/CommonDigest.h>
#import <CoreText/CoreText.h>
#import <UIKit/UIKit.h>

NSInteger strCompare(id str1, id str2, void *context);

@interface NSString(NSStringEx)

/**
 *SSO　SecretKey　AES加密
 *
 *＠param　key　密钥
 */
- (NSString *)AES128EncryptWithKey:(NSString *)key;

/**
 *SSO　SecretKey　AES解密
 *
 *＠param　key　密钥
 */
- (NSString *)AES128DecryptWithKey:(NSString *)key;

- (NSNumber*) stringToNumber;

/**
 * 将字符串以URL编码.但'=', '&'字符除外.
 * 
 * @param stringEncoding 编码类型
 * @return 编码后的字符串
 */
- (NSString*) urlEncode:(NSStringEncoding)stringEncoding;
/*
 * 解码
 */
- (NSString*) urlDecode:(NSStringEncoding)stringEncoding;
/**
 * 将字符串以URL编码.
 * 
 * @param stringEncoding 编码类型
 * @return 编码后的字符串
 */
- (NSString*) urlEncode2:(NSStringEncoding)stringEncoding;
- (NSString*) urlEncoder;
- (NSString *)stringByReplaceString:(NSString *)rs withCharacter:(char)c;

/**
 * 将字符串MD5加密.
 * 
 * @return 加密后的字符串.
 */
- (NSString*) md5;

/**
 * 给查询字符串添加Signature.
 * 
 * 暂时给map模块用的,TODO
 * @return 添加Signature后的字符串.
 */
- (NSString*) queryAppendSignatureForMap;

+ (NSString*)componentsJoinedByDictionary:(NSDictionary *)dic
								seperator:(NSString *)seperator;

/**
 * 给查询字符串添加Signature.
 * 
 * @return 添加Signature后的字符串.
 */
- (NSString*) queryAppendSignature:(NSString *)opSecretKey;

/**
 * 通过查询信息字典生成查询字符串,并附带Signature.字符串经过URL Encode.
 * 
 * @param query 查询参数字典。
 * @param opSecretKey SecretKey。
 * 
 * @return 添加Signature并URL Encode后的字符串.
 */
+ (NSString*) queryStringWithSignature:(NSDictionary*)query
                           opSecretKey:(NSString *)opSecretKey;
/**
 * 通过查询信息字典生成查询字符串,并附带Signature.字符串经过URL Encode。
 * 本方法主要正对3G手机开放平台，因为该平台计算sig时值只取前50个字符。
 * 
 * @param query 查询参数字典。
 * @param opSecretKey SecretKey。
 * @param valueLenLimit 计算Signature是时参数值的长度限制。
 *
 * @return 添加Signature并URL Encode后的字符串.
 */
+ (NSString*) queryStringWithSignature:(NSDictionary*)query
                           opSecretKey:(NSString *)opSecretKey 
						 valueLenLimit:(NSInteger)valueLenLimit;

+ (NSString*)signature:(NSDictionary*)query opSecretKey:(NSString *)opSecretKey valueLenLimit:(NSInteger)valueLenLimit;

/**
 * 通过查询信息字典生成查询字符串, 可配置字符串经过URL Encode.
 * 
 * @return URL Encode后的字符串.
 */
+ (NSString *)queryStringFromQueryDictionary:(NSDictionary *)query withURLEncode:(BOOL)doURLEncode;

/**
 * 生成查询标识符,目前用于唯一标识一个缓存地址.
 * 
 * @return 查询标识符字符串.
 */
- (NSString*) queryIdentifier;

// 根据人人网新鲜事日期的格式将字符串解析为NSDate
// 格式形如: 06-17 15:07
- (NSDate*) dateFromFeedFormat;

// 根据人人网状态日期的格式将字符串解析为NSDate
// 格式形如: 2009-06-17 15:07:49
- (NSDate*) dateFromStatusFormat;

// 根据人人网相册日期的格式将字符串解析为NSDate
// 格式形如: 2009-06-17
- (NSDate*) dateFromAlbumFormat;

/**
 * 将格式为:yyyyMMddHHmmss
 */ 
- (NSDate*)dateFromStringyyyyMMddHHmmss;

// Trim whitespace
- (NSString *)trim;
- (NSString *) stringTrimAsNewsfeed;
- (NSString *) getParameter:(NSString *)parameterName;

/**
 * 对发送的一些字符做转义处理.
 */
//- (NSString*)escapeForPost;

//- (NSString*) des3:(NSString*)key encrypt:(BOOL)isEncrypt;


/**
 * 预处理为实体应用,例如把 & 替换成 &amp;
 */
+ (NSString *) preParseER:(NSString*)string;

/**
 * 预处理为实体应用,例如把 其中 & 替换成 空;
 */
+ (NSString *) preParseERNotAt:(NSString*)string;

/**
 * 将预处理的文字转化回来为,例如把 &amp;替换成 &  
 */
+ (NSString *) afterParseER:(NSString*)string;

/**
 * 对来自rest接口的状态进行过滤
 */
- (NSString*)stringByFilterForStatusFromRest;

/**
 * 去掉字符中间的空格,只保留一个.
 */
- (NSString*)stringByTrimmingWhitespace;

/**
 * 给解码Aes编码
 * 
 */
- (NSString*) stringByDecodeAes;
/**
 * 简化用户名或邮箱名的字符串
 * 例如qu***@126.com
 */
- (NSString *)getSimpleEmailString;
/**
 * 字符串中包含的字数，
 * 汉子占一个字，英文或标点占用半个字
 */
- (NSInteger)CountWord;
- (NSString *)priceValue;

- (BOOL)isPureInt;
- (BOOL)isEmpty;

@end



