//
//  MIUtility.m
//  MISpring
//
//  Created by XU YUJIAN on 13-1-27.
//  Copyright (c) 2013年 Husor Inc.. All rights reserved.
//

#import "MIUtility.h"
#import "XGPush.h"
#import "MizheFramework/HusorEncrypt.h"
#import "MIRegModel.h"
#import <objc/runtime.h>
#import <CommonCrypto/CommonCryptor.h>
//#import <AdSupport/ASIdentifierManager.h>
#import <sys/socket.h>
#import <sys/sysctl.h>
#import <net/if.h>
#import <net/if_dl.h>
#import <AVFoundation/AVFoundation.h>

@implementation MIUtility

+ (BOOL)isExternalURL:(NSURL*)URL {
    if ((URL.host == nil)
        || [URL.host isEqualToString:@"maps.google.com"]
        || [URL.host isEqualToString:@"itunes.apple.com"]
        || [URL.host isEqualToString:@"phobos.apple.com"]) {
        return YES;
    } else {
        return NO;
    }
}
+ (BOOL)isAppURL:(NSURL*)URL {
    return [self isExternalURL:URL]
    || ([[UIApplication sharedApplication] canOpenURL:URL] && ![MIUtility isWebURL:URL]);
}
+ (BOOL)isWebURL:(NSURL*)URL {
    return URL.scheme && ([URL.scheme caseInsensitiveCompare:@"http"] == NSOrderedSame
                          || [URL.scheme caseInsensitiveCompare:@"https"] == NSOrderedSame
                          || [URL.scheme caseInsensitiveCompare:@"ftp"] == NSOrderedSame
                          || [URL.scheme caseInsensitiveCompare:@"ftps"] == NSOrderedSame
                          || [URL.scheme caseInsensitiveCompare:@"data"] == NSOrderedSame
                          || [URL.scheme caseInsensitiveCompare:@"file"] == NSOrderedSame);
}

+ (BOOL)isScannableURLString:(NSString *)str
{
    NSURL *url = [NSURL URLWithString:str];
    if (url == nil) {
        // 去掉参数尝试，防止因为参数不合法(没有urlencode)造成解析URL失败
        NSString *urlStr = str;
        if ([str rangeOfString:@"?"].location != NSNotFound) {
            urlStr = [str substringToIndex:[str rangeOfString:@"?"].location];
        }
        url = [NSURL URLWithString:urlStr];
    }
    
    return [MIUtility isWebURL:url] || [[UIApplication sharedApplication] canOpenURL:url];
}



+ (BOOL) isDeviceIPad
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        return YES;
    }
#endif
    return NO;
}
+ (NSString*)serializeURL:(NSString *)baseUrl
                   params:(NSDictionary *)params
               httpMethod:(NSString *)httpMethod {
    
    NSURL* parsedURL = [NSURL URLWithString:baseUrl];
    NSString* queryPrefix = parsedURL.query ? @"&" : @"?";
    
    NSMutableArray* pairs = [NSMutableArray array];
    for (NSString* key in [params keyEnumerator]) {
        if (([[params valueForKey:key] isKindOfClass:[UIImage class]])
            ||([[params valueForKey:key] isKindOfClass:[NSData class]])) {
            continue;
        }
        
        NSString* escaped_value = ( NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                      NULL, /* allocator */
                                                                                      (CFStringRef)[params objectForKey:key],
                                                                                      NULL, /* charactersToLeaveUnescaped */
                                                                                      (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                      kCFStringEncodingUTF8));
        
        [pairs addObject:[NSString stringWithFormat:@"%@=%@", key, escaped_value]];
    }
    NSString* query = [pairs componentsJoinedByString:@"&"];
    
    return [NSString stringWithFormat:@"%@%@%@", baseUrl, queryPrefix, query];
}

+ (NSString *)getNumiidFromUrl:(NSString*)url
{
    if (url == nil) {
        return nil;
    } else {
        NSString *numiid = nil;
        NSRange range = NSMakeRange(0, [url length]);
        NSArray *regExps = [MIConfig globalConfig].regs;
        for (MIRegModel *regModel in regExps) {
            NSRegularExpression *regExp = [NSRegularExpression regularExpressionWithPattern:regModel.reg options:NSRegularExpressionCaseInsensitive error: nil];
            NSArray *matches = [regExp matchesInString:url options:NSMatchingReportCompletion range:range];
            if (matches && [matches count] > 0) {
                numiid = [url substringWithRange:[matches[0] rangeAtIndex:regModel.group.integerValue]];
                break;
            }
        }
        
        return numiid;
    }
}

