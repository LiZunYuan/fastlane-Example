//
//  MIAdService.m
//  MISpring
//
//  Created by husor on 14-11-12.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MIAdService.h"
#import "MIAppDelegate.h"


#define MIAPP_ADS_CACHE_INTERVAL @(10*60)
#define MIAPP_ADS_CACHE_FILE @"ads.cache.file"

static MIAdService *_sharedManager = nil;

@interface MIAdService()
{
    MKNetworkEngine * _catsEngine;
    MIAdsModel      *_memCacheAdsModel;      // 原始广告数据内存缓存
    NSMutableDictionary *_memCacheExpires;   // 原始广告数据内存缓存失效时间
    NSInteger _currentUserTag;               // 当前缓存的user_tag
    MIAdsModel *_displayAdsModel;            // 用于展示的广告数据
}

@end


@implementation MIAdService

- (id)init
{
    self = [super init];
    if (self) {
        [self initStaticMap];
        _currentUserTag = [MIMainUser getInstance].userTag.integerValue;
        _memCacheAdsModel = [[MIAdsModel alloc] init];
        _memCacheExpires = [[NSMutableDictionary alloc] initWithCapacity:AdsTypeMax];
        
        _displayAdsModel = [[MIAdsModel alloc] init];
        
        _catsEngine = [[MKNetworkEngine alloc] initWithHostName: @"m.mizhe.com" customHeaderFields:nil];
        [_catsEngine useCache];
    }
    return self;
}

+ (instancetype)sharedManager {
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedManager = [[self alloc] init];
    });
    
    return _sharedManager;
}

- (void)initStaticMap
{
    // 缓存的广告位key
    _adKeys =  @[//@"all",
                 @"ads",
                 @"splashAds",
                 @"mizheShortcuts",
                 @"recommendHeader",
                 @"promotionShortcuts",
                 @"squareShortcuts",
                 @"brandBanners",
                 @"tenyuanBanners",
                 @"youpinBanners",
                 @"middleBanners",
                 @"dialogAds",
                 @"popupAds",
                 @"topbarAds",
                 @"nvzhuangCatShortcuts",
                 @"temaiHeaderBanners",
                 @"tenyuanShortcuts",
                 @"youpinShortcuts",
                 @"muyingBanners"
                ];
}

- (void)loadAdWithType:(NSArray *)adsTypeArray block:(LoadSuccessBlock)block
{
    // 前后两次userTag变化，则直接清除缓存
    NSInteger userTag = [MIMainUser getInstance].userTag.integerValue;
    if (_currentUserTag != userTag) {
        [self clearCache];
        _currentUserTag = userTag;
    }
    
    __weak typeof(self) weakSelf = self;
    [self doGetAds:adsTypeArray expires:MIAPP_ADS_CACHE_INTERVAL block:^(MIAdsModel *model) {
        for (NSNumber *type in adsTypeArray) {
            if (type.integerValue != All_Ads) {
                [weakSelf filterInvalidAds:model withType:(AdsType)type.integerValue];
            } else {
                // 包含全部广告位的情况
                for (NSInteger adType = All_Ads + 1; adType < AdsTypeMax; ++adType) {
                    [weakSelf filterInvalidAds:model withType:(AdsType)adType];
                }
                break;
            }
        }
        
        block(_displayAdsModel);
    }];
    
}

/**
 *  通过广告位过滤无效广告
 */
- (void)filterInvalidAds:(MIAdsModel *)model withType:(AdsType)adsType
{
    NSString *adKey = [_adKeys objectAtIndex:adsType-1];
    
    NSArray *adKeys = @[adKey];
    if (adsType == All_Ads) {
        adKeys = _adKeys;
    }
    
    for (NSString *key in adKeys) {
        // 闪屏广告需要先下载图片后才展示
        if ([key isEqualToString:@"splashAds"]) {
            _displayAdsModel.splashAds = [self downloadSplashAdsImage:model.splashAds];
        }
        // 弹出的dialog广告（下载链接，需要检查是否安装了相应的app）
        else if ([key isEqualToString:@"popupAds"]) {
            _displayAdsModel.popupAds = [self clearDialogInvalidAds:model.popupAds];
        }
        else {
            NSArray *adsArray = [model valueForKey:key];
            [_displayAdsModel setValue:[self clearInvalidAds:adsArray] forKey:key];
        }
    }
}

/**
 *  重新加载内存缓存
 */
