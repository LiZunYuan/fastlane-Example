//
//  MIAddFavViewController.m
//  MISpring
//
//  Created by 贺晨超 on 13-10-9.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIAddFavViewController.h"


#pragma mark - mallView
@interface MallView : UIView
@property NSString *mallId;
@property UIImageView *mallImg;
@property UILabel *mallCommission;
@property UIButton *btnAdd;
@property UIButton *mallView;
@property MIMallModel *mall;
@property UIActivityIndicatorView *indicatorView;

@end

@implementation MallView
@synthesize mallId = _mallId;
@synthesize mallImg = _mallImg;
@synthesize mallCommission = _mallCommission;
@synthesize btnAdd = _btnAdd;
@synthesize mallView = _mallView;
@synthesize mall = _mall;
@synthesize indicatorView = _indicatorView;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _mallView = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 90, 90)];
        
        _mallImg = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 80, 40)];
        [_mallImg setContentMode:UIViewContentModeScaleAspectFit];
        _indicatorView= [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _indicatorView.tag = 999;
        _indicatorView.center = CGPointMake(_mallImg.viewWidth / 2, _mallImg.viewHeight / 2);
        [_mallImg addSubview:_indicatorView];
        _mallCommission = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, 90, 15)];
        _mallCommission.lineBreakMode = UILineBreakModeWordWrap|UILineBreakModeClip;
        _mallCommission.font = [UIFont systemFontOfSize:12];
        _mallCommission.textColor = [UIColor lightGrayColor];
        _mallCommission.textAlignment = UITextAlignmentCenter;
        
        [_mallView addSubview:_mallImg];
        [_mallView addSubview:_mallCommission];
        
        [_mallView setExclusiveTouch:YES];
        [_mallView addTarget:self action:@selector(onGotoMall) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_mallView];
        
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 72, 100, 1)];
        line.alpha = 0.3;
        [line setBackgroundColor:[UIColor lightGrayColor]];
        [self addSubview:line];
        
        _btnAdd = [[UIButton alloc] initWithFrame:CGRectMake(5, 76, 90, 20)];
        _btnAdd.adjustsImageWhenHighlighted = NO;
        [_btnAdd setExclusiveTouch:YES];
        [_btnAdd setBackgroundColor:[UIColor whiteColor]];
        _btnAdd.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
        [_btnAdd setImageEdgeInsets:UIEdgeInsetsMake(0.0, -5, 0.0, 0.0)];
        
        [self addSubview:_btnAdd];
        
    }
    return self;
}

- (void) onGotoMall
{
    NSString *mallUrl = [NSString stringWithFormat: @"%@rebate/mobile/%@?uid=%d", [MIConfig globalConfig].goURL, _mall.mallId, 1];
    MIMallWebViewController *vc = [[MIMallWebViewController alloc] initWithURL:[NSURL URLWithString:mallUrl] mall:_mall];
    [[MINavigator navigator] openPushViewController:vc animated:YES];
}


@end

@interface MallTableCell : UITableViewCell

@property(nonatomic, strong) UIView * contView;
@property(nonatomic, strong) NSMutableArray * views;
@property(nonatomic, strong) NSMutableArray *imageViews;
@property(nonatomic, strong) NSMutableArray *labels;
@property(nonatomic, strong) NSMutableArray *moreLabels;


@end

@implementation MallTableCell
@synthesize contView = _contView;
@synthesize views = _views;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.viewHeight - 90);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
		self.backgroundColor = [UIColor clearColor];
        
        _views = [[NSMutableArray alloc] initWithCapacity:3];
        
        for (int i = 0; i < 3; i++) {
            int x = 105 * i + 5;
            MallView *view = [[MallView alloc] initWithFrame:CGRectMake(x, 5, 100, 100)];
            view.clipsToBounds = YES;
            view.backgroundColor = [UIColor whiteColor];
            view.layer.cornerRadius = 5;
            view.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:1].CGColor;
            view.layer.borderWidth = 0.5;
            [self addSubview:view];
            [_views addObject:view];
        }
    }
    return self;
}

@end


@implementation MIAddFavViewController

@synthesize searchBar = _searchBar;
@synthesize searchDisplay = _searchDisplay;
@synthesize searchNote = _searchNote;
@synthesize mallData = _mallData;
@synthesize mallSearchRequest = _mallSearchRequest;
@synthesize hasMore = _hasMore;
@synthesize mallCount = _mallCount;

