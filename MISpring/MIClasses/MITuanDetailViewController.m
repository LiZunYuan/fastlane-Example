//
//  MITuanDetailViewController.m
//  MISpring
//
//  Created by 徐 裕健 on 13-10-30.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MITuanDetailViewController.h"
#import "MIDeleteUILabel.h"
#import "MITuanRelateItemsCell.h"
#import "MWPhoto.h"
#import "MWPhotoBrowser.h"


#pragma mark - MITuanItemInfoCell
@interface MITuanItemInfoCell : UITableViewCell

@property(nonatomic, strong) MITuanItemModel *item;
@property(nonatomic, strong) UIImageView *itemImageView;
@property(nonatomic, strong) UILabel *itemTimeLabel;
@property(nonatomic, strong) UILabel *itemViewsLabel;
@property(nonatomic, strong) RTLabel *itemTitleLabel;
@property(nonatomic, strong) UILabel *itemPriceLabel;
@property(nonatomic, strong) MIDeleteUILabel *itemPriceOriLabel;
@property(nonatomic, strong) UILabel *itemPostageLabel;
@property(nonatomic, strong) UILabel *itemBuyLabel;
@property(nonatomic, strong) UILabel *discountLabel;
@property(nonatomic, strong) UIView *line;

@end

@implementation MITuanItemInfoCell
@synthesize item;
@synthesize itemTimeLabel;
@synthesize itemViewsLabel;
@synthesize itemImageView;
@synthesize itemTitleLabel;
@synthesize itemPriceLabel;
@synthesize itemPriceOriLabel;
@synthesize itemPostageLabel;
@synthesize itemBuyLabel;
@synthesize discountLabel;
@synthesize line;

- (id) initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        itemImageView = [[UIImageView alloc] initWithFrame: CGRectMake(0, 0, SCREEN_WIDTH, 280)];
        itemImageView.userInteractionEnabled = NO;
        itemImageView.clipsToBounds = YES;
        itemImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:itemImageView];
        
        itemPriceLabel = [[UILabel alloc] init];
        itemPriceLabel.frame = CGRectMake(12, 280+16, 100, 28);
        itemPriceLabel.backgroundColor = [UIColor clearColor];
        itemPriceLabel.font = [UIFont boldSystemFontOfSize: 28];
        itemPriceLabel.textColor = [MIUtility colorWithHex:0xff3d00];
        [self addSubview:itemPriceLabel];
        
        itemPriceOriLabel = [[MIDeleteUILabel alloc] init];
        itemPriceOriLabel.bounds = CGRectMake(0, 0, 40, 20);
        itemPriceOriLabel.backgroundColor = [UIColor clearColor];
        itemPriceOriLabel.textColor = [MIUtility colorWithHex:0x999999];
        itemPriceOriLabel.font = [UIFont systemFontOfSize: 12];
        itemPriceOriLabel.strikeThroughEnabled = YES;
        [self addSubview:itemPriceOriLabel];
        
        discountLabel = [[UILabel alloc]init];
        discountLabel.bounds = CGRectMake(0, 0, 30, 16);
        discountLabel.layer.backgroundColor = [MIUtility colorWithHex:0x8dbb1a].CGColor;
        discountLabel.textColor = [MIUtility colorWithHex:0xffffff];
        discountLabel.font = [UIFont systemFontOfSize:10];
        discountLabel.layer.cornerRadius = 3;
        discountLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:discountLabel];
        
        itemPostageLabel = [[UILabel alloc] init];
        itemPostageLabel.bounds = CGRectMake(0, 0, 30, 16);
        itemPostageLabel.layer.backgroundColor = [MIUtility colorWithHex:0xfda24a].CGColor;
        itemPostageLabel.font = [UIFont systemFontOfSize: 10];
        itemPostageLabel.textColor = [MIUtility colorWithHex:0xffffff];
        itemPostageLabel.layer.cornerRadius = 3;
        itemPostageLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:itemPostageLabel];
        
        line = [[UIView alloc]initWithFrame:CGRectMake(12, 280+60, self.viewWidth-24, 0.5)];
        line.backgroundColor = [MIUtility colorWithHex:0xe4e4e4];
        [self addSubview:line];
        
        itemTitleLabel = [[RTLabel alloc] initWithFrame:CGRectMake(12, 280+60.5+12, SCREEN_WIDTH - 24, MAXFLOAT)];
        itemTitleLabel.backgroundColor = [UIColor clearColor];
        itemTitleLabel.font = [UIFont systemFontOfSize:13.0];
        itemTitleLabel.textColor = [MIUtility colorWithHex:0x333333];
        [self addSubview:itemTitleLabel];
    }
    
    return self;
}


