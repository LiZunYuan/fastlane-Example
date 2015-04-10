//
//  MIGrobal.h
//  MISpring
//
//  Created by Yujian Xu on 13-3-11.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIUtility.h"
#import "MINavigator.h"
#import "MIUsefulMacros.h"
#import "MIConfig.h"
#import "MIMainUser.h"
#import "MIGetTbkClickRequest.h"
#import "MICustomNavigationBar.h"
#import "MIBaseViewController.h"
#import "MIUITextButton.h"
#import "MICommonButton.h"
#import "MIButtonItem.h"
#import "MIActionSheet.h"
#import "MISinaWeiboConstants.h"
#import "MITipView+Manager.h"
#import "MIMainScreenViewController.h"

#import "MIWebViewController.h"
#import "MIModalWebViewController.h"
#import "MITbWebViewController.h"
#import "MILoginViewController.h"
#import "MIMyMizheViewController.h"
#import "MILoginGuideViewController.h"
#import "MIRegisterViewController.h"
#import "MISettingViewController.h"

#define MIAPP_UPDATE_ALERT_MAXCOUNT       5       //版本更新提醒
#define MIAPP_GRADE_ALERT_MAXCOUNT        3       //版本评分提醒
#define MIAPP_ACTIVITY_INDICATOR_VIEW_TAG 999     //活动指示器的标签
#define MIAPP_FAVS_DELETE_IMAGEVIEW_TAG   999999  //删除收藏的标签

#define MIAPP_ONE_MIN_INTERVAL   -60
#define MIAPP_TEN_MIN_INTERVAL   -10*60
#define MIAPP_HALF_HOUR_INTERVAL -30*60
#define MIAPP_ONE_HOUR_INTERVAL  -60*60
#define MIAPP_ONE_DAY_INTERVAL   -24*60*60
#define MIAPP_ONE_WEEK_INTERVAL  -7*24*60*60

// 1表示淘宝，2表示天猫
typedef enum TuanOriginType
{
    TuanOriginTaobao = 1,
    TuanOriginTmall
}TuanOriginType;

/*
 * 常用路径或消息通知名称
 */
#define kShowGradeAlertView         @"kShowGradeAlertView"
#define kShowChongzhiTipsAlertView  @"kShowChongzhiTipsAlertView"
#define kLastUpdateHomeAdsTime      @"kLastUpdateHomeAdsTime"
#define kLastUpdateCatsTime         @"kLastUpdateCatsTime"
#define kShowGradeAlertViewCount    @"kShowGradeAlertViewCount"
#define kMuyingItemClicksCount      @"kMuyingItemClicksCount"
#define kLastUpdateTemaiTime        @"kLastUpdateTemaiTime"
#define kLastUpdateBeibeiTemaiTime  @"kLastUpdateBeibeiTemaiTime"
#define kLastUpdateBrandTime        @"kLastUpdateBrandTime"
#define kLastUpdateTuanTime         @"kLastUpdateTuanTime"
#define kLastUpdateBrandTemaiTime   @"kLastUpdateBrandTemaiTime"
#define kLastUpdateTenTime          @"kLastUpdateTenTime"
#define kDefaultUserAgent           @"kDefaultUserAgent"
#define kFirstActiveApp             @"kFirstActiveApp"
#define kLastAppUpdateAlertView     @"kLastAppUpdateAlertView"
#define kShowNotifySettingAlertView @"kShowNotifySettingAlertView"
#define kAdsDataHasUpdated          @"kAdsDataHasUpdated"
#define kBrandFavorListDefaults     @"kBrandFavorListDefaults"
#define kBrandFavorBeginTimeDefaults    @"kBrandFavorBeginTimeDefaults"
#define kItemFavorBeginTimeDefaults     @"kItemFavorBeginTimeDefaults"
#define kItemFavorListDefaults      @"kItemFavorListDefaults"
#define kLastTuanHotTime            @"kLastTuanHotTime"
#define kPushCount                  @"kPushCount"
#define kShakeTag                   @"kShakeTag"
#define kSigninTag                  @"kSigninTag"
#define kRandomTag                  @"kRandomTag"

#define kActiveTime                 @"kActiveTime"//激活时间

