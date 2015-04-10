//
//  MIRebateMainViewController.m
//  MISpring
//
//  Created by XU YUJIAN on 13-1-25.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIRebateMainViewController.h"
#import "MIFavoriteViewController.h"
#import "MIMallReloadModel.h"

@implementation MIRebateMainViewController
@synthesize searchBar = _searchBar;
@synthesize tbShortcutView = _tbShortcutView;
@synthesize mallSuggestsView = _mallSuggestsView;
@synthesize reloadMobileMallsRequest = _reloadMobileMallsRequest;
@synthesize hotMalls = _hotMalls;


- (void)viewDidLoad
{
    [super viewDidLoad];   
	// Do any additional setup after loading the view.
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, self.navigationBarHeight - PHONE_NAVIGATION_BAR_ITEM_HEIGHT, PHONE_SCREEN_SIZE.width, PHONE_NAVIGATION_BAR_ITEM_HEIGHT)];
    _searchBar.backgroundColor = [UIColor clearColor];
    _searchBar.placeholder = @"输入宝贝关键字查返利";
    _searchBar.delegate = self;
    _searchBar.translucent = YES;
    _searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    _searchBar.tintColor = [UIColor lightGrayColor];
    _searchBar.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
    if (IOS_VERSION >= 7.0) {
        _searchBar.barTintColor = [UIColor whiteColor];
        for(UIView *subview in [[[self.searchBar subviews] objectAtIndex:0] subviews])
        {
            if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
                [subview removeFromSuperview];
                break;
            }
        }
    } else {
        [[_searchBar.subviews objectAtIndex:0] removeFromSuperview];
    }
    [_searchBar setSearchFieldBackgroundImage:[[UIImage imageNamed:@"search_bar_textfield_indexbg"] resizableImageWithCapInsets: UIEdgeInsetsMake(0, 10, 0, 10)] forState:UIControlStateNormal];
    [self.navigationBar addSubview:_searchBar];
    
    self.baseTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _baseTableView.frame = CGRectMake(0, self.navigationBarHeight, self.view.viewWidth, self.view.viewHeight - TABBAR_HEIGHT - self.navigationBarHeight);
    _baseTableView.alpha = 0;
    _baseTableView.backgroundColor = [UIColor clearColor];
    _baseTableView.backgroundView.alpha = 0;
    _baseTableView.showsVerticalScrollIndicator = NO;
    _baseTableView.delegate = self;
    _baseTableView.dataSource = self;
    _baseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view sendSubviewToBack:self.baseTableView];
    _baseTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    
//    if ([MIConfig globalConfig].showJifen)
//    {
//        _headerView = [[MIRebateHeaderView alloc] initWithFrame:CGRectMake(0, 0, PHONE_SCREEN_SIZE.width, 75)];
//        self.baseTableView.tableHeaderView = self.headerView;
//    }
    self.tbShortcutView = [[MITbShortcutView alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 20, 140)];
    self.mallSuggestsView = [[MIMallSuggestsView alloc] initWithFrame: CGRectMake(10, 0, SCREEN_WIDTH - 20, MIMALL_SUGGEST_TABLECELL_HEIGHT*7)];
    _mallSuggestsView.clipsToBounds = YES;
    _mallSuggestsView.layer.cornerRadius = 3;
    _mallSuggestsView.tableView.scrollEnabled = NO;
    _mallSuggestsView.tableView.showsVerticalScrollIndicator = YES;
    [self setOverlayStatus:EOverlayStatusLoading labelText:nil];

    self.hotMalls = [[NSMutableArray alloc] initWithCapacity:20];

    __weak typeof(self) wself = self;
    _reloadMobileMallsRequest = [[MIMallReloadRequest alloc] init];
    [_reloadMobileMallsRequest setType:[NSNumber numberWithBool:TRUE]];
    [_reloadMobileMallsRequest setLast:[NSNumber numberWithInt:0]];
    [_reloadMobileMallsRequest setSummary:[NSNumber numberWithBool:TRUE]];
    _reloadMobileMallsRequest.onCompletion = ^(MIMallReloadModel *model) {
        [NSKeyedArchiver archiveRootObject:model.malls toFile:[[MIMainUser documentPath] stringByAppendingPathComponent:@"hot.malls.data"]];
        [wself finishLoadTableViewData:model.malls];
    };
    
    _reloadMobileMallsRequest.onError = ^(MKNetworkOperation* completedOperation, MIError* error) {
        [wself failLoadTableViewData];
        MILog(@"error_msg=%@",error.description);
    };
    
    NSString *hotMallsDataPath = [[MIMainUser documentPath] stringByAppendingPathComponent:@"hot.malls.data"];
    NSDictionary *attrDict = [[NSFileManager defaultManager] attributesOfItemAtPath:hotMallsDataPath error:NULL];
    NSDate *fileModifiedDate = [attrDict objectForKey:NSFileModificationDate];
    if (attrDict != nil && [fileModifiedDate timeIntervalSinceNow] > MIAPP_ONE_DAY_INTERVAL) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^
                       {
                           NSArray *malls = [NSKeyedUnarchiver unarchiveObjectWithFile:hotMallsDataPath];
                           dispatch_async(dispatch_get_main_queue(), ^
                                          {
                                              [self finishLoadTableViewData:malls];
                                          });
                       });
    } else {
        [_reloadMobileMallsRequest sendQuery];
    }
}