@end

#pragma mark - MITuanShopShuoCell
@interface MITuanShopShuoCell:UITableViewCell

@property(nonatomic, strong) UILabel * shuoLabel;

@end

@implementation MITuanShopShuoCell
@synthesize shuoLabel;

- (id) initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.viewWidth, 0.5)];
        line1.backgroundColor = [MIUtility colorWithHex:0xe4e4e4];
        [self addSubview:line1];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, line1.bottom, self.viewWidth, 8)];
        lineView.backgroundColor = [MIUtility colorWithHex:0xeeeeee];
        [self addSubview:lineView];
        
        UILabel *shuo = [[UILabel alloc] initWithFrame:CGRectMake(12, 16, 100, 14)];
        shuo.text = @"掌柜说";
        shuo.textColor = [MIUtility colorWithHex:0x333333];
        shuo.font = [UIFont systemFontOfSize:14];
        shuo.backgroundColor = [UIColor clearColor];
        [self addSubview:shuo];
        
        shuoLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 42, SCREEN_WIDTH - 24, 10)];
        shuoLabel.lineBreakMode = NSLineBreakByWordWrapping;
        shuoLabel.backgroundColor = [UIColor clearColor];
        shuoLabel.font = [UIFont systemFontOfSize:12];
        shuoLabel.textColor = [MIUtility colorWithHex:0x666666];
        shuoLabel.numberOfLines = 0;
        [self addSubview:shuoLabel];
    }
    
    return self;
}

@end



#pragma mark - MITuanDetailViewController

typedef enum {
    NormalType,
    LowerFiveMinuteType,
}FavorBtnType;

@interface MITuanDetailViewController ()<MWPhotoBrowserDelegate>
{
    MIUserFavorItemAddRequest *_itemAddRequest;
    MIUserFavorItemDeleteRequest *_itemDeleteRequest;
}
@property (nonatomic,strong)MITuanItemInfoCell *tuanItemCell;
@property (nonatomic,strong)MITuanShopShuoCell *shuoCell;
@property (nonatomic,assign)BOOL isAddFavor;
@property (nonatomic,strong)NSMutableArray *itemFavorArray;
@property (nonatomic,strong)UIButton *favorBtn;
@property(nonatomic, assign) FavorBtnType favorBtnType;

@property (nonatomic, strong) NSMutableArray *selections;
@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) NSMutableArray *thumbs;

@end

@implementation MITuanDetailViewController
@synthesize item,shuoStr,relatesArr;
@synthesize detailGetRequest = _detailGetRequest;
@synthesize placeholderImage = _placeholderImage;

