//
//  MIConfig.m
//  MISpring
//
//  Created by XU YUJIAN on 13-1-27.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIConfig.h"
#import "MIRegModel.h"
#import "KeychainItemWrapper.h"

NSString *const kQQAppKey = @"QQ000363A3";
NSString *const kTencentAppID = @"222115";
NSString *const kWeixinAppKey = @"wxcd0e612a7ff58ddf";
NSString *const kUmengAppKey = @"516ab19756240ba82204457f";
NSString *const kPid = @"mm_35109883_0_0";
NSString *const kSaPid = @"mm_35109883_5240802_22824263";
NSString *const kSearchPid = @"mm_35109883_5240802_23404275";
NSString *const kTaobaoSche = @"taobao://";
NSString *const kSclick = @"^(taobao|itaobao)://.*?(mm_35109883_0_0|cloud-jump\\.html)";
NSString *const kJumpTb = @"cloud-jump\\.html";
NSString *const kTaobaoAd = @"smartAd";
NSString *const kTmallAd = @"s-topBaner";
NSString *const kBeibeiAppID = @"863998476";
NSString *const kTaobaoAppID = @"387682726";
NSString *const kTopAppKey = @"21457740";
NSString *const kTopAppSecretKey = @"655e9e6c92544b5449a5a6ca85e740c5";
NSString *const kTtid = @"ttid=400000_21457740@mziosc_iPhone_1.0";
NSString *const kAppDl = @"(http|https)://(m|www)\\.(beibei|mizhe)\\.com\\/app\\/get(.*)";
NSString *const kTdjUrl = @"http://static.mizhe.com/html/tdj/m.html";
NSString *const kUpyunKey = @"FTFed2UrDusYRbjslXTvc4S7hus=";
NSString *const kMyTaobao = @"http://h5.m.taobao.com/awp/mtb/mtb.htm#!/awp/mtb/mtb.htm";
NSString *const kMyTaobaoOrder = @"http://h5.m.taobao.com/awp/mtb/mtb.htm#!/awp/mtb/olist.htm?sta=4";
NSString *const kMyTaobaoFav = @"http://h5.m.taobao.com/fav/index.htm?sprefer=p23590";
NSString *const kMyTaobaoCart = @"http://h5.m.taobao.com/awp/base/cart.htm#!/awp/base/cart.htm";
NSString *const kBeibeiAppSlogan = @"下载贝贝特卖APP浏览，更省流量。随时随地轻松抢购，查看物流。";
NSString *const kHelpCenter = @"http://h5.mizhe.com/help/qa_nav.html";
NSString *const kCustomerService = @"http://h5.mizhe.com/help/contact.html";
static MIConfig *_globalConfig = nil;

@implementation MIConfig

@synthesize upyunKey = _upyunKey;
@synthesize apiURL = _apiURL;
@synthesize staticApiURL = _staticApiURL;
@synthesize desKey = _desKey;
@synthesize appSecretKey = _appSecretKey;
@synthesize version = _version;
@synthesize helpURL = _helpURL;
@synthesize specialNoticeURL = _specialNoticeURL;
@synthesize agreementURL = _agreementURL;
@synthesize forgetPasswordURL = _forgetPasswordURL;
@synthesize faqURL = _faqURL;
@synthesize incomeURL = _incomeURL;
@synthesize appStoreURL = _appStoreURL;
@synthesize appStoreReviewURL = _appStoreReviewURL;
@synthesize findAlipayAccountURL = _findAlipayAccountURL;
@synthesize securityCenterURL = _securityCenterURL;
@synthesize clientInfo = _clientInfo;
@synthesize appConfigInfo = _appConfigInfo;
@synthesize tuanCategory = _tuanCategory;
@synthesize brandCategory = _brandCategory;
@synthesize channelId = _channelId;
@synthesize goURL = _goURL;
@synthesize checkinURL = _checkinURL;
@synthesize trustLoginURL = _trustLoginURL;
@synthesize appSharePicURL = _appSharePicURL;
@synthesize appSharePicLargeURL = _appSharePicLargeURL;
@synthesize howToUpdateLevelURL = _howToUpdateLevelURL;
@synthesize isHiddenReminderView = _isHiddenReminderView;
@synthesize homeTabs = _homeTabs;

#pragma mark - Singleton method