+ (NSString *)getParamValueFromUrl:(NSString*)url paramName:(NSString *)paramName
{
    if (![paramName hasSuffix:@"="])
    {
        paramName = [NSString stringWithFormat:@"%@=", paramName];
    }

    NSString * str = nil;
    NSRange start = [url rangeOfString:paramName];
    if (start.location != NSNotFound)
    {
        // confirm that the parameter is not a partial name match
        unichar c = '?';
        if (start.location != 0)
        {
            c = [url characterAtIndex:start.location - 1];
        }
        if (c == '?' || c == '&' || c == '#')
        {
            NSRange end = [[url substringFromIndex:start.location+start.length] rangeOfString:@"&"];
            NSUInteger offset = start.location+start.length;
            str = end.location == NSNotFound ?
            [url substringFromIndex:offset] :
            [url substringWithRange:NSMakeRange(offset, end.location)];
            str = [str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
    }
    return str;
}

+ (NSDictionary*)parseURLParams:(NSString *)query {
	NSArray *pairs = [query componentsSeparatedByString:@"&"];
	NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
	for (NSString *pair in pairs) {
		NSArray *kv = [pair componentsSeparatedByString:@"="];
        if ([kv count] > 1) {
            NSString *val =
            [[kv objectAtIndex:1]
             stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            if (val == nil) {
                val = @"";
            }
            
            [params setObject:val forKey:[kv objectAtIndex:0]];
        }
	}
    return params;
}

+ (void)deleteCookies:(NSArray *)hosts{
    NSHTTPCookieStorage* cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    if (hosts.count != 0) {
        for (NSString* hostURL in hosts) {
            NSArray* urlCookies = [cookies cookiesForURL:[NSURL URLWithString:hostURL]];
            for (NSHTTPCookie* cookie in urlCookies) {
                [cookies deleteCookie:cookie];
            }
        }
    }
}

+ (NSString *)getMacAddress
{
    int                 mgmtInfoBase[6];
    char                *msgBuffer = NULL;
    NSString            *errorFlag = NULL;
    size_t              length;
    
    // Setup the management Information Base (mib)
    mgmtInfoBase[0] = CTL_NET;        // Request network subsystem
    mgmtInfoBase[1] = AF_ROUTE;       // Routing table info
    mgmtInfoBase[2] = 0;
    mgmtInfoBase[3] = AF_LINK;        // Request link layer information
    mgmtInfoBase[4] = NET_RT_IFLIST;  // Request all configured interfaces
    
    // With all configured interfaces requested, get handle index
    if ((mgmtInfoBase[5] = if_nametoindex("en0")) == 0)
        errorFlag = @"if_nametoindex failure";
    // Get the size of the data available (store in len)
    else if (sysctl(mgmtInfoBase, 6, NULL, &length, NULL, 0) < 0)
        errorFlag = @"sysctl mgmtInfoBase failure";
    // Alloc memory based on above call
    else if ((msgBuffer = malloc(length)) == NULL)
        errorFlag = @"buffer allocation failure";
    // Get system information, store in buffer
    else if (sysctl(mgmtInfoBase, 6, msgBuffer, &length, NULL, 0) < 0)
    {
        free(msgBuffer);
        errorFlag = @"sysctl msgBuffer failure";
    }
    else
    {
        // Map msgbuffer to interface message structure
        struct if_msghdr *interfaceMsgStruct = (struct if_msghdr *) msgBuffer;
        
        // Map to link-level socket structure
        struct sockaddr_dl *socketStruct = (struct sockaddr_dl *) (interfaceMsgStruct + 1);
        
        // Copy link layer address data in socket structure to an array
        unsigned char macAddress[6];
        memcpy(&macAddress, socketStruct->sdl_data + socketStruct->sdl_nlen, 6);
        
        // Read from char array into a string object, into traditional Mac address format
        NSString *macAddressString = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                                      macAddress[0], macAddress[1], macAddress[2], macAddress[3], macAddress[4], macAddress[5]];
        
        // Release the buffer memory
        free(msgBuffer);
        
        return macAddressString;
    }
    
    // Error...
    MILog(@"errorFlag=%@", errorFlag);
    return @"";
}

//+ (NSString *)getIdfaString
//{
//    NSBundle *adSupportBundle = [NSBundle bundleWithPath:@"/System/Library/Frameworks/AdSupport.framework"];
//    [adSupportBundle load];
//    if (adSupportBundle == nil) {
//        return @"";
//    } else {
//        Class asIdentifierMClass = NSClassFromString(@"ASIdentifierManager");
//        if(asIdentifierMClass == nil){
//            return @"";
//        } else {
//            //for arc
//            ASIdentifierManager *asIM = [[asIdentifierMClass alloc] init];
//            if (asIM == nil) {
//                return @"";
//            } else {
//                
//                if(asIM.advertisingTrackingEnabled){
//                    return [asIM.advertisingIdentifier UUIDString];
//                } else {
//                    return [asIM.advertisingIdentifier UUIDString];
//                }
//            }
//        }
//    }
//}
//
//+ (NSString *)getIdfvString
//{
//    if([[UIDevice currentDevice] respondsToSelector:@selector(identifierForVendor)]) {
//        return [[UIDevice currentDevice].identifierForVendor UUIDString];
//    }
//    
//    return @"";
//}

/**
 *	@brief	计算sig签名
 *
 *	@param 	query 	上传参数
 *	@param 	opSecretKey 	secretKey:sessionKey存在传入用户secretKey，不存在传入应用secretKey
 *	@param 	valueLenLimit 	截取长度，默认为50
 *
 *	@return	上传参数+sig 字符串
 */
+ (NSString*)queryStringWithSignature:(NSDictionary *)query
                          opSecretKey:(NSString *)opSecretKey
                        valueLenLimit:(NSInteger)valueLenLimit
{
    if (!query) {
        return nil;
    }
    
    if (!opSecretKey) {
        return [NSString queryStringFromQueryDictionary:query withURLEncode:YES];
    }
    
    NSArray * keys = [query allKeys];
    NSArray * sortedKeys = [keys sortedArrayUsingFunction:strCompare context:NULL];
    
    NSMutableString *buffer = [[NSMutableString alloc] initWithString: opSecretKey];
    for (NSString *key in sortedKeys)
    {
        [buffer appendString:[NSString stringWithFormat:@"%@%@", key, [query objectForKey: key]]];
    }
    [buffer appendString:opSecretKey];
    NSString * signature = [[buffer md5] uppercaseString];
        
    // 将查询字典参数拼接成字符串,URL Encode,然后附带上Signature.
    [buffer deleteCharactersInRange:NSMakeRange(0, buffer.length)];
    for (id key in query) {
        NSString* value = [NSString stringWithFormat:@"%@",[query objectForKey:key]];
        value = [value urlEncode2:NSUTF8StringEncoding];
        [buffer appendString:[NSString stringWithFormat:@"&%@=%@", key,value]];
    }
    [buffer appendString:[NSString stringWithFormat:@"&sign=%@", signature]];
    NSString* ret = [buffer substringFromIndex:1]; // 去掉第一个'&'

    return ret;
}

+ (NSString*)getSignWithDictionary:(NSDictionary *)params
{
    return [[HusorEncrypt getInstance] genSignWithDict:params];
}

//+ (NSString*)getSignWithDictionary:(NSDictionary *)params
//                         secretKey:(NSString *)secretKey
//{
//    NSArray * keys = [params allKeys];
//    NSArray * sortedKeys = [keys sortedArrayUsingFunction:strCompare context:NULL];
//    
//    NSMutableString *buffer = [[NSMutableString alloc] initWithString: secretKey];
//    for (NSString *key in sortedKeys)
//    {
//        [buffer appendString:[NSString stringWithFormat:@"%@%@", key, [params objectForKey: key]]];
//    }
//    [buffer appendString:secretKey];
//    NSString * signature = [[buffer md5] uppercaseString];
//    return signature;
//}

+ (id)convertDisctionary2Object:(NSDictionary *) dict
                      className: (NSString *) className {
    
    Class class = NSClassFromString(className);
    id obj = [[class alloc] init];
    
    // 分析类属性和方法签名
    NSMutableDictionary * propDict = [[NSMutableDictionary alloc] init];
    NSString * typePattern = @"T@\"(.+)\"";
    NSString * modelPattern = @"MI(.+)";
    NSError *error = [[NSError alloc] init];
    NSRegularExpression * typeReg = [NSRegularExpression regularExpressionWithPattern:typePattern options:NSRegularExpressionCaseInsensitive error:&error];
    NSRegularExpression * modelReg = [NSRegularExpression regularExpressionWithPattern:modelPattern options:NSRegularExpressionCaseInsensitive error:&error];
    unsigned propertyCount;
    
    //获取对象的全部属性，及set方法特性参数
    objc_property_t *properties = class_copyPropertyList(class,&propertyCount);
    for(NSInteger i=0;i<propertyCount;i++){
        objc_property_t prop = properties[i];
        
        NSString * propName = [NSString stringWithFormat: @"%s", property_getName(prop)];
        NSString * selector = [NSString stringWithFormat:@"%s", property_getAttributes(prop)];
        
        NSArray * matches = [typeReg matchesInString:selector options:NSMatchingReportCompletion range:NSMakeRange(0, [selector length])];
        NSString * propType = [selector substringWithRange:[matches[0] rangeAtIndex:1]];
        
//        NSUInteger count =[modelReg numberOfMatchesInString:propType options:NSRegularExpressionCaseInsensitive range:NSMakeRange(0, [propType length])];
//        if (count > 0) {
//            [propDict setObject:propType forKey:propName];
//        }
        [propDict setObject:propType forKey:[NSString stringWithFormat:@"%@%@", [[propName substringToIndex:1] uppercaseString], [propName substringFromIndex:1]]];
    }
    free(properties);

    NSArray * array = [dict allKeys];
    NSEnumerator *enumlator = [array objectEnumerator];
    NSString *string;
    while (string = [enumlator nextObject])
    {
        NSString *propName;
        propName = [string stringByReplacingOccurrencesOfString:@"_" withString:@"."];
        propName = [[propName capitalizedString] stringByReplacingOccurrencesOfString:@"." withString:@""];
        
        NSString *setMethod = [NSString stringWithFormat:@"set%@:", propName];

        if ([obj respondsToSelector:NSSelectorFromString(setMethod)])
        {
            id value = [dict objectForKey:string];

            if ([value isKindOfClass:[NSArray class]]) {
                if ([value count] > 0 && [value[0] isKindOfClass: [NSDictionary class]]) {
                    // 拼装模型
                    NSString * innerModelName = [NSString stringWithFormat:@"MI%@Model", [propName substringToIndex: [propName length] - 1]];
                    Class innerClass = NSClassFromString(innerModelName);
                    NSMutableArray * _value = [[NSMutableArray alloc] initWithCapacity: [value count]];
                    if (innerClass != nil) {
                        for (NSDictionary* tmpDict in value) {
                            [_value addObject: [self convertDisctionary2Object:tmpDict className:innerModelName]];
                        }
                        value = _value;
                    }
                }
            } else {
                NSString * propType = [propDict valueForKey: propName];
                if (propType != nil) {
                    if ([value isKindOfClass:[NSDictionary class]]) {
                        NSUInteger count =[modelReg numberOfMatchesInString:propType options:NSRegularExpressionCaseInsensitive range:NSMakeRange(0, [propType length])];
                        if (count > 0) {
                            if (![value isEqual:[NSNull null]]) {
                                value = [self convertDisctionary2Object:value className:propType];
                            }
                        }
                    } else if ([propType isEqualToString:@"NSNumber"]) {
                        if (![value isEqual:[NSNull null]]) {
                            value = [NSNumber numberWithDouble: [value doubleValue]];
                        }
                        else
                        {
                            value = [NSNumber numberWithInt:0];
                        }
                    } else if ([propType isEqualToString:@"NSString"]) {
                        if ([value isKindOfClass:[NSNumber class]]) {
                            value = [value stringValue];
                        }
                    } else if ([propType isEqualToString:@"NSArray"]) {
                        value = nil;
                    }
                }
            }
            
            [obj performSelector:NSSelectorFromString(setMethod) withObject:value];
        }
    }
    
    return obj;

}

+ (NSString *) encryptUseDES:(NSString *)clearText
{
    return [[HusorEncrypt getInstance] desEncrypt:clearText];
}

+ (NSString*) decryptUseDES:(NSString*)cipherText
{
    return [[HusorEncrypt getInstance] desDecrypt:cipherText];
}

//DES加密
//+ (NSString *) encryptUseDES:(NSString *)clearText key:(NSString *)key
//{
//    NSData *data = [clearText dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
//    size_t bufferPtrSize = ([clearText length] + kCCKeySizeDES) & ~(kCCKeySizeDES -1);
//    unsigned char buffer[bufferPtrSize];
//    memset(buffer, 0, sizeof(char));
//    size_t numBytesEncrypted = 0;
//
//    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
//                                          kCCAlgorithmDES,
//                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
//                                          [key UTF8String],
//                                          kCCKeySizeDES,
//                                          nil,
//                                          [data bytes],
//                                          [data length],
//                                          buffer,
//                                          bufferPtrSize,
//                                          &numBytesEncrypted);
//
//    NSString* plainText = nil;
//    if (cryptStatus == kCCSuccess) {
//        NSData *dataTemp = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
//        plainText = [GTMBase64 stringByEncodingData:dataTemp];
//    }else{
//        MILog(@"DES加密失败");
//    }
//    return plainText;
//}

//DES解密
//+ (NSString*) decryptUseDES:(NSString*)cipherText key:(NSString*)key {
//     //利用 GTMBase64 解碼 Base64 字串
//    NSData* cipherData = [GTMBase64 decodeString:cipherText];
//    size_t bufferPtrSize = ([cipherText length] + kCCKeySizeDES) & ~(kCCKeySizeDES -1);
//    unsigned char buffer[bufferPtrSize];
//    memset(buffer, 0, sizeof(char));
//    size_t numBytesDecrypted = 0;
//
//    // IV 偏移量不需使用
//    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
//                                          kCCAlgorithmDES,
//                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
//                                          [key UTF8String],
//                                          kCCKeySizeDES,
//                                          nil,
//                                          [cipherData bytes],
//                                          [cipherData length],
//                                          buffer,
//                                          bufferPtrSize,
//                                          &numBytesDecrypted);
//    NSString* plainText = nil;
//    if (cryptStatus == kCCSuccess) {
//        NSData* data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesDecrypted];
//        plainText = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    }
//    return plainText;
//}

+ (NSString *)numDeRounding:(float)number afterPoint:(NSInteger)position {
    number = number + pow(0.1, position + 1);
    
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    
    NSDecimalNumber *ouncesDecimal;
    NSDecimalNumber *roundedOunces;
    
    ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat: number];    
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    
    return [NSString stringWithFormat:@"%@",roundedOunces];
}

+ (UIColor *) colorWithHex:(NSInteger)hex {
    return [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0
                           green:((float)((hex & 0xFF00) >> 8))/255.0
                            blue:((float)(hex & 0xFF))/255.0 alpha:1.0];
}

+ (UIColor *) colorWithHex:(NSInteger)hex alpha:(CGFloat)alpha{
    return [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0
                           green:((float)((hex & 0xFF00) >> 8))/255.0
                            blue:((float)(hex & 0xFF))/255.0 alpha:alpha];
}

+ (BOOL)isJhsRebate:(NSURLRequest *)request
{
    BOOL rebate = YES;
    NSString *url = request.URL.absoluteString;
    NSString *host = request.URL.host;
    if ([url rangeOfString:@"tg_key=jhs" options:NSCaseInsensitiveSearch].location != NSNotFound) {
        rebate = NO;
    } else if ([url rangeOfString:@"tracelog=jubuyitnow" options:NSCaseInsensitiveSearch].location != NSNotFound) {
        rebate = NO;
    } else if ([host isEqualToString:@"detail.ju.taobao.com"]) {
        rebate = NO;
    } else {
        NSDictionary *headers = [request allHTTPHeaderFields];
        if ([headers objectForKey:@"Referer"] != nil) {
            NSString * referer = [headers objectForKey:@"Referer"];
            if ([referer hasPrefix: @"http://jhs.m.taobao.com"]) {
                rebate = NO;
            }
        }
    }
    
    return rebate;
}

+ (BOOL)isTbkSclickUrl:(NSString*)url
{
    return [url rangeOfString:[MIConfig globalConfig].mmPid options:NSCaseInsensitiveSearch].location != NSNotFound
    || [url rangeOfString:[MIConfig globalConfig].saPid options:NSCaseInsensitiveSearch].location != NSNotFound
    || [url rangeOfString:[MIConfig globalConfig].searchPid options:NSCaseInsensitiveSearch].location != NSNotFound;
}

+ (BOOL)validatorEmail:(NSString *)email
{
    BOOL success = NO;
    
    NSError *error = NULL;
    NSString *regexString = @"^[+\\w\\.\\-']+@[a-zA-Z0-9-]+(\\.[a-zA-Z0-9-]+)*(\\.[a-zA-Z]{2,})+$";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexString options:NSRegularExpressionCaseInsensitive error: &error];
    if(!error && regex)
    {
        NSUInteger numberOfMatches = [regex numberOfMatchesInString:email options:0 range:NSMakeRange(0, email.length)];
        success = (numberOfMatches == 1);
    }
    
    return success;
}