- (id) initWithItem: (MITuanItemModel *) model placeholderImage:(UIImage *)placeholder{
    self = [super init];
    if (self != nil) {
        self.item = model;
        self.iid = model.numIid;
        self.placeholderImage = placeholder;
        __weak typeof(self) weakSelf = self;
        _detailGetRequest = [[MITemaiDetailGetRequest alloc] init];
        _detailGetRequest.onCompletion = ^(MITemaiDetailGetModel *model) {
            [weakSelf finishLoadTableViewData:model];
        };
        _detailGetRequest.onError = ^(MKNetworkOperation* completedOperation, MIError* error) {
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
    
    [self.navigationBar setBarTitle:@"米折独家特卖"];
    self.bottomToolBar = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.viewHeight - 44, self.view.viewWidth, 44)];
    self.bottomToolBar.backgroundColor = [UIColor whiteColor];
    self.bottomToolBar.alpha = 0;
    [self.view addSubview:self.bottomToolBar];
    
    self.bgView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 120, self.bottomToolBar.viewHeight)];
    self.bgView1.backgroundColor = [UIColor clearColor];
    [self.bottomToolBar addSubview:self.bgView1];
    
    self.leftTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 3, 120, 20)];
    self.leftTimeLabel.backgroundColor = [UIColor clearColor];
    self.leftTimeLabel.font = [UIFont systemFontOfSize:12];
    self.leftTimeLabel.textColor = [MIUtility colorWithHex:0x333333];
    self.leftTimeLabel.textAlignment = NSTextAlignmentLeft;
    [self.bgView1 addSubview:self.leftTimeLabel];
    
    self.customerLabel = [[RTLabel alloc]initWithFrame:CGRectMake(12, 23, 120, 20)];
    self.customerLabel.backgroundColor = [UIColor clearColor];
    self.customerLabel.font = [UIFont systemFontOfSize:12];
    self.customerLabel.textAlignment = NSTextAlignmentLeft;
    [self.bgView1 addSubview:self.customerLabel];
    
    self.customerLabel2 = [[RTLabel alloc]initWithFrame:CGRectMake(12, 17, 120, 20)];
    self.customerLabel2.backgroundColor = [UIColor clearColor];
    self.customerLabel2.font = [UIFont systemFontOfSize:11];
    self.customerLabel2.textAlignment = NSTextAlignmentLeft;
    [self.bottomToolBar addSubview:self.customerLabel2];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, PHONE_SCREEN_SIZE.width, 0.5)];
    line.backgroundColor = [MIUtility colorWithHex:0xcecece];
    [self.bottomToolBar addSubview:line];
    
    self.PurchaseLabel = [[UILabel alloc]initWithFrame:CGRectMake(PHONE_SCREEN_SIZE.width -10 -123, 4, 123, 36)];
    self.PurchaseLabel.font = [UIFont systemFontOfSize:15];
    self.PurchaseLabel.textColor = [MIUtility colorWithHex:0xffffff];
    self.PurchaseLabel.textAlignment = NSTextAlignmentCenter;
    self.PurchaseLabel.layer.cornerRadius = 3;
    self.PurchaseLabel.clipsToBounds = YES;
    self.PurchaseLabel.userInteractionEnabled = YES;
    [self.bottomToolBar addSubview:self.PurchaseLabel];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToBuyAction)];
    [self.PurchaseLabel addGestureRecognizer:tap];
    
    self.baseTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.navigationBarHeight, PHONE_SCREEN_SIZE.width, self.view.viewHeight - self.navigationBarHeight - 44) style:UITableViewStylePlain];
    _baseTableView.showsVerticalScrollIndicator = NO;
    _baseTableView.backgroundColor = [UIColor whiteColor];
    _baseTableView.dataSource = self;
    _baseTableView.delegate = self;
    self.baseTableView.alpha = 0;
    self.baseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view sendSubviewToBack:self.baseTableView];
    
    //DetailRequestRequest
    //    _shuoHeight = 0;
    self.tuanItemCell = [[MITuanItemInfoCell alloc]initWithReuseIdentifier:@"tuanItemCellIdentifier"];
    if (self.item) {
        NSString *imgUrl;
        if([[Reachability reachabilityForInternetConnection] isReachableViaWiFi]){
            imgUrl = [[NSString alloc] initWithFormat:@"%@_670x670.jpg", self.item.img];
        } else {
            imgUrl = [[NSString alloc] initWithFormat:@"%@_310x310.jpg", self.item.img];
        }
        [self.tuanItemCell.itemImageView sd_setImageWithURL:[NSURL URLWithString: imgUrl] placeholderImage:self.placeholderImage];
    }
    self.shuoCell = [[MITuanShopShuoCell alloc] initWithReuseIdentifier: @"shopShuoCellIdentifier"];
    
    __weak typeof(self) weakSelf = self;
    
    _itemDeleteRequest = [[MIUserFavorItemDeleteRequest alloc] init];
    _itemDeleteRequest.onCompletion = ^(MIUserFavorItemDeleteModel *model) {
        if (model.success.boolValue)
        {
            [weakSelf showSimpleHUD:@"开抢提醒已关闭，你可能会错过哦~" afterDelay:1];
            weakSelf.isAddFavor = NO;
            [weakSelf.itemFavorArray removeObject:weakSelf.item.tuanId];
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
            [weakSelf.itemFavorArray addObject:weakSelf.item.tuanId];
            [[NSUserDefaults standardUserDefaults] setObject:weakSelf.itemFavorArray forKey:kItemFavorListDefaults];
            [[NSUserDefaults standardUserDefaults] synchronize];
            weakSelf.isAddFavor = YES;
            [weakSelf.favorBtn setImage:[UIImage imageNamed:@"ic_xiangqing_remind_select"] forState:UIControlStateNormal];
            [weakSelf.favorBtn setTitle:@"已加提醒" forState:UIControlStateNormal];
            weakSelf.favorBtn.backgroundColor = [MIUtility colorWithHex:0xbebebe];
            
            NSNumber *alertTime = [[NSUserDefaults standardUserDefaults] objectForKey: kBrandFavorBeginTimeDefaults];
            double nowInterval = [[NSDate date] timeIntervalSince1970] + [MIConfig globalConfig].timeOffset;
            
            if (weakSelf.item && weakSelf.item.startTime && weakSelf.item.startTime.integerValue > nowInterval && (alertTime.integerValue > weakSelf.item.startTime.integerValue || alertTime == nil))
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self startTimer];
    if (!self.relatesArr) {
        [self setOverlayStatus:EOverlayStatusLoading labelText:nil];
        [_detailGetRequest sendQuery];
    }
    [MITipView showContentOperateTipInView:self.view tipKey:@"MITuanDetailViewController" imgKey:@"img_tips_contentoperate" type:MI_TIP_AUTO_DISMISS];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    [self stopTimer];
    
    if (_detailGetRequest) {
        [_detailGetRequest cancelRequest];
    }
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
            [_itemAddRequest setIid:self.item.tuanId];
            
            [_itemAddRequest sendQuery];
        }
        else
        {
            [_itemDeleteRequest setIids:[NSString stringWithFormat:@"%@",self.item.tuanId]];
            [_itemDeleteRequest sendQuery];
        }
    }
    else
    {
        [self showSimpleHUD:@"时间快到了哦，做好准备抢购吧！" afterDelay:1];
    }
}


