//
//  MIMainTableView.m
//  MISpring
//
//  Created by yujian on 14-12-11.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MIMainTableView.h"
#import "MIAdService.h"
#import "MITuanItemsCell.h"
#import "MIAdsAlertView.h"
#import "MIMainHeaderAdView.h"

@interface MIMainTableView()<MIAdsAlertViewDelegate>
{
    BOOL _hasLoadMainAds;       // 是否加载了首页广告数据
    BOOL _hasLoadFirstPage;     // 是否加载了首页第一页数据
}
@property (nonatomic, strong) NSArray *mizheShortCuts;
@property (nonatomic, strong) NSArray *recommendHeader;
@property (nonatomic, strong) NSArray *ads;
@property (nonatomic, strong) NSArray *promotionShortcuts;
@property (nonatomic, strong) NSArray *squareShortcuts;
@property (nonatomic, strong) NSArray *middleBanners;
@property (nonatomic, strong) NSArray *dialogAds;
@property (nonatomic, strong) NSArray *mainHeaderAds;
@property (nonatomic, strong) MIAdsAlertView *adsAlert;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) MIMainHeaderAdView *mainHeaderAdView;

@end

@implementation MIMainTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _adBox = [[MIAdView alloc] init];
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, PHONE_SCREEN_SIZE.width, self.adBox.viewHeight + 75)];
        [_headerView addSubview:self.adBox];
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, self.adBox.bottom, PHONE_SCREEN_SIZE.width, 1)];
        line.backgroundColor = [UIColor colorWithWhite:0.75 alpha:0.45];
        [_headerView addSubview:line];
        
        _shortView = [[MIMainShortView alloc] initWithFrame:CGRectMake(0, line.bottom, PHONE_SCREEN_SIZE.width, 74)];
        [_headerView addSubview:_shortView];
        
        _bigAdsView = [[[NSBundle mainBundle] loadNibNamed:@"MIMainAdsView" owner:self options:nil] objectAtIndex:0];
//        _bigAdsView.frame = CGRectMake(0, _shortView.bottom, self.viewWidth, 160 + 8);
        _bigAdsView.frame = CGRectMake(0, _shortView.bottom, self.viewWidth, 0);
        [_headerView addSubview:_bigAdsView];
        
//        _middleAdsView = [[MITopAdView alloc] initWithFrame:CGRectMake(0, 0, self.viewWidth, 58)];
        _middleAdsView = [[MITopAdView alloc] initWithFrame:CGRectMake(0, 0, self.viewWidth, 0)];
        _middleAdsView.clickEventLabel = kHomeSmallAds;
        UIView *clipLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.viewWidth, 8)];
        clipLineView.backgroundColor = MILineColor;
        [_middleAdsView addSubview:clipLineView];
        _middleAdsView.top = _bigAdsView.bottom;
        [_headerView addSubview:_middleAdsView];
        
        _squareAdsView = [[[NSBundle mainBundle] loadNibNamed:@"MISquareAdsView" owner:self options:nil]objectAtIndex:0];
//        _squareAdsView.frame = CGRectMake(0, _middleAdsView.bottom, self.viewWidth, 128);
        _squareAdsView.frame = CGRectMake(0, _middleAdsView.bottom, self.viewWidth, 0);
        [_headerView addSubview:_squareAdsView];
        
        self.tableView.backgroundColor = MINormalBackgroundColor;
    }
    return self;
}

- (void)willAppearView
{
    [super willAppearView];
    [self loadMainAdsView];
}

- (void)loadMainAdsView
{
    __weak typeof(self) weakSelf = self;
    [[MIAdService sharedManager] loadAdWithType:@[@(Ads),@(MI_Shortcuts),@(Recommend_Header),@(Promotion_Shortcuts),@(Square_Shortcuts),@(Middle_Banners),@(Popup_Ads),@(Temai_Header_Banners)] block:^(MIAdsModel *model) {
        _ads = model.ads;
        _mizheShortCuts = model.mizheShortcuts;
        _recommendHeader = model.recommendHeader;
        _promotionShortcuts = model.promotionShortcuts;
        _squareShortcuts = model.squareShortcuts;
        _middleBanners = model.middleBanners;
        _dialogAds = model.popupAds;
        _mainHeaderAds = model.temaiHeaderBanners;
        [weakSelf loadDialogAds];
        [weakSelf loadAds];
        _hasLoadMainAds = YES;
        // 已经加载了首页数据，但还未显示，则改变overlay的状态
        if (_hasLoadFirstPage && self.overlayView.status != EOverlayStatusRemove) {
            [weakSelf.overlayView setOverlayStatus:EOverlayStatusRemove labelText:nil];
        }
        [weakSelf.tableView reloadData];
    }];
}