+ (BOOL)validatorNumeric:(NSString *)number
{
    BOOL success = NO;
    
    NSError *error = NULL;
    NSString *regexString = @"^\\d+$";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexString options:NSRegularExpressionCaseInsensitive error: &error];
    if(!error && regex)
    {
        NSUInteger numberOfMatches = [regex numberOfMatchesInString:number options:0 range:NSMakeRange(0, number.length)];
        success = (numberOfMatches == 1);
    }
    
    return success;
}

+ (BOOL)validatorRange:(NSRange)range text:(NSString *)text
{
    BOOL success = NO;
    
    NSInteger length = text.length;
    if(length >= range.location && length <= range.length)
    {
        success = YES;
    }
    
    return success;
}

+ (void)clickEventWithLog:(NSString *)log cid:(NSString *)cid s:(NSString *)s
{
    NSString *uidBase64;
    NSTimeInterval a = [[NSDate date] timeIntervalSince1970];
    NSString * ts = [NSString stringWithFormat:@"%.0f", a*1000];
    NSString * outerCode = [[MIMainUser getInstance].userId stringValue];
    if (outerCode == nil || outerCode.length == 0) {
        uidBase64 = @"0";
    } else {
        uidBase64 = [[outerCode dataUsingEncoding:NSUTF8StringEncoding] base64EncodedString];
        uidBase64 = [uidBase64 stringByReplacingOccurrencesOfString:@"+" withString:@"-"];
        uidBase64 = [uidBase64 stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
        if ([uidBase64 hasSuffix:@"="]) {
            uidBase64 = [uidBase64 substringToIndex:(uidBase64.length - 1)];
        }
    }
    
    NSString *urlString = [NSString stringWithFormat:@"tracelog/click.html?au=%@&log=%@&id=%@&f=3&s=%@&_t=%@", uidBase64, log, cid, s, ts];
    MKNetworkEngine *catsEngine = [[MKNetworkEngine alloc] initWithHostName: @"click.husor.cn" customHeaderFields:nil];
    MKNetworkOperation *op = [catsEngine operationWithPath: urlString];
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        MILog(@"success");
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        MILog(@"error");
    }];
    [catsEngine enqueueOperation:op];
}