- (void)goToBuyAction
{
    //type = 1、10yuan 2、youpin 3、brand
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
    [MIUtility setMuyingTag:@"muying" key:self.cat];
    [MIUtility clickEventWithLog:@"tuan" cid:item.tuanId.stringValue s:@"1"];
    NSString *type = [self.detailGetRequest.fields objectForKey:@"type"];
    if (type && type.integerValue == MIYouPin) {
        [MobClick event:kYouPinGoBuys];
    } else {
        [MobClick event:kTuanItemGoBuys];
    }
    
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
    
    NSURL *itemURL = [NSURL URLWithString:[NSString stringWithFormat:[MIConfig globalConfig].tbUrl, item.numIid]];
    MITbWebViewController *webVC = [[MITbWebViewController alloc] initWithURL:itemURL];
    webVC.tag = @"tu";
    webVC.numiid = item.numIid;
    webVC.tuanNumiid = item.numIid;
    webVC.origin = item.origin.integerValue;
//    webVC.tips = item.tip;
    webVC.productTitle = item.title;
    [webVC setWebTitle:@"购买商品"];
    [[MINavigator navigator] openPushViewController:webVC animated:YES];
}

- (void)goShareAction
{
    [MobClick event:kTaobaoDetailShareClicks];
    NSString *url = [NSString stringWithFormat:@"http://tuan.mizhe.com/deal/%@.html", self.item.encryptTid];
    NSString *title = self.item.title;
    NSString *desc = @"国内最大的女性特卖网站，致力于为年轻女性提供时尚又实惠的专属特卖服务！每天10点开抢，不见不散~";
    NSString *comment = [NSString stringWithFormat:@"只要%@元，刚刚在@米折网 看到这个宝贝，好心动！全场包邮，超划算的！推荐你也去看看！",self.item.price.priceValue] ;
    NSString *smallImg = [[NSString alloc] initWithFormat:@"%@_100x100.jpg", self.item.img];
    NSString *largeImg = [[NSString alloc] initWithFormat:@"%@_670x670.jpg", self.item.img];
    [MINavigator showShareActionSheetWithUrl:url title:title desc:desc comment:comment image:self.tuanItemCell.itemImageView smallImg:smallImg largeImg:largeImg inView:self.view platform:@"weixin_timeline_qzone_qq_weibo_copy_gohome"];
}

