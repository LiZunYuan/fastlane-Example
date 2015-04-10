//
//  MITbDetailsViewController.m
//  MISpring
//
//  Created by 徐 裕健 on 13-9-25.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import <StoreKit/StoreKit.h>
#import "MIAppDelegate.h"
#import "MITbDetailsViewController.h"
#import "MITaobaoDescViewController.h"
#import "MIVIPCenterViewController.h"
#import "MITbkItemDetailGetModel.h"
#import "MITbkMobileItemsConvertModel.h"
#import "MITbkRebateAuthGetModel.h"
#import "MITbkConvertItemModel.h"
#import "MITbkAuthrizeItemModel.h"

#pragma mark - MITaobaoItemCell
@interface MITaobaoItemCell:UITableViewCell

@property(nonatomic, strong) UIImageView *itemImageView;
@property(nonatomic, strong) UILabel *volumeLabel;

@end

@implementation MITaobaoItemCell

@synthesize itemImageView;
@synthesize volumeLabel;

- (id) initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        itemImageView = [[UIImageView alloc] initWithFrame: CGRectMake(0, 0, PHONE_SCREEN_SIZE.width, 300)];
        itemImageView.userInteractionEnabled = NO;
        [self addSubview:itemImageView];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 280, SCREEN_WIDTH, 20)];
        view.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
        [self addSubview:view];
        
        volumeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 20, 20)];
        volumeLabel.backgroundColor = [UIColor clearColor];
        volumeLabel.font = [UIFont systemFontOfSize:14.0];
        volumeLabel.textColor = [UIColor whiteColor];
        volumeLabel.textAlignment = UITextAlignmentRight;
        [volumeLabel setShadowColor: [UIColor blackColor]];
        [volumeLabel setShadowOffset: CGSizeMake(0, -1.0)];
        [view addSubview:volumeLabel];
    }
    return self;
}
@end

#pragma  mark - MITaobaokeItemCell
@interface MITaobaokeItemCell:UITableViewCell<SKStoreProductViewControllerDelegate>

@property(nonatomic, strong) UILabel *itemTitle;
@property(nonatomic, strong) RTLabel *itemPrice;
@property(nonatomic, strong) RTLabel *itemRebate;
@property(nonatomic, strong) UILabel *itemBuyLabel;

@property(nonatomic, assign) BOOL tbkRebateAuthorize;
@property(nonatomic, strong) MITbkItemModel *model;
@property(nonatomic, strong) NSString *clickUrl;
@property(nonatomic, strong) UIImageView *rebateImageView;

@end

@implementation MITaobaokeItemCell

@synthesize itemTitle;
@synthesize itemPrice;
@synthesize itemRebate;
@synthesize itemBuyLabel;
@synthesize tbkRebateAuthorize;
@synthesize model;
@synthesize clickUrl;
@synthesize rebateImageView;

