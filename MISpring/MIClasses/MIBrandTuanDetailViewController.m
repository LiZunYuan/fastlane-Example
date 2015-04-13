//
//  MIBrandTuanDetailViewController.m
//  MISpring
//
//  Created by 曲俊囡 on 13-12-6.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIBrandTuanDetailViewController.h"
#import "MIAppDelegate.h"
#import "MIDeleteUILabel.h"
#import "MITemaiDetailGetModel.h"
#import "MIBrandRecModel.h"
#import "MIBrandViewController.h"
#import "MITbkMobileItemsConvertModel.h"
#import "MITbkConvertItemModel.h"
#import "MITuanRelateItemsCell.h"
#import "MITuanItemModel.h"

#pragma mark - MIProductItemInfoCell
@interface MIProductItemInfoCell : UITableViewCell

@property(nonatomic, strong) MIItemModel *item;
@property(nonatomic, strong) NSString *clickUrl;
@property(nonatomic, strong) UIImageView *itemImageView;
@property(nonatomic, strong) NSTimer *itemTimer;
@property(nonatomic, strong) RTLabel *itemTitleLabel;
@property(nonatomic, strong) RTLabel *itemPriceLabel;
@property(nonatomic, strong) MIDeleteUILabel *itemPriceOriLabel;
@property(nonatomic, strong) UILabel *itemPostageLabel;
@property (nonatomic, strong)UILabel *discountLabel;
@property (nonatomic, strong)UIView *line;

@end

@implementation MIProductItemInfoCell
@synthesize item;
@synthesize clickUrl;
@synthesize itemTimer;
@synthesize itemImageView;
@synthesize itemTitleLabel;
@synthesize itemPriceLabel;
@synthesize itemPriceOriLabel;
@synthesize itemPostageLabel;
@synthesize discountLabel;
@synthesize line;

- (id) initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        itemImageView = [[UIImageView alloc] initWithFrame: CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH / 320 * 280)];
        itemImageView.userInteractionEnabled = NO;
        itemImageView.clipsToBounds = YES;
        itemImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:itemImageView];
        
        
        itemPriceLabel = [[RTLabel alloc] initWithFrame: CGRectMake(12.5, SCREEN_WIDTH / 320 * 280 + 10, 100, 40)];
        itemPriceLabel.backgroundColor = [UIColor clearColor];
        itemPriceLabel.font = [UIFont boldSystemFontOfSize: 28];
        itemPriceLabel.textColor = [MIUtility colorWithHex:0xf73710];
        [self addSubview:itemPriceLabel];
        
        itemPriceOriLabel = [[MIDeleteUILabel alloc] init];
        itemPriceOriLabel.bounds = CGRectMake(0, 0, 40, 20);
        itemPriceOriLabel.backgroundColor = [UIColor clearColor];
        itemPriceOriLabel.textColor = [UIColor lightGrayColor];
        itemPriceOriLabel.font = [UIFont systemFontOfSize: 12];
        itemPriceOriLabel.strikeThroughEnabled = YES;
        [self addSubview:itemPriceOriLabel];
        
        discountLabel = [[UILabel alloc]init];
        discountLabel.bounds = CGRectMake(0, 0, 30, 16);
        discountLabel.layer.backgroundColor = [MIUtility colorWithHex:0x8dbb1a].CGColor;
        discountLabel.textColor = [MIUtility colorWithHex:0xffffff];
        discountLabel.font = [UIFont systemFontOfSize:10];
        discountLabel.textAlignment = NSTextAlignmentCenter;
        discountLabel.layer.cornerRadius = 3;
        [self addSubview:discountLabel];
        
        itemPostageLabel = [[UILabel alloc] init];
        itemPostageLabel.bounds = CGRectMake(0, 0, 30, 16);
        itemPostageLabel.layer.backgroundColor = [MIUtility colorWithHex:0xfda24a].CGColor;
        itemPostageLabel.font = [UIFont systemFontOfSize: 10];
        itemPostageLabel.textColor = [MIUtility colorWithHex:0xffffff];
        itemPostageLabel.layer.cornerRadius = 3;
        itemPostageLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:itemPostageLabel];
        
        line = [[UIView alloc]initWithFrame:CGRectMake(10, SCREEN_WIDTH / 320 * 280 + 50, SCREEN_WIDTH - 20, 0.6)];
        line.backgroundColor = [MIUtility colorWithHex:0xe5e5e5];
        [self addSubview:line];
        
        itemTitleLabel = [[RTLabel alloc] initWithFrame:CGRectMake(10, SCREEN_WIDTH / 320 * 280 + 60, SCREEN_WIDTH - 20, MAXFLOAT)];
        itemTitleLabel.backgroundColor = [UIColor clearColor];
        itemTitleLabel.font = [UIFont systemFontOfSize:13.0];
        itemTitleLabel.textColor = [MIUtility colorWithHex:0x333333];
        [self addSubview:itemTitleLabel];
    }
    
    return self;
}
@end