- (void)loadDialogAds
{
    if (_dialogAds.count > 0)
    {
        // 对于已点击过的弹框广告，不再显示
        NSDictionary *dict = [_dialogAds objectAtIndex:0];
        NSString *lastClickImage = [[NSUserDefaults standardUserDefaults] objectForKey:@"kClickDialogAdsImage"];
        if ([[dict objectForKey:@"beibei"] integerValue] == 1 || (lastClickImage && [lastClickImage isEqualToString:[dict objectForKey:@"img"]])) {
            return;
        }

        if (_adsAlert == nil) {
            _adsAlert = [[MIAdsAlertView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            [_adsAlert setAdsImageViewUrl:[NSURL URLWithString:[dict objectForKey:@"img"]]];
            _adsAlert.delegate = self;
        }
    }
}

-(void)showDailogAds
{
    if (_adsAlert && _adsAlert.superview == nil) {
        NSString *alertTime = [[NSUserDefaults standardUserDefaults] objectForKey:MINotifyDialogAdsTime];
        NSString *nowTime = [[NSDate date] stringForYymmdd];
        if (![alertTime isEqualToString:nowTime])
        {
            [[UIApplication sharedApplication].keyWindow addSubview:_adsAlert];
            [[NSUserDefaults standardUserDefaults] setObject:nowTime forKey:MINotifyDialogAdsTime];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
}

- (void)finishLoadTableViewData:(id)model
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date]
                                              forKey:kLastUpdateTemaiTime];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [super finishLoadTableViewData:model needReload:NO];
    if ([model isKindOfClass:[MITemaiGetModel class]]) {
        MITemaiGetModel *temaiModel = (MITemaiGetModel *)model;
        _hasLoadFirstPage = YES;
        if (temaiModel.page.integerValue != 1 || _hasLoadMainAds) {
            [self.tableView reloadData];
        } else {
            // 广告数据未回来，继续伪造正在请求中
            [self.overlayView setOverlayStatus:EOverlayStatusLoading labelText:nil];
        }
    }
}

- (void)clickAdsView
{
    if (_dialogAds.count > 0)
    {
        NSDictionary *dict = [_dialogAds objectAtIndex:0];
        [MINavigator openShortCutWithDictInfo:dict];
        
        [[NSUserDefaults standardUserDefaults] setObject:[dict objectForKey:@"img"] forKey:@"kClickDialogAdsImage"];
        [[NSUserDefaults standardUserDefaults] synchronize];

    }
}

- (void)loadAds
{
    [self.adBox addADsImageViews:_ads];

    if (_mizheShortCuts.count >= 4)
    {
        if (![_mizheShortCuts isEqual:self.shortView.data])
        {
            [self.shortView loadData:_mizheShortCuts];
        }
    }
    else if(self.shortView.data.count == 0)
    {
        NSString *dataPath =  [[NSBundle mainBundle] pathForResource:@"iconshortcut.local" ofType:@"data"];
        NSData *data = [NSData dataWithContentsOfFile:dataPath];
        if (data.length > 0)
        {
            NSArray * array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            [self.shortView loadData:array];
        }
    }
    
    UIView *header = _headerView;
    
    if (_promotionShortcuts.count == 4)
    {
        self.bigAdsView.hidden = NO;
        self.bigAdsView.frame = CGRectMake(0, _shortView.bottom, SCREEN_WIDTH, SCREEN_WIDTH / 2 + 8);
        [self.bigAdsView loadData:_promotionShortcuts];
    }
    else
    {
        self.bigAdsView.hidden = YES;
        self.bigAdsView.frame = CGRectMake(0, _shortView.bottom, self.viewWidth, 0);
    }
    
    if (_middleBanners.count > 0)
    {
        self.middleAdsView.hidden = NO;
        self.middleAdsView.adsArray = _middleBanners;
        
        [self.middleAdsView loadAds];
        self.middleAdsView.frame = CGRectMake(0, self.bigAdsView.bottom + 8, self.viewWidth, self.middleAdsView.viewHeight);
    }
    else
    {
        self.middleAdsView.hidden = YES;
        self.middleAdsView.frame = CGRectMake(0, self.bigAdsView.bottom, self.viewWidth, 0);
    }
    
    if (_squareShortcuts.count >= 3)
    {
        _squareAdsView.hidden = NO;
        _squareAdsView.frame = CGRectMake(0, self.middleAdsView.bottom, self.viewWidth, 136 * SCREEN_WIDTH / 320);
        [_squareAdsView loadData:_squareShortcuts];
    }
    else
    {
        _squareAdsView.hidden = YES;
        _squareAdsView.frame = CGRectMake(0, self.middleAdsView.bottom, self.viewWidth, 0);
    }
    header.viewHeight = _squareAdsView.bottom;
    if (_mainHeaderAdView) {
        [_mainHeaderAdView removeAllSubviews];
    } else {
        _mainHeaderAdView = [[MIMainHeaderAdView alloc] initWithFrame:CGRectMake(0, _squareAdsView.bottom, self.viewWidth, 0)];
    }
    _mainHeaderAdView.top = _squareAdsView.bottom;
    [_mainHeaderAdView loadData:_mainHeaderAds];
    header.viewHeight += _mainHeaderAdView.viewHeight;
    [header addSubview:_mainHeaderAdView];

    self.tableView.tableHeaderView = header;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = [self.modelArray count] + [_recommendHeader count];
    NSInteger number = count / 2 + count % 2;
    return number;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger count = [self.modelArray count] + [_recommendHeader count];
    NSInteger rows = [self tableView:tableView numberOfRowsInSection:0] - 1;
    
    if (self.hasMore && (indexPath.row == rows) && (count > 0)) {
        return 50;
    } else {
        return (SCREEN_WIDTH - 24) / 2 + 48 + 8;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger count = [self.modelArray count];
    NSInteger rows = [self tableView:tableView numberOfRowsInSection:0] - 1;
    
    static NSString *ContentIdentifier = @"TuanItemsCellReuseIdentifier";
    static NSString *LoadMoreIdentifier = @"LoadMoreCellReuseIdentifier";
    if (self.hasMore && (count > 0) && (indexPath.row == rows)) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LoadMoreIdentifier];
        if(!cell){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LoadMoreIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            
            UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            indicatorView.center = CGPointMake(100, 25);
            indicatorView.tag = 999;
            
            cell.textLabel.textAlignment = UITextAlignmentCenter;
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.textLabel.text = @"加载中...";
            [cell addSubview:indicatorView];
        }
        
        UIActivityIndicatorView *indicatorView = (UIActivityIndicatorView *)[cell viewWithTag:999];
        [indicatorView startAnimating];
        
        return cell;
    } else {
        MITuanItemsCell *tuanItemsCell = [tableView dequeueReusableCellWithIdentifier:ContentIdentifier];
        if (!tuanItemsCell) {
            tuanItemsCell = [[MITuanItemsCell alloc] initWithreuseIdentifier:ContentIdentifier];
            tuanItemsCell.selectionStyle = UITableViewCellSelectionStyleNone;
            tuanItemsCell.backgroundColor = [UIColor clearColor];
        }
        
        for (NSInteger i = indexPath.row*2; i < (indexPath.row + 1) * 2; i ++) {
            @try {
                
                if (i < _recommendHeader.count) {
                    
                    NSDictionary *dic = [_recommendHeader objectAtIndex:i];
                    if (i == indexPath.row*2) {
                        tuanItemsCell.itemView1.hidden = NO;
                        tuanItemsCell.itemView1.adView.hidden = NO;
                        tuanItemsCell.itemView1.dic = dic;
                        tuanItemsCell.itemView1.type = MITuanInsertAds;
                        [tuanItemsCell.itemView1.adView sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"img"]] placeholderImage:nil];
                    }
                    else{
                        tuanItemsCell.itemView2.hidden = NO;
                        tuanItemsCell.itemView2.adView.hidden = NO;
                        tuanItemsCell.itemView2.dic = dic;
                        tuanItemsCell.itemView2.type = MITuanInsertAds;
                        [tuanItemsCell.itemView2.adView sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"img"]] placeholderImage:nil];
                    }
                }
                else
                {
                    
                    id model = [self.modelArray objectAtIndex:i - _recommendHeader.count];
                    if (i == indexPath.row*2) {
                        tuanItemsCell.itemView1.hidden = NO;
                        tuanItemsCell.itemView1.adView.hidden = YES;
                        tuanItemsCell.itemView1.type = MITuanNormal;
                        [self updateCellView:tuanItemsCell.itemView1 tuanModel:model];
                    } else {
                        tuanItemsCell.itemView2.hidden = NO;
                        tuanItemsCell.itemView2.adView.hidden = YES;
                        tuanItemsCell.itemView2.type = MITuanNormal;
                        [self updateCellView:tuanItemsCell.itemView2 tuanModel:model];
                    }
                }
            }
            @catch (NSException *exception) {
                if (i == indexPath.row*2) {
                    tuanItemsCell.itemView1.hidden = YES;
                } else {
                    tuanItemsCell.itemView2.hidden = YES;
                }
            }
        }
        
        return tuanItemsCell;
    }
}



@end