- (id) initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        itemTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, SCREEN_WIDTH - 20, 50)];
        itemTitle.numberOfLines = 2;
        itemTitle.lineBreakMode = NSLineBreakByCharWrapping;
        itemTitle.backgroundColor = [UIColor clearColor];
        itemTitle.font = [UIFont systemFontOfSize:14.0];
        itemTitle.textColor = [UIColor darkTextColor];
        [self addSubview:itemTitle];
        
        itemPrice = [[RTLabel alloc] initWithFrame:CGRectMake(10, itemTitle.bottom, SCREEN_WIDTH - 20, 20)];
        itemPrice.font = [UIFont systemFontOfSize:14.0];
        itemPrice.textColor = [UIColor darkGrayColor];
        [self addSubview:itemPrice];
        
        itemRebate = [[RTLabel alloc] initWithFrame:CGRectMake(10, itemPrice.bottom, SCREEN_WIDTH - 20, 20)];
        itemRebate.backgroundColor = [UIColor clearColor];
        itemRebate.font = [UIFont systemFontOfSize:14.0];
        itemRebate.textColor = [UIColor darkGrayColor];
        [self addSubview:itemRebate];
        
        rebateImageView = [[UIImageView alloc] initWithFrame:CGRectMake(120, 67, 68, 18)];
        rebateImageView.hidden = YES;
        rebateImageView.userInteractionEnabled = YES;
        [self addSubview:rebateImageView];
        
        UITapGestureRecognizer *goToMemberCenter = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToMemberCenterAction)];
        [rebateImageView addGestureRecognizer:goToMemberCenter];

        itemBuyLabel = [[UILabel alloc] initWithFrame: CGRectMake(210, itemTitle.bottom + 5, 100, 36)];
        itemBuyLabel.userInteractionEnabled = YES;
        itemBuyLabel.backgroundColor = [UIColor redColor];
        itemBuyLabel.layer.cornerRadius = 3.0;
        itemBuyLabel.text = @"去购买";
        itemBuyLabel.clipsToBounds = YES;
        itemBuyLabel.textAlignment = UITextAlignmentCenter;
        itemBuyLabel.font = [UIFont systemFontOfSize: 20];
        itemBuyLabel.textColor = [UIColor whiteColor];
        [self addSubview:itemBuyLabel];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToBuyAction)];
        [itemBuyLabel addGestureRecognizer:tap];
    }
    
    return self;
}
- (void)goToMemberCenterAction
{
    [MobClick event:kVipCenterClicks];
    
    MIVIPCenterViewController *vipCenterView = [[MIVIPCenterViewController alloc] init];
    [[MINavigator navigator] openPushViewController:vipCenterView animated:YES];
}
- (void)goToBuyAction
{
    [MobClick event:kTaobaoDetailBuyClicks];
    
    NSString *numiid = self.model.numIid;
    if (self.clickUrl && self.tbkRebateAuthorize && [MIConfig globalConfig].tbMidPage) {
        NSURL *itemURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@&sche=mizheapp://action", self.clickUrl]];
        NSURL *taobaoSchemes = [NSURL URLWithString:[MIConfig globalConfig].taobaoSche];
        if ([[UIApplication sharedApplication] canOpenURL:taobaoSchemes] || [MIConfig globalConfig].htmlRebate) {
            [self goTaobaoShopping:itemURL numiid:numiid];
        } else {
            MIButtonItem *cancelItem = [MIButtonItem itemWithLabel:@"不要返利"];
            cancelItem.action = ^{
                [self goTaobaoShopping:itemURL numiid:numiid];
            };
            MIButtonItem *affirmItem = [MIButtonItem itemWithLabel:@"去安装"];
            affirmItem.action = ^{
                if (IOS_VERSION >= 6.0) {
                    [self openAppWithIdentifier:[MIConfig globalConfig].taobaoAppID];
                } else {
                    NSString *taobao = [NSString stringWithFormat:@"https://itunes.apple.com/app/id%@?mt=8", [MIConfig globalConfig].taobaoAppID];
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:taobao]];
                }
            };
            
            UIAlertView *installTaobaoAlertView = [[UIAlertView alloc] initWithTitle:@"米姑娘提醒" message:@"请先安装最新版淘宝客户端，然后从米折点“去购买”即自动跳转淘宝，在淘宝客户端下单即可获得返利" cancelButtonItem:cancelItem otherButtonItems:affirmItem, nil];
            [installTaobaoAlertView show];
        }
    } else {
        NSURL *itemURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://a.m.taobao.com/i%@.htm", numiid]];
        if ([MIConfig globalConfig].tbMidPage) {
            [self goTaobaoShopping:itemURL numiid:numiid];
        } else {
            MITbkWebViewController * webVC = [[MITbkWebViewController alloc] initWithURL:itemURL];
            webVC.itemImageUrl = self.model.picUrl;
            webVC.productTitle = self.model.title;
            webVC.webTitle = @"购买商品";
            [[MINavigator navigator] openPushViewController: webVC animated:YES];
        }
    }
}

- (void) goTaobaoShopping:(NSURL *)itemURL numiid:(NSString *)iid
{
    MITbWebViewController *webVC = [[MITbWebViewController alloc] initWithURL:itemURL];
    webVC.numiid = iid;
    webVC.itemImageUrl = self.model.picUrl;
    webVC.productTitle = self.model.title;
    [webVC setWebTitle:@"购买商品"];
    [[MINavigator navigator] openPushViewController:webVC animated:YES];
}

- (void)openAppWithIdentifier:(NSString *)appId {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.window animated:YES];
    hud.removeFromSuperViewOnHide = YES;
    
    SKStoreProductViewController *storeProductVC = [[SKStoreProductViewController alloc] init];
    storeProductVC.delegate = self;
    NSDictionary *dict = [NSDictionary dictionaryWithObject:appId forKey:SKStoreProductParameterITunesItemIdentifier];
    [storeProductVC loadProductWithParameters:dict completionBlock:^(BOOL result, NSError *error) {
        [hud setHidden:YES];
        if (!error) {
            UIViewController* topViewController = [MINavigator navigator].navigationController.topViewController;
            [topViewController presentViewController:storeProductVC animated:YES completion:nil];
        } else {
            NSString *taobao = [NSString stringWithFormat:@"https://itunes.apple.com/app/id%@?mt=8", [MIConfig globalConfig].taobaoAppID];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:taobao]];
        }
    }];
}