#pragma mark - MIBrandShuoCell
@interface MIBrandShuoCell:UITableViewCell

@property(nonatomic, strong) RTLabel * shuoLabel;
@end

@implementation MIBrandShuoCell
@synthesize shuoLabel;

- (id) initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.6)];
        line1.backgroundColor = [MIUtility colorWithHex:0xe5e5e5];
        [self addSubview:line1];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, line1.bottom, SCREEN_WIDTH, 8)];
        lineView.backgroundColor = [MIUtility colorWithHex:0xeeeeee];
        [self addSubview:lineView];
        
        shuoLabel = [[RTLabel alloc] initWithFrame:CGRectMake(10, 18, SCREEN_WIDTH - 20, MAXFLOAT)];
        shuoLabel.lineBreakMode = RTTextLineBreakModeCharWrapping;
        shuoLabel.backgroundColor = [UIColor clearColor];
        shuoLabel.font = [UIFont systemFontOfSize:12.0];
        shuoLabel.textColor = [MIUtility colorWithHex:0x666666];
        [self addSubview:shuoLabel];
    }
    
    return self;
}

@end



#pragma mark - MIBrandTuanDetailViewController
typedef enum {
    NormalType,
    LowerFiveMinuteType,
}FavorBtnType;

@interface MIBrandTuanDetailViewController ()
{
    MIUserFavorItemAddRequest *_itemAddRequest;
    MIUserFavorItemDeleteRequest *_itemDeleteRequest;
}

@property (nonatomic,strong)MIProductItemInfoCell *productItemInfocell;
@property (nonatomic,strong)MIBrandShuoCell *shuoCell;
@property (nonatomic,assign)BOOL isAddFavor;
@property (nonatomic,strong)NSMutableArray *itemFavorArray;
@property (nonatomic,strong)UIButton *favorBtn;
@property(nonatomic, assign) FavorBtnType favorBtnType;

@end

@implementation MIBrandTuanDetailViewController