@synthesize tableView = _tableView;


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationBar setBarTitle:@"添加商城关注" textSize:20.0];
    
    [self buildSearchBar];
    [self buildTabelView];
    [self buildSearchNote];
    
    [_searchNote setHidden:NO];
    
    _mallData = [[NSMutableArray alloc] initWithCapacity:10];
    _mallCount = 0;
    _loading = YES;
    
    __block typeof(self) bself = self;
    _mallSearchRequest = [[MIMallGetRequest alloc] init];
    [_mallSearchRequest setPage:1];
    [_mallSearchRequest setPageSize:20];
    _mallSearchRequest.onCompletion = ^(MIMallGetModel *model) {
        [bself finishLoadMallData:model];
    };
    
    _mallSearchRequest.onError = ^(MKNetworkOperation* completedOperation, MIError* error) {
        [bself loadFailed];
        MILog(@"error_msg=%@",error.description);
    };

    [_mallSearchRequest sendQuery];
    [self setOverlayStatus:EOverlayStatusLoading labelText:nil];
}

- (void)buildTabelView
{
    _tableView = [[UITableView alloc] initWithFrame: CGRectMake(0,  self.navigationBarHeight + self.searchBar.viewHeight, SCREEN_WIDTH, self.view.viewHeight - self.navigationBarHeight - self.searchBar.viewHeight) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundView.alpha  = 0;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 5)];
    
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView setBackgroundColor: [UIColor clearColor]];
    [self.view addSubview:_tableView];
}

- (void)buildSearchNote
{
    _searchNote = [[UILabel alloc] init];
    _searchNote.frame = CGRectMake(0, 220, SCREEN_WIDTH, 50);
    _searchNote.font = [UIFont systemFontOfSize:16.0];
    _searchNote.textAlignment = UITextAlignmentCenter;
    _searchNote.text = @"请输入商城关键词开始搜索\n需要添加关注的商城";
    _searchNote.backgroundColor = [UIColor clearColor];
    _searchNote.textColor = [MIUtility colorWithHex:0x808080];
    _searchNote.numberOfLines = 0;
    [self.view addSubview:_searchNote];
}

- (void)buildSearchBar
{
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, self.navigationBarHeight, SCREEN_WIDTH, self.navigationBarHeight)];
    _searchBar.placeholder = @"搜索添加商城关注";
    _searchBar.delegate = self;
    _searchBar.translucent = YES;
    _searchBar.tintColor = [UIColor lightGrayColor];
    _searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;

    if (IOS_VERSION >= 7.0) {
        UIImage *bgImage = [UIImage imageNamed:@"navigator_bar_bg"];
        _searchBar.barTintColor = [UIColor colorWithPatternImage:bgImage];
    } else {
        [[_searchBar.subviews objectAtIndex:0] removeFromSuperview];
    }
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"search_bar_bg"] resizableImageWithCapInsets: UIEdgeInsetsZero]];
    imageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.navigationBarHeight);
    [_searchBar insertSubview:imageView atIndex:0];
    [_searchBar setSearchFieldBackgroundImage:[[UIImage imageNamed:@"search_bar_textfield_bg"] resizableImageWithCapInsets: UIEdgeInsetsMake(0, 10, 0, 10)] forState:UIControlStateNormal];
    [self.view addSubview: _searchBar];
    
    _searchDisplay = [[UISearchDisplayController alloc] initWithSearchBar:_searchBar contentsController:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSString *lastVersion = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastVersion"];
    if (lastVersion != nil && ([lastVersion isEqualToString:@"2.0.0"] || [lastVersion isEqualToString:@"2.0.1"])) {
        [MITipView showAlertTipWithKey:@"MIAddFavViewController" message:@"由于淘宝的合作策略调整，添加店铺关注功能暂不能使用，请谅解！"];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:1 forKey:@"updateFavs"];
}

#pragma mark - scrollView && page
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_searchBar resignFirstResponder];
}

#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
    if (IOS_VERSION < 7.0) {
        for (UIView *subView in _searchBar.subviews){
            if([subView isKindOfClass:[UIButton class]]){
                [(UIButton*)subView setTitle:@"取消" forState:UIControlStateNormal];
                UIImage *barButton = [[UIImage imageNamed:@"barButtonLight"] resizableImageWithCapInsets:UIEdgeInsetsMake(15, 10, 15, 10)];
                UIImage *barButtonPressed = [[UIImage imageNamed:@"barButton"] resizableImageWithCapInsets:UIEdgeInsetsMake(15, 10, 15, 10)];
                [(UIButton*)subView setBackgroundImage:barButton forState:UIControlStateNormal];
                [(UIButton*)subView setBackgroundImage:barButtonPressed forState:UIControlStateHighlighted];
                break;
            }
        }
    }
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text = nil;
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [_searchBar setShowsCancelButton:NO animated:YES];
    [_searchBar resignFirstResponder];
    
    [_mallData removeAllObjects];
    [_tableView reloadData];

    self.loading = YES;
    [_mallSearchRequest setPageSize:20];
    [_mallSearchRequest setPage:1];
    [_mallSearchRequest setQ:searchBar.text];
    [_mallSearchRequest sendQuery];
    [self setOverlayStatus:EOverlayStatusLoading labelText:nil];
}