#pragma mark - SKStoreProductViewControllerDelegate
- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController {
    [viewController dismissViewControllerAnimated:YES completion:^{
    }];
}
@end

#pragma mark - MITaobaokeShopCell
@interface MITaobaokeShopCell:UITableViewCell

@property(nonatomic, strong) UILabel * nickLabel;

@end

@implementation MITaobaokeShopCell

@synthesize nickLabel;

- (id) initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 20, 1)];
        lineView.image = [[UIImage imageNamed:@"ic_line"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        [self addSubview:lineView];

        UIImageView *imageView = [[UIImageView alloc] initWithFrame: CGRectMake(10, 10, 40, 40)];
        imageView.image = [UIImage imageNamed:@"ic_shopper"];
        
        nickLabel = [[UILabel alloc] initWithFrame: CGRectMake(60, 10, 240, 20)];
        nickLabel.backgroundColor = [UIColor clearColor];
        nickLabel.textAlignment = UITextAlignmentLeft;
        nickLabel.textColor = [UIColor darkGrayColor];
        nickLabel.font = [UIFont fontWithName:@"Arial" size:14];
        
        UILabel *gotoShopLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 30, 240, 20)];
        gotoShopLabel.backgroundColor = [UIColor clearColor];
        gotoShopLabel.textColor = [UIColor grayColor];
        gotoShopLabel.font = [UIFont fontWithName:@"Arial" size:12];
        gotoShopLabel.text = @"进店铺看看";
        
        [self addSubview: imageView];
        [self addSubview: nickLabel];
        [self addSubview: gotoShopLabel];
        
        UIImageView *lineViewBottom = [[UIImageView alloc] initWithFrame:CGRectMake(10, 59, SCREEN_WIDTH - 20, 1)];
        lineViewBottom.image = [[UIImage imageNamed:@"ic_line"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        [self addSubview:lineViewBottom];
    }
    
    return self;
}

@end

@interface MITbDetailsViewController ()
{
    CGFloat _titleHeight;
    BOOL _isShowBuyButton;
}
@end

@implementation MITbDetailsViewController
@synthesize iid;
@synthesize clickUrl;
@synthesize topClient;
@synthesize topSessionKey;
@synthesize tbkConvertting;
@synthesize tbkConvertFailed;
@synthesize tbkRebateAuthorize;
@synthesize tbkItemDetailRequest;
@synthesize tbkItemsConvertRequest;
@synthesize tbkRebateAuthGetRequest;
@synthesize loginTips = _loginTips;
@synthesize loginView = _loginView;
@synthesize keywordsArray = _keywordsArray;
@synthesize orderNoteView = _orderNoteView;

