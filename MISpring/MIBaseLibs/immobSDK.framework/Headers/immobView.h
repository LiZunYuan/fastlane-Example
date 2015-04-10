
/*!
 @header immobView.h
 @abstract immobView,提供使用SDK的接口。
 @author limei
 @version 2.9.0 2014/05/16 Creation
 */

#import <UIKit/UIKit.h>

extern NSString * const   accountname;     // 多帐号，用于区分APP用户


/*!
 @enum AdUnitIdType
 @abstract sdk所支持的广告类型
 @constant banner = 1, //banner 横幅广告
 @constant fullScreen=2, //全屏广告
 @constant offerWall = 3, //积分墙广告
 @constant interstitial=4  //插屏广告
 */

typedef enum  {
    banner = 1, //banner 横幅广告
    fullScreen=2, //全屏广告
    offerWall = 3, //积分墙广告
    interstitial=4  //插屏广告
    }AdUnitIdType;


@class immobView;

/*!
 @protocol
 @abstract 这个immobView类的一个protocol
 @discussion 用于实时通知immobview的一系列行为
 */

@protocol immobViewDelegate <NSObject>


@optional


/*!
 @method
 @abstract  用于实时回调通知当前的广告状态
 @discussion 用于实时回调通知当前的广告状态。
 @param immobView 当前的实例对象
 */
- (void) immobViewDidReceiveAd:(immobView*)immobView;
/*!
 @method
 @abstract  返回immobView执行过程中的error信息
 @discussion 用于实时回调通知当前的广告状态。
 @param immobView 当前的实例对象
 @param errorCode 服务器返回的错误码
 */
- (void) immobView: (immobView*) immobView didFailReceiveimmobViewWithError: (NSInteger) errorCode;

/*!
 @method
 @abstract  用于通知账户设置情况
 @discussion 用于通知账户设置情况,如果email账号未设置,此方法会被调用到。
 @param immobView 当前的实例对象
 */
- (void) emailNotSetupForAd:(immobView *)immobView;

/*!
 @method
 @abstract  积分查询回调方法
 @discussion 用于通知账户设置情况。
 @param score 积分总数
 @param message 错误信息
 */
- (void) immobViewQueryScore:(NSUInteger)score WithMessage:(NSString *)message;


/*!
 @method
 @abstract  积分减少回调方法
 @discussion 用于通知账户设置情况。
 @param status 状态返回 YES\NO
 @param message 错误信息
 */
- (void) immobViewReduceScore:(BOOL)status WithMessage:(NSString *)message;

/*!
 @method
 @abstract  广告从界面上移除或被关闭时被调用
 @discussion 广告从界面上移除或被关闭时被调用
 @param immobView 当前的实例对象
 */
- (void) onDismissScreen:(immobView *)immobView;

/*!
 @method
 @abstract  当广告调用一个新的页面并且会导致离开目前运行程序时被调用,如:打开appStore
 @discussion 当广告调用一个新的页面并且会导致离开目前运行程序时被调用,如:打开appStore
 @param immobView 当前的实例对象
 */
- (void) onLeaveApplication:(immobView *)immobView;


/*!
 @method
 @abstract  广告页面被创建或显示在覆盖在屏幕上面时调用本方法
 @discussion 广告页面被创建或显示在覆盖在屏幕上面时调用本方法
 @param immobView 当前的实例对象
 */
- (void) onPresentScreen:(immobView *)immobView;

@end

/*!
 @class
 @abstract immobView是展示广告的载体同时也是JS接口的实现类。
 @discussion immobView负责处理所有的广告逻辑。
 */

@interface immobView : UIView


/*!
 @property
 @abstract 在力美广告平台获取到的广告位ID,此ID为与广告平台通信的依据,注:此ID需审核通过后方可使用。广告位无效或关闭会报100021的错误。
 */
@property (nonatomic, retain) NSString *adUnitIdString;

/*!
 @property
 @abstract immobview 的Delegate,用于实现一些方法回调。
 */
@property (nonatomic, assign) id<immobViewDelegate> delegate;


/*!
 @property
 @abstract 主要针对多账户的应用程序,可以设置一些用户信息(比如：账户名称),以便于多账户之间积分的区分。
 */
@property (nonatomic, assign) NSMutableDictionary *UserAttribute;

/*!
 @property
 @abstract 此属性用于标识当前广告是否可用，用户可以根据当前广告的状态来决定当前广告是否显示,适用于插屏及全屏广告。
 */
@property (nonatomic, assign) BOOL isAdReady;


/*!
 @method
 @abstract  初始化immobView
 @discussion 用于immobView的初始化,需要把从广告平台申请的广告位作的参数传进去。
 @param adUnitId (NSString --required)从力美广告平台获取到的广告位
 @param type (AdUnitIdType --required)当前的广告类型，详情请参见AdUnitIdType
 @param rootVC (UIViewController --required)此参数为必选参数
 @param userinfo (NSDictionary --optional) 用户信息设置  @{accountname: @"user's id"}
 @result immobView的实例
 */
