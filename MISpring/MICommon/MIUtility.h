//
//  MIUtility.h
//  MISpring
//
//  Created by XU YUJIAN on 13-1-27.
//  Copyright (c) 2013年 Husor Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MIUtility : NSObject

+ (BOOL)isExternalURL:(NSURL*)URL;
+ (BOOL)isAppURL:(NSURL*)URL;
+ (BOOL)isWebURL:(NSURL*)URL;
+ (BOOL) isDeviceIPad;
+ (BOOL)isBeibeiAppExist;
+ (NSString*)serializeURL:(NSString *)baseUrl
                   params:(NSDictionary *)params
               httpMethod:(NSString *)httpMethod;
+ (NSString *)getParamValueFromUrl:(NSString*)url paramName:(NSString *)paramName;
+ (NSString *)getNumiidFromUrl:(NSString*)url;
+ (NSDictionary*)parseURLParams:(NSString *)query;
+ (void)deleteCookies:(NSArray *)hosts;
+ (NSString *)getMacAddress;
//+ (NSString *)getIdfaString;
//+ (NSString *)getIdfvString;
+ (NSString*)queryStringWithSignature:(NSDictionary *)query
                          opSecretKey:(NSString *)opSecretKey
                        valueLenLimit:(NSInteger)valueLenLimit;
+ (NSString*)getSignWithDictionary:(NSDictionary *)params;
//+ (NSString*)getSignWithDictionary:(NSDictionary *)params
//                         secretKey:(NSString *)secretKey;
+ (id)convertDisctionary2Object:(NSDictionary *) dict
                      className: (NSString *) className;

+ (NSString *) encryptUseDES:(NSString *)clearText;
+ (NSString *) decryptUseDES:(NSString *)cipherText;
//+ (NSString *) encryptUseDES:(NSString *)clearText key:(NSString *)key;
//+ (NSString *) decryptUseDES:(NSString *)cipherText key:(NSString*)key;

+ (NSString *)numDeRounding:(float)number afterPoint:(NSInteger)position;
+ (UIColor *) colorWithHex:(NSInteger)hex;
+ (UIColor *) colorWithHex:(NSInteger)hex alpha:(CGFloat)alpha;
+ (BOOL)isJhsRebate:(NSURLRequest*)request;
+ (BOOL)isTbkSclickUrl:(NSString*)url;
+ (BOOL)validatorEmail:(NSString *)email;
+ (BOOL)validatorNumeric:(NSString *)number;
+ (BOOL)validatorRange:(NSRange)range text:(NSString *)text;
+ (void)clickEventWithLog:(NSString *)log cid:(NSString *)cid s:(NSString *)s;
+ (NSString *)trustLoginWithUrl:(NSString *)baseUrl;
+ (void)handleBeibeiUrl:(NSURL *)beibeiURL;
+ (void)hideTaobaoSmartAd:(UIWebView *)webView;
+ (void)hideTmallSmartAd:(UIWebView *)webView;
+ (NSInteger)getRandomNumber:(NSInteger)from to:(NSInteger)to;
+ (void)checkForEmail:(NSString *)mail message:(NSString *)msg;
+ (NSInteger)calcIntervalWithEndTime:(NSInteger)endTime andNowTime:(NSInteger)nowTime;
+ (BOOL)isNotificationEnable;
+ (BOOL)isNotificationTypeBadgeEnable;
+ (void)setApplicationIconBadgeNumber:(NSInteger)number;
+ (void)setMuyingTag:(NSString *)tag key:(NSString *)key;
+ (void)setPushTag:(NSString *)tag;
+ (BOOL)isScannableURLString:(NSString *)str;
/**
 * object c 本地dictionary 转化为object
 * 注意，dictionary的属性必须和object的属性名完全一致！
 */
+ (id)nativeConvertDictionary2Object:(NSDictionary *)dict className:(NSString *)className;
+ (id)nativeConvertDictionary:(NSDictionary *)dict toObject:(id) obj;
+ (BOOL)isCameraEnable;
+ (void)setLocalNotificationWithType:(NSInteger)type alertBody:(NSString *)alertBody at:(NSTimeInterval)gmtBegin;
+ (void)delLocalNotificationByType:(NSInteger) typeValue;

+ (void)checkForEmail:(NSString *)mail message:(NSString *)msg label:(NSString *)action;

@end