-(id) initWithNumiid: (NSString *) numiid {
    self = [super init];
    if (self != nil) {
        self.iid = numiid;
        self.topClient = [TopIOSClient getIOSClientByAppKey: [MIConfig globalConfig].topAppKey];
        self.isJhsRebate = YES;
        self.tbkConvertFailed = NO;
        self.tbkConvertting = NO;
        self.tbkRebateAuthorize = NO;
        self.keywordsArray = [NSArray arrayWithObjects:@"冲值", @"话费", @"充值", @"捷易", @"易赛", @"点卡", @"龙之谷", @"qq", @"腾讯", @"币", @"网游", @"游戏", @"代练", @"虚拟", @"skype", @"花费", nil];
        
        __weak typeof(self) weakSelf = self;
        tbkItemDetailRequest = [[MITbkItemDetailGetRequest alloc] init];
        tbkItemDetailRequest.onCompletion = ^(MITbkItemDetailGetModel *tbkItemDetailModel) {
            [weakSelf setOverlayStatus:EOverlayStatusRemove labelText:nil];

            if (tbkItemDetailModel.success.boolValue) {
                [weakSelf tbkItemDetailApiCompletion:tbkItemDetailModel.tbkItemDetail];
            } else {
                [weakSelf tbkItemDetailApiError:nil];
            }
        };
        tbkItemDetailRequest.onError = ^(MKNetworkOperation* completedOperation, MIError* error) {
            [weakSelf tbkItemDetailApiError:error];
        };
        
        tbkItemsConvertRequest = [[MITbkMobileItemsConvertRequest alloc] init];
        tbkItemsConvertRequest.onCompletion = ^(MITbkMobileItemsConvertModel *model) {
            if (model.success.boolValue) {
                [weakSelf tbkItemsConvertApiCompletion:model];
            } else {
                [weakSelf tbkItemsConvertApiError:nil];
            }
        };
        tbkItemsConvertRequest.onError = ^(MKNetworkOperation* completedOperation, MIError* error) {
            [weakSelf tbkItemsConvertApiError:error];
        };
        
        tbkRebateAuthGetRequest = [[MITbkRebateAuthGetRequest alloc] init];
        tbkRebateAuthGetRequest.onCompletion = ^(MITbkRebateAuthGetModel *model) {
            if (model.success.boolValue) {
                [weakSelf tbkRebateAuthApiCompletion:model];
            } else {
                [weakSelf tbkRebateAuthApiError:nil];
            }
        };
        tbkRebateAuthGetRequest.onError = ^(MKNetworkOperation* completedOperation, MIError* error) {
            [weakSelf tbkRebateAuthApiError:error];
        };
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.navigationBar setBarTitle:@"商品详情" textSize:20.0];
    
    _isShowBuyButton = NO;
    
    self.baseTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.navigationBarHeight, PHONE_SCREEN_SIZE.width, self.view.viewHeight - self.navigationBarHeight) style:UITableViewStylePlain];
    _baseTableView.hidden = YES;
    _baseTableView.showsVerticalScrollIndicator = NO;
    _baseTableView.backgroundColor = [UIColor whiteColor];
    _baseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _baseTableView.dataSource = self;
    _baseTableView.delegate = self;
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
    footView.backgroundColor = [UIColor clearColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH - 20, 15)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor darkGrayColor];
    label.font = [UIFont systemFontOfSize:14];
    label.text = @"友情提醒";
    [footView addSubview:label];
    UILabel *reminderLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 25, SCREEN_WIDTH - 20, 50)];
    reminderLabel.backgroundColor = [UIColor clearColor];
    reminderLabel.numberOfLines = 0;
    reminderLabel.lineBreakMode = RTTextLineBreakModeWordWrapping;
    reminderLabel.text = @"根据淘宝最新规则，查询返利将不显示返利比例，且跳转到淘宝客户端购买，但返利仍会正常发放，具体金额以到账时为准。";
    reminderLabel.textColor = [UIColor grayColor];
    reminderLabel.font = [UIFont systemFontOfSize:12];
    [footView addSubview:reminderLabel];
    self.baseTableView.tableFooterView = footView;
    
    [self.view bringSubviewToFront:self.navigationBar];
    
    _orderNoteView = [[MIOrderNoteView alloc] initWithFrame:CGRectMake(0, self.navigationBarHeight, PHONE_SCREEN_SIZE.width, self.view.viewHeight - self.navigationBarHeight)];
    _orderNoteView.noteTile.text = @"该宝贝暂无返利哦~";
    [_orderNoteView.noteButton setTitle:@"直接去淘宝购买" forState:UIControlStateNormal];
    [_orderNoteView.noteButton addTarget:self action:@selector(goTaobaoShopping) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_orderNoteView];
    _orderNoteView.hidden = YES;
    
    _loginView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    
    [[_loginView layer] setShadowOffset:CGSizeMake(0, 2)];
    [[_loginView layer] setShadowRadius: 3];
    [[_loginView layer] setShadowOpacity: 0.8];
    [[_loginView layer] setShadowColor:[UIColor darkGrayColor].CGColor];
    [_loginView setBackgroundColor:[UIColor colorWithWhite:0.3 alpha:0.85]];
    
    _loginTips = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    _loginTips.lineBreakMode = UILineBreakModeCharacterWrap;
    _loginTips.font = [UIFont systemFontOfSize: 14];
    _loginTips.textColor = [UIColor whiteColor];
    _loginTips.backgroundColor = [UIColor clearColor];
    _loginTips.textAlignment = NSTextAlignmentCenter;
    _loginTips.shadowColor = [UIColor blackColor];
    _loginTips.shadowOffset = CGSizeMake(0, -1.0);
    _loginTips.numberOfLines = 0;
    _loginTips.text = @"若是虚拟商品，直接去购买无返利\n点此去充值中心购买拿返利";
    [_loginView addSubview: _loginTips];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goChongzhi)];
    [_loginView addGestureRecognizer:singleTap];
    
    [self.view insertSubview: _loginView belowSubview:self.navigationBar];
    
    [MobClick event:kTaobaoDetailViewClicks];
    
    if (!self.isJhsRebate) {
        _orderNoteView.noteTile.text = @"聚划算商品暂不支持返利哦~";
        _orderNoteView.hidden = NO;
        return;
    }
    
    if (!self.itemModel)
    {
        if ([MIConfig globalConfig].topTbkApi) {
            NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
            [params setObject:@"taobao.tbk.items.detail.get" forKey:@"method"];
            [params setObject: self.iid forKey:@"num_iids"];
            [params setObject: @"num_iid,nick,title,price,volume,pic_url,shop_url" forKey:@"fields"];
            self.topSessionKey = [self.topClient api:@"GET" params:params target:self cb:@selector(detailsApiResponse:) userId:nil needMainThreadCallBack:true];
        } else {
            [tbkItemDetailRequest setNumiid:self.iid];
            [tbkItemDetailRequest sendQuery];
        }
 
        [self setOverlayStatus:EOverlayStatusLoading labelText:nil];
    }
    else
    {
        CGSize size = [self.itemModel.title sizeWithFont:[UIFont boldSystemFontOfSize:14] constrainedToSize:CGSizeMake(SCREEN_WIDTH - 20, 40) lineBreakMode:NSLineBreakByCharWrapping];
        _titleHeight = size.height;
        _baseTableView.hidden = NO;
        [self.navigationBar setBarRightButtonItem:self selector:@selector(goShareAction) imageKey:@"mi_navbar_share_img"];
        [self.baseTableView reloadData];
        [self showLoginView];
        
        [self taobaokeMobileItemConvert];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSString *lastVersion = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastVersion"];
    if (lastVersion != nil &&  [lastVersion compare:@"1.5.2"] != NSOrderedDescending) {
        [MITipView showAlertTipWithKey:@"MITbDetailsViewController" message:@"由于淘宝的合作策略调整，查询返利将不显示返利比例，且跳转淘宝客户端购买拿返利！"];
    }
    
    [self.baseTableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.tbkConvertFailed = !self.clickUrl;
    self.tbkConvertting = NO;
    if (self.topSessionKey) {
        [self.topClient cancel:self.topSessionKey];
    }
    
    if ([tbkItemDetailRequest.operation isExecuting]) {
        [tbkItemDetailRequest cancelRequest];
    }
    
    if ([tbkItemsConvertRequest.operation isExecuting]) {
        [tbkItemsConvertRequest cancelRequest];
    }
    
    if ([tbkRebateAuthGetRequest.operation isExecuting]) {
        [tbkRebateAuthGetRequest cancelRequest];
    }
}

#pragma mark - private method
- (void)goTaobaoShopping
{
    NSURL *itemURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://a.m.taobao.com/i%@.htm", iid]];
    if ([MIConfig globalConfig].tbMidPage) {
        MITbWebViewController *webVC = [[MITbWebViewController alloc] initWithURL:itemURL];
        webVC.numiid = iid;
        webVC.itemImageUrl = self.itemModel.picUrl;
        webVC.productTitle = self.itemModel.title;
        webVC.webTitle = @"购买商品";
        [[MINavigator navigator] openPushViewController:webVC animated:YES];
    } else {
        MITbkWebViewController * webVC = [[MITbkWebViewController alloc] initWithURL:itemURL];
        webVC.numiid = self.iid;
        webVC.itemImageUrl = self.itemModel.picUrl;
        webVC.productTitle = self.itemModel.title;
        webVC.webTitle = @"购买商品";
        [[MINavigator navigator] openPushViewController: webVC animated:YES];
    }
}

- (void)goChongzhi
{
    NSString *pid = [MIConfig globalConfig].saPid;
    NSString * outerCode = [[MIMainUser getInstance].userId stringValue];
    if (outerCode == nil || outerCode.length == 0) {
        outerCode = @"1";
    }
    
    NSString *wvsUrl = @"http://wvs.m.taobao.com?pid=%@&unid=%@&backHiddenFlag=1";
    NSString *mobilePhoneFeeUrl = [NSString stringWithFormat:wvsUrl, pid, outerCode];
    MITbWebViewController *webVC = [[MITbWebViewController alloc] initWithURL:[NSURL URLWithString:mobilePhoneFeeUrl]];
    [webVC setWebTitle:@"充值中心"];
    [[MINavigator navigator] openPushViewController:webVC animated:YES];
}

- (void) hideLoginView {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration: 0.35];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    _loginView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40);
    
    [UIView commitAnimations];
}