- (id)init {
    self = [super init]; 
    if (self) {
        _isHiddenReminderView = NO;

        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        
        // 应用的推广渠道channelId
        self.channelId = @"haima";
        NSString *retinaPath = [[NSBundle mainBundle] pathForResource:@"channelId" ofType:@"data"];
        NSString *channelId = [[NSString stringWithContentsOfFile:retinaPath encoding:NSUTF8StringEncoding error:nil] trim];
        if (channelId && ![channelId isEmpty]) {
            self.channelId = channelId;
        }

        // API 地址（服务分配）
        self.apiURL = @"http://api.mizhe.com/gateway/route";//正式服务器
//        self.apiURL = @"http://api-dev.mizhe.com/gateway/route";//测试服务器

        self.staticApiURL = @"http://m.mizhe.com";
        self.goURL = @"http://go.mizhe.com/";
        
        // DES Key（服务分配）
        self.desKey = @"c_12xAa3";

        // App Secret Key（服务分配）
        self.appSecretKey = @"XePCCfh0haDh865FwA5OnJuwJz2";
        
        // 客户端版本
        self.version = [infoDictionary objectForKey:(NSString *)kCFBundleVersionKey];
            
        //帮助中心
        self.helpURL = @"http://www.mizhe.com/help/center.html";

        //特别声明
        self.specialNoticeURL = @"http://m.mizhe.com/help/specialnotice.html";

        //注册协议
        self.agreementURL = @"http://m.mizhe.com/help/agreement.html";

        //忘记密码
        self.forgetPasswordURL = @"http://www.mizhe.com/member/reset_passwd.html";
        
        //常见问题
        self.faqURL = @"http://m.mizhe.com/help/faq.html";

        //安全中心
        self.securityCenterURL = @"http://i.mizhe.com/security/index.html";
        
        //我的邀请
        self.incomeURL = @"http://i.mizhe.com/invite/income.html";

        //去APP STROE 评分
        self.appStoreURL = @"https://itunes.apple.com/app/id633394165?mt=8";

        self.appStoreReviewURL = @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=633394165";
        
        //查看支付宝账号
        self.findAlipayAccountURL = @"http://member1.taobao.com/member/manage_account.htm?asker=wangwang";
       
        //如何升级
        self.howToUpdateLevelURL = @"http://m.mizhe.com/help/member.html";

        self.beibeiURL = @"http://m.beibei.com/";              //正式服务器

        self.checkinURL = @"http://m.mizhe.com/app/checkin.html";

        self.trustLoginURL = @"http://api.mizhe.com/login/trust.html";

        self.appSharePicURL = @"http://s0.husor.cn/image/app/app_share_pic_smaller.png";

        self.appSharePicLargeURL = @"http://s0.mizhe.cn/image/app_share_pic_large.png";
        
        self.tabBarMaps = [NSDictionary dictionaryWithObjectsAndKeys:@"0", @"home", @"0", @"taobao", @"0", @"mall", @"0", @"rebate", @"1", @"brand", @"2", @"groupon", @"2", @"tuan", @"3", @"youpin", @"4", @"mine", nil];
    }
    return self;
}

+ (MIConfig* )globalConfig {
    if(!_globalConfig) {
        _globalConfig = [[MIConfig alloc] init];
    }
    
    return _globalConfig;
}

+ (id) allocWithZone:(NSZone*) zone
{
	@synchronized(self) {
		if (_globalConfig == nil) {
			_globalConfig = [super allocWithZone:zone];  // assignment and return on first allocation
			return _globalConfig;
		}
	}
	return nil;
}

- (id) copyWithZone:(NSZone*) zone
{
	return _globalConfig;
}

- (NSString*)firstRunTag
{
    NSString* tag = [NSString stringWithFormat:@"first_run_v%@", self.version];
    return tag;
}

- (NSString *)mmPid
{
//    return @"mm_35109883_0_0"; //无线端Pid
    
    MIConfigModel *appConfigInfo = [MIConfig getAppConfigInfo];
    if (appConfigInfo && appConfigInfo.mmPid) {
        return appConfigInfo.mmPid;
    } else {
        return kPid;
    }
}

- (NSString *)saPid
{
//    return @"mm_35109883_5240802_22824263"; //无线端Pid
    
    MIConfigModel *appConfigInfo = [MIConfig getAppConfigInfo];
    if (appConfigInfo && appConfigInfo.saPid) {
        return appConfigInfo.saPid;
    } else {
        return kSaPid;
    }
}