+ (NSString *)trustLoginWithUrl:(NSString *)baseUrl
{
    NSTimeInterval a = [[NSDate date] timeIntervalSince1970];
    NSString * ts = [NSString stringWithFormat:@"%.0f", a];
    
    NSString *url;
    if ([baseUrl rangeOfString: @"?"].length == 0) {
        url = [NSString stringWithFormat:@"%@?ts=%@", baseUrl, ts];
    } else {
        url = [NSString stringWithFormat:@"%@&ts=%@", baseUrl, ts];
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   [MIMainUser getInstance].sessionKey, @"session",
                                   ts, @"ts",
                                   url, @"t",
                                   @"iPhone", @"os",
                                   [MIConfig globalConfig].version, @"version",
                                   [MIConfig getUDID], @"udid", nil];
//    NSString *sign = [NSString stringWithFormat:@"%@%@%@%@%@", ts, [MIMainUser getInstance].sessionKey, [MIOpenUDID value], url, ts];
    NSString *sign = [MIUtility getSignWithDictionary:params];
    [params setObject:sign forKey:@"sign"];
    return [MIUtility serializeURL:[MIConfig globalConfig].trustLoginURL params:params httpMethod:@"GET"];
}

+(BOOL)isBeibeiAppExist
{
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"beibeiapp://"]];
}