- (id) initWithItem: (MIItemModel *) model placeholderImage:(UIImage *)placeholder{
    self = [super init];
    if (self != nil) {
        self.item = model;
        self.iid = model.numIid.stringValue;
        self.placeholderImage = placeholder;
        
        //DetailRequestRequest
        __weak typeof(self) weakSelf = self;
        _request = [[MITemaiDetailGetRequest alloc] init];
        _request.onCompletion = ^(MITemaiDetailGetModel *model) {
            [weakSelf finishLoadTableViewData:model];
        };
        _request.onError = ^(MKNetworkOperation* completedOperation, MIError* error) {
            if (!weakSelf.item)
            {
                [weakSelf setOverlayStatus:EOverlayStatusReload labelText:nil];
            }
            MILog(@"error_msg=%@",error.description);
        };
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationBar setBarTitle:@"独家品牌特卖"];
    
    self.bottomToolBar = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.viewHeight - 44, self.view.viewWidth, 44)];
    self.bottomToolBar.backgroundColor = [UIColor whiteColor];
    self.bottomToolBar.alpha = 0;
    [self.view addSubview:self.bottomToolBar];
    
    
    self.bgView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 120, 44)];
    self.bgView1.backgroundColor = [UIColor clearColor];
    [self.bottomToolBar addSubview:self.bgView1];
    
    self.leftTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(12.5, 3, 120, 20)];
    self.leftTimeLabel.backgroundColor = [UIColor clearColor];
    self.leftTimeLabel.font = [UIFont systemFontOfSize:11];
    self.leftTimeLabel.textColor = [MIUtility colorWithHex:0x333333];
    self.leftTimeLabel.textAlignment = NSTextAlignmentLeft;
    [self.bgView1 addSubview:self.leftTimeLabel];
    
    self.customerLabel = [[RTLabel alloc]initWithFrame:CGRectMake(12.5, 23, 120, 20)];
    self.customerLabel.backgroundColor = [UIColor clearColor];
    self.customerLabel.font = [UIFont systemFontOfSize:12];
    self.customerLabel.textAlignment = NSTextAlignmentLeft;
    [self.bgView1 addSubview:self.customerLabel];
    
    self.customerLabel2 = [[RTLabel alloc]initWithFrame:CGRectMake(12.5, 17, 120, 20)];
    self.customerLabel2.backgroundColor = [UIColor clearColor];
    self.customerLabel2.font = [UIFont systemFontOfSize:12];
    self.customerLabel2.textAlignment = NSTextAlignmentLeft;
    [self.bottomToolBar addSubview:self.customerLabel2];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, PHONE_SCREEN_SIZE.width, 0.6)];
    line.backgroundColor = [MIUtility colorWithHex:0xe5e5e5];
    [self.bottomToolBar addSubview:line];
    self.PurchaseLabel = [[UILabel alloc]initWithFrame:CGRectMake(PHONE_SCREEN_SIZE.width -10 -123, 4, 123, 36)];
    self.PurchaseLabel.font = [UIFont systemFontOfSize:18];
    self.PurchaseLabel.textColor = [MIUtility colorWithHex:0xffffff];
    self.PurchaseLabel.textAlignment = NSTextAlignmentCenter;
    self.PurchaseLabel.layer.cornerRadius = 3;
    self.PurchaseLabel.clipsToBounds = YES;
    self.PurchaseLabel.userInteractionEnabled = YES;
    [self.bottomToolBar addSubview:self.PurchaseLabel];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToBuyAction)];
    [self.PurchaseLabel addGestureRecognizer:tap];
    
    
    self.baseTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.navigationBarHeight, PHONE_SCREEN_SIZE.width, self.view.viewHeight - self.navigationBarHeight) style:UITableViewStylePlain];
    _baseTableView.showsVerticalScrollIndicator = NO;
    _baseTableView.backgroundColor = [UIColor whiteColor];
    _baseTableView.dataSource = self;
    _baseTableView.delegate = self;
    self.baseTableView.alpha = 0;
    self.baseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view sendSubviewToBack:self.baseTableView];
    
    self.productItemInfocell = [[MIProductItemInfoCell alloc] initWithReuseIdentifier:@"productItemInfocell"];
    if (self.item) {
        NSString *imgUrl;
        if([[Reachability reachabilityForInternetConnection] isReachableViaWiFi]){
            imgUrl = [[NSString alloc] initWithFormat:@"%@_670x670.jpg", self.item.img];
        } else {
            imgUrl = [[NSString alloc] initWithFormat:@"%@_310x310.jpg", self.item.img];
        }
        [self.productItemInfocell.itemImageView sd_setImageWithURL:[NSURL URLWithString: imgUrl] placeholderImage:self.placeholderImage];
    }
    
    self.shuoCell = [[MIBrandShuoCell alloc] initWithReuseIdentifier: @"shopShuoCellIdentifier"];
    
    __weak typeof(self) weakSelf = self;
    
    _itemDeleteRequest = [[MIUserFavorItemDeleteRequest alloc] init];
    _itemDeleteRequest.onCompletion = ^(MIUserFavorItemDeleteModel *model) {
        if (model.success.boolValue)
        {
            [weakSelf showSimpleHUD:@"开抢提醒已关闭，你可能会错过哦~" afterDelay:1];
            weakSelf.isAddFavor = NO;
            [weakSelf.itemFavorArray removeObject:weakSelf.item.brandId];
            [[NSUserDefaults standardUserDefaults] setObject:weakSelf.itemFavorArray forKey:kItemFavorListDefaults];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [weakSelf.favorBtn setImage:[UIImage imageNamed:@"ic_xiangqing_remind"] forState:UIControlStateNormal];
//            NSDate *date = [NSDate dateWithTimeIntervalSince1970:weakSelf.startTime.integerValue];
//            NSString *time = [date stringForTimeline2];
//            [weakSelf.favorBtn setTitle:[NSString stringWithFormat:@"%@开抢",time] forState:UIControlStateNormal];
            [weakSelf.favorBtn setTitle:@"添加提醒" forState:UIControlStateNormal];
            weakSelf.favorBtn.backgroundColor = [MIUtility colorWithHex:0x8dbb1a];
        }
        else
        {
            weakSelf.isAddFavor = YES;
            [weakSelf showSimpleHUD:@"取消开抢提醒失败" afterDelay:1];
        }
    };
    
    _itemDeleteRequest.onError = ^(MKNetworkOperation* completedOperation, MIError* error) {
        MILog(@"error_msg=%@",error.description);
    };
    
    _itemAddRequest = [[MIUserFavorItemAddRequest alloc] init];
    _itemAddRequest.onCompletion = ^(MIUserFavorItemAddModel *model) {
        if (model.success.boolValue)
        {
            [MobClick event:kFavorClick];
            [weakSelf showSimpleHUD:@"开抢提醒已添加" afterDelay:1];
            [weakSelf.itemFavorArray addObject:weakSelf.item.brandId];
            [[NSUserDefaults standardUserDefaults] setObject:weakSelf.itemFavorArray forKey:kItemFavorListDefaults];
            [[NSUserDefaults standardUserDefaults] synchronize];
            weakSelf.isAddFavor = YES;
            [weakSelf.favorBtn setImage:[UIImage imageNamed:@"ic_xiangqing_remind_select"] forState:UIControlStateNormal];
            [weakSelf.favorBtn setTitle:@"已加提醒" forState:UIControlStateNormal];
            weakSelf.favorBtn.backgroundColor = [MIUtility colorWithHex:0xbebebe];
            
            NSNumber *alertTime = [[NSUserDefaults standardUserDefaults] objectForKey: kBrandFavorBeginTimeDefaults];
            double nowInterval = [[NSDate date] timeIntervalSince1970] + [MIConfig globalConfig].timeOffset;
            
            if ( weakSelf.item && weakSelf.item.startTime && weakSelf.item.startTime.integerValue > nowInterval && (alertTime.integerValue > weakSelf.item.startTime.integerValue || alertTime == nil))
            {
                [MIUtility setLocalNotificationWithType:APP_LOCAL_NOTIFY_ACTION_PRODUCT_START_ALARM alertBody:@"你的开抢提醒单品已经开抢了" at:weakSelf.item.startTime.integerValue];
                [[NSUserDefaults standardUserDefaults] setObject:@(weakSelf.item.startTime.integerValue) forKey:kItemFavorBeginTimeDefaults];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        }
        else if([model.data isEqualToString:@"out_of_limit"])
        {
            weakSelf.isAddFavor = NO;
            MIButtonItem *affirmItem = [MIButtonItem itemWithLabel:@"整理开抢提醒"];
            affirmItem.action = ^{
                MIUserFavorViewController *vc = [[MIUserFavorViewController alloc] init];
                vc.type = ItemType;
                [[MINavigator navigator] openPushViewController:vc animated:YES];
            };
            MIButtonItem *affirmItem2 = [MIButtonItem itemWithLabel:@"取消"];
            affirmItem2.action = ^{
            };
            [[[UIAlertView alloc] initWithTitle:@"提示" message:model.message cancelButtonItem:affirmItem2 otherButtonItems:affirmItem, nil] show];
        }
        else
        {
            weakSelf.isAddFavor = NO;
            [weakSelf showSimpleHUD:model.message afterDelay:1];
        }
    };
    
    _itemAddRequest.onError = ^(MKNetworkOperation* completedOperation, MIError* error) {
        MILog(@"error_msg=%@",error.description);
    };
    
    _favorBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _favorBtn.frame = CGRectMake(0, 0, 123, 36);
    _favorBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    _favorBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _favorBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 13, 0, 0);
    _favorBtn.backgroundColor = [MIUtility colorWithHex:0x8dbb1a];
    [_favorBtn addTarget:self action:@selector(favorBtnClick) forControlEvents:UIControlEventTouchUpInside];
    _favorBtn.hidden = YES;
}