- (NSString *)searchPid
{
//    return @"mm_35109883_5240802_23404275"; //无线s8 Pid
    
    MIConfigModel *appConfigInfo = [MIConfig getAppConfigInfo];
    if (appConfigInfo && appConfigInfo.searchPid) {
        return appConfigInfo.searchPid;
    } else {
        return kSearchPid;
    }
}

- (NSString *)upyunKey
{
    MIConfigModel *appConfigInfo = [MIConfig getAppConfigInfo];
    if (appConfigInfo && appConfigInfo.upyunKey) {
        return appConfigInfo.upyunKey;
    } else {
        return kUpyunKey;
    }
}
- (NSString *)sclick
{
    MIConfigModel *appConfigInfo = [MIConfig getAppConfigInfo];
    if (appConfigInfo && appConfigInfo.sclick) {
        return appConfigInfo.sclick;
    } else {
        return kSclick;
    }
}
- (NSString *)jumpTb
{
    MIConfigModel *appConfigInfo = [MIConfig getAppConfigInfo];
    if (appConfigInfo && appConfigInfo.jumpTb) {
        return appConfigInfo.jumpTb;
    } else {
        return kJumpTb;
    }
}

- (NSString *)beibeiAppID
{
    MIConfigModel *appConfigInfo = [MIConfig getAppConfigInfo];
    if (appConfigInfo && appConfigInfo.beibeiAppid) {
        return appConfigInfo.beibeiAppid;
    } else {
        return kBeibeiAppID;
    }
}

- (NSString *)beibeiAppSlogan
{
    MIConfigModel *appConfigInfo = [MIConfig getAppConfigInfo];
    if (appConfigInfo && appConfigInfo.beibeiAppSlogan) {
        return appConfigInfo.beibeiAppSlogan;
    } else {
        return kBeibeiAppSlogan;
    }
}

- (NSString *)closeSearchVersion
{
    MIConfigModel *appConfigInfo = [MIConfig getAppConfigInfo];
    if (appConfigInfo && appConfigInfo.closeSearchVersion) {
        return appConfigInfo.closeSearchVersion;
    } else {
        return self.version;
    }
}

- (NSString *) reviewVersion
{
    MIConfigModel *appConfigInfo = [MIConfig getAppConfigInfo];
    if (appConfigInfo && appConfigInfo.reviewVersion) {
        return appConfigInfo.reviewVersion;
    } else {
        return self.version;
    }
}

- (NSString *)taobaoSche
{
    MIConfigModel *appConfigInfo = [MIConfig getAppConfigInfo];
    if (appConfigInfo && appConfigInfo.taobaoSche) {
        return appConfigInfo.taobaoSche;
    } else {
        return kTaobaoSche;
    }
}

- (NSString *)taobaoAd
{
    MIConfigModel *appConfigInfo = [MIConfig getAppConfigInfo];
    if (appConfigInfo && appConfigInfo.taobaoAd) {
        return appConfigInfo.taobaoAd;
    } else {
        return kTaobaoAd;
    }
}

- (NSString *)tmallAd
{
    MIConfigModel *appConfigInfo = [MIConfig getAppConfigInfo];
    if (appConfigInfo && appConfigInfo.tmallAd) {
        return appConfigInfo.tmallAd;
    } else {
        return kTmallAd;
    }
}

- (NSString *)taobaoAppID
{
    MIConfigModel *appConfigInfo = [MIConfig getAppConfigInfo];
    if (appConfigInfo && appConfigInfo.taobaoAppid) {
        return appConfigInfo.taobaoAppid;
    } else {
        return kTaobaoAppID;
    }
}

- (NSString *)topAppKey
{
    MIConfigModel *appConfigInfo = [MIConfig getAppConfigInfo];
    if (appConfigInfo && appConfigInfo.topAppKey) {
        return appConfigInfo.topAppKey;
    } else {
        return kTopAppKey;
    }
}

- (NSString *)topAppSecretKey
{
    MIConfigModel *appConfigInfo = [MIConfig getAppConfigInfo];
    if (appConfigInfo && appConfigInfo.topAppSecret) {
        return appConfigInfo.topAppSecret;
    } else {
        return kTopAppSecretKey;
    }
}

- (NSString *) appDl
{
    MIConfigModel *appConfigInfo = [MIConfig getAppConfigInfo];
    if (appConfigInfo && appConfigInfo.appDl) {
        return appConfigInfo.appDl;
    } else {
        return kAppDl;
    }
}