+ (void)handleBeibeiUrl:(NSURL *)beibeiURL
{
    if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"beibeiapp://"]]) {
        if ([[Reachability reachabilityForInternetConnection] isReachableViaWiFi]) {
            MIButtonItem *cancelItem = [MIButtonItem itemWithLabel:@"跳过"];
            cancelItem.action = ^{
                [MINavigator openTbWebViewControllerWithURL:beibeiURL desc:@"贝贝特卖"];
            };
            
            MIButtonItem *affirmItem = [MIButtonItem itemWithLabel:@"好"];
            affirmItem.action = ^{
                [MobClick event:@"kAppAdClicks"];
                NSString *itunes = @"https://itunes.apple.com/app/id%@?mt=8";
                NSString *beibei = [NSString stringWithFormat:itunes, [MIConfig globalConfig].beibeiAppID];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:beibei]];
            };
            
            [[[UIAlertView alloc] initWithTitle:@"米姑娘提示"
                                       message:[MIConfig globalConfig].beibeiAppSlogan
                              cancelButtonItem:cancelItem
                              otherButtonItems:affirmItem, nil] show];
        } else {
            [MINavigator openTbWebViewControllerWithURL:beibeiURL desc:@"贝贝特卖"];
        }
    } else {
        NSString *baseUrl = beibeiURL.absoluteString;
        NSRange range = [baseUrl rangeOfString:@"?"];
        if (range.location != NSNotFound) {
            baseUrl = [baseUrl substringToIndex:range.location];
        }
        
        NSInteger i;
        NSArray *matches;
        NSArray *regExps = [NSArray arrayWithObjects:@"www\\.beibei\\.com\\/martshow\\/([0-9]+)\\.html",
                            @"www\\.beibei\\.com\\/detail\\/([0-9]+)\\.html", nil];
        for (i = 0; i < regExps.count; i++) {
            NSString *regExpString = [regExps objectAtIndex:i];
            NSRegularExpression *regExp = [NSRegularExpression regularExpressionWithPattern:regExpString options:NSRegularExpressionCaseInsensitive error: nil];
            matches = [regExp matchesInString:baseUrl options:NSMatchingReportCompletion range:NSMakeRange(0, baseUrl.length)];
            if (matches && [matches count] > 0) {
                break;
            }
        }
        
        if (i == 0) {
            NSString *scheme;
            NSString *mid = [baseUrl substringWithRange:[matches[0] rangeAtIndex:1]];
            NSString *iid = beibeiURL.fragment;
            if (iid) {
                scheme = [NSString stringWithFormat:@"beibeiapp://action?target=martshow&mid=%@&iid=%@", mid,iid];
            } else {
                scheme = [NSString stringWithFormat:@"beibeiapp://action?target=martshow&mid=%@", mid];
            }
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:scheme]];
        } else if (i == 1) {
            NSString *scheme;
            NSString *iid = [baseUrl substringWithRange:[matches[0] rangeAtIndex:1]];
            NSString *sid = beibeiURL.fragment;
            if (sid) {
                scheme = [NSString stringWithFormat:@"beibeiapp://action?target=detail&iid=%@&%@", iid, sid];
            } else {
                scheme = [NSString stringWithFormat:@"beibeiapp://action?target=detail&iid=%@", iid];
            }
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:scheme]];
        } else if ([baseUrl isEqualToString:@"http://www.beibei.com"] || [baseUrl isEqualToString:@"http://www.beibei.com/"]
                   || [baseUrl isEqualToString:@"www.beibei.com"] || [baseUrl isEqualToString:@"www.beibei.com/"]) {
            NSString *scheme = @"beibeiapp://action?";
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:scheme]];
        } else {
            NSString *scheme = [NSString stringWithFormat:@"beibeiapp://action?target=webview&url=%@", [baseUrl urlEncode:NSUTF8StringEncoding]];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:scheme]];
        }
    }
}