- (void)reloadTableViewDataSource
{
    if (self.loading) {
        [_detailGetRequest cancelRequest];
    }
    
    self.loading = YES;
    [self setOverlayStatus:EOverlayStatusLoading labelText:nil];
    
    [_detailGetRequest sendQuery];
}
- (void)finishLoadTableViewData:(MITemaiDetailGetModel *)model
{
    if (!self.item)
    {
        self.item = [[MITuanItemModel alloc] init];
    }
    [self.navigationBar setBarRightButtonItem:self selector:@selector(goShareAction) imageKey:@"mi_navbar_share_img"];

    self.item.tuanId = model.tuanId;
    self.item.numIid = model.numIid.stringValue;
    self.item.title = model.title;
    self.item.img = model.img;
    self.item.price = model.price;
    self.item.priceOri = model.priceOri;
    self.item.postageType = model.postageType;
    self.item.discount = model.discount;
    self.item.cid = model.cid;
    self.item.volumn = model.volumn;
    self.item.origin = model.origin;
    self.item.startTime = model.startTime;
    self.item.endTime = model.endTime;
    self.item.status = model.status;
    self.item.views = model.views;
    self.item.clicks = model.clicks;
    self.item.labelImg = model.labelImg;
    self.item.encryptTid = model.encryptTid;
    [self setOverlayStatus:EOverlayStatusRemove labelText:nil];
    
    if (0 != [[model.shopShuo stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length])
    {
        self.shuoStr = model.shopShuo;
    } else {
        self.shuoStr = @"掌柜太懒了，什么都没说";
    }
    
    self.relatesArr = model.tuanItemsRecs;
    [self setProductItemInfo];
    
    self.startTime = model.startTime;
    
    if ([self isRemindTime:model.startTime.integerValue])
    {
        NSArray *favorArray = [[NSUserDefaults standardUserDefaults] objectForKey:kItemFavorListDefaults];
        _itemFavorArray = [[NSMutableArray alloc] initWithArray:favorArray];
        self.favorBtn.hidden = NO;
        if ([_itemFavorArray containsObject:self.item.tuanId])
        {
            [_favorBtn setImage:[UIImage imageNamed:@"ic_xiangqing_remind_select"] forState:UIControlStateNormal];
            _favorBtn.backgroundColor = [MIUtility colorWithHex:0xbebebe];
            [_favorBtn setTitle:@"已加提醒" forState:UIControlStateNormal];
            //[_favorBtn setTitleColor:[MIUtility colorWithHex:0xececec] forState:UIControlStateNormal];
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
    double nowInterval = [[NSDate date] timeIntervalSince1970] + [MIConfig globalConfig].timeOffset;
    return time > nowInterval;
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
        NSInteger hours = (interval - days * 3600 *24)/ 60 / 60;
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
    else if (endInterval <0)
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
//            NSInteger interval1 = [MIUtility calcIntervalWithEndTime:endInterval andNowTime:nowInterval];
            NSInteger day = endInterval / 60 / 60 / 24;
            NSInteger hour = endInterval%(60 * 60 * 24)/60/60;
            NSInteger minute = endInterval%(60*60)/60;
            NSInteger second = endInterval % 60;
            self.leftTimeLabel.text = [[NSString alloc] initWithFormat:@"剩%ld天%.2ld:%.2ld:%.2ld", (long)day,(long)hour, (long)minute, (long)second];
        }
    }
}


#pragma mark - UITabelView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.item ==nil) {
        return 0;
    }
    return 3;
}

