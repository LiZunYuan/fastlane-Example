//
//  MITenTuanViewController.m
//  MISpring
//
//  Created by 曲俊囡 on 14-7-22.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MITenTuanViewController.h"
#import "MITuanTenGetModel.h"
#import "MITuanItemModel.h"
#import "MITuanTenCatModel.h"
#import "NSDate+NSDateExt.h"
#import "NSString+NSStringEx.h"
#import "MITuanItemView.h"


@interface MITenTuanViewController ()

@end

@implementation MITenTuanViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        __weak typeof(self) weakSelf = self;
        self.cat = @"";
        _request = [[MITuanTenGetRequest alloc] init];
        _request.onCompletion = ^(MITuanTenGetModel *model) {
            [weakSelf finishLoadTableViewData:model];
        };
        
        _request.onError = ^(MKNetworkOperation* completedOperation, MIError* error) {
            [weakSelf failLoadTableViewData];
            MILog(@"error_msg=%@",error.description);
        };

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSDate *lastUpdateTuanTime = [[NSUserDefaults standardUserDefaults] objectForKey:kLastUpdateTenTime];
    NSInteger interval = [lastUpdateTuanTime timeIntervalSinceNow];
    if (interval <= MIAPP_ONE_HOUR_INTERVAL && [[Reachability reachabilityForInternetConnection] isReachable]) {
        //如果超出一天，清空特卖缓存
        [self.tuanArray removeAllObjects];
        [self loadTuanCatsData:YES];
    }
    
    if (self.tuanArray.count == 0) {
        [self refreshData];
    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_request cancelRequest];
}

- (void)selectedIndex:(NSInteger)index
{
    [super selectedIndex:index];
    
    if (self.cats.count > index) {
        MITuanTenCatModel *model = [self.cats objectAtIndex:index];
        
        self.cat = model.catId;
        if (self.segmentType == MITuanSegmentViewNone)
        {
            [self.navigationBar setBarTitle:model.catName];
        }
    }
    
    [self refreshData];
}

//- (void)selectedCatId:(NSString *)catId catName:(NSString *)catName
//{
//    [super selectedCatId:catId catName:catName];
//    
//    self.cat = catId;
//    if (self.segmentType == MITuanSegmentViewNone)
//    {
//        [self.navigationBar setBarTitle:catName textSize:20.0];
//    }
//    
//    [self refreshData];
//}

//得到类目cat的数据
- (void)loadTuanCatsData:(BOOL)reload
{
    NSMutableArray *cats = [[MIConfig getTuanCategory] mutableCopy];
    if (![self.subject isEqualToString:@"youpin"])
    {
        MITuanTenCatModel *cat1 = [[MITuanTenCatModel alloc] init];
        cat1.catId = @"9kuai9";
        cat1.catName = @"9.9包邮";
        [cats insertObject:cat1 atIndex:1];
        MITuanTenCatModel *cat2 = [[MITuanTenCatModel alloc] init];
        cat2.catId = @"19kuai9";
        cat2.catName = @"19.9包邮";
        [cats insertObject:cat2 atIndex:2];
    }
    
    self.cats = cats;
    
    [self setTopScrollCatArray:self.cats];
    
    if (!self.screenView) {
        self.screenView = [[MIScreenView alloc] initWithArray:self.titleArray];
        self.screenView.delegate = self;
        [self.view addSubview:self.screenView];
        [self.view bringSubviewToFront:self.navigationBar];
    } else {
        [self.screenView reloadContenWithCats:self.titleArray];
    }
    
    _isShowScreen = NO;
    self.screenView.frame = CGRectMake(0, -self.screenView.viewHeight - 20, self.screenView.viewWidth, self.screenView.viewHeight);
    if (self.cat && self.cat.length) {
        for (MITuanTenCatModel *cat in cats)
        {
            if ([self.cat isEqualToString:cat.catId])
            {
                [self selectedIndex:[cats indexOfObject:cat]];
                break;
            }
        }
    } else {
        self.cat = @"";
    }
}

- (void) refreshData {
    _hasMore = NO;
    [_request cancelRequest];
    [self.tuanArray removeAllObjects];
    [_baseTableView reloadData];
    
    self.loading = YES;
    if ([self.cat isEqualToString:@"9kuai9"] || [self.cat isEqualToString:@"19kuai9"])
    {
        [_request setCat:@"all"];
        [_request setSubject:self.cat];
    }
    else
    {
        [_request setCat:self.cat];
        [_request setSubject:self.subject];
    }
    [_request setPage:1];
    [_request setPageSize:_tuanTenPageSize];
    [_request sendQuery];
    [self setOverlayStatus:EOverlayStatusLoading labelText:nil];
}

#pragma mark - EGOPullFresh methods
-(NSString *)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView *)view
{
    NSString *header;
    if (![self.subject isEqualToString:@"youpin"]) {
        header = @"特价天天有，10元就购了";
    } else {
        header = @"超值性价比，优品特惠";
    }
    return header;
}