+ (void)setLocalNotificationWithType:(NSInteger)type alertBody:(NSString *)alertBody at:(NSTimeInterval)gmtBegin
{
    NSTimeInterval nowInterval = [[NSDate date] timeIntervalSince1970] + [MIConfig globalConfig].timeOffset;
    if (gmtBegin > nowInterval)
    {
        NSTimeInterval leftInterval = gmtBegin - nowInterval;
        [self setLocalNotificationWithType:type alertBody:alertBody after:leftInterval];
    }
}

+ (void)setLocalNotificationWithType:(NSInteger)type alertBody:(NSString *)alertBody after:(NSInteger)interval
{
    if ([MIUtility isNotificationEnable])
    {
        [MIUtility delLocalNotificationByType:type];
        
        //获得系统日期
        NSDate* remindTime = [NSDate dateWithTimeIntervalSinceNow:interval];
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        notification.fireDate= remindTime;
        notification.repeatInterval = 0;
        notification.timeZone = [NSTimeZone defaultTimeZone];
        notification.userInfo = @{@"type":@(type)};
        notification.alertBody = alertBody;
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    } else {
        NSNumber *remindTime = [[NSUserDefaults standardUserDefaults] objectForKey:@"kLocalNotificationReminderTime"];
        NSNumber *now = @([[NSDate date] timeIntervalSince1970]);
        if (remindTime && [remindTime isSameDay:now]) {
            // 选择不再提醒，则一天只提醒一次
            return;
        }
        
        MIButtonItem *cancelItem = [MIButtonItem itemWithLabel:@"不再提醒"];
        cancelItem.action = ^{
            //标记时间(当日内不再提醒)
            [[NSUserDefaults standardUserDefaults] setObject:now forKey:@"kLocalNotificationReminderTime"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        };
        MIButtonItem *affirmItem = [MIButtonItem itemWithLabel:@"知道了"];
        affirmItem.action = ^{
        };
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提醒"
                                                            message:@"你的米折无法接收开抢消息提醒，请在手机的“设置->通知中心->米折“中开启"
                                                   cancelButtonItem:cancelItem
                                                   otherButtonItems:affirmItem, nil];
        [alertView show];
    }
}