- (BOOL)tuanTbApp
{
//    return TRUE;  //团购商品跳转淘宝客户端
    
    MIConfigModel *appConfigInfo = [MIConfig getAppConfigInfo];
    if (appConfigInfo && appConfigInfo.tuanTbApp) {
        return [appConfigInfo.tuanTbApp boolValue];
    } else {
        return FALSE;  //默认不跳转淘宝客户端
    }
}

- (BOOL)zhiTbApp
{
//    return TRUE;  //超值爆料商品跳转淘宝客户端
    
    MIConfigModel *appConfigInfo = [MIConfig getAppConfigInfo];
    if (appConfigInfo && appConfigInfo.zhiTbApp) {
        return [appConfigInfo.zhiTbApp boolValue];
    } else {
        return FALSE;  //默认不跳转淘宝客户端
    }
}

- (BOOL)htmlRebate
{
//    return FALSE;  //h5不支持淘客佣金结算
    
    MIConfigModel *appConfigInfo = [MIConfig getAppConfigInfo];
    if (appConfigInfo && appConfigInfo.htmlRebate) {
        return [appConfigInfo.htmlRebate boolValue];
    } else {
        return FALSE;  //默认h5不支持淘客佣金结算
    }
}

- (BOOL)temaiRebate
{
//    return FALSE;  //h5不支持淘客佣金结算
    
    MIConfigModel *appConfigInfo = [MIConfig getAppConfigInfo];
    if (appConfigInfo && appConfigInfo.temaiRebate) {
        return [appConfigInfo.temaiRebate boolValue];
    } else {
        return FALSE;  //默认h5不支持淘客佣金结算
    }
}

- (BOOL)tdjMidPage
{
//    return TRUE;  //打开淘点金中间页
    
    MIConfigModel *appConfigInfo = [MIConfig getAppConfigInfo];
    if (appConfigInfo && appConfigInfo.callTbk) {
        return [appConfigInfo.callTbk isEqualToString:@"tdj"];
    } else {
        return FALSE;  //默认不打开淘点金中间页
    }
}

- (BOOL)topTbkApi
{
//    return FALSE;  //客户端使用米折封装的淘客api
    
    MIConfigModel *appConfigInfo = [MIConfig getAppConfigInfo];
    if (appConfigInfo && appConfigInfo.callTbk) {
        return [appConfigInfo.callTbk isEqualToString:@"client"];
    } else {
        return FALSE;  //默认为客户端直接调用米折封装的淘宝客api
    }
}

- (BOOL)tbMidPage
{
//    return FALSE;  //不打开淘宝中间页

    MIConfigModel *appConfigInfo = [MIConfig getAppConfigInfo];
    if (appConfigInfo && appConfigInfo.tbMidPage) {
        return [appConfigInfo.tbMidPage boolValue];
    } else {
        return TRUE;  //默认打开淘宝中间页
    }
}

- (NSArray *)regs
{
//    return nil;

    MIConfigModel *appConfigInfo = [MIConfig getAppConfigInfo];
    if (appConfigInfo && appConfigInfo.regs) {
        return appConfigInfo.regs;
    } else {
        return nil;
    }
}

- (NSString *)helpCenter
{
    MIConfigModel *appConfigInfo = [MIConfig getAppConfigInfo];
    if (appConfigInfo && appConfigInfo.helpCenter) {
        return appConfigInfo.helpCenter;
    } else {
        return kHelpCenter;
    }
}

- (NSString *)customerService
{
    MIConfigModel *appConfigInfo = [MIConfig getAppConfigInfo];
    if (appConfigInfo && appConfigInfo.customerService) {
        return appConfigInfo.customerService;
    } else {
        return kCustomerService;
    }
}


- (NSString *) myTaobao
{
    MIConfigModel *appConfigInfo = [MIConfig getAppConfigInfo];
    if (appConfigInfo && appConfigInfo.myTaobao) {
        return appConfigInfo.myTaobao;
    } else {
        return kMyTaobao;
    }
}

- (NSString *) myTaobaoOrder
{
    MIConfigModel *appConfigInfo = [MIConfig getAppConfigInfo];
    if (appConfigInfo && appConfigInfo.myTaobaoOrder) {
        return appConfigInfo.myTaobaoOrder;
    } else {
        return kMyTaobaoOrder;
    }
}

- (NSString *) myTaobaoFav
{
    MIConfigModel *appConfigInfo = [MIConfig getAppConfigInfo];
    if (appConfigInfo && appConfigInfo.myTaobaoFav) {
        return appConfigInfo.myTaobaoFav;
    } else {
        return kMyTaobaoFav;
    }
}