- (void)reloadMemeryCache:(LoadSuccessBlock)complete
{
    __weak typeof(self) weakSelf = self;
    // 读文件放到非UI线程
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *adsCacheFilePath = [[MIMainUser documentPath] stringByAppendingPathComponent:MIAPP_ADS_CACHE_FILE];
        NSData *data = [NSData dataWithContentsOfFile:adsCacheFilePath];
        if (data.length > 0) {
            NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            _memCacheAdsModel = [MIUtility nativeConvertDictionary2Object:dict className:@"MIAdsModel"];
            
            
            for (NSString *key in _adKeys) {
                NSNumber *expire = [[NSUserDefaults standardUserDefaults] objectForKey:key];
                if (expire) {
                    [_memCacheExpires setObject:expire forKey:key];
                }
            }
            
            // 回到主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                complete(_memCacheAdsModel);
            });
        } else {
            [weakSelf clearCache];
        }
    });
}

/**
 *  检查广告缓存
 */
- (BOOL)checkAdsFromCache:(NSArray *)adsTypeArray block:(LoadSuccessBlock)complete
{
    if (adsTypeArray == nil || adsTypeArray.count == 0) {
        MILog(@"fatal error: [%s] %s:%d empty adsTypeArray!", __FILE__, __FUNCTION__, __LINE__);
        return YES;
    }
    
    // 1. 获取缓存的adKey
    BOOL hasAllAds = NO;
    NSMutableArray *tempAdKeys = [[NSMutableArray alloc] initWithCapacity:adsTypeArray.count];
    for (NSNumber *type in adsTypeArray) {
        if (type.integerValue == All_Ads) {
            hasAllAds = YES;
            break;
        }
        
        [tempAdKeys addObject:[_adKeys objectAtIndex:type.integerValue - 1]];
    }
    
    NSArray *adKeys = nil;
    if (hasAllAds) {
        adKeys = _adKeys;
    } else {
        adKeys = tempAdKeys;
    }
    
    double nowInterval = [[NSDate date] timeIntervalSince1970];
    
    // 2. 内存缓存检查
    BOOL memeryCached = NO;
    if (_memCacheExpires && _memCacheExpires.allKeys.count > 0) {
        memeryCached = YES;
        
        for (NSString *key in adKeys) {
            NSNumber *expire = [_memCacheExpires objectForKey:key];
            
            // 缓存失效
            if (expire == nil || expire.integerValue < nowInterval) {
                memeryCached = NO;
                break;
            }
        }
    }
    
    if (memeryCached) {
        MILog(@"get ads from memery cache, keys: %@", adKeys);
        complete(_memCacheAdsModel);
        return YES;
    }
    
    // 3. 文件缓存检查
    BOOL fileCached = YES;
    for (NSString *key in adKeys) {
        NSNumber *expire = [[NSUserDefaults standardUserDefaults] objectForKey:key];
        
        // 缓存失效
        if (expire == nil || expire.integerValue < nowInterval) {
            fileCached = NO;
            break;
        }
    }
    
    if (fileCached) {
        MILog(@"get ads from file cache, keys: %@", adKeys);
        [self reloadMemeryCache:complete];
    }
    
    return fileCached;
}

/**
 *  获取广告位广告
 */
