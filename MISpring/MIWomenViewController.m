//
//  MIWomenViewController.m
//  MISpring
//
//  Created by 曲俊囡 on 15/3/26.
//  Copyright (c) 2015年 Husor Inc. All rights reserved.
//

#import "MIWomenViewController.h"
#import "MINavigationBarTitleButtonView.h"
#import "MIWomenCatoryView.h"
#import "MIAdService.h"

@interface MIWomenViewController ()

@property (nonatomic, strong) NSMutableArray *categoryArray;
@property (nonatomic, strong) MINavigationBarTitleButtonView *titleView;
@property (nonatomic, strong) UIView *shadowView;
@property (nonatomic, strong) MIWomenCatoryView *screenView;
@property (nonatomic, strong) MIPageBaseRequest *temaiReq;

@end

@implementation MIWomenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _titleView = [[MINavigationBarTitleButtonView alloc] initWithFrame:CGRectMake(80, self.navigationBarHeight - PHONE_NAVIGATION_BAR_ITEM_HEIGHT, SCREEN_WIDTH / 2, PHONE_NAVIGATION_BAR_ITEM_HEIGHT)];
    _titleView.centerX = SCREEN_WIDTH / 2;
    [self.titleView setBarTitle:self.catName textSize:20.0];
    
    __weak typeof(self) weakSelf = self;
    [self.titleView setShowScreenViewBlock:^(BOOL isShowScreen) {
        if (isShowScreen)
        {
            [weakSelf showScreenView];
        }
        else
        {
            [weakSelf hiddenScreenView];
        }
    }];
    [self.navigationBar addSubview:self.titleView];
    
    _womenTableView = [[MIWomenTableView alloc] initWithFrame:CGRectMake(0, self.navigationBar.bottom, PHONE_SCREEN_SIZE.width, self.view.viewHeight - self.navigationBar.bottom)];
    self.womenTableView.refreshTableView.refreshTitleImg.image = [UIImage imageNamed:@"txt_refresh_default"];
    
    
    _temaiReq  = [[MIPageBaseRequest alloc] init];
    self.temaiReq.onCompletion = ^(id model) {
        [weakSelf.womenTableView finishLoadTableViewData:model];
    };
    
    self.temaiReq.onError = ^(MKNetworkOperation* completedOperation, MIError* error){
        [weakSelf.womenTableView failLoadTableViewData];
        MILog(@"error_msg=%@",error.description);
    };
    
    [self requestSetURL:self.cat];
    [self.temaiReq setPage:1];
    [self.temaiReq setPageSize:20];
    [self.temaiReq setModelName:NSStringFromClass([MITemaiGetModel class])];
    self.womenTableView.request = self.temaiReq;
    [self.view addSubview:self.womenTableView];
    self.womenTableView.isShowShortCuts = NO;
    [self.womenTableView willAppearView];
    
    _shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, PHONE_SCREEN_SIZE.width, self.view.viewHeight)];
    self.shadowView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.35];
    self.shadowView.alpha = 0;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenScreenView)];
    [self.shadowView addGestureRecognizer:tap];
    [self.view addSubview:self.shadowView];
    [self loadCategoryData];
}

- (void)requestSetURL:(NSString *)cat
{
    NSString *apiUrl = [NSString stringWithFormat:@"http://m.mizhe.com/temai/nvzhuang---{int}-{int}---1-%@.html",cat];
    apiUrl = [apiUrl stringByReplacingOccurrencesOfString:@"{int}" withString:@"%d"];
    [self.temaiReq setFormat:apiUrl];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self hiddenScreenView];
    
}

- (void)hiddenScreenView
{
    if (self.screenView) {
        self.shadowView.alpha = 0;
        self.titleView.screenImageView.image = [UIImage imageNamed:@"the_drop_down"];
        self.titleView.hasShowScreenView = NO;
        [UIView animateWithDuration:0.3 animations:^{
            self.screenView.frame = CGRectMake(0, -self.screenView.viewHeight - 20, PHONE_SCREEN_SIZE.width, self.screenView.viewHeight);
        }];
    }
}
- (void)showScreenView
{
    if (self.screenView)
    {
        [UIView animateWithDuration:0.3 animations:^{
            self.shadowView.alpha = 1;
            self.titleView.screenImageView.image = [UIImage imageNamed:@"Up_arrow"];
            self.titleView.hasShowScreenView = YES;
            self.screenView.frame = CGRectMake(0, self.navigationBarHeight, PHONE_SCREEN_SIZE.width, self.screenView.viewHeight);
        }];
    }
}
//得到类目cat的数据
- (void)loadCategoryData
{
    _categoryArray = [[NSMutableArray alloc] initWithCapacity:8];
    [[MIAdService sharedManager] loadAdWithType:@[@(Nvzhuang_Cat_Shortcuts)] block:^(MIAdsModel *model) {
        [self.categoryArray removeAllObjects];
        if (model.nvzhuangCatShortcuts.count <= 8)
        {
            [self.categoryArray addObjectsFromArray:model.nvzhuangCatShortcuts];
        }
        else
        {
            for (int i = 0; i < 8; i++)
            {
                [self.categoryArray addObject:[model.nvzhuangCatShortcuts objectAtIndex:i]];
            }
        }
        
        if (!self.screenView) {
            _screenView = [[MIWomenCatoryView alloc] initWithArray:self.categoryArray];
            self.screenView.frame = CGRectMake(0, -self.screenView.viewHeight - 20, PHONE_SCREEN_SIZE.width, self.screenView.viewHeight);
            self.screenView.delegate = self;
            self.screenView.catName = self.catName;
            [self.screenView showSelectedCategory];
            [self.view addSubview:self.screenView];
            [self.view bringSubviewToFront:self.navigationBar];
        } else {
            [self.screenView reloadContenWithCats:self.categoryArray];
        }
        
        //初始化参数为全部
        _cat = @"";
        _isShowScreen = NO;
        self.screenView.frame = CGRectMake(0, -self.screenView.viewHeight - 20, self.screenView.viewWidth, self.screenView.viewHeight);
    }];
}

- (void)selectedIndex:(NSInteger)index
{
    [self hiddenScreenView];
    [self.titleView setBarTitle:[[self.categoryArray objectAtIndex:index] objectForKey:@"desc"] textSize:20.0];
    [self requestSetURL:[[self.categoryArray objectAtIndex:index] objectForKey:@"data"]];
    [self.womenTableView refreshData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