-(id)initWithAdUnitId:(NSString *)adUnitId adUnitType:(AdUnitIdType)type rootViewController:(UIViewController *)rootVC userInfo:(NSDictionary *)userinfo;


/*!
 @method
 @abstract 加载广告。
 @discussion  immobViewRequest方法被调用后,会开始加载广告内容并展示出来(插屏广告除外)。
 */
-(void)immobViewRequest;
/*!
 @method
 @abstract 用于展示广告。
 @discussion  immobViewDisplay被调用时,必须保证immobView在最上层,如不在最上层，会导致广告无法正常展示。
 */
-(void)immobViewDisplay;

/*!
 @method
 @abstract immobView的显示。
 @discussion 此方法与immobViewHide相对应。
 */
-(void)immobViewShow;
/*!
 @method
 @abstract immobView的隐藏。
 @discussion 此方法与immobViewShow相对应。
 */
-(void)immobViewHide;
/*!
 @method
 @abstract 此方法调用后,所有的广告逻辑，将被暂停。
 @discussion 此方法与immobViewOnResume相对应。
 */
-(void)immobViewOnPause;
/*!
 @method
 @abstract 此方法调用后,所有暂停的广告逻辑将会恢复正常运行。
 @discussion 此方法与immobViewOnPause相对应。
 */
-(void)immobViewOnResume;
/*!
 @method
 @abstract immobView的销毁。
 @discussion 此方法执行后,所有的广告逻辑将会停止，如果需要重新加载immobView,需要重新初始化对象。
 */
-(void)immobViewDestroy;


/*!
 @method
 @abstract  积分查询
 @discussion 根据传入的广告位ID,向服务器发起查询积分的请求,适用于单机媒体
 @param adUnitId （NSString--required） 广告位ID
 */
-(void)immobViewQueryScoreWithAdUnitID:(NSString *)adUnitId;
/*!
 @method
 @abstract 积分查询
 @discussion 根据传入的广告位ID,向服务器发起查询积分的请求,适用于需要用户登陆的媒体。
 @param adUnitId （NSString--required）广告位ID
 @param accountId （NSString--required）用户的账户,不可包含下划线
 */
-(void)immobViewQueryScoreWithAdUnitID:(NSString *)adUnitId WithAccountID:(NSString *)accountId;
/*!
 @method
 @abstract  积分减少
 @discussion 根据传入的广告位ID,及分数,向服务器发起减少积分的请求,适用于单机媒体
 @param score （NSInteger--required）要减少的分数
 @param adUnitId （NSString--required）广告位ID
 */
-(void)immobViewReduceScore:(NSInteger)score WithAdUnitID:(NSString *)adUnitId;
/*!
 @method
 @abstract  积分减少
 @discussion 根据传入的广告位ID,及分数,向服务器发起减少积分的请求,适用于需要用户登陆的媒体。
 @param score （NSInteger--required）要减少的分数。
 @param adUnitId （NSString--required）广告位ID
 @param accountId （NSString--required）用户的账户,不可包含下划线
 */
-(void)immobViewReduceScore:(NSInteger)score WithAdUnitID:(NSString *)adUnitId WithAccountID:(NSString *)accountId;

#pragma block method

/*!
 @method
 @abstract  获取当前广告位的状态。
 */
-(void)canOpen:(void (^)(BOOL isCanOpen)) handle;
/*!
 @method
 @abstract  查询积分。
 @discussion  根据传入的广告位，及用户唯一标识来查询服务上积分。
 @param adunitId （NSString--required）从力美广告平台获取到的广告位Id
 @param accountId （NSString--optional）用户的唯一标识，例如，网游类的用户登陆账号，如果没有可以为空:@"" 此参数与userAttribute中的accountname所对应的value值保持一致且不能包含下划线 "_"
 */
-(void)queryScoreWithAdunitId:(NSString *)adUnitId  accountId:(NSString *)accountId completionHandler:(void (^)(NSInteger score,NSString *message)) handle;

/*!
 @method
 @abstract  减少积分。
 @discussion  根据传入的广告位， 用户唯一标识及所要减少的积分数来减少服务上积分。
 @param adunitId （NSString--required）从力美广告平台获取到的广告位Id
 @param accountId （NSString--optional）用户的唯一标识，例如，网游类的用户登陆账号，如果没有可以为空:@"" 此参数与userAttribute中的accountname所对应的value值保持一致
 @param score （NSInteger--required）需要减少的积分数。注:score要大于0
 */
-(void)reduceScoreWithAdunitId:(NSString *)adUnitId  accountId:(NSString *)accountId  score:(NSInteger)score completionHandler:(void (^)(BOOL success,NSString *message)) handle;
 

@end
