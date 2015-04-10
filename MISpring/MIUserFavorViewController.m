//
//  MIUserFavorViewController.m
//  MISpring
//
//  Created by yujian on 14-12-15.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MIUserFavorViewController.h"
#import "MIUserFavorSegment.h"
#import "MIReFreshTableView.h"
#import "MIUserFavorItemGetRequest.h"
#import "MIUserFavorItemGetModel.h"
#import "MIUserFavorItemDeleteRequest.h"
#import "MIUserFavorItemDeleteModel.h"
#import "MIUserFavorBrandGetRequest.h"
#import "MIUserFavorBrandGetModel.h"
#import "MIUserFavorBrandDeleteRequest.h"
#import "MIUserFavorBrandDeleteModel.h"
#import "MIFavorTableView.h"
#import "MIBrandFavorTableView.h"
#import "MIEmptyView.h"
#import "MIMainScrollView.h"

@interface MIUserFavorViewController ()<MIReFreshTableViewDelegate,UIScrollViewDelegate,MIUserFavorSegmentDelegate>
{
    MIUserFavorItemGetRequest *_itemGetRequest;
    MIUserFavorItemDeleteRequest *_itemDeleteRequest;
    MIUserFavorBrandGetRequest *_brandGetRequest;
    MIUserFavorBrandDeleteRequest *_brandDeleteRequest;
    
    MIFavorTableView *_itemFavorTableView;
    MIBrandFavorTableView *_brandFavorTableView;
    MIUserFavorSegment *_segment;
    NSInteger _currentPage;
    MIMainScrollView *_scrollView;
    NSInteger _pageSize;
}

@property (nonatomic, strong) MIFavorTableView *itemFavorTableView;
@property (nonatomic, strong) MIBrandFavorTableView *brandFavorTableView;
@property (nonatomic, assign) BOOL isEditing;

@end