- (void)goToBuyAction
{
    if ([self.PurchaseLabel.text isEqualToString:@"即将开始"]) {
        [MINavigator showSimpleHudWithTips:self.customerLabel2.text];
    } else if ([self.PurchaseLabel.text isEqualToString:@"去抢购"]) {
        if ([[MIMainUser getInstance] checkLoginInfo]) {
            [self goShopping];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithLoginAction:^{
                [self goShopping];
            }];
            [alertView show];
        }
    } else {
        NSString *tips = [NSString stringWithFormat:@"来晚啦，特卖%@", self.PurchaseLabel.text];
        [MINavigator showSimpleHudWithTips:tips];
    }
}

- (void)goShopping
{
    [MobClick event:kBrandItemGoBuys];
    [MIUtility setMuyingTag:@"muying" key:self.cat];
    [MIUtility clickEventWithLog:@"brand" cid:self.item.brandId.stringValue s:@"1"];
    
    [XGPush setTag:@"抢购商品"];
    [XGPush delTag:@"激活未抢购"];
    
    if ([MIConfig globalConfig].notificationSource) {
        [MobClick event:kNotifyTuanBuyClicks];
    }
    
    NSNumber *time1 = [NSNumber numberWithInteger:[[NSUserDefaults standardUserDefaults] integerForKey:kActiveTime]];
    NSNumber *time2 = [NSNumber numberWithInteger:[[NSDate date] timeIntervalSince1970]];
    if ([time1 isSameDay:time2]) {
        [MobClick event:@"kNowGoBuys"];
    }
    
    NSURL *itemURL = [NSURL URLWithString:[NSString stringWithFormat:[MIConfig globalConfig].tbUrl, self.item.numIid]];;
    MITbWebViewController *webVC = [[MITbWebViewController alloc] initWithURL:itemURL];
    webVC.tag = @"br";
    webVC.numiid = self.item.numIid.stringValue;
    webVC.brandNumiid = self.item.numIid.stringValue;
    webVC.origin = self.item.origin.integerValue;
//    webVC.tips = self.item.tip;
    webVC.productTitle = self.item.title;
    [webVC setWebTitle:@"购买商品"];
    [[MINavigator navigator] openPushViewController:webVC animated:YES];
}