- (void)finishLoadTableViewData:(NSArray *)malls
{
    _baseTableView.alpha = 1;
    [self setOverlayStatus:EOverlayStatusRemove labelText:nil];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^
                   {
                       NSMutableDictionary *dict = [MIConfig getAdsConfigInfo];
                       NSMutableArray *adsArrayDicts = [dict mutableArrayValueForKey:@"taobao_shortcut"];
                       dispatch_async(dispatch_get_main_queue(), ^
                                      {
                                          [self.tbShortcutView loadData:adsArrayDicts];
                                      });
                   });
    
    [_hotMalls removeAllObjects];
    [_hotMalls addObjectsFromArray:malls];
    
    NSInteger count = malls.count + 1;
    NSInteger number = count / 3;
    if (count % 3 != 0) {
        number += 1 ;
    }
    
    self.mallSuggestsView.viewHeight = MIMALL_SUGGEST_TABLECELL_HEIGHT * number;
    self.mallSuggestsView.tableView.viewHeight = self.mallSuggestsView.viewHeight;

    [_mallSuggestsView loadData:malls];
}

- (void)failLoadTableViewData
{
    NSString *adsDataPath = [[MIMainUser documentPath] stringByAppendingPathComponent:@"hot.malls.data"];
    NSArray *malls = [NSKeyedUnarchiver unarchiveObjectWithFile:adsDataPath];
    [self finishLoadTableViewData:malls];
}

# pragma mark - Private methods
- (void)goToMyFavor
{
    MIFavoriteViewController * vc = [[MIFavoriteViewController alloc] init];
    [[MINavigator navigator] openPushViewController:vc animated:YES];
}

#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    MITbSearchViewController *searchViewController = [[MITbSearchViewController alloc] init];
    [[MINavigator navigator] openPushViewController:searchViewController animated:NO];
    return NO;
}

#pragma mark - TableView datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((0 == indexPath.row) || (2 == indexPath.row))
    {
        return 35;
    }
    else if (1 == indexPath.row)
    {
        return 140;
    }
    else
    {
        return self.mallSuggestsView.viewHeight;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.row)
    {
        UITableViewCell *taobaoRebateCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"taobaoRebate"];
        taobaoRebateCell.selectionStyle = UITableViewCellSelectionStyleNone;
        taobaoRebateCell.backgroundColor = [UIColor clearColor];
        RTLabel *taobaoTipsLabel = [[RTLabel alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH - 20, 25)];
        taobaoTipsLabel.text = @"<font face='HelveticaNeue-CondensedBold' size=18.0 color='#FF7B52'>淘宝返利</font>  最高返利50%";
        taobaoTipsLabel.font = [UIFont systemFontOfSize:12.0];
        taobaoTipsLabel.textColor = [UIColor lightGrayColor];
        taobaoTipsLabel.backgroundColor = [UIColor clearColor];
        taobaoTipsLabel.layer.shadowColor = [UIColor whiteColor].CGColor;
        taobaoTipsLabel.layer.shadowOffset = CGSizeMake(0, -0.8);
        taobaoTipsLabel.textAlignment = RTTextAlignmentLeft;
        [taobaoRebateCell addSubview: taobaoTipsLabel];
        return taobaoRebateCell;
    }
    else if (1 == indexPath.row)
    {
        UITableViewCell *rebateCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"rebate"];
        rebateCell.selectionStyle = UITableViewCellSelectionStyleNone;
        rebateCell.backgroundColor = [UIColor clearColor];
        [rebateCell addSubview:self.tbShortcutView];
        return rebateCell;
    }
    else if (2 == indexPath.row)
    {
        UITableViewCell *mallRebateCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"mallRebate"];
        mallRebateCell.selectionStyle = UITableViewCellSelectionStyleNone;
        mallRebateCell.backgroundColor = [UIColor clearColor];
        
        RTLabel *mallTipsLabel = [[RTLabel alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH - 20, 25)];
        mallTipsLabel.text = @"<font face='HelveticaNeue-CondensedBold' size=18.0 color='#FF7B52'>商城返利</font>  600家知名商城返利";
        mallTipsLabel.font = [UIFont systemFontOfSize:12.0];
        mallTipsLabel.textColor = [UIColor lightGrayColor];
        mallTipsLabel.backgroundColor = [UIColor clearColor];
        mallTipsLabel.layer.shadowColor = [UIColor whiteColor].CGColor;
        mallTipsLabel.layer.shadowOffset = CGSizeMake(0, -0.8);
        mallTipsLabel.textAlignment = RTTextAlignmentLeft;
        [mallRebateCell addSubview: mallTipsLabel];
        
        UIButton *myFavButton = [UIButton buttonWithType:UIButtonTypeCustom];
        myFavButton.frame = CGRectMake(250, 10, 60, 20);
        myFavButton.backgroundColor = [MIUtility colorWithHex:0xFF7B52];
        myFavButton.layer.cornerRadius = 10;
        [myFavButton setTitle:@"关注商城" forState:UIControlStateNormal];
        myFavButton.titleLabel.font = [UIFont systemFontOfSize:11.0];
        [myFavButton addTarget:self action:@selector(goToMyFavor) forControlEvents:UIControlEventTouchUpInside];
        [mallRebateCell addSubview:myFavButton];
        return mallRebateCell;
    }
    else
    {
        UITableViewCell *mallSuggestsCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"mallRebate"];
        mallSuggestsCell.selectionStyle = UITableViewCellSelectionStyleNone;
        mallSuggestsCell.backgroundColor = [UIColor clearColor];
     
        [mallSuggestsCell addSubview:_mallSuggestsView];
        return mallSuggestsCell;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