- (void)doGetAds:(NSArray *)adsTypeArray expires:(NSNumber *)expires block:(LoadSuccessBlock)block
{
    // 检查是否有缓存，有则直接使用缓存
    if ([self checkAdsFromCache:adsTypeArray block:block]) {
        return;
    }
    
    // 拼接广告位字符串
    NSMutableString *adsType = [[NSMutableString alloc] init];
    for (NSInteger i = 0; i < adsTypeArray.count; i++)
    {
        NSNumber *num = [adsTypeArray objectAtIndex:i];
        if (i < adsTypeArray.count - 1)
        {
            [adsType appendFormat:@"%ld_",(long)num.integerValue];
        }
        else
        {
            [adsType appendFormat:@"%ld",(long)num.integerValue];
        }
    }
    
    NSString *channel = [[MIConfig globalConfig].channelId urlEncoder];
    NSString *url = [NSString stringWithFormat:@"resource/ads-iPhone-%ld-%@-%@-%@.html", (long)_currentUserTag, channel,adsType,[MIConfig globalConfig].version];
    
    // 重新请求
    __weak typeof(self) weakSelf = self;
    MKNetworkOperation* adsOp = [_catsEngine operationWithPath: url params: nil httpMethod:@"GET" ssl:NO];
    [adsOp addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        NSData* data = completedOperation.responseData;
        if (data.length > 0) {
            
            NSMutableDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            NSDictionary *appError = [dict objectForKey:@"app_error"];
            if (appError && [[appError objectForKey:@"cant_use"] intValue] == 1) {
                MIButtonItem *affirmItem = [MIButtonItem itemWithLabel:@"立即更新"];
                affirmItem.action = ^{
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[appError objectForKey:@"target"]]];
                };
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                    message:[appError objectForKey:@"desc"]
                                                           cancelButtonItem:nil
                                                           otherButtonItems:affirmItem, nil];
                [alertView show];
                return;
            }
            
            // 设置缓存
            NSInteger nowInterval = [[NSDate date] timeIntervalSince1970];
            NSNumber *expireTime = @(nowInterval + expires.integerValue);
            MIAdsModel *model = [MIUtility convertDisctionary2Object:dict className:@"MIAdsModel"];
            for (NSString *adKey in _adKeys) {
                id value = [model valueForKey:adKey];
                
                if (value != nil) {
                    // 文件缓存
                    [[NSUserDefaults standardUserDefaults] setObject:expireTime forKey:adKey];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    // 内存缓存
                    [_memCacheExpires setObject:expireTime forKey:adKey];
                    [_memCacheAdsModel setValue:value forKey:adKey];
                }
            }
            _memCacheAdsModel.latestConfigTime = model.latestConfigTime;
            
            // 缓存内容写入文件持久化
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[_memCacheAdsModel toJsonObject] options:NSJSONWritingPrettyPrinted error:nil];
            NSString *adsCacheFilePath = [[MIMainUser documentPath] stringByAppendingPathComponent:MIAPP_ADS_CACHE_FILE];
            [jsonData writeToFile:adsCacheFilePath atomically:YES];
            
            // 检查配置是否需要更新
            MIConfigModel *configModel = [MIConfig getAppConfigInfo];
            if (configModel.time == nil || (_memCacheAdsModel.latestConfigTime &&
                    _memCacheAdsModel.latestConfigTime.integerValue > configModel.time.integerValue)) {
                [MIAppDelegate updateAppConfigWithTs:_memCacheAdsModel.latestConfigTime onCompelete:^{

                }];
            }
            
            block(_memCacheAdsModel);
        }
    } errorHandler:^(MKNetworkOperation* completedOperation, NSError *error) {
        [weakSelf reloadMemeryCache:^(MIAdsModel *model) {
            block(_memCacheAdsModel);
        }];
    }];
    
    [_catsEngine enqueueOperation:adsOp];
}

- (NSMutableArray *)downloadSplashAdsImage:(NSArray *)ads
{
    NSMutableArray *mutableAds = [[NSMutableArray alloc] initWithCapacity:ads.count];
    double nowInterval = [[NSDate date] timeIntervalSince1970] + [MIConfig globalConfig].timeOffset;
    for (NSInteger i = 0; i < ads.count; ++i) {
        NSDictionary *dict = [ads objectAtIndex:i];
        if (![dict objectForKey:@"bg"] || ![dict objectForKey:@"img"]) {
            //如果没有背景色值，否则不显示该广告
            continue;
        }
        
        NSInteger startInterval = [[dict objectForKey:@"begin"] intValue];
        if (startInterval && startInterval > nowInterval)
        {
            //如果活动时间未开始，否则不显示该广告
            continue;
        }
        
        NSInteger endIntervial = [[dict objectForKey:@"end"] intValue];
        if (endIntervial && endIntervial < nowInterval)
        {
            //如果活动时间已结束，则需要将缓存数据删除
            [[SDImageCache sharedImageCache] removeImageForKey:[dict objectForKey:@"img"]];
            continue;
        }
        
        UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:[dict objectForKey:@"img"]];
        if (!image)
        {
            //如果图片未缓存下来，则不显示该广告
            NSURL *imgURL = [NSURL URLWithString:[dict objectForKey:@"img"]];
            [SDWebImageManager.sharedManager downloadImageWithURL:imgURL options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                MILog(@"loadLauchAdsImgData:error=%@,finish=%d,url=%@", error, finished, imgURL.absoluteString);
            }];
            continue;
        }
        [mutableAds addObject:dict];
    }
    
    if (mutableAds.count > 0) {
        self.hasSplashAds = YES;
    } else {
        self.hasSplashAds = NO;
    }
    
    return mutableAds;
}