- (void) showLoginView {
    if ([MIConfig globalConfig].wvsRate > 0) {
        NSString *title = self.itemModel.title;
        for (NSString *keyword in _keywordsArray) {
            if (title && [title rangeOfString:keyword  options:NSCaseInsensitiveSearch].location != NSNotFound) {
                [UIView animateWithDuration:0.35 delay:0 options:UIViewAnimationCurveEaseInOut animations:^{
                    _loginView.top = self.navigationBarHeight;
                }completion:nil];
                break;
            }
        }
    } else {
        [self hideLoginView];
    }
}

#pragma mark - tbk api response
- (void)detailsApiResponse:(id)data
{
    [self setOverlayStatus:EOverlayStatusRemove labelText:nil];
    
    TopApiResponse *response = (TopApiResponse *)data;
    id responseObj = [TopIOSClient getResponseObject: response.content];
    if (responseObj && ![responseObj isKindOfClass: [TopServiceError class]]) {
        responseObj = (NSDictionary *)[responseObj objectForKey:@"tbk_items_detail_get_response"];
        if ([[responseObj objectForKey:@"total_results"] intValue] == 1) {
            responseObj = (NSDictionary *)[responseObj objectForKey:@"tbk_items"];
            responseObj = (NSArray *)[responseObj objectForKey:@"tbk_item"];
            responseObj = (NSDictionary *)[responseObj objectAtIndex:0];
            if (responseObj) {
                [self tbkItemDetailApiCompletion:[MIUtility convertDisctionary2Object:responseObj className:@"MITbkItemModel"]];
                return;
            }
        }
        
        _orderNoteView.hidden = NO;
    } else {
        TopServiceError *topServiceErr = (TopServiceError*)responseObj;
        [self setOverlayStatus:EOverlayStatusError labelText:topServiceErr.errorMsg];
    }
}

