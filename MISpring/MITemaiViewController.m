//
//  MITemaiViewController.m
//  MISpring
//
//  Created by 曲俊囡 on 14-7-22.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MITemaiViewController.h"
#import "MITuanItemModel.h"
#import "MITuanTenCatModel.h"
#import "NSDate+NSDateExt.h"
#import "NSString+NSStringEx.h"
#import "MITuanItemView.h"
#import "MISVTopObject.h"
#import "MIBaseTableView.h"

@interface MITemaiViewController ()
{
    MITemaiGetRequest *_temaiGetrequest;
}
@end

@implementation MITemaiViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.cats = [[NSMutableArray alloc]initWithCapacity:9];
        [self loadTuanCatsData:YES];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationBar setBarTitle:@"今日特卖"];
    __weak typeof(self) weakSelf = self;
    _temaiGetrequest = [[MITemaiGetRequest alloc] init];
    _temaiGetrequest.onCompletion = ^(id model) {
        [weakSelf finishLoadTableViewData:model];
    };
    
    _temaiGetrequest.onError = ^(MKNetworkOperation* completedOperation, MIError* error) {
        [weakSelf failLoadTableViewData];
        MILog(@"error_msg=%@",error.description);
    };
    
    [_temaiGetrequest setCat:self.cat];
    [_temaiGetrequest setPage:1];
    [_temaiGetrequest setPageSize:self.tuanTenPageSize];
    self.request = _temaiGetrequest;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)finishLoadTableViewData:(id)model
{
    if (self.tableArr.count > self.topScrollView.currentPage) {
        MIBaseTableView *table = [self.tableArr objectAtIndex:self.topScrollView.currentPage];
        [table finishLoadTableViewData:model];
    }
}

- (void)failLoadTableViewData
{
    if (self.tableArr.count > self.topScrollView.currentPage) {
        MIBaseTableView *table = [self.tableArr objectAtIndex:self.topScrollView.currentPage];
        [table failLoadTableViewData];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}


//得到类目cat的数据
- (void)loadTuanCatsData:(BOOL)reload
{
    NSArray *cats = [MIConfig getTuanCategory];
    self.cats = cats;
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

- (void)addScreenView
{
    [self setTopScrollCatArray:self.cats];
    if (!self.screenView) {
        self.screenView = [[MIScreenView alloc] initWithArray:self.titleArray];
        self.screenView.delegate = self;
        [self.view addSubview:self.screenView];
        [self.view bringSubviewToFront:self.navigationBar];
    } else {
        [self.screenView reloadContenWithCats:self.titleArray];
    }
    
    self.isShowScreen = NO;
    self.screenView.frame = CGRectMake(0, -self.screenView.viewHeight - 20, self.screenView.viewWidth, self.screenView.viewHeight);
}

- (void)tableWillAppear
{
    [_temaiGetrequest setCat:self.cat];
    [super tableWillAppear];
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