- (NSDictionary *)clearCatInvalidAds:(NSDictionary *)catAdsDict
{
    if (catAdsDict == nil || catAdsDict.allKeys.count == 0) {
        return nil;
    }
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:catAdsDict.count];
    for (NSString *key in [catAdsDict keyEnumerator]) {
        NSArray *ads = [catAdsDict objectForKey:key];
        
        [dict setObject:[self clearInvalidAds:ads] forKey:key];
    }
    
    return dict;
}

- (NSArray *)clearDialogInvalidAds:(NSArray *)arr
{
    NSArray *dialogAds = [self clearInvalidAds:arr];
    if (dialogAds == nil || dialogAds.count == 0) {
        return dialogAds;
    }
    
    // 只取其中第一个广告
    NSDictionary *dict = [dialogAds objectAtIndex:0];
    NSString *target = [dict objectForKey:@"target"];
    if (target == nil || target.length == 0) {
        return @[];
    }
    
    return @[dict];
}

- (NSArray *)clearInvalidAds:(NSArray *)arr
{
    if (arr == nil || arr.count == 0) {
        return arr;
    }
    
    NSMutableArray *mutableAds = [[NSMutableArray alloc] initWithCapacity:arr.count];
    for (NSInteger i = 0; i < arr.count; ++i)
    {
        NSDictionary *dic = [arr objectAtIndex:i];
        NSNumber *startTime = [dic objectForKey:@"begin"];
        NSNumber *endTime = [dic objectForKey:@"end"];
        double nowInterval = [[NSDate date] timeIntervalSince1970] + [MIConfig globalConfig].timeOffset;
        if (startTime.integerValue == 0 && endTime.integerValue == 0) {
            // 智能投放广告，无限制时间，直接添加
            [mutableAds addObject:dic];
            continue;
        }
        
        if (nowInterval < startTime.doubleValue || nowInterval > endTime.doubleValue)
        {
            // 时间未开始，或已经结束不显示的广告
            continue;
        }
        
        NSString *login = [dic objectForKey:@"login"];
        if (login && login.intValue == -1 && [[MIMainUser getInstance] checkLoginInfo])
        {
            // 登录后就不显示的广告
            continue;
        } else if (![dic objectForKey:@"target"] && ![dic objectForKey:@"img"]) {
            // 如果没有target或者img，否则不显示该广告
            continue;
        } else if ([[dic objectForKey:@"target"] hasPrefix:@"http"]) {
            NSString *schema = [dic objectForKey:@"data"];
            NSURL *url = nil;
            if ([schema hasSuffix:@"://"]) {
                url = [NSURL URLWithString:schema];
            } else {
                url = [NSURL URLWithString:[NSString stringWithFormat:@"%@://", schema]];
            }
            
            if (url && [[UIApplication sharedApplication] canOpenURL:url]) {
                // 如果要下载的app已经安装了，就直接过滤
                continue;
            }
        }
        
        //跳转到APP STORE的URL样式为https://itunes.apple.com/cn/app/mi-zhe-tao-bao-sheng-qian/id633394165?mt=8&uo=4
        NSURL *URL = [NSURL URLWithString:[dic objectForKey:@"target"]];
        if ([URL.host isEqualToString:@"itunes.apple.com"]
            || [URL.host isEqualToString:@"phobos.apple.com"]) {
            MIAppDelegate* delegate = (MIAppDelegate*)[[UIApplication sharedApplication] delegate];
            if(delegate.appNewVersion == nil){
                //如果用户未更新，则显示新版的广告，否则剔除广告
                continue;
            }
        }

        
        // 其他广告直接添加
        [mutableAds addObject:dic];
    }
    
    return mutableAds;
}

/**
 *  清除内存缓存
 */
- (void)clearMemeryCache
{
    [_memCacheExpires removeAllObjects];
    
    // 丢弃对原来数据的引用
    _memCacheAdsModel = nil;
    _memCacheAdsModel = [[MIAdsModel alloc] init];
}

/**
 *  清除文件缓存
 */
- (void)clearFileCache
{
    for (NSString *key in _adKeys)
    {
        [[NSUserDefaults standardUserDefaults] setObject:@(0) forKey:key];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/**
 * 清除全部缓存，包括文件和内存缓存
 */
- (void)clearCache
{
    [self clearFileCache];
    [self clearMemeryCache];
    
    if (_catsEngine) {
        [_catsEngine emptyCache];
    }
}


- (void)cancelRequest
{
    [_catsEngine cancelAllOperations];
}



@end