@implementation MIUserFavorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    _isEditing = NO;
    _segment = [[MIUserFavorSegment alloc] initWithFrame:CGRectMake(0, self.navigationBarHeight, self.view.viewWidth, 40)];
    _segment.segmentTitleArray = @[@"特卖商品",@"特卖专场"];
    _segment.delegate = self;
    [_segment freshSegment];
    [self.view addSubview:_segment];
    
    [self.navigationBar setBarTitle:@"开抢提醒"];
    [self.navigationBar setBarRightTextButtonItem:self selector:@selector(edit) title:@"编辑"];
    [self.view bringSubviewToFront:self.navigationBar];

    _pageSize = 100;
    
    __weak typeof(self) weakSelf = self;
    _itemGetRequest = [[MIUserFavorItemGetRequest alloc] init];
    _itemGetRequest.onCompletion = ^(MIUserFavorItemGetModel *model)
    {
        [weakSelf finishLoadItemTableViewData:model];
    };
    _itemGetRequest.onError = ^(MKNetworkOperation* completedOperation, MIError* error) {
        MILog(@"error_msg=%@",error.description);
    };
    
    [_itemGetRequest setPage:-1];
    [_itemGetRequest setPageSize:_pageSize];

    _brandGetRequest = [[MIUserFavorBrandGetRequest alloc] init];
    _brandGetRequest.onCompletion = ^(MIUserFavorBrandGetModel *model)
    {
        [weakSelf finishLoadEventTableViewData:model];
    };
    _itemGetRequest.onError = ^(MKNetworkOperation* completedOperation, MIError* error) {
        MILog(@"error_msg=%@",error.description);
    };
    
    [_brandGetRequest setPage:-1];
    [_brandGetRequest setPageSize:_pageSize];
    
    _itemDeleteRequest = [[MIUserFavorItemDeleteRequest alloc] init];
    _itemDeleteRequest.onCompletion = ^(MIUserFavorItemDeleteModel *model)
    {
        if (model.success.boolValue)
        {
            [weakSelf showSimpleHUD:@"删除成功" afterDelay:1];
            [weakSelf edit];
            if (weakSelf.itemFavorTableView.modelArray.count == 0)
            {
                weakSelf.navigationBar.rightButton.hidden = YES;
            }
        }
        else
        {
            [weakSelf showSimpleHUD:model.message afterDelay:1];
        }
    };
    _itemDeleteRequest.onError = ^(MKNetworkOperation* completedOperation, MIError* error) {
        MILog(@"error_msg=%@",error.description);
    };
    
    _brandDeleteRequest = [[MIUserFavorBrandDeleteRequest alloc] init];
    _brandDeleteRequest.onCompletion = ^(MIUserFavorBrandDeleteModel *model)
    {
        if (model.success.boolValue)
        {
            [weakSelf showSimpleHUD:@"删除成功" afterDelay:1];
            [weakSelf edit];
            if (weakSelf.brandFavorTableView.modelArray.count == 0)
            {
                weakSelf.navigationBar.rightButton.hidden = YES;
            }
        }
    };
    _brandDeleteRequest.onError = ^(MKNetworkOperation* completedOperation, MIError* error) {
        MILog(@"error_msg=%@",error.description);
    };
    
    _scrollView = [[MIMainScrollView alloc] initWithFrame:CGRectMake(0, _segment.bottom, self.view.viewWidth, self.view.viewHeight - _segment.bottom)];
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.bounces = NO;
    _scrollView.backgroundColor = [MIUtility colorWithHex:0xf2f2f2];
    _scrollView.contentSize = CGSizeMake(self.view.viewWidth * 2, _scrollView.viewHeight);
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.scrollsToTop = NO;
    [self.view addSubview:_scrollView];
    
    MIEmptyView *emptyView = [[[NSBundle mainBundle] loadNibNamed:@"MIEmptyView" owner:self options:nil] objectAtIndex:0];
    emptyView.frame = CGRectMake(0, 0, PHONE_SCREEN_SIZE.width, _scrollView.frame.size.height);
    emptyView.type = FavorEmptyType;
    [_scrollView addSubview:emptyView];
    
    MIEmptyView *emptyView2 = [[[NSBundle mainBundle] loadNibNamed:@"MIEmptyView" owner:self options:nil] objectAtIndex:0];
    emptyView2.frame = CGRectMake(self.view.viewWidth, 0, PHONE_SCREEN_SIZE.width, _scrollView.frame.size.height);
    emptyView2.type = BrandFavorEmptyType;
    [_scrollView addSubview:emptyView2];
    
    _itemFavorTableView = [[MIFavorTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.viewWidth, _scrollView.viewHeight)];
    _itemFavorTableView.refreshTableView.refreshTitleImg.image = [UIImage imageNamed:@"txt_refresh_other"];
    _itemFavorTableView.freshDelegate = self;
    [_scrollView addSubview:_itemFavorTableView];
    
    _brandFavorTableView = [[MIBrandFavorTableView alloc] initWithFrame:CGRectMake(self.view.viewWidth, 0, self.view.viewWidth, _scrollView.viewHeight)];
    _brandFavorTableView.refreshTableView.refreshTitleImg.image = [UIImage imageNamed:@"txt_refresh_pinpai"];
    _brandFavorTableView.freshDelegate = self;
    [_scrollView addSubview:_brandFavorTableView];
    
    [_segment selectSegmentIndex:self.type];
}

- (void)setIsEditing:(BOOL)isEditing
{
    _isEditing = isEditing;
    if (_isEditing)
    {
        [self.navigationBar.rightButton setTitle:@"完成" forState:UIControlStateNormal];
    }
    else
    {
        [self.navigationBar.rightButton setTitle:@"编辑" forState:UIControlStateNormal];
    }
}

- (void)edit
{
    _isEditing = !_isEditing;
    if (_currentPage == ItemType)
    {
        _itemFavorTableView.isEditing = _isEditing;
        if (_isEditing)
        {
            [_itemFavorTableView showDeleteBtn];
        }
        else
        {
            [_itemFavorTableView hiddenDeleteBtn];
            [_itemFavorTableView.selectItemsArray removeAllObjects];
        }
        [_itemFavorTableView reloadData];
    }
    else
    {
        _brandFavorTableView.isEditing = _isEditing;
        if (_isEditing)
        {
            [_brandFavorTableView showDeleteBtn];
        }
        else
        {
            [_brandFavorTableView hiddenDeleteBtn];
            [_brandFavorTableView.selectItemsArray removeAllObjects];
        }
        [_brandFavorTableView reloadData];
    }
    if (_isEditing)
    {
        [self.navigationBar.rightButton setTitle:@"完成" forState:UIControlStateNormal];
    }
    else
    {
        [self.navigationBar.rightButton setTitle:@"编辑" forState:UIControlStateNormal];
    }
}