//下拉刷新
#pragma mark - EGOPullFresh methods
- (void)reloadTableViewDataSource
{
    if (self.loading) {
        [_request cancelRequest];
    }
    
    self.loading = YES;
    if (self.tuanArray.count > 0) {
        [self setOverlayStatus:EOverlayStatusRemove labelText:nil];
    } else {
        [self setOverlayStatus:EOverlayStatusLoading labelText:nil];
    }
    
    [_request setPage:1];
    [_request sendQuery];
}
- (void)finishLoadTableViewData:(MITuanTenGetModel *)model
{
    [self setOverlayStatus:EOverlayStatusRemove labelText:nil];
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:kLastUpdateTenTime];
    [[NSUserDefaults standardUserDefaults] synchronize];
        
    if (self.loading) {
        self.loading = NO;
        [super finishLoadTableViewData];
    }
    
    if (model.page.integerValue == 1) {
        [self.tuanArray removeAllObjects];
    }
    
    self.totalCount = model.count.integerValue;
    [self.tuanArray addObjectsFromArray:model.tuanItems];
    if (self.tuanArray.count != 0) {
        if (model.tuanItems.count < _tuanTenPageSize) {
            _hasMore = NO;
        } else {
            _hasMore = YES;
        }
        [_baseTableView reloadData];
    } else {
        [self setOverlayStatus:EOverlayStatusEmpty labelText:nil];
    }
    
}

- (void)failLoadTableViewData
{
    [self setOverlayStatus:EOverlayStatusRemove labelText:nil];
    
    if (self.loading) {
        self.loading = NO;
        [super failLoadTableViewData];
    }
    
    if ([self.tuanArray count] == 0) {
        [self setOverlayStatus:EOverlayStatusReload labelText:nil];
    }
}

//刷新产品的cell
- (void)updateCellView:(MITuanItemView *)view tuanModel:(MITuanItemModel *)model
{
    static BOOL timerIsFired = NO;
    
    view.item = model;
    view.cat = self.cat;
    [view.indicatorView startAnimating];
    
    //是否新品
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:model.startTime.doubleValue];
    if (0 == [date compareWithToday])
    {
        view.icNewImgView.hidden = NO;
        view.description.frame = CGRectMake(25, 154, 120, 16);
    }
    else
    {
        view.icNewImgView.hidden = YES;
        view.description.frame = CGRectMake(5, 154, 142, 16);
    }
    
    NSMutableString *imgUrl = [NSMutableString stringWithString:model.img];
    [imgUrl appendString:@"_310x310.jpg"];
    [view.itemImage sd_setImageWithURL:[NSURL URLWithString:imgUrl]];
    
    double nowInterval = [[NSDate date] timeIntervalSince1970] + [MIConfig globalConfig].timeOffset;
    double interval = model.startTime.doubleValue - nowInterval;
    if (interval > 0) {
        view.statusImage.hidden = YES;
        view.price.textColor = [MIUtility colorWithHex:0xff0000];
        view.viewsInfo.textColor = [MIUtility colorWithHex:0x8dbb1a];
        view.viewsInfo.text = [[NSDate dateWithTimeIntervalSince1970:model.startTime.doubleValue] stringForTimeTips2];
        if (timerIsFired == NO) {
            [NSTimer scheduledTimerWithTimeInterval:++interval target:self selector:@selector(reloadTableViewForSale) userInfo:nil repeats:NO];
            timerIsFired = YES;
        }
    } else {
        NSDate *endTime = [NSDate dateWithTimeIntervalSince1970:model.endTime.doubleValue];
        NSInteger intervalEndTime = [endTime timeIntervalSinceNow];
        if (intervalEndTime <= 0) {
            view.viewsInfo.text = @"已结束";
            view.viewsInfo.textColor = [UIColor grayColor];
            view.price.textColor = [UIColor grayColor];
            view.statusImage.hidden = NO;
            view.statusImage.image = [UIImage imageNamed:@"ic_timeout"];
        } else {
            if (model.status.integerValue != 1) {
                //商品已售空
                view.viewsInfo.text = @"抢光了";
                view.viewsInfo.textColor = [UIColor grayColor];
                view.price.textColor = [UIColor grayColor];
                view.statusImage.hidden = NO;
                view.statusImage.image = [UIImage imageNamed:@"ic_sellout"];
            } else {
                NSString *clickColumn;
                float clicksVolumn = model.clicks.floatValue + model.volumn.floatValue;
                if (clicksVolumn >= 10000.0) {
                    clickColumn = [[NSString alloc] initWithFormat:@"%.1f万人在抢", clicksVolumn / 10000.0];
                } else {
                    clickColumn = [[NSString alloc] initWithFormat:@"%.f人在抢", clicksVolumn];
                }
                view.viewsInfo.text = clickColumn;
                view.viewsInfo.textColor = [UIColor lightGrayColor];
                view.statusImage.hidden = YES;
                view.price.textColor = [MIUtility colorWithHex:0xff0000];
            }
        }
    }
    
    NSString *decimal = model.price.pointValue;
    view.price.text = [[NSString alloc] initWithFormat:@"<font size=12.0> ￥</font><font size=24.0>%ld</font><font size=14.0>%@</font>", (long)model.price.integerValue / 100, decimal];
    view.price.textAlignment = NSTextAlignmentLeft;
    NSString *desc = [model.title stringByReplacingOccurrencesOfString:@"【" withString:@"["];
    desc = [desc stringByReplacingOccurrencesOfString:@"，" withString:@","];
    view.description.text = [desc stringByReplacingOccurrencesOfString:@"】" withString:@"]"];
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger count = [self.tuanArray count];
    NSInteger rows = [self tableView:tableView numberOfRowsInSection:0] - 1;
    
    if (_hasMore && (count > 0) && (indexPath.row == rows) && !self.loading) {
        self.loading = YES;
        [_request setPage:(self.tuanArray.count / _tuanTenPageSize + 1)];
        [_request setPageSize:_tuanTenPageSize];
        [_request sendQuery];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