- (NSString *)live800CachedReg
{
    MIConfigModel *appConfigInfo = [MIConfig getAppConfigInfo];
    if (appConfigInfo && appConfigInfo.live800CachedReg) {
        return appConfigInfo.live800CachedReg;
    } else {
        return @".*chatbox.jsp\\?.*(configID=((?!895).)*(&.*|$)|skillId=((?!268).)*(&.*|$))";
    }
}

- (NSString *)tbUrl
{
    MIConfigModel *appConfigInfo = [MIConfig getAppConfigInfo];
    if (appConfigInfo && appConfigInfo.tbUrl) {
        return appConfigInfo.tbUrl;
    } else {
        return @"http://a.m.taobao.com/i%@.htm";
    }
}

+ (NSString *)screenSize{
    CGSize screen = [[UIScreen mainScreen] bounds].size;
    return [NSString stringWithFormat:@"%.fx%.f",screen.width,screen.height];
}

+ (NSDictionary *)getClientInfo
{
    NSMutableDictionary* ci = [[MIConfig globalConfig] clientInfo];
    if (!ci) {
        ci = [NSMutableDictionary dictionaryWithCapacity:10];
    } else {
        return ci;
    }
    
    UIDevice *device = [UIDevice currentDevice];
    MIConfig *config = [MIConfig globalConfig];
    [ci setObject:@"iPhone" forKey:@"platform"];    //>1.2.1的版本才开始添加该参数
    [ci setObject:device.model forKey:@"model"];
    [ci setObject:device.systemVersion forKey:@"os"];
    [ci setObject:[MIConfig screenSize] forKey:@"screen"];
    [ci setObject:config.version forKey:@"version"];
    [ci setObject:[config getCurrentUDID] forKey:@"udid"];
    [ci setObject:config.channelId forKey:@"bd"];
    [[MIConfig globalConfig] setClientInfo:ci];
    return ci;
}

+ (MIConfigModel *)getAppConfigInfo
{
    MIConfigModel *configInfo = [[MIConfig globalConfig] appConfigInfo];
    if (!configInfo) {
        NSString *appConfigPath = [[MIMainUser documentPath] stringByAppendingPathComponent:@"app.config.data"];
        NSString *data = [NSKeyedUnarchiver unarchiveObjectWithFile:appConfigPath];
        NSString *config = [MIUtility decryptUseDES:data];
        if (config) {
            NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:[config dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
            if (dic) {
                configInfo = [MIUtility convertDisctionary2Object:dic className:@"MIConfigModel"];
                [[MIConfig globalConfig] setAppConfigInfo:configInfo];
            }
        }
    }
    return configInfo;
}

+ (NSMutableArray *)getTuanCategory
{
    NSMutableArray *tuanCategory = [[MIConfig globalConfig] tuanCategory];
    if (!tuanCategory)
    {
        NSString *tuanCatsDataPath = [[MIMainUser documentPath] stringByAppendingPathComponent:@"tuan.cats.data"];
        if (![[NSFileManager defaultManager] fileExistsAtPath:tuanCatsDataPath]) {
            tuanCatsDataPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"tuan.cats.data"];
        }
        NSMutableArray *cats = [NSKeyedUnarchiver unarchiveObjectWithFile:tuanCatsDataPath];
        [[MIConfig globalConfig] setTuanCategory:cats];
        return cats;
    }
    return tuanCategory;
}

+ (NSMutableArray *)getYoupinCategory
{
    NSMutableArray *tuanCategory = [[MIConfig globalConfig] youpinCategory];
    if (!tuanCategory)
    {
        NSMutableArray *cats = nil;
        NSString *youpinCatsDataPath = [[MIMainUser documentPath] stringByAppendingPathComponent:@"youpin.cats.data"];
        if (![[NSFileManager defaultManager] fileExistsAtPath:youpinCatsDataPath]) {
            youpinCatsDataPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"youpin.cats.data"];
        }
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:youpinCatsDataPath]) {
            cats = [NSKeyedUnarchiver unarchiveObjectWithFile:youpinCatsDataPath];
            [[MIConfig globalConfig] setYoupinCategory:cats];
        } else {
            NSString *tuanCatsDataPath = [[MIMainUser documentPath] stringByAppendingPathComponent:@"tuan.cats.data"];
            if (![[NSFileManager defaultManager] fileExistsAtPath:tuanCatsDataPath]) {
                tuanCatsDataPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"tuan.cats.data"];
            }
            cats = [NSKeyedUnarchiver unarchiveObjectWithFile:tuanCatsDataPath];
            [[MIConfig globalConfig] setYoupinCategory:cats];

        }
        
        return cats;
    }
    return tuanCategory;
}