- (void) tbkItemDetailApiCompletion:(MITbkItemModel *)model
{
    self.itemModel = model;
    CGSize size = [self.itemModel.title sizeWithFont:[UIFont boldSystemFontOfSize:14] constrainedToSize:CGSizeMake(SCREEN_WIDTH - 20, 40) lineBreakMode:NSLineBreakByCharWrapping];
    _titleHeight = size.height;
    
    _baseTableView.hidden = NO;
    [self.navigationBar setBarRightButtonItem:self selector:@selector(goShareAction) imageKey:@"mi_navbar_share_img"];
    [self.baseTableView reloadData];
    [self showLoginView];
    
    [self taobaokeMobileItemConvert];
}

- (void) tbkItemDetailApiError:(MIError *)error
{
    if (error) {
        [self setOverlayStatus:EOverlayStatusError labelText:nil];
    } else {
        self.orderNoteView.hidden = NO;
    }
}

- (void)taobaokeMobileItemConvert
{
    self.tbkConvertting = YES;
    if ([MIConfig globalConfig].topTbkApi) {
        NSString * outerCode = [[MIMainUser getInstance].userId stringValue];
        if (outerCode == nil || outerCode.length == 0) {
            outerCode = @"1";
        }
        
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setObject:@"taobao.tbk.mobile.items.convert" forKey:@"method"];
        [params setObject: self.iid forKey:@"num_iids"];
        [params setObject: @"click_url" forKey:@"fields"];
        [params setObject: outerCode forKey:@"outer_code"];
        
        if (self.topSessionKey) {
            [self.topClient cancel:self.topSessionKey];
        }
        self.topSessionKey = [self.topClient api:@"GET" params:params target:self cb:@selector(taobaokeMobileItemConvertApiResponse:) userId:nil needMainThreadCallBack:true];
    } else {
        if ([self.tbkItemsConvertRequest.operation isExecuting]) {
            MILog(@"tbkItemsConvertRequest isExecuting");
            [self.tbkItemsConvertRequest cancelRequest];
        }
        
        [self.tbkItemsConvertRequest setNumiids:iid];
        [self.tbkItemsConvertRequest sendQuery];
    }
}

- (void) taobaokeMobileItemConvertApiResponse:(id)data
{
    self.tbkConvertting = NO;
    
    TopApiResponse *response = (TopApiResponse *)data;
    id responseObj = [TopIOSClient getResponseObject: response.content];
    if (responseObj && ![responseObj isKindOfClass: [TopServiceError class]]) {
        responseObj = (NSDictionary *)[responseObj objectForKey:@"tbk_mobile_items_convert_response"];
        if ([[responseObj objectForKey:@"total_results"] intValue] == 1) {
            responseObj = (NSDictionary *)[responseObj objectForKey:@"tbk_items"];
            responseObj = (NSArray *)[responseObj objectForKey:@"tbk_item"];
            responseObj = (NSDictionary *)[responseObj objectAtIndex:0];
            if (responseObj) {
                self.clickUrl = [responseObj objectForKey:@"click_url"];
                self.tbkConvertting = YES;
                [self getTaobaokeRebateAuthorize];
                return;
            }
        }
    } else {
        self.tbkConvertFailed = YES;
        MILog(@"taobaokeItemConvertApiResponse failed!");
    }
    
    _isShowBuyButton = YES;
    [self.baseTableView reloadData];
}

