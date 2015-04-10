//
//  MIConfig.h
//  MISpring
//
//  Created by XU YUJIAN on 13-1-27.
//  Copyright (c) 2013年 Husor Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIConfigModel.h"

FOUNDATION_EXTERN NSString *const kQQAppKey;
FOUNDATION_EXTERN NSString *const kTencentAppID;
FOUNDATION_EXTERN NSString *const kWeixinAppKey;
FOUNDATION_EXTERN NSString *const kUmengAppKey;
FOUNDATION_EXTERN NSString *const kPid;
FOUNDATION_EXTERN NSString *const kTopAppKey;
FOUNDATION_EXTERN NSString *const kTopAppSecretKey;
FOUNDATION_EXTERN NSString *const kTtid;

@interface MIConfig : NSObject  {
    // API 地址（服务分配）
    NSString *_apiURL;
    // 静态API 地址（服务分配）
    NSString *_staticApiURL;
    // DES Key（服务分配）
    NSString *_desKey;
    // App Secret Key（服务分配）
    NSString *_appSecretKey;
    // 客户端版本
    NSString *_version;
    //帮助中心
    NSString *_helpURL;
    //特别声明
    NSString *_specialNoticeURL;
    //米折注册协议
    NSString *_agreementURL;
    //忘记密码
    NSString *_forgetPasswordURL;
    //常见问题
    NSString *_faqURL;
    //APPStore URL
    NSString *_appStoreURL;
    //APPStore 评分URL
    NSString *_appStoreReviewURL;
    //查看支付宝账号URL
    NSString *_findAlipayAccountURL;
    //设备信息
    NSMutableDictionary *_clientInfo;
    //应用相关配置信息
    MIConfigModel *_configInfo;
    // go.mizhe.com
    NSString *_goURL;
    NSString *_taobaoURL;
    NSString *_myTaobaoURL;
    NSString *_myTaobaoOrderURL;
    NSString *_myTaobaoBagURL;
    NSString *_myTaobaoFavURL;
}

+ (MIConfig* )globalConfig;

//又拍的验证密匙
@property (nonatomic, readonly) NSString *upyunKey;
// API 地址（服务分配）
@property (nonatomic, copy) NSString *apiURL;
// 静态API 地址（服务分配）
@property (nonatomic, copy) NSString *staticApiURL;
// GO Base URL
@property (nonatomic, copy) NSString *goURL;
// API Key（服务分配）
@property (nonatomic, copy) NSString *desKey;
// App Secret Key（服务分配）
@property (nonatomic, copy) NSString *appSecretKey;
// 客户端版本
@property (nonatomic, copy) NSString *version;
//帮助中心
@property (nonatomic, copy) NSString *helpURL;
//特别声明
@property (nonatomic, copy) NSString *specialNoticeURL;
//注册协议
@property (nonatomic, copy) NSString *agreementURL;
//忘记密码
@property (nonatomic, copy) NSString *forgetPasswordURL;
//常见问题
@property (nonatomic, copy) NSString *faqURL;
//我的邀请
@property (nonatomic, copy) NSString *incomeURL;
//APPStore URL
@property (nonatomic, copy) NSString *appStoreURL;
@property (nonatomic, copy) NSString *appStoreReviewURL;
//查看支付宝账号URL
@property (nonatomic, copy) NSString *findAlipayAccountURL;
@property (nonatomic, copy) NSString *checkinURL;
@property (nonatomic, copy) NSString *trustLoginURL;
@property (nonatomic, copy) NSString *appSharePicURL;
@property (nonatomic, copy) NSString *appSharePicLargeURL;
@property (nonatomic, copy) NSString *securityCenterURL;
//如何升级URL
@property (nonatomic, copy) NSString *howToUpdateLevelURL;

//帮助中心
@property (nonatomic, copy) NSString *helpCenter;

@property (nonatomic, copy) NSString *customerService;