+ (void)delLocalNotificationByType:(NSInteger) typeValue
{
    if (![MIUtility isNotificationEnable]) {
        return;
    }
    
    NSArray *localNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    if (localNotifications.count > 0) {
        for (int i = 0; i < localNotifications.count; ++i) {
            UILocalNotification *notification = [localNotifications objectAtIndex:i];
            NSNumber *type = [notification.userInfo objectForKey:@"type"];
            if (type.integerValue == typeValue) {
                [[UIApplication sharedApplication] cancelLocalNotification:notification];
            }
        }
    }
}


+ (void)hideTaobaoSmartAd:(UIWebView *)webView
{
    NSString *scriptFormat = @"var child=document.getElementById(\"%@\");child.parentNode.removeChild(child);";
    NSString *script = [NSString stringWithFormat:scriptFormat, [MIConfig globalConfig].taobaoAd];
    [NSObject cancelPreviousPerformRequestsWithTarget:webView
                                             selector:@selector(stringByEvaluatingJavaScriptFromString:)
                                               object:script];
    [webView performSelector:@selector(stringByEvaluatingJavaScriptFromString:) withObject:script afterDelay:0.5];
}

+ (void)hideTmallSmartAd:(UIWebView *)webView
{
    NSString *scriptFormat = @"var child=document.getElementById(\"%@\");child.parentNode.removeChild(child);";
    NSString *script = [NSString stringWithFormat:scriptFormat, [MIConfig globalConfig].tmallAd];
    [NSObject cancelPreviousPerformRequestsWithTarget:webView
                                             selector:@selector(stringByEvaluatingJavaScriptFromString:)
                                               object:script];
    [webView performSelector:@selector(stringByEvaluatingJavaScriptFromString:) withObject:script afterDelay:0.5];
}

+ (NSInteger)getRandomNumber:(NSInteger)from to:(NSInteger)to
{
    return (NSInteger)(from + (arc4random() % (to - from + 1)));
}

+ (NSInteger)calcIntervalWithEndTime:(NSInteger)endTime andNowTime:(NSInteger)nowTime
{
    NSDate* today = [NSDate dateWithTimeIntervalSinceNow:[MIConfig globalConfig].timeOffset];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"H"];
    
    NSInteger interval;
    NSString *todayStr = [formatter stringFromDate:today];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *todayTenStr = [formatter stringFromDate:today];
    NSString *todayTenClock = [NSString stringWithFormat:@"%@ 10:00:00", todayTenStr];
    formatter.dateFormat  = @"yyyy-MM-dd HH:mm:ss";
    NSDate *todayTenDate = [formatter dateFromString:todayTenClock];
    if (todayStr.intValue < 9) {
        interval = [todayTenDate timeIntervalSince1970] - nowTime;
    } else {
        NSDate *tomorrowTenDate = [NSDate dateWithTimeInterval:24*60*60 sinceDate:todayTenDate];
        interval = [tomorrowTenDate timeIntervalSince1970] - nowTime;
    }
    
    if (endTime < interval) {
        interval = endTime;
    }
    
    return interval;
}

+ (void)checkForEmail:(NSString *)mail message:(NSString *)msg
{
    if (!mail || !mail.length) {
        return;
    }
    
    MIButtonItem *cancelItem = [MIButtonItem itemWithLabel:@"取消"];
    cancelItem.action = nil;
    
    MIButtonItem *affirmItem = [MIButtonItem itemWithLabel:@"去查收"];
    affirmItem.action = ^{
        NSInteger index = 0;
        if ([mail rangeOfString:@"@"].location != NSNotFound && mail.length >= 2) {
            index = [mail rangeOfString:@"@"].location + 1;
        }
        
        NSString *mailHost = [mail substringFromIndex:index];
        if ([mailHost rangeOfString:@"mail"].location != NSNotFound) {
            NSString *mailUrl = [NSString stringWithFormat:@"http://%@", mailHost];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:mailUrl]];
        } else {
            NSString *mailUrl = [NSString stringWithFormat:@"http://mail.%@", mailHost];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:mailUrl]];
        }
    };
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:msg cancelButtonItem:cancelItem otherButtonItems:affirmItem, nil];
    [alertView show];
}

+ (BOOL)isNotificationEnable
{
    UIApplication *application = [UIApplication sharedApplication];
    if (IOS_VERSION >= 8.0) {
        return [application currentUserNotificationSettings].types != UIUserNotificationTypeNone;
    } else {
        return [application enabledRemoteNotificationTypes] != UIRemoteNotificationTypeNone;
    }
}