- (void)segmentSelectedItemIndex:(NSInteger)index
{
    if (_currentPage != index) {
        if (index == 0) {
            _itemFavorTableView.scrollsToTop = YES;
            _brandFavorTableView.scrollsToTop = NO;
        }else{
            _itemFavorTableView.scrollsToTop = NO;
            _itemFavorTableView.scrollsToTop = YES;
        }
        _currentPage = index;
        [_scrollView setContentOffset:CGPointMake(index * _scrollView.frame.size.width, 0) animated:YES];
        [self loadCurTableFirstPageData];
    }
}

- (void)loadCurTableFirstPageData
{
    MIReFreshTableView *curTable = nil;
    if (_currentPage == ItemType)
    {
        curTable = _itemFavorTableView;
    }
    else
    {
        curTable = _brandFavorTableView;
    }
    
    self.isEditing = curTable.isEditing;
    if (curTable.modelArray.count == 0)
    {
        self.navigationBar.rightButton.hidden = YES;
        [self sendFirstPageRequest];
    }
    else
    {
        self.navigationBar.rightButton.hidden = NO;
    }
}

- (void)sendFirstPageRequest
{
    if (_currentPage == ItemType)
    {
        [_itemGetRequest setPage:1];
        [_itemGetRequest sendQuery];
        [_itemFavorTableView.overlayView setOverlayStatus:EOverlayStatusLoading labelText:nil];
    }
    else
    {
        [_brandGetRequest setPage:1];
        [_brandGetRequest sendQuery];
        [_brandFavorTableView.overlayView setOverlayStatus:EOverlayStatusLoading labelText:nil];
    }
}

- (void)deletePage:(NSString *)ids
{
    if (_currentPage == ItemType)
    {
        [_itemDeleteRequest setIids:[NSString stringWithFormat:@"%@",ids]];
        [_itemDeleteRequest sendQuery];
    }
    else
    {
        [_brandDeleteRequest setAids:[NSString stringWithFormat:@"%@",ids]];
        [_brandDeleteRequest sendQuery];
    }
}

- (void)sendNextPageRequest
{
    if (_currentPage == ItemType)
    {
        [_itemGetRequest setPage:_itemFavorTableView.currentPage];
        [_itemGetRequest sendQuery];
        [_itemFavorTableView.overlayView setOverlayStatus:EOverlayStatusLoading labelText:nil];
    }
    else
    {
        [_brandGetRequest setPage:_brandFavorTableView.currentPage];
        [_brandGetRequest sendQuery];
        [_brandFavorTableView.overlayView setOverlayStatus:EOverlayStatusLoading labelText:nil];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadCurTableFirstPageData];
}

- (void)finishLoadItemTableViewData:(MIUserFavorItemGetModel *)model
{
    [_itemFavorTableView.refreshTableView egoRefreshScrollViewDataSourceDidFinishedLoading:_itemFavorTableView];
    if (_currentPage == ItemType)
    {
        if (model.favorItems.count > 0)
        {
            self.navigationBar.rightButton.hidden = NO;
        }
        else
        {
           self.navigationBar.rightButton.hidden = YES;
        }
        [_itemFavorTableView finishLoadTableViewData:model.page.integerValue dataSource:model.favorItems totalCount:model.count];
    }
}

- (void)finishLoadEventTableViewData:(MIUserFavorBrandGetModel *)model
{
    [_brandFavorTableView.refreshTableView egoRefreshScrollViewDataSourceDidFinishedLoading:_brandFavorTableView];
    if (_currentPage == BrandType)
    {
        if (model.favorBrands.count > 0)
        {
            self.navigationBar.rightButton.hidden = NO;
        }
        else
        {
            self.navigationBar.rightButton.hidden = YES;
        }
        [_brandFavorTableView finishLoadTableViewData:model.page.integerValue dataSource:model.favorBrands totalCount:model.count];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    _currentPage = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    if (_currentPage != _segment.currentIndex)
    {
        [_segment selectSegmentIndex:_currentPage];
        _segment.currentIndex = _currentPage;
        MIReFreshTableView *curTable = nil;
        if (_currentPage == ItemType)
        {
            curTable = _itemFavorTableView;
            _brandFavorTableView.scrollsToTop = NO;
        }
        else
        {
            curTable = _brandFavorTableView;
            _itemFavorTableView.scrollsToTop = NO;
        }
        curTable.scrollsToTop = YES;

        self.isEditing = curTable.isEditing;
        if (curTable.modelArray.count == 0)
        {
            self.navigationBar.rightButton.hidden = YES;
            [self sendFirstPageRequest];
        }
        else
        {
            self.navigationBar.rightButton.hidden = NO;
        }
    }
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