//我的贝贝
@property (nonatomic, copy) NSString *beibeiURL;
// PID
@property (nonatomic, copy) NSString *channelId;
@property (nonatomic, readonly) NSString* firstRunTag;
//设置页面是否显示提醒安全信息
@property (nonatomic, assign) BOOL isHiddenReminderView;

// 服务器配置信息
@property (nonatomic, readonly) BOOL      tuanTbApp;
@property (nonatomic, readonly) BOOL      zhiTbApp;
@property (nonatomic, readonly) BOOL      tbMidPage;
@property (nonatomic, readonly) BOOL      htmlRebate;
@property (nonatomic, readonly) BOOL      temaiRebate;
@property (nonatomic, readonly) BOOL      topTbkApi;
@property (nonatomic, readonly) NSString* mmPid;
@property (nonatomic, readonly) NSString* saPid;
@property (nonatomic, readonly) NSString* searchPid;
@property (nonatomic, readonly) NSString* sclick;
@property (nonatomic, readonly) NSString* jumpTb;
@property (nonatomic, readonly) NSString* taobaoAd;
@property (nonatomic, readonly) NSString* tmallAd;
@property (nonatomic, readonly) NSString* taobaoSche;
@property (nonatomic, readonly) NSString* taobaoAppID;
@property (nonatomic, readonly) NSString* topAppKey;
@property (nonatomic, readonly) NSString* topAppSecretKey;
@property (nonatomic, readonly) NSString* appDl;
@property (nonatomic, readonly) NSArray*  regs;
@property (nonatomic, readonly) NSString *myTaobao;
@property (nonatomic, readonly) NSString *myTaobaoOrder;
@property (nonatomic, readonly) NSString *myTaobaoCart;
@property (nonatomic, readonly) NSString *myTaobaoFav;
@property (nonatomic, readonly) NSString* beibeiAppID;
@property (nonatomic, readonly) NSString* beibeiAppSlogan;
@property (nonatomic, readonly) NSString* closeSearchVersion;
@property (nonatomic, readonly) NSString* reviewVersion;
@property (nonatomic, readonly) NSString* live800CachedReg;
@property (nonatomic, readonly) NSString* tbUrl;
@property (nonatomic, copy) NSString* shakeUrl;

//设备相关信息
@property (nonatomic, strong) NSMutableDictionary *clientInfo;
//应该相关配置信息
@property (nonatomic, strong) MIConfigModel *appConfigInfo;
//团购类目数据信息
@property (atomic, strong) NSMutableArray *tuanCategory;
@property (atomic, strong) NSMutableArray *youpinCategory;
//品牌特卖类目数据信息
@property (atomic, strong) NSMutableArray *brandCategory;
//主界面Tab Index映射关系
@property (nonatomic, strong) NSDictionary *tabBarMaps;
//系统时间与服务器标准时间偏移量
@property (nonatomic, strong) NSMutableArray *homeTabs;
//版本更新
@property (nonatomic, strong) NSNumber *updateType;
@property (nonatomic, strong) NSNumber *updateTimes;
@property (nonatomic, strong) NSNumber *emailRegisterOpen;

@property (atomic, assign) double timeOffset;
@property (nonatomic, assign) BOOL bNotification;

@property (nonatomic, copy) NSString *notificationSource;

// 检查是否为审核版本
- (BOOL) isReviewVersion;

//配置统计信息ClientInfo
+ (NSDictionary *)getClientInfo;
+ (MIConfigModel *)getAppConfigInfo;
+ (NSMutableArray *)getTuanCategory;
+ (NSMutableArray *)getYoupinCategory;
+ (NSArray *)getBrandCategory;
+ (NSMutableArray *)getHomeTabs;
+ (NSMutableArray *)getBrandTabs;
+ (NSMutableArray *)getTenYuanTabs;
+ (NSMutableArray *)getYouPinTabs;

+ (NSString *)getUDID;
@end