#define kCrashLogPath       @"crashLog"
#define kMiZheCachePath     @"MiZheCache"
#define MiNotifyUserHasShared  @"MiNotifyUserHasShared"
#define MiNotifyUserHasLogined  @"MiNotifyUserHasLogined"
#define MiNotifyUserHasLogouted @"MiNotifyUserHasLogouted"
#define MiNotificationShowAlertLogin @"MiNotificationShowAlertLogin"
#define MiNotificationNewsMessageDidUpdate @"MiNotificationNewsMessageDidUpdate"
#define MiNotifyWebViewImageLoadSuccess    @"MiNotifyWebViewImageLoadSuccess"
#define MiNotifyWebViewReload     @"MiNotifyWebViewReload"
#define MINotifyQQLoginSuccess    @"MINotifyQQLoginSuccess"
#define MINotifyWeiboLoginSuccess @"MINotifyWeiboLoginSuccess"
#define MINotifyDialogAdsTime   @"MINotifyDialogAdsTime"


#define MIConfigHasUpdated          @"BBConfigHasUpdated"
#define MINotifyUserHasShared       @"MINotifyUserHasShared"
#define MINotifyUserHasLogined      @"MINotifyUserHasLogined"
#define MINotifyWebViewReload       @"MINotifyWebViewReload"

//在“后台”进入前台后才调用，第一次启动时，并不发出。
#define MIApplicationBecomeActive   @"MIApplicationBecomeActive"

// webview 加载结束标识url
#define WEBVIEW_COMPLETE_URL       @"webviewprogressproxy:///complete"

/**
 *	@brief	友盟统计自定义事件ID
 */
#define MIAPP_UPLOAD_TESTSTORE    @"test"
#define MIAPP_UPLOAD_APPSTORE     @"App Store"

#define MIAPP_UPLOAD_PPSTORE      @"pp store"
#define MIAPP_UPLOAD_91STORE      @"91 store"
#define MIAPP_UPLOAD_I4STORE      @"i4 store"
#define MIAPP_UPLOAD_TONGBUSTORE  @"tongbu store"
#define MIAPP_UPLOAD_KYSTORE      @"kuaiyong store"

#define kShared         @"kShared"            //分享
#define kLogined        @"kLogined"           //登录
#define kCheckin        @"kCheckin"           //签到
#define kInvited        @"kInvited"           //邀请
#define kDoTasks        @"kDoTasks"           //做任务
#define kInvitation     @"kInvitation"        //发出邀请次数
#define kNewRegister    @"kNewRegister"       //新增注册用户数
#define kAppReviewed    @"kAppReviewed"       //APP评分次数
#define kHomeShortcut   @"kHomeShortcut"      //首页快捷通道点击量
#define kTaobaoLogin    @"kTaobaoLogin"       //使用淘宝登录
#define kQQLogin        @"kQQLogin"           //使用qq登录
#define kWeiboLogin     @"kWeiboLogin"        //使用微博登录
#define kTuanItemClicks @"kTuanItemClicks"    //团购页面商品点击次数
#define kYouPinItemClicks @"kYouPinItemClicks"    //优品页面商品点击次数
#define kYouPinGoBuys     @"kYouPinGoBuys"        //优品详情页面去抢购点击次数
#define kTuanItemGoBuys   @"kTuanItemGoBuys"      //10元购详情页面去抢购点击次数
#define kBrandItemClicks  @"kBrandItemClicks"     //品牌特卖页面商品点击次数
#define kBrandShopClicks  @"kBrandShopClicks"     //品牌特卖页面店铺点击次数
#define kBrandItemGoBuys  @"kBrandItemGoBuys"     //品牌特卖详情页面去抢购点击次数
#define kTaobaoItemClicks @"kTaobaoItemClicks"    //淘宝返利搜索页面商品点击次数
#define kAdsClicks        @"kAdsClicks"           //首页广告点击数
#define kSplashAdsClicks  @"kSplashAdsClicks"     //闪屏广告点击数
#define kMallsTime        @"kMallsTime"           //去商城购物浏览时长
#define kTaobaoFilterSort @"kTaobaoFilterSort"    //淘宝商品搜索结果筛选项点击次数
#define kMainTabsClicks   @"kMainTabsClicks"      //底部TabBar点击数
#define kTuanTabsClicks   @"kTuanTabsClicks"      //团购tab点击数
#define kOrderTabsClicks  @"kOrderTabsClicks"     //我的订单tab点击数
#define kTemaiCatClicks   @"kTemaiCatClicks"      //特卖类目点击数
#define kZhiCatClicks     @"kZhiCatClicks"        //超值爆料类目点击数
#define kTaobaoSearchUrl  @"kTaobaoSearchUrl"     //使用淘宝url搜索商品数
#define kMyTaobaoClicks   @"kMyTaobaoClicks"      //我的淘宝快捷入口点击数
#define kLastLoadCustomerTime       @"kLastLoadCustomerTime"
#define kTuanRelateItemClicks       @"kTuanRelateItemClicks"         //10元购推荐商品点击次数
#define kBrandRelateItemClicks      @"kBrandRelateItemClicks"        //推荐品牌点击次数
#define kTaobaoShortCutClicks       @"kTaobaoShortCutClicks"         //淘宝返利快捷入口点击数

