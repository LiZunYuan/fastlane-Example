//
//  MIConfigModel.h
//  MISpring
//
//  Created by 徐 裕健 on 13-12-6.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MIConfigModel : NSObject

@property (nonatomic, strong) NSNumber *tuanTbApp;
@property (nonatomic, strong) NSNumber *zhiTbApp;
@property (nonatomic, strong) NSNumber *tbMidPage;
@property (nonatomic, strong) NSNumber *htmlRebate;
@property (nonatomic, strong) NSNumber *temaiRebate;
@property (nonatomic, strong) NSString *mmPid;
@property (nonatomic, strong) NSString *saPid;
@property (nonatomic, strong) NSString *searchPid;
@property (nonatomic, strong) NSString *sclick;
@property (nonatomic, strong) NSString *jumpTb;
@property (nonatomic, strong) NSString *taobaoAd;
@property (nonatomic, strong) NSString *tmallAd;
@property (nonatomic, strong) NSString *taobaoAppid;
@property (nonatomic, strong) NSString *taobaoSche;
@property (nonatomic, strong) NSString *topAppKey;
@property (nonatomic, strong) NSString *topAppSecret;
@property (nonatomic, strong) NSString *callTbk;      //调用淘宝API的方式，tdj表示使用淘点金，client表示使用客户端直接调淘宝Api，server表示使用米折api
@property (nonatomic, strong) NSString *appDl;
@property (nonatomic, strong) NSArray *regs;          //淘宝url正则表达式，类型为MIRegModel
@property (nonatomic, strong) NSString *upyunKey;
@property (nonatomic, strong) NSString *myTaobao;
@property (nonatomic, strong) NSString *myTaobaoOrder;
@property (nonatomic, strong) NSString *myTaobaoFav;
@property (nonatomic, strong) NSString *beibeiAppid;
@property (nonatomic, strong) NSString *beibeiAppSlogan;
@property (nonatomic, strong) NSString *helpCenter;
@property (nonatomic, strong) NSString *customerService;
@property (nonatomic, strong) NSString *closeSearchVersion;
@property (nonatomic, strong) NSString *reviewVersion;
@property (nonatomic, strong) NSNumber *time;
@property (nonatomic, strong) NSString *live800CachedReg;
@property (nonatomic, strong) NSString *checkinUrl;
@property (nonatomic, readonly) NSString* tbUrl;
@property (nonatomic, strong) NSMutableArray *homeTabs;
@property (nonatomic, strong) NSMutableArray *brandTabs;
@property (nonatomic, strong) NSMutableArray *tenyuanTabs;
@property (nonatomic, strong) NSMutableArray *youpinTabs;
@property (nonatomic, strong) NSNumber *updateType;
@property (nonatomic, strong) NSNumber *updateTimes;
@property (nonatomic, strong) NSNumber *emailRegisterOpen;
@property (nonatomic, copy) NSString* shakeUrl;

@end
