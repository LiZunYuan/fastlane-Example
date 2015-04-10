//
//  MISinaWeiboConstants.h
//  MISpring
//
//  Created by Yujian Xu on 13-6-18.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#ifndef MISpring_MISinaWeiboConstants_h
#define MISpring_MISinaWeiboConstants_h

#define kSinaAppKey             @"3247146470"
#define kSinaAppSecret          @"93848132ef362db03a8bc652d788ac66"
#define kSinaAppRedirectURI     @"http://www.mizhe.com"

#define SinaWeiboSdkVersion                @"2.0"

#define kSinaWeiboSDKErrorDomain           @"SinaWeiboSDKErrorDomain"
#define kSinaWeiboSDKErrorCodeKey          @"SinaWeiboSDKErrorCodeKey"

#define kSinaWeiboSDKOAuth2APIDomain       @"https://open.weibo.cn/2/oauth2/"
#define kSinaWeiboWebAuthURL               @"https://open.weibo.cn/2/oauth2/authorize"
#define kSinaWeiboWebAccessTokenURL        @"open.weibo.cn/2/oauth2/access_token"
#define kSinaWeiboSDKAPIDomain             @"open.weibo.cn/2"

#define kSinaWeiboAppAuthURL_iPhone        @"sinaweibosso://login"
#define kSinaWeiboAppAuthURL_iPad          @"sinaweibohdsso://login"

typedef enum
{
	kSinaWeiboSDKErrorCodeParseError       = 200,
	kSinaWeiboSDKErrorCodeSSOParamsError   = 202,
} SinaWeiboSDKErrorCode;


#endif