+ (BOOL)isNotificationTypeBadgeEnable
{
    UIApplication *application = [UIApplication sharedApplication];
    if (IOS_VERSION >= 8.0) {
        return [application currentUserNotificationSettings].types & UIUserNotificationTypeBadge;
    } else {
        return [application enabledRemoteNotificationTypes] & UIRemoteNotificationTypeBadge;
    }
}

+ (void)setApplicationIconBadgeNumber:(NSInteger)number {
    if ([MIUtility isNotificationTypeBadgeEnable]) {
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:number];
    }
}

+ (void)setMuyingTag:(NSString *)tag key:(NSString *)key;
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger clicks = [userDefaults integerForKey:kMuyingItemClicksCount];
    if (key && [key hasPrefix:tag] && clicks < 6) {
        if (clicks == 5) {
            [XGPush setTag:tag successCallback:^{
                [userDefaults setInteger:6 forKey:kMuyingItemClicksCount];
            } errorCallback:^{
                
            }];
        } else {
            [userDefaults setInteger:++clicks forKey:kMuyingItemClicksCount];
        }
    }
}

+ (void)setPushTag:(NSString *)tag;
{
    [XGPush delTag:[NSString stringWithFormat:tag, @"1-4"]];
    [XGPush delTag:[NSString stringWithFormat:tag, @"5-10"]];
    [XGPush delTag:[NSString stringWithFormat:tag, @"11-20"]];
    [XGPush delTag:[NSString stringWithFormat:tag, @"21-30"]];
    [XGPush delTag:[NSString stringWithFormat:tag, @"31-50"]];
    [XGPush delTag:[NSString stringWithFormat:tag, @"50+"]];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger clicks = [userDefaults integerForKey:kPushCount];
    NSString *count = @"1";
    if (clicks >= 0 && clicks < 5) {
        count = @"1-4";
    } else if (clicks < 11) {
        count = @"5-10";
    } else if(clicks < 21){
        count = @"11-20";
    } else if(clicks < 31){
        count = @"21-30";
    } else if(clicks < 51){
        count = @"31-50";
    } else {
        count = @"50+";
    }
    [userDefaults setInteger:++clicks forKey:kMuyingItemClicksCount];
    [XGPush setTag:[NSString stringWithFormat:tag, count]];
}

+ (BOOL)isCameraEnable
{
    // ios7以后摄像头有权限控制
    if (IOS_VERSION >= 7.0) {
        return [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo] == AVAuthorizationStatusAuthorized
        || [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo] == AVAuthorizationStatusNotDetermined;
    }
    
    // ios7以前都会授权
    return YES;
}



/**
 * object c 本地dictionary 转化为object
 * 设置全部属性
 */
+ (id)nativeConvertDictionary2Object:(NSDictionary *)dict className:(NSString *)className
{
    if (dict == nil || dict.allKeys.count == 0) {
        return nil;
    }
    
    Class class = NSClassFromString(className);
    id obj = [[class alloc] init];
    
    //获取对象的全部属性，及set方法特性参数
    unsigned propertyCount;
    objc_property_t *properties = class_copyPropertyList(class,&propertyCount);
    for(NSInteger i=0;i<propertyCount;i++){
        objc_property_t prop = properties[i];
        
        NSString * propName = [NSString stringWithFormat: @"%s", property_getName(prop)];
        id value = [dict objectForKey:propName];
        [obj setValue:value forKey:propName];
    }
    free(properties);
    
    return obj;
}

/**
 * object c 本地dictionary 转化为object
 * 仅仅设置dict中有的属性
 */
+ (id)nativeConvertDictionary:(NSDictionary *)dict toObject:(id) obj
{
    if (dict == nil || dict.allKeys.count == 0) {
        obj = nil;
        return obj;
    }
    
    for (NSString *key in [dict keyEnumerator]) {
        id value = [dict objectForKey:key];
        [obj setValue:value forKey:key];
    }
    
    return obj;
}

+ (void)checkForEmail:(NSString *)mail message:(NSString *)msg label:(NSString *)action
{
    if (!mail || !mail.length) {
        return;
    }
    
    MIButtonItem *cancelItem = [MIButtonItem itemWithLabel:@"取消"];
    cancelItem.action = nil;
    
    MIButtonItem *affirmItem = [MIButtonItem itemWithLabel:action];
    affirmItem.action = ^{
        NSInteger index = 0;
        if ([mail rangeOfString:@"@"].location != NSNotFound && mail.length >= 2) {
            index = [mail rangeOfString:@"@"].location + 1;
        }
        
        NSString *mailHost = [mail substringFromIndex:index];
        if ([mailHost rangeOfString:@"mail"].location != NSNotFound) {
            NSString *mailUrl = [NSString stringWithFormat:@"http://%@", mailHost];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:mailUrl]];
        } else {
            NSString *mailUrl = [NSString stringWithFormat:@"http://mail.%@", mailHost];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:mailUrl]];
        }
    };
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:msg cancelButtonItem:cancelItem otherButtonItems:affirmItem, nil];
    [alertView show];
}

@end