- (void) tbkItemsConvertApiCompletion:(MITbkMobileItemsConvertModel *)model
{
    MITbkConvertItemModel *itemModel = [model.tbkConvertItems objectAtIndex:0];
    self.clickUrl = itemModel.clickUrl;
    [self getTaobaokeRebateAuthorize];
}

- (void) tbkItemsConvertApiError:(MIError*) error
{
    MILog(@"tbkItemsConvertApiError");
    _isShowBuyButton = YES;
    self.tbkConvertting = NO;
    self.tbkConvertFailed = !!error;
    [self.baseTableView reloadData];
}

- (void) getTaobaokeRebateAuthorize
{
    if ([MIConfig globalConfig].topTbkApi) {
        if (self.topSessionKey) {
            [self.topClient cancel:self.topSessionKey];
        }
        
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setObject:@"taobao.taobaoke.rebate.authorize.get" forKey:@"method"];
        [params setObject:iid forKey:@"num_iid"];
        
        self.topSessionKey = [self.topClient api:@"GET" params:params target:self cb:@selector(taobaoRebateAuthApiResponse:) userId:nil needMainThreadCallBack:true];
    } else {
        if ([self.tbkRebateAuthGetRequest.operation isExecuting]) {
            MILog(@"tbkItemsConvertRequest isExecuting");
            [self.tbkRebateAuthGetRequest cancelRequest];
        }
        
        [self.tbkRebateAuthGetRequest setNumiids:iid];
        [self.tbkRebateAuthGetRequest sendQuery];
    }
}

- (void) taobaoRebateAuthApiResponse:(id)data
{
	MILog(@"taobaoRebateAuthApiResponse:");
    self.tbkConvertting = NO;

	TopApiResponse *response = (TopApiResponse *)data;
	id responseObj = [TopIOSClient getResponseObject: response.content];
	if (responseObj && ![responseObj isKindOfClass: [TopServiceError class]]) {
		responseObj = (NSDictionary *)[responseObj objectForKey:@"taobaoke_rebate_authorize_get_response"];
		self.tbkRebateAuthorize = [[responseObj objectForKey:@"rebate"] boolValue];
	} else {
        self.tbkConvertFailed = YES;
    }
    _isShowBuyButton = YES;
    [self.baseTableView reloadData];
}

- (void) tbkRebateAuthApiCompletion:(MITbkRebateAuthGetModel *)model
{
    MILog(@"tbkRebateAuthApiCompletion=%@", model);
    MITbkAuthrizeItemModel *tbkRebateItem = [model.tbkAuthrizeItems objectAtIndex:0];
    self.tbkRebateAuthorize = tbkRebateItem.rebate.boolValue;
    [self tbkRebateAuthApiError:nil];
}

