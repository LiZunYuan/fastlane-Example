//
//  MITenViewController.m
//  MISpring
//
//  Created by husor on 14-11-7.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MITenViewController.h"
#import "MIBaseTableView.h"
#import "MISVTopObject.h"
#import "MIMainScrollView.h"

@interface MITenViewController ()
{
    MITuanTenGetRequest *_tenGetrequest;
}
@end

@implementation MITenViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.cats = [[NSMutableArray alloc]initWithCapacity:9];
        self.subject = @"10yuan";   // 默认是10元购页面(注意顺序！)
    }
    return self;
}

- (void)setSubject:(NSString *)subject
{
    _subject = subject;
    [self loadTuanCatsData:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    __weak typeof(self) weakSelf = self;
    _tenGetrequest = [[MITuanTenGetRequest alloc] init];
    _tenGetrequest.onCompletion = ^(id model) {
        [weakSelf finishLoadTableViewData:model];
    };
    
    _tenGetrequest.onError = ^(MKNetworkOperation* completedOperation, MIError* error) {
        [weakSelf failLoadTableViewData];
        MILog(@"error_msg=%@",error.description);
    };
    
    [_tenGetrequest setPage:1];
    [_tenGetrequest setPageSize:self.tuanTenPageSize];
    self.request = _tenGetrequest;
}

- (void)setRequestCat
{
    if ([self.cat isEqualToString:@"9kuai9"] || [self.cat isEqualToString:@"19kuai9"])
    {
        [_tenGetrequest setCat:@"all"];
        [_tenGetrequest setSubject:self.cat];
    }
    else
    {
        [_tenGetrequest setCat:self.cat];
        [_tenGetrequest setSubject:self.subject];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)loadTuanCatsData:(BOOL)reload
{
    self.topScrollView.isScrolling = YES;
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
}

- (void)addScreenView
{
    if (!self.screenView) {
        [self setTopScrollCatArray:self.cats];
        self.screenView = [[MIScreenView alloc] initWithArray:self.titleArray];
        self.screenView.delegate = self;
        [self.view addSubview:self.screenView];
        [self.view bringSubviewToFront:self.navigationBar];
    } else {
        [self.screenView reloadContenWithCats:self.titleArray];
    }
    
    self.isShowScreen = NO;
    self.screenView.frame = CGRectMake(0, -self.screenView.viewHeight - 20, self.screenView.viewWidth, self.screenView.viewHeight);
    if (!self.cat || !self.cat.length) {
        self.cat = @"";
    }
    
    self.scroll.contentSize = CGSizeMake(self.view.viewWidth * self.cats.count, self.scroll.viewHeight);
    if (self.tableArr.count > 1) {
        self.currentView = [self.tableArr objectAtIndex:1];
    }
}

- (void)tableWillAppear
{
    [self setRequestCat];
    [super tableWillAppear];
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