#pragma mark - UITableViewDataSource
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger count = [_mallData  count];
    NSInteger rows = [self tableView:_tableView numberOfRowsInSection:0] - 1;
    if (_hasMore && (indexPath.row == rows) && !self.loading) {
        self.loading = YES;
        [self loadMoreMall:(count / 20 + 1)];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    MILog(@"table count %d",[_mallData count]);
    if ([_mallData count] % 3 == 0) {
        return [_mallData count] / 3 ;
    } else {
        return [_mallData count] / 3 + 1 ;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger rows = [self tableView:_tableView numberOfRowsInSection:0] - 1 ;
    if ((indexPath.row == rows && [_mallData count] > 0))  {
        if (_hasMore) {
            return 50;
        } else {
            return 105;
        }
    }
    return 105;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger rows = [self tableView:_tableView numberOfRowsInSection:0] - 1;
    if (_hasMore && (indexPath.row == rows && [_mallData count] > 0)){
        UITableViewCell *loadCell = [tableView dequeueReusableCellWithIdentifier:@"mall_more"];
        if(!loadCell){
            loadCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"mall_more"];
            loadCell.selectionStyle = UITableViewCellSelectionStyleNone;
            loadCell.backgroundColor = [UIColor clearColor];
            
            UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            indicatorView.center = CGPointMake(MISEARCH_SHORTCUT_SIZE.width/2 - 80, 25);
            indicatorView.tag = 10001;
            [indicatorView startAnimating];
            
            loadCell.textLabel.textAlignment = UITextAlignmentCenter;
            loadCell.textLabel.font = [UIFont systemFontOfSize:14];
            loadCell.textLabel.text = @"加载中...";
            [loadCell addSubview:indicatorView];
        }
        
        UIActivityIndicatorView *indicator = (UIActivityIndicatorView *)[loadCell viewWithTag:10001];
        [indicator startAnimating];
        
        return loadCell;
    } else {
        MallTableCell *cell = [tableView dequeueReusableCellWithIdentifier: @"right_mall"];
        if (cell == nil) {
            cell = [[MallTableCell alloc]
                    initWithStyle:UITableViewCellStyleValue1
                    reuseIdentifier:@"right_mall"];
        }
        int j = 0;
        for (int i = indexPath.row * 3; i < (indexPath.row + 1) * 3; i ++, j++) {
            @try {
                MallView *view = (MallView *)[cell.views objectAtIndex:j];
                MIMallModel *model = [_mallData objectAtIndex:i];
                view.mall = model;
                view.hidden = NO;
                
                
                NSMutableArray * hasFavs = [self getFavs];
                
                [view.btnAdd setTitleColor:[MIUtility colorWithHex:0x009FA3] forState:UIControlStateNormal];
                [view.btnAdd setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
                UIImage *image = [UIImage imageNamed:@"ic_add_addmall"];
                [view.btnAdd setImage:image forState:UIControlStateNormal];
                [view.btnAdd setTitle:@"添加关注" forState:UIControlStateNormal];
                
                for (MIFavsModel *hf in hasFavs) {
                    if ( [hf.iid isEqualToString: model.mallId] ) {
                        [view.btnAdd setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                        [view.btnAdd setTitleColor:[MIUtility colorWithHex:0x009FA3] forState:UIControlStateHighlighted];
                        UIImage *image = [UIImage imageNamed:@"ic_add_succeed"];
                        [view.btnAdd setImage:image forState:UIControlStateNormal];
                        [view.btnAdd setTitle:@"取消关注" forState:UIControlStateNormal];
                        break;
                    }
                }
                
                [view.btnAdd addTarget:self action:@selector(onAddMallBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [view.btnAdd setTag:i];
                UIActivityIndicatorView *indicator = view.indicatorView;
                [indicator startAnimating];
                UIImageView *imageView = view.mallImg;
                
                [imageView sd_setImageWithURL: [NSURL URLWithString:model.logo]];
                
                UILabel *commissionLabel = view.mallCommission;
                float commission;
                if (model.type.integerValue == 1 && model.mobileCommission.floatValue != 0) {
                    //移动商城
                    commission = [model.mobileCommission floatValue] / 100;
                } else {
                    commission = [model.commission floatValue] / 100;
                }
                
                if ([model.commissionType isEqualToString:@"2"]) {
                    //最高返利为按元计算
                    commissionLabel.text = [NSString stringWithFormat:@"最高返%.1f元", commission];
                } else {
                    //最高返利为按比例计算
                    commissionLabel.text = [NSString stringWithFormat:@"最高返%.1f%%", commission];
                }
            }
            @catch (NSException *exception) {
                MILog(@"CATCH");
                ((MallView *)[cell.views objectAtIndex:j]).hidden = YES;
            }
        }
        return cell;
    }
}

#pragma mark - Private Method
- (void) loadMoreMall:(NSInteger)page
{
    self.loading = YES;
    [_mallSearchRequest setPage:page];
    [_mallSearchRequest setPageSize:20];
    [_mallSearchRequest sendQuery];
}

- (void) loadFailed {
    self.loading = NO;
    [self setOverlayStatus:EOverlayStatusRemove labelText:nil];
}

- (void) finishLoadMallData:(MIMallGetModel *)model {
    self.loading = NO;
    
    _mallCount = model.count.integerValue;
    [_mallData addObjectsFromArray:model.malls];
    if (model.count.integerValue > [_mallData count]) {
        _hasMore = YES;
    } else {
        _hasMore = NO;
    }
    
    [self setOverlayStatus:EOverlayStatusRemove labelText:nil];
    if (_mallData.count == 0) {
        [self setOverlayStatus:EOverlayStatusEmpty labelText:@"亲，换个关键字试试哦"];
    } else {
        [_searchNote setHidden:YES];
    }
    [_tableView reloadData];
}

- (void) onAddMallBtnClick:(UIButton *)sender
{
    MIMallModel *_mall = [_mallData objectAtIndex:sender.tag];
    MIFavsModel *favModel = [[MIFavsModel alloc] init];
    favModel.iid = _mall.mallId;
    favModel.name = _mall.name;
    favModel.domain = @"";
    favModel.deletable = @"1";
    favModel.commissionMode = _mall.mode.stringValue;
    favModel.commissionType = _mall.commissionType;
    favModel.type = @"1";
    favModel.logo = _mall.logo;
    favModel.mallType = _mall.type;
    if (_mall.type.boolValue && _mall.mobileCommission.floatValue != 0) {
        favModel.commission = _mall.mobileCommission;
    } else {
        favModel.commission = _mall.commission;
    }
    BOOL isFaved = NO;
    
    NSMutableArray * hasFavs = [self getFavs];
    
    for (MIFavsModel *hf in hasFavs) {
        if ([hf.iid isEqualToString: _mall.mallId]) {
            isFaved = YES;
            break;
        }
    }
    
    if ( [hasFavs count] == 0 || isFaved == NO ) {
        [self addFavs:favModel];
        [sender setTitle:@"取消关注" forState:UIControlStateNormal];
        [sender setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [sender setTitleColor:[MIUtility colorWithHex:0x009FA3] forState:UIControlStateHighlighted];
        UIImage *image = [UIImage imageNamed:@"ic_add_succeed"];
        [sender setImage:image forState:UIControlStateNormal];
    } else{
        [self delFavs:favModel];
        [sender setTitle:@"添加关注" forState:UIControlStateNormal];
        [sender setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [sender setTitleColor:[MIUtility colorWithHex:0x009FA3] forState:UIControlStateNormal];
        UIImage *image = [UIImage imageNamed:@"ic_add_addmall"];
        [sender setImage:image forState:UIControlStateNormal];
    }

    [MobClick event:kAddFavsMall label:_mall.name];
}

- (NSMutableArray *) getFavs
{
    NSString * favDataPath = [[MIMainUser documentPath] stringByAppendingPathComponent:@"home.fav.data"];
    NSMutableArray *hasFavs = [[NSMutableArray alloc] initWithCapacity:10];
    [hasFavs addObjectsFromArray:[NSKeyedUnarchiver unarchiveObjectWithFile:favDataPath]];
    
    return hasFavs;
}

- (void) addFavs: (MIFavsModel *)model
{
    NSMutableArray * hasFavs = [self getFavs];
    [hasFavs addObject: model];
    
    [NSKeyedArchiver archiveRootObject:hasFavs toFile:[[MIMainUser documentPath] stringByAppendingPathComponent:@"home.fav.data"]];
}

- (void)delFavs: (MIFavsModel *)model
{
    NSMutableArray * hasFavs = [self getFavs];
    for (MIFavsModel * hf in hasFavs) {
        
        if ( [hf.iid isEqualToString: model.iid] ) {
            [hasFavs removeObject: hf];
            break;
        }
    }
    [NSKeyedArchiver archiveRootObject:hasFavs toFile:[[MIMainUser documentPath] stringByAppendingPathComponent:@"home.fav.data"]];
}

@end