- (void) tbkRebateAuthApiError:(MIError *)error
{
    _isShowBuyButton = YES;
    self.tbkConvertting = NO;
    self.tbkConvertFailed = !!error;
    [self.baseTableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)goShareAction
{
    [MobClick event:kTaobaoDetailShareClicks];
    if (self.itemModel) {
        MITaobaoItemCell *cell = (MITaobaoItemCell *)[self.baseTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        
        NSString * outerCode = [[MIMainUser getInstance].userId stringValue];
        if (outerCode == nil || outerCode.length == 0) {
            outerCode = @"1";
        }
        NSString *encryptUseDES = [MIUtility encryptUseDES:outerCode key:[MIConfig globalConfig].desKey];
        NSString *url = [NSString stringWithFormat:@"http://m.mizhe.com/share/t.html?iid=%@&pid=%@", self.iid, encryptUseDES];
        NSString *desc = @"米折网（mizhe.com），网购省钱第一站！通过米折网到淘宝、天猫、当当、1号店等600多家商城购物可享最高50%的现金返利，作为导购返利的领导品牌，已受到千万买家的认可和喜爱，苹果AppStore榜首推荐，并获得Hao123和QQ导航等网站权威推荐，安全可靠，值得您的信赖！";
        NSString *comment = @"【分享好东东】通过@米折网 购买还有返利拿哦！";
        NSString *smallImg = [[NSString alloc] initWithFormat:@"%@_100x100.jpg", self.itemModel.picUrl];
        NSString *largeImg = [[NSString alloc] initWithFormat:@"%@_670x670.jpg", self.itemModel.picUrl];
        [MINavigator showShareActionSheetWithUrl:url title:self.itemModel.title desc:desc comment:comment image:cell.itemImageView smallImg:smallImg largeImg:largeImg inView:self.view platform:@"qq_qzone_weixin_timeline_weibo_copy"];
    }
}

#pragma mark - UITabelView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *imageCellIdentifier = @"ImageItemCell";
    static NSString *productCellIdentifier = @"ProductItemCell";
    static NSString *taobaoShopCellIdentifier = @"TaobaoKeItemCell";
    
    if (indexPath.row == 0) {
        MITaobaoItemCell *cell = [tableView dequeueReusableCellWithIdentifier: imageCellIdentifier];
        if (cell == nil) {
            cell = [[MITaobaoItemCell alloc] initWithReuseIdentifier:imageCellIdentifier];
        }
        NSString *imgUrl;
        if([[Reachability reachabilityForInternetConnection] isReachableViaWiFi]){
            imgUrl = [[NSString alloc] initWithFormat:@"%@_670x670.jpg", self.itemModel.picUrl];
        } else {
            imgUrl = [[NSString alloc] initWithFormat:@"%@_310x310.jpg", self.itemModel.picUrl];
        }
        [cell.itemImageView sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"default_avatar_img"]];
        cell.volumeLabel.text = [NSString stringWithFormat:@"最近售出 %d 件", self.itemModel.volume.integerValue];
        return cell;
    } else if (indexPath.row == 1){
        MITaobaokeItemCell *cell = [tableView dequeueReusableCellWithIdentifier: productCellIdentifier];
        if (cell == nil) {
            cell = [[MITaobaokeItemCell alloc] initWithReuseIdentifier:productCellIdentifier];
        }
        cell.rebateImageView.hidden = YES;
        cell.itemBuyLabel.hidden = !_isShowBuyButton;
        cell.itemTitle.text = self.itemModel.title;
        cell.itemTitle.viewHeight = _titleHeight;
        cell.itemBuyLabel.top = cell.itemTitle.bottom + 5;
        cell.itemPrice.top = cell.itemTitle.bottom + 5;
        cell.itemRebate.top = cell.itemPrice.bottom;
        cell.model = self.itemModel;
        cell.clickUrl = self.clickUrl;
        cell.tbkRebateAuthorize = self.tbkRebateAuthorize;
        
        float price = self.itemModel.price.floatValue;
        cell.itemPrice.text = [NSString stringWithFormat:@"原价：<font size=12.0>￥</font> %0.2f ", price];
        
        if (self.tbkConvertting) {
            cell.itemRebate.text = @"返利：<font size=12.0 color='#499d00'>★</font><font color='#499d00'> 查询返利中... </font>";
        } else if (self.tbkConvertFailed) {
            cell.itemRebate.text = @"返利：<font size=12.0 color='#499d00'>★</font><font color='#499d00'> 查询失败，点此重试 </font>";
        } else if (self.clickUrl && self.tbkRebateAuthorize) {
            cell.itemRebate.text = @"返利：<font size=12.0 color='#499d00'>★</font><font color='#499d00'> 有返利 </font>";
            if ([[MIMainUser getInstance] checkLoginInfo]) {
                NSString *imagePath = [NSString stringWithFormat:@"img_skip_vip%@",[MIMainUser getInstance].grade];
                cell.rebateImageView.image = [UIImage imageNamed:imagePath];
                cell.rebateImageView.centerY = cell.itemRebate.centerY;
                cell.rebateImageView.hidden = NO;
            }
        } else {
            cell.itemRebate.text = @"返利：<font size=12.0 color='#499d00'>★</font><font color='#499d00'> 暂无返利 </font>";
        }
        
        return cell;
    } else if (indexPath.row == 2) {
        MITaobaokeShopCell *cell = [tableView dequeueReusableCellWithIdentifier: taobaoShopCellIdentifier];
        if (cell == nil) {
            cell = [[MITaobaokeShopCell alloc] initWithReuseIdentifier:taobaoShopCellIdentifier];
        }
        
        cell.nickLabel.text = [NSString stringWithFormat:@"掌柜：%@", self.itemModel.nick];
        return cell;
    } else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 300;
    } else if (indexPath.row == 1){
        return _titleHeight + 55;
    } else{
        return 60;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 1) {
        if (self.tbkConvertFailed) {
            _isShowBuyButton = NO;
            self.tbkConvertFailed = NO;
            [tableView reloadData];
            [self taobaokeMobileItemConvert];
        }
    } else if (indexPath.row == 2) {
        [MobClick event:kTaobaoShopClicks];
        
        [MINavigator openTbWebViewControllerWithURL:[NSURL URLWithString:self.itemModel.shopUrl] desc:self.itemModel.nick];
    } else {
        MILog(@"unresponse");
    }
}

@end