-(void)setProductItemInfo
{
    self.tuanItemCell = [[MITuanItemInfoCell alloc] initWithReuseIdentifier: @"tuanItemCellIdentifier"];
    self.tuanItemCell.item = self.item;
    NSString *imgUrl;
    if([[Reachability reachabilityForInternetConnection] isReachableViaWiFi]){
        imgUrl = [[NSString alloc] initWithFormat:@"%@_670x670.jpg", self.item.img];
    } else {
        imgUrl = [[NSString alloc] initWithFormat:@"%@_310x310.jpg", self.item.img];
    }
    [self.tuanItemCell.itemImageView sd_setImageWithURL:[NSURL URLWithString: imgUrl] placeholderImage:self.placeholderImage];
    
    NSString *desc = [self.item.title stringByReplacingOccurrencesOfString:@"【" withString:@"["];
    desc = [desc stringByReplacingOccurrencesOfString:@"，" withString:@","];
    NSString *original = [desc stringByReplacingOccurrencesOfString:@"】" withString:@"]"];
    
    double nowInterval = [[NSDate date] timeIntervalSince1970] + [MIConfig globalConfig].timeOffset;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.item.startTime.doubleValue];
    NSString *dateStr = [date stringForYymmdd];
    NSDate *nowDate = [NSDate dateWithTimeIntervalSince1970:nowInterval];
    NSString *nowStr = [nowDate stringForYymmdd];
    NSString *str = @"<font color=#ff3d00 size=13>今日特卖 </font>";
    NSString *appended = [str stringByAppendingString:original];
    if ([dateStr isEqualToString:nowStr])
    {
        self.tuanItemCell.itemTitleLabel.text = appended;
    }
    else
    {
        self.tuanItemCell.itemTitleLabel.text = original;
    }
    self.tuanItemCell.itemTitleLabel.viewHeight = ceilf(self.tuanItemCell.itemTitleLabel.optimumSize.height);
    self.tuanItemCell.itemTitleLabel.top = 280 + 60.5 + 12;

    self.tuanItemCell.itemPriceLabel.text = [NSString stringWithFormat:@"￥%@", self.item.price.priceValue];