#define kTaobaoDetailViewClicks     @"kTaobaoDetailViewClicks"       //淘宝商品中间页打开数
#define kTaobaoDetailBuyClicks      @"kTaobaoDetailBuyClicks"        //淘宝商品中间页购买点击数
#define kTaobaoShopClicks           @"kTaobaoShopClicks"             //淘宝商品中间页店铺点击数
#define kTaobaoDetailShareClicks    @"kTaobaoDetailShareClicks"      //淘宝商品中间页分享的点击数

#define kTemaiCatClicks         @"kTemaiCatClicks"      //特卖类目点击数
#define kBrandCatClicks         @"kBrandCatClicks"      // 品牌特卖类目点击数
#define kTuanCatClicks          @"kTuanCatClicks"       //10元购类目点击数
#define kYoupinCatClicks        @"kYoupinCatClicks"     //优品惠类目点击数

#define kAddFavs        @"kAddFavs"           //选择个性定制次数
#define kAddFavsMall    @"kAddFavsMal"        //选择添加或删除关注商城的次数
#define kHomeFavs       @"kHomeFavs"          //首页收藏点击数

#define kZhiItemViews   @"kZhiItemViews"       //查看超值爆料优惠点击数
#define kZhiItemClicks  @"kZhiItemClicks"      //超值爆料优惠去购买点击数
#define kZhiCommClicks  @"kZhiCommClicks"      //超值爆料评论点击数
#define kZhiVoteClicks  @"kZhiVoteClicks"      //超值爆料赞点击数
#define kZhiShareClicks @"kZhiShareClicks"     //超值爆料分享点击数

#define kVipCenterClicks  @"kVipCenterClicks"  //会员中心点击数
#define kVipUpdateClicks  @"kVipUpdateClicks"  //我要升级点击数

#define kUpdateHeadClicks  @"kUpdateHeadClicks"  //更新头像点击数
#define kUpdateNickClicks  @"kUpdateNickClicks"  //更新昵称点击数

#define kMsgCenterClicks   @"kMsgCenterClicks"   //消息中心点击数
#define kNotifyClicks      @"kNotifyClicks"      //推送消息点击数
#define kScanClicks        @"kScanClicks"
#define kHomeShortcut      @"kHomeShortcut"
#define kHomePopAds        @"kHomePopAds"
#define kHomeThreeAds      @"kHomeThreeAds"
#define kHomeSmallAds      @"kHomeSmallAds"
#define kMainAdsTopClicks  @"kMainAdsTopClicks"
#define kBrandTopAds       @"kBrandTopAds"
#define k10YuanTopAds      @"k10YuanTopAds"
#define kYoupinTopAds      @"kYoupinTopAds"
#define kTopbarAds         @"kTopbarAds"        //顶部gif广告

#define kTuanShortcut      @"kTuanShortcut"     //十元购首页新增的三个快捷入口
#define kYoupinShortcut    @"kYoupinShortcut"   //优品惠...
#define kTuanHotItems      @"kTuanHotItems"     //十元购爆款区域
#define kYoupinHotItems    @"kYoupinHotItems"   //优品惠...
#define kNvzhuangCats      @"kNvzhuangCats"     //女装二级类目
#define kNotifyCheckin     @"kNotifyCheckin"    //签到推送打开
#define kNotifyTuanBuyClicks @"kNotifyTuanBuyClicks" //推送带来的抢购
#define kNotifyNewRegister @"kNotifyNewRegister" //推送带来的注册
#define kNowNewRegister     @"kNowNewRegister"  //单日激活单日注册
#define kPhoneRegister      @"kPhoneRegister"   //手机注册数
#define kFavorClick         @"kFavorClick"      //商品详情页提醒我点击数
#define kFavorBrandClick    @"kFavorBrandClick" //品牌特卖提醒我点击数