- (void)startTimer
{
    [self stopTimer];
    if (self.item.startTime && self.item.endTime) {
        self.itemTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(handleTimer:) userInfo:nil repeats:YES];;
        [self.itemTimer fire];
    }
}

- (void)stopTimer
{
    if (self.itemTimer) {
        [self.itemTimer invalidate];
        self.itemTimer = nil;
    }
}

- (void)handleTimer: (NSTimer *) timer
{
    double nowInterval = [[NSDate date] timeIntervalSince1970] + [MIConfig globalConfig].timeOffset;
    NSInteger interval = self.item.startTime.doubleValue - nowInterval;
    NSInteger endInterval = self.item.endTime.doubleValue - nowInterval;
    _favorBtn.hidden = YES;
    if (interval > 0) {
        // 还没有开始抢购
        self.bgView1.hidden = YES;
        
        if ([self isRemindTime:self.item.startTime.integerValue])
        {
            if (interval < 5 * 60)
            {
                self.favorBtnType = LowerFiveMinuteType;
            }
            else
            {
                self.favorBtnType = NormalType;
            }
            _favorBtn.hidden = NO;
        }
        else
        {
            _favorBtn.hidden = YES;
        }
        
        self.PurchaseLabel.text = @"即将开始";
        self.PurchaseLabel.backgroundColor = [MIUtility colorWithHex:0x8dbb1a];
        NSInteger days = interval /60/60/24;
        NSInteger hours = (interval - days * 3600 * 24)/ 60 / 60;
        NSInteger minutes = interval / 60 % 60;
        NSInteger seconds = interval % 60;
        if (days == 0)
        {
            self.customerLabel2.text = [[NSString alloc] initWithFormat:@"%.2ld:%.2ld:%.2ld后开抢", (long)hours, (long)minutes, (long)seconds];
        }
        else if (days>0)
        {
            self.customerLabel2.text = [[NSString alloc] initWithFormat:@"%ld天%.2ld:%.2ld:%.2ld后开抢", (long)days, (long)hours, (long)minutes, (long)seconds];
        }
        self.customerLabel2.textColor = [MIUtility colorWithHex:0x333333];
    }
    else if (endInterval < 0)
    {
        //已经结束
        self.customerLabel2.hidden = YES;
        self.leftTimeLabel.text = @"特卖已结束";
        self.customerLabel.text = [NSString stringWithFormat:@"<font color='#599E07'>%@</font><font color='#666666'>人已抢</font>",self.item.clicks];
        self.PurchaseLabel.text = @"已结束";
        self.PurchaseLabel.backgroundColor = [MIUtility colorWithHex:0x999999];
        [self stopTimer];
    }
    else
    {
        if (self.item.status.integerValue != 1) {
            // 抢光了
            self.customerLabel2.hidden = YES;
            self.leftTimeLabel.text = @"特卖已抢光";
            self.customerLabel.text = [NSString stringWithFormat:@"<font color='#599E07'>%@</font><font color='#666666'>人已抢</font>",self.item.clicks];
            self.PurchaseLabel.text = @"抢光了";
            self.PurchaseLabel.backgroundColor = [MIUtility colorWithHex:0x999999];
            [self stopTimer];
        }
        else
        {
            //没抢光 没结束
            self.customerLabel2.hidden = YES;
            self.PurchaseLabel.backgroundColor = [MIUtility colorWithHex:0xf73710];
            self.PurchaseLabel.text = @"去抢购";
            self.customerLabel.text = [NSString stringWithFormat:@"<font color='#599E07'>%@</font><font color='#666666'>人在抢</font>",self.item.clicks];
            
           // NSInteger interval1 = [MIUtility calcIntervalWithEndTime:endInterval andNowTime:nowInterval];
            NSInteger day = endInterval / 60 / 60 / 24;
            NSInteger hour = endInterval%(60 * 60 * 24)/60/60;
            NSInteger minute = endInterval%(60*60)/60;
            NSInteger second = endInterval % 60;

            self.leftTimeLabel.text = [[NSString alloc] initWithFormat:@"剩%ld天%.2ld:%.2ld:%.2ld",(long)day,(long)hour,(long)minute,(long)second];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self startTimer];
    if (!self.recommendArray) {
        [self setOverlayStatus:EOverlayStatusLoading labelText:nil];
        [_request sendQuery];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self stopTimer];
    [_request cancelRequest];
}

- (void)favorBtnClick
{
    if (![[MIMainUser getInstance] checkLoginInfo])
    {
        [MINavigator openLoginViewController];
        return;
    }
    if (self.favorBtnType == NormalType)
    {
        self.isAddFavor = !self.isAddFavor;
        if (self.isAddFavor)
        {
            [_itemAddRequest setIid:self.item.brandId];
            [_itemAddRequest sendQuery];
        }
        else
        {
            [_itemDeleteRequest setIids:[NSString stringWithFormat:@"%@",self.item.brandId]];
            [_itemDeleteRequest sendQuery];
        }
    }
    else
    {
        [self showSimpleHUD:@"时间快到了哦，做好准备抢购吧！" afterDelay:1];
    }
}

- (void)goShareAction
{
    [MobClick event:kTaobaoDetailShareClicks];
    NSString *url = [NSString stringWithFormat:@"http://brand.mizhe.com/shop/%@.html#%@", self.item.encryptAid, self.item.encryptBid];
    NSString *title = self.item.title;
    
    NSString *desc = [NSString stringWithFormat:@"只要%@元，刚刚在@米折网 看到这个宝贝，好心动！全场包邮，超划算的！推荐你也去看看！",self.item.price.priceValue];
    NSString *comment = [NSString stringWithFormat:@"只要%@元，刚刚在@米折网 看到这个宝贝，好心动！全场包邮，超划算的！推荐你也去看看！",self.item.price.priceValue];
    NSString *smallImg = [[NSString alloc] initWithFormat:@"%@_100x100.jpg", self.item.img];
    NSString *largeImg = [[NSString alloc] initWithFormat:@"%@_670x670.jpg", self.item.img];
    [MINavigator showShareActionSheetWithUrl:url title:title desc:desc comment:comment image:self.productItemInfocell.itemImageView smallImg:smallImg largeImg:largeImg inView:self.view platform:@"qq_qzone_weixin_timeline_weibo_copy_gohome"];
}

#pragma mark - EGOPullFresh methods
- (void)reloadTableViewDataSource
{
    if (self.loading) {
        [_request cancelRequest];
    }
    
    self.loading = YES;
    [self setOverlayStatus:EOverlayStatusLoading labelText:nil];
    
    [_request sendQuery];
}
- (void)finishLoadTableViewData:(MITemaiDetailGetModel *)model
{
    if (!self.item)
    {
        self.item = [[MIItemModel alloc] init];
    }
    [self.navigationBar setBarRightButtonItem:self selector:@selector(goShareAction) imageKey:@"mi_navbar_share_img"];

    self.item.aid = model.aid;
    self.item.brandId = model.brandId;
    self.item.recomWords = model.brandDesc;
    self.item.title = model.title;
    self.item.img = model.img;
    self.item.numIid = model.numIid;
    self.item.status = model.status;
    self.item.postageType = model.postageType;
    self.item.price = model.price;
    self.item.priceOri = model.priceOri;
    self.item.discount = model.discount;
    self.item.cid = model.cid;
    self.item.stock = model.stock;
    self.item.clicks = model.clicks;
    self.item.origin = model.origin;
    self.item.startTime = [NSString stringWithFormat:@"%@",model.startTime];
    self.item.endTime = [NSString stringWithFormat:@"%@",model.endTime];
    self.item.encryptAid = model.encryptAid;
    self.item.encryptBid = model.encryptBid;
    
    self.recommendArray = model.brandItemsRecs;
    for (MIBrandRecModel *model in _recommendArray) {
        model.origin = self.item.origin;
    }
    
    self.startTime = model.startTime;
    
    [self setOverlayStatus:EOverlayStatusRemove labelText:nil];
    [self updateRecomWordsWithString:model.brandDesc];
    [self setProductItemInfo];
    
    if ([self isRemindTime:model.startTime.integerValue])
    {
        NSArray *favorArray = [[NSUserDefaults standardUserDefaults] objectForKey:kItemFavorListDefaults];
        _itemFavorArray = [[NSMutableArray alloc] initWithArray:favorArray];
        self.favorBtn.hidden = NO;
        if ([_itemFavorArray containsObject:self.item.brandId])
        {
            [_favorBtn setImage:[UIImage imageNamed:@"ic_xiangqing_remind_select"] forState:UIControlStateNormal];
            _favorBtn.backgroundColor = [MIUtility colorWithHex:0xbebebe];
            [_favorBtn setTitle:@"已加提醒" forState:UIControlStateNormal];
            [_favorBtn setTitleColor:[MIUtility colorWithHex:0xececec] forState:UIControlStateNormal];
            self.isAddFavor = YES;
        }
        else
        {
//            NSDate *date = [NSDate dateWithTimeIntervalSince1970:model.startTime.integerValue];
//            NSString *time = [date stringForTimeline2];
            _favorBtn.backgroundColor = [MIUtility colorWithHex:0x8dbb1a];
            [_favorBtn setImage:[UIImage imageNamed:@"ic_xiangqing_remind"] forState:UIControlStateNormal];
//            [_favorBtn setTitle:[NSString stringWithFormat:@"%@开抢",time] forState:UIControlStateNormal];
            [_favorBtn setTitle:@"添加提醒" forState:UIControlStateNormal];
            self.isAddFavor = NO;
        }
        [self.PurchaseLabel addSubview:_favorBtn];
    }
    else
    {
        self.favorBtn.hidden = YES;
    }

    [self startTimer];
    [self.baseTableView reloadData];
    self.bottomToolBar.alpha = 1;
    self.baseTableView.alpha = 1;

}

- (BOOL)isRemindTime:(NSInteger)time
{
    NSInteger nowInterval = [[NSDate date] timeIntervalSince1970] + [MIConfig globalConfig].timeOffset;
    return time > nowInterval;
}

- (void)updateRecomWordsWithString:(NSString *)aString
{
    if (0 != [[aString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length])
    {
        self.brandDes = aString;
    } else {
        self.brandDes = @"掌柜太懒了，什么都没说";
    }
}
#pragma mark - UITabelView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.item == nil) {
        return 0;
    }
    return 3;
}