//    CGSize expectedSize = self.tuanItemCell.itemPriceLabel.optimumSize;
    CGSize expectedSize = [self.tuanItemCell.itemPriceLabel.text sizeWithFont:self.tuanItemCell.itemPriceLabel.font constrainedToSize:CGSizeMake(100, 28)];
    self.tuanItemCell.itemPriceLabel.viewWidth = expectedSize.width;
    self.tuanItemCell.itemPriceLabel.viewHeight = ceilf(expectedSize.height);
    
    self.tuanItemCell.itemPriceOriLabel.left = self.tuanItemCell.itemPriceLabel.right +5;
    self.tuanItemCell.itemPriceOriLabel.text = [NSString stringWithFormat:@"￥%@",self.item.priceOri.priceValue];
    CGSize size = [self.tuanItemCell.itemPriceOriLabel.text sizeWithFont:self.tuanItemCell.itemPriceOriLabel.font constrainedToSize:CGSizeMake(200, 20)];
    self.tuanItemCell.itemPriceOriLabel.viewWidth = size.width;
    self.tuanItemCell.itemPriceOriLabel.bottom = self.tuanItemCell.itemPriceLabel.bottom -2;
    self.tuanItemCell.discountLabel.text = [NSString stringWithFormat:@"%.1f折",self.item.discount.floatValue/10];
    CGSize size1 = [self.tuanItemCell.discountLabel.text sizeWithFont:self.tuanItemCell.discountLabel.font constrainedToSize:CGSizeMake(100, 20)];
    self.tuanItemCell.discountLabel.viewWidth = size1.width + 10;
    self.tuanItemCell.discountLabel.left = self.tuanItemCell.itemPriceOriLabel.right + 10;
    self.tuanItemCell.discountLabel.bottom = self.tuanItemCell.itemPriceLabel.bottom -5;
    if (self.item.postageType.integerValue == 202) {
        self.tuanItemCell.itemPostageLabel.text = @"大部分地区包邮";
    } else {
        self.tuanItemCell.itemPostageLabel.text = @"全国包邮";
    }
    CGSize size2 = [self.tuanItemCell.itemPostageLabel.text sizeWithFont:self.tuanItemCell.itemPostageLabel.font constrainedToSize:CGSizeMake(100, 16)];
    self.tuanItemCell.itemPostageLabel.viewWidth = size2.width + 10;
    self.tuanItemCell.itemPostageLabel.left = self.tuanItemCell.discountLabel.right + 5;
    self.tuanItemCell.itemPostageLabel.bottom = self.tuanItemCell.itemPriceLabel.bottom -5;
    
    self.shuoCell.shuoLabel.text = self.shuoStr;
    CGSize shuoLabelSize = [self.shuoCell.shuoLabel.text sizeWithFont:self.shuoCell.shuoLabel.font constrainedToSize:CGSizeMake(self.shuoCell.shuoLabel.viewWidth, 200)];
    self.shuoCell.shuoLabel.viewHeight = shuoLabelSize.height;
    
    [self.baseTableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *tuanRelateCellIdentifier = @"tuanRelateCellIdentifier";
    
    if (indexPath.row == 0) {
        return self.tuanItemCell;
    } else if (indexPath.row == 1){
        
//        if (self.shuoStr) {
//            self.shuoCell.shuoLabel.text = self.shuoStr;
//            self.shuoCell.shuoLabel.viewHeight = ceilf(self.shuoCell.shuoLabel.optimumSize.height);
//        }
        
        return self.shuoCell;
    } else if (indexPath.row == 2) {
        MITuanRelateItemsCell *cell = [tableView dequeueReusableCellWithIdentifier: tuanRelateCellIdentifier];
        if (cell == nil) {
            cell = [[MITuanRelateItemsCell alloc] initWithReuseIdentifier:tuanRelateCellIdentifier];
            cell.type = ItemType;
        }
        
        if (self.relatesArr) {
            cell.tuanItems = self.relatesArr;
            
            for (NSInteger i = 0; i < self.relatesArr.count && i < 6; i++)
            {
                @try {
                    MITuanItemModel *model = (MITuanItemModel *)[cell.tuanItems objectAtIndex:i];
                    NSString *imgUrl = [[NSString alloc] initWithFormat:@"%@_120x120.jpg", model.img];
                    UIImageView *imageView = [cell.images objectAtIndex:i];
                    [imageView sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"default_avatar_img"]];
                    UILabel *priceLabel = (UILabel *)[cell.prices objectAtIndex:i];
                    priceLabel.text = [NSString stringWithFormat:@"￥%@",model.price.priceValue];
                    CGSize expectedSize = [priceLabel.text sizeWithFont:priceLabel.font constrainedToSize:CGSizeMake(1000, 15)];
                    priceLabel.viewWidth = expectedSize.width + 5;
                    MIDeleteUILabel *priceOriLabel = (MIDeleteUILabel *)[cell.priceOris objectAtIndex:i];
                    priceOriLabel.text = model.priceOri.priceValue;
                    expectedSize = [priceOriLabel.text sizeWithFont:priceOriLabel.font constrainedToSize:CGSizeMake(1000, 15)];
                    priceOriLabel.viewWidth = expectedSize.width;
                    priceOriLabel.left = priceLabel.right;
                    imageView = [cell.temaiImages objectAtIndex:i];
                    imageView.hidden = YES;
                }
                @catch (NSException *exception) {
                    MILog(@"tuan item is out of indexs");
                }
            }
        }
        
        return cell;
    }
    else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 369+ceilf(self.tuanItemCell.itemTitleLabel.optimumSize.height);
    } else if (indexPath.row == 1){
        return self.shuoCell.shuoLabel.viewHeight + 58;
    } else {
        return 286;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.row)
    {
        NSString *imgUrl;
        if([[Reachability reachabilityForInternetConnection] isReachableViaWiFi]){
            imgUrl = [[NSString alloc] initWithFormat:@"%@_670x670.jpg", self.item.img];
        } else {
            imgUrl = [[NSString alloc] initWithFormat:@"%@_310x310.jpg", self.item.img];
        }
        if (!_photos || !_photos.count)
        {
            NSMutableArray *photos = [[NSMutableArray alloc] init];
            [photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:imgUrl]]];
            _photos = photos;
        }
        if (!_thumbs || !_thumbs.count)
        {
            NSMutableArray *thumbs = [[NSMutableArray alloc] init];
            [thumbs addObject:[MWPhoto photoWithURL:[NSURL URLWithString:imgUrl]]];
            _thumbs = thumbs;
        }
        
        // Create browser
        MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
        browser.displayActionButton = NO;
        browser.displayNavArrows = NO;
        browser.displaySelectionButtons = NO;
        browser.alwaysShowControls = NO;
        browser.zoomPhotosToFill = YES;
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
        browser.wantsFullScreenLayout = YES;