+ (NSArray *)getBrandCategory
{
    NSMutableArray *brandCategory = [[MIConfig globalConfig] brandCategory];
    if (!brandCategory)
    {
        NSString *brandCatsDataPath = [[MIMainUser documentPath] stringByAppendingPathComponent:@"tuan.brand.cats.data"];
        if (![[NSFileManager defaultManager] fileExistsAtPath:brandCatsDataPath]) {
            brandCatsDataPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"tuan.brand.cats.data"];
        }
        NSMutableArray *cats = [NSKeyedUnarchiver unarchiveObjectWithFile:brandCatsDataPath];
        [[MIConfig globalConfig] setBrandCategory:cats];
        return cats;
    }
    return brandCategory;
}

+ (NSMutableArray *)getHomeTabs;
{
    MIConfigModel *appConfigInfo = [MIConfig getAppConfigInfo];
    return [appConfigInfo homeTabs];
}

+ (NSMutableArray *)getBrandTabs
{
    MIConfigModel *appConfigInfo = [MIConfig getAppConfigInfo];
    return [appConfigInfo brandTabs];
}

+ (NSMutableArray *)getTenYuanTabs;
{
    MIConfigModel *appConfigInfo = [MIConfig getAppConfigInfo];
    return [appConfigInfo tenyuanTabs];
}

+ (NSMutableArray *)getYouPinTabs
{
    MIConfigModel *appConfigInfo = [MIConfig getAppConfigInfo];
    return [appConfigInfo youpinTabs];
}

- (NSNumber *)updateType
{
    MIConfigModel *appConfigInfo = [MIConfig getAppConfigInfo];
    if (appConfigInfo.updateType != nil) {
        return appConfigInfo.updateType;
    }
    
    return @(0);
}

- (NSNumber *)updateTimes
{
    MIConfigModel *appConfigInfo = [MIConfig getAppConfigInfo];
    if (appConfigInfo.updateTimes != nil) {
        return appConfigInfo.updateTimes;
    }
    
    return @(MIAPP_UPDATE_ALERT_MAXCOUNT);
}

- (NSString *)checkinURL
{
    MIConfigModel *appConfigInfo = [MIConfig getAppConfigInfo];
    if (appConfigInfo.checkinUrl != nil) {
        return appConfigInfo.checkinUrl;
    }
    
    return @"http://m.mizhe.com/app/checkin.html";
}

- (NSString *)shakeUrl
{
    MIConfigModel *appConfigInfo = [MIConfig getAppConfigInfo];
    if (appConfigInfo.shakeUrl != nil) {
        return appConfigInfo.shakeUrl;
    }
    
    return @"http://t.mizhe.com/yyy";
}

// 检查是否为审核版本
- (BOOL) isReviewVersion
{
    return [self.version isEqualToString:self.reviewVersion];
}

+ (NSString *)getUDID
{
    return [[MIConfig getClientInfo] objectForKey:@"udid"];
}

- (NSNumber *)emailRegisterOpen
{
    MIConfigModel *appConfigInfo = [MIConfig getAppConfigInfo];
    if (appConfigInfo.emailRegisterOpen != nil) {
        return appConfigInfo.emailRegisterOpen;
    }
    
    return @(1);
}

- (NSString *)getCurrentUDID
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // The AppUID will uniquely identify this app within the pastebins
    //
    NSString * appUID = [defaults objectForKey:@"OpenUDID_appUID"];
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc]initWithIdentifier:@"UUID" accessGroup:nil];
    NSString *strUUID = [keychainItem objectForKey:(__bridge id)kSecValueData];
    
    if (appUID) {
        if (strUUID == nil || [strUUID isEqualToString:nil]) {
            [keychainItem setObject:appUID forKey:(__bridge id)kSecValueData];
        }
        return appUID;
    } else if (strUUID && ![strUUID isEqualToString:@""]) {
        [defaults setObject:strUUID forKey:@"OpenUDID_appUID"];
        [defaults synchronize];
        return strUUID;
    } else {
        strUUID = [MIOpenUDID value];
        [keychainItem setObject:strUUID forKey:(__bridge id)kSecValueData];
        [defaults setObject:strUUID forKey:@"OpenUDID_appUID"];
        [defaults synchronize];
        return strUUID;
    }
}

@end