-(void)setProductItemInfo
{
    self.productItemInfocell.item = self.item;
    NSString *imgUrl;
    if([[Reachability reachabilityForInternetConnection] isReachableViaWiFi]){
        imgUrl = [[NSString alloc] initWithFormat:@"%@_670x670.jpg", self.item.img];
    } else {
        imgUrl = [[NSString alloc] initWithFormat:@"%@_310x310.jpg", self.item.img];
    }
    [self.productItemInfocell.itemImageView sd_setImageWithURL:[NSURL URLWithString: imgUrl] placeholderImage:self.placeholderImage];
    
    NSString *desc = [self.item.title stringByReplacingOccurrencesOfString:@"【" withString:@"["];
    desc = [desc stringByReplacingOccurrencesOfString:@"，" withString:@","];
    NSString *original = [desc stringByReplacingOccurrencesOfString:@"】" withString:@"]"];
    
    double nowInterval = [[NSDate date] timeIntervalSince1970] + [MIConfig globalConfig].timeOffset;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.item.startTime.doubleValue];
    NSString *dateStr = [date stringForYymmdd];
    NSDate *nowDate = [NSDate dateWithTimeIntervalSince1970:nowInterval];
    NSString *nowStr = [nowDate stringForYymmdd];
    
    NSString *str = @"<font color=#f73710 size=13>今日特卖 </font>";
    NSString *appended = [str stringByAppendingString:original];
    
    if ([dateStr isEqualToString:nowStr])
    {
        self.productItemInfocell.itemTitleLabel.text = appended;
    }
    else{
        self.productItemInfocell.itemTitleLabel.text = original;
    }
    self.productItemInfocell.itemTitleLabel.viewHeight = ceilf(self.productItemInfocell.itemTitleLabel.optimumSize.height);
    self.productItemInfocell.itemTitleLabel.top = SCREEN_WIDTH / 320 * 280 + 60;
    
    self.productItemInfocell.itemPriceLabel.text = [NSString stringWithFormat:@"<font size=28.0>￥</font>%@", self.item.price.priceValue];
    CGSize expectedSize = self.productItemInfocell.itemPriceLabel.optimumSize;
    self.productItemInfocell.itemPriceLabel.viewWidth = ceilf(expectedSize.width);
    self.productItemInfocell.itemPriceLabel.viewHeight = ceilf(expectedSize.height);
    
    self.productItemInfocell.itemPriceOriLabel.left = self.productItemInfocell.itemPriceLabel.right + 5;
    self.productItemInfocell.itemPriceOriLabel.text = [NSString stringWithFormat:@"￥%@",self.item.priceOri.priceValue];
    CGSize size = [self.productItemInfocell.itemPriceOriLabel.text sizeWithFont:self.productItemInfocell.itemPriceOriLabel.font constrainedToSize:CGSizeMake(200, 20)];
    self.productItemInfocell.itemPriceOriLabel.viewWidth = size.width;
    self.productItemInfocell.itemPriceOriLabel.bottom = self.productItemInfocell.itemPriceLabel.bottom -2;
    self.productItemInfocell.discountLabel.text = [NSString stringWithFormat:@"%.1f折",self.item.discount.floatValue/10];
    CGSize size1 = [self.productItemInfocell.discountLabel.text sizeWithFont:self.productItemInfocell.discountLabel.font constrainedToSize:CGSizeMake(100, 20)];
    self.productItemInfocell.discountLabel.viewWidth = size1.width + 10;
    self.productItemInfocell.discountLabel.left = self.productItemInfocell.itemPriceOriLabel.right + 10;
    self.productItemInfocell.discountLabel.bottom = self.productItemInfocell.itemPriceLabel.bottom -5;
    if (self.item.postageType.integerValue == 0)
    {
        self.productItemInfocell.itemPostageLabel.text = @"不包邮";
    }
    else if (self.item.postageType.integerValue == 1)
    {
        self.productItemInfocell.itemPostageLabel.text = @"全国包邮";
    }
    else
    {
        self.productItemInfocell.itemPostageLabel.text = @"大部分地区包邮";
    }
    CGSize size2 = [self.productItemInfocell.itemPostageLabel.text sizeWithFont:self.productItemInfocell.itemPostageLabel.font constrainedToSize:CGSizeMake(100, 16)];
    self.productItemInfocell.itemPostageLabel.viewWidth = size2.width + 10;
    self.productItemInfocell.itemPostageLabel.left = self.productItemInfocell.discountLabel.right + 5;
    self.productItemInfocell.itemPostageLabel.bottom = self.productItemInfocell.itemPriceLabel.bottom - 5;
    self.shuoCell.shuoLabel.text = [[NSString alloc] initWithFormat:@"<font size=12.0 color='#b16f7b'>品牌说：</font>%@", self.brandDes];;
    [self.baseTableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *tuanRelateCellIdentifier = @"tuanRelateCellIdentifier";

    if (indexPath.row == 0) {
        return self.productItemInfocell;
    } else if (indexPath.row == 1){
        
        if (self.brandDes) {
            self.shuoCell.shuoLabel.text = [[NSString alloc] initWithFormat:@"<font size=12.0 color='#b16f7b'>品牌说：</font>%@", self.brandDes];;
            self.shuoCell.shuoLabel.viewHeight = ceilf(self.shuoCell.shuoLabel.optimumSize.height);
            self.shuoCell.shuoLabel.top = 18;
        }
        
        return self.shuoCell;
    } else if (indexPath.row == 2) {
        MITuanRelateItemsCell *cell = [tableView dequeueReusableCellWithIdentifier: tuanRelateCellIdentifier];
        if (cell == nil) {
            cell = [[MITuanRelateItemsCell alloc] initWithReuseIdentifier:tuanRelateCellIdentifier];
            cell.type = BrandType;
        }
        
        if (self.recommendArray) {
            cell.tuanItems = self.recommendArray;
            for (NSInteger i = 0; i < self.recommendArray.count && i < 6; i++)
            {
                @try {
                    MITuanItemModel *model = (MITuanItemModel *)[cell.tuanItems objectAtIndex:i];
                    cell.titleLabel.text = @"正在热卖品牌";
                    NSString *imgUrl = [[NSString alloc] initWithFormat:@"%@_120x120.jpg", model.img];
                    UIImageView *imageView = [cell.images objectAtIndex:i];
                    [imageView sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"default_avatar_img"]];
                    UILabel *priceLabel = (UILabel *)[cell.prices objectAtIndex:i];
                    priceLabel.text = [NSString stringWithFormat:@"￥%@",model.price.priceValue];
                    CGSize expectedSize = [priceLabel.text sizeWithFont:priceLabel.font constrainedToSize:CGSizeMake(1000, 15)];
                    priceLabel.viewWidth = expectedSize.width + 5;
                    MIDeleteUILabel *priceOriLabel = (MIDeleteUILabel *)[cell.priceOris objectAtIndex:i];
                    priceOriLabel.text = model.discount.discountValue;
                    priceOriLabel.strikeThroughEnabled = NO;
                    expectedSize = [priceOriLabel.text sizeWithFont:priceOriLabel.font constrainedToSize:CGSizeMake(1000, 15)];
                    priceOriLabel.viewWidth = expectedSize.width;
                    priceOriLabel.left = priceLabel.right;
                    imageView = [cell.temaiImages objectAtIndex:i];
                    imageView.hidden = NO;
                }
                @catch (NSException *exception) {
                    MILog(@"tuan item is out of indexs");
                }
            }
        }
        
        return cell;
    } else {
        return nil;

    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return ceilf(self.productItemInfocell.itemTitleLabel.optimumSize.height) + SCREEN_WIDTH / 320 * 280 + 70;
    } else if (indexPath.row == 1){
        return ceilf(self.shuoCell.shuoLabel.optimumSize.height) + 28;
    } else {
        return SCREEN_WIDTH / 320 * 105 * 2 + 56 + 50;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