#endif
        browser.enableGrid = NO;
        browser.startOnGrid = NO;
        browser.enableSwipeToDismiss = YES;
        [browser setCurrentPhotoIndex:index];
        
        //    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:browser];
        //    nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        browser.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:browser animated:YES completion:nil];
    }
}
#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return self.photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < self.photos.count)
        return [self.photos objectAtIndex:index];
    return nil;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index {
    if (index < self.thumbs.count)
        return [self.thumbs objectAtIndex:index];
    return nil;
}

//- (MWCaptionView *)photoBrowser:(MWPhotoBrowser *)photoBrowser captionViewForPhotoAtIndex:(NSUInteger)index {
//    MWPhoto *photo = [self.photos objectAtIndex:index];
//    MWCaptionView *captionView = [[MWCaptionView alloc] initWithPhoto:photo];
//    return [captionView autorelease];
//}

//- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser actionButtonPressedForPhotoAtIndex:(NSUInteger)index {
//    NSLog(@"ACTION!");
//}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser didDisplayPhotoAtIndex:(NSUInteger)index {
    //    NSLog(@"Did start viewing photo at index %lu", (unsigned long)index);
}

- (BOOL)photoBrowser:(MWPhotoBrowser *)photoBrowser isPhotoSelectedAtIndex:(NSUInteger)index {
    return [[self.selections objectAtIndex:index] boolValue];
}

//- (NSString *)photoBrowser:(MWPhotoBrowser *)photoBrowser titleForPhotoAtIndex:(NSUInteger)index {
//    return [NSString stringWithFormat:@"Photo %lu", (unsigned long)index+1];
//}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index selectedChanged:(BOOL)selected {
    [self.selections replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:selected]];
    //    NSLog(@"Photo at index %lu selected %@", (unsigned long)index, selected ? @"YES" : @"NO");
}

- (void)photoBrowserDidFinishModalPresentation:(MWPhotoBrowser *)photoBrowser {
    // If we subscribe to this method we must dismiss the view controller ourselves
    //    NSLog(@"Did finish modal presentation");
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
