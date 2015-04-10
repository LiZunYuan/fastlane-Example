//
//  MITbkItemsViewController.m
//  MISpring
//
//  Created by lsave on 13-3-18.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MITbkItemsViewController.h"
#import "MITbkItemGetModel.h"
#import "MITbkItemModel.h"
#import "TbkItemTableViewCell.h"
#import "MITuanItemView.h"
#import "MITuanItemsCell.h"
#import "MIBrandRecomModel.h"


#define kMaxPage 20
#define kPageSize 20
#define kMoreCellItemTags 99
#define SORT_VIEW_HEIGHT 36

@implementation MITbkItemsViewController

@synthesize requestReturned = _requestReturned;
@synthesize keywords = _keywords;
@synthesize numiid = _numiid;
@synthesize sort = _sort;
@synthesize isTmall = _isTmall;
@synthesize page = _page;
@synthesize request = _request;
@synthesize tableView = _tableView;
@synthesize dataList = _dataList;
@synthesize filterView = _filterView;

@synthesize sortSwitchView = _sortSwitchView;
@synthesize minPrice = _minPrice;
@synthesize maxPrice = _maxPrice;


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationBar setBarTitle:_keywords textSize:20.0];
    
    _tableView = [[UITableView alloc] initWithFrame: CGRectMake(0, SORT_VIEW_HEIGHT + self.navigationBarHeight, 320, self.view.viewHeight - self.navigationBarHeight - SORT_VIEW_HEIGHT) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.alpha = 0;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    _page = 1;
    _sort = @"default";
    _isTmall = @"false";
    _minPrice = @"0";
    _maxPrice = @"99999999";
    _dataList = [[NSMutableArray alloc] init];
    
    _sortSwitchView = [[MITbItemSortsView alloc] init];
    _sortSwitchView.top = self.navigationBarHeight;
    _sortSwitchView.delegate = self;
    [self.view addSubview:_sortSwitchView];
    
    _recomTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.navigationBarHeight, PHONE_SCREEN_SIZE.width, self.view.viewHeight - self.navigationBarHeight) style:UITableViewStylePlain];
    _recomTableView.backgroundColor = [UIColor clearColor];
    _recomTableView.dataSource = self;
    _recomTableView.delegate = self;
    _recomTableView.alpha = 0;
    _recomTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_recomTableView];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, PHONE_SCREEN_SIZE.width, 110)];
    headerView.backgroundColor = [MIUtility colorWithHex:0xeeeeee];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, PHONE_SCREEN_SIZE.width, 74)];
    label.backgroundColor = [UIColor whiteColor];
    label.text = @"没有结果，换个关键字搜下吧~";
    label.font = [UIFont systemFontOfSize:18];
    label.textColor = [UIColor lightGrayColor];
    label.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:label];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 75, PHONE_SCREEN_SIZE.width, 30)];
    titleLabel.backgroundColor = [UIColor whiteColor];
    titleLabel.text = @"  今日品牌特卖";
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textColor = [UIColor darkGrayColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [headerView addSubview:titleLabel];
    self.recomTableView.tableHeaderView = headerView;
    
    _filterView = [[MITbFilterViewController alloc] init];
    _filterView.delegate = self;
    [self.view bringSubviewToFront:self.navigationBar];
    
    [self.navigationBar setBarRightTextButtonItem:self selector:@selector(toggleFilter:) title:@"筛选"];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(hud) weakHud = hud;
    _request = [[MITbkItemGetRequest alloc] init];
    [_request setQ: self.keywords];
    [_request setPage:_page];
    [_request setPageSize:kPageSize];
    
    __weak typeof(self) weakSelf = self;
    _request.onCompletion = ^(MITbkItemGetModel * model) {
        [weakHud hide: true];
        [weakSelf finishLoadTableViewData:model];
    };
    _request.onError = ^(MKNetworkOperation* completedOperation, NSError *error) {
        [weakHud hide: true];
        if ([weakSelf.dataList count] == 0) {
            [weakSelf setOverlayStatus:EOverlayStatusError labelText:nil];
        }
    };
    [_request sendQuery];
    
    _brandItemRecomRequest = [[MITuanBrandItemRecomGetRequest alloc] init];
    [_brandItemRecomRequest useCache];
    _brandItemRecomRequest.onCompletion = ^(MITuanBrandItemRecomGetModel *model) {
        [weakSelf finishLoadBrandRecomData:model];
    };
    
    _brandItemRecomRequest.onError = ^(MKNetworkOperation* completedOperation, MIError* error) {

        MILog(@"error_msg=%@",error.description);
    };

}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if ([_request.operation isExecuting]) {
        [_request cancelRequest];
    }
    if ([_brandItemRecomRequest.operation isExecuting])
    {
        [_brandItemRecomRequest cancelRequest];
    }
}
//请求品牌特卖推荐的商品
- (void)finishLoadBrandRecomData:(MITuanBrandItemRecomGetModel *)model
{
    _brandrecomArray = (NSMutableArray *)model.brandRecoms;
    if (_brandrecomArray.count)
    {
        [self.recomTableView reloadData];
        self.recomTableView.alpha = 1;
        self.tableView.alpha = 0;
        _sortSwitchView.alpha = 0;
    } else {
        _sortSwitchView.alpha = 1;
        self.tableView.alpha = 1;
        self.recomTableView.alpha = 0;
    }
    [self setOverlayStatus:EOverlayStatusRemove labelText:nil];
}

- (void)finishLoadTableViewData:(MITbkItemGetModel * )model
{
    if ([model.tbkItems count] > 0) {
        [self.dataList removeAllObjects];
        [self.dataList addObjectsFromArray:model.tbkItems];
    }
    
    if ([model.tbkItems count] < kPageSize) {
        self.requestReturned = NO;
    } else {
        self.requestReturned = YES;
    }
    [self setOverlayStatus:EOverlayStatusRemove labelText:nil];
    if ([model.tbkItems count] == 0)
    {
        _sortSwitchView.alpha = 0;
        self.tableView.alpha = 0;
        [_brandItemRecomRequest sendQuery];
        [self setOverlayStatus:EOverlayStatusLoading labelText:nil];
    } else {
        self.recomTableView.alpha = 0;
        _sortSwitchView.alpha = 1;
        self.tableView.alpha = 1;
        [self.tableView reloadData];
        [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];

    }
}

- (void) toggleFilter:(UIButton *)btn
{
    [_request cancelRequest];
    [[MINavigator navigator] openPushViewController:_filterView animated:YES];
}

#pragma mark - MITbItemSortsViewDelegate
- (void)didSelectTbItemSortsKey:(NSString *)sortsKey
{
    MILog(@"sortKey=%@", sortsKey);
    if (self.numiid || self.dataList.count < kPageSize) {
        return;
    }
    
    if (self.loading) {
        [_request cancelRequest];
    }
    
    // reset
    _page = 1;
    _sort = sortsKey;
    _requestReturned = YES;
    
    [_request setQ: self.keywords];
    [_request setPage: _page];
    [_request setPageSize:kPageSize];
    [_request setSort: sortsKey];
    [_request setMaxPrice: _maxPrice];
    [_request setMinPrice: _minPrice];
    [_request setIsTmall: _isTmall];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    __weak typeof(hud) weakHud = hud;
    __weak typeof(self) weakSelf = self;
    _request.onCompletion = ^(MITbkItemGetModel * model) {
        [weakHud hide: true];
        [weakSelf finishLoadTableViewData:model];
    };
    _request.onError = ^(MKNetworkOperation* completedOperation, NSError *error) {
        [weakHud hide: true];
    };
    
    [_request sendQuery];
    self.loading = YES;
    
    [MobClick event:kTaobaoFilterSort label:sortsKey];
}

#pragma mark - MITaobaoFilterViewControllerDelegate
- (void)searchFilterUIViewDidCancel:(NSMutableArray *)filterInfo    
{   
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    // reset
    _page = 1;
    
    _minPrice = [filterInfo objectAtIndex:1];
    _maxPrice = [filterInfo objectAtIndex:2];
    _isTmall = [filterInfo objectAtIndex:0];
    _requestReturned = YES;

    [_request setQ: self.keywords];
    [_request setPage: _page];
    [_request setPageSize:kPageSize];
    [_request setSort: _sort];
    [_request setMaxPrice: _maxPrice];
    [_request setMinPrice: _minPrice];
    [_request setIsTmall: _isTmall];
    
    __weak typeof(hud) bhud = hud;
    __weak typeof(self) weakSelf = self;
    _request.onCompletion = ^(MITbkItemGetModel * model) {
        [bhud hide: true];
        [weakSelf finishLoadTableViewData:model];
    };
    _request.onError = ^(MKNetworkOperation* completedOperation, NSError *error) {
        [bhud hide: true];
    };
    [_request sendQuery];
    
    [MobClick event:kTaobaoFilterSort label:_sort];
}

#pragma mark - UITableViewDataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.recomTableView)
    {
        NSInteger count = [_brandrecomArray count];
        if (count == 0) {
            return 0;
        }
        
        NSInteger number = count / 2 + count % 2;
        return number;
    }
    else
    {
        if (_page >= kMaxPage) {
            return [_dataList count];
        } else {
            return [_dataList count] + 1;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.recomTableView)
    {
        static NSString *ContentIdentifier = @"TuanItemsCellReuseIdentifier";
        MITuanItemsCell *tuanItemsCell = [tableView dequeueReusableCellWithIdentifier:ContentIdentifier];
        if (!tuanItemsCell) {
            tuanItemsCell = [[MITuanItemsCell alloc] initWithreuseIdentifier:ContentIdentifier];
            tuanItemsCell.selectionStyle = UITableViewCellSelectionStyleNone;
			tuanItemsCell.backgroundColor = [UIColor clearColor];
        }
        
        for (int i = indexPath.row*2; i < (indexPath.row + 1) * 2; i ++) {
            @try {
                id model = [_brandrecomArray objectAtIndex:i];
                if (i == indexPath.row*2) {
                    tuanItemsCell.itemView1.hidden = NO;
                    [self updateCellView:tuanItemsCell.itemView1 tuanModel:model];
                } else {
                    tuanItemsCell.itemView2.hidden = NO;
                    [self updateCellView:tuanItemsCell.itemView2 tuanModel:model];
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
    else
    {
        static NSString *itemCellIdentifier = @"TbkItemCell";
        static NSString *moreCellIdentifier = @"MoreItemCell";
        
        NSUInteger row = indexPath.row;
        UITableViewCell *cell = nil;
        if ([_dataList count] > row) {
            cell = [tableView dequeueReusableCellWithIdentifier: itemCellIdentifier];
            if (cell == nil) {
                cell = [[TbkItemTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:itemCellIdentifier];
                cell.backgroundColor = [UIColor clearColor];
            }
            
            MITbkItemModel * model = ((MITbkItemModel *)[_dataList objectAtIndex:row]);
            TbkItemTableViewCell *tbkItemCell = (TbkItemTableViewCell *)cell;
            
            NSString * imagePostfix = @"_160x160.jpg";
            if ([UIScreen mainScreen].scale != 1) {
                imagePostfix = @"_270x270.jpg";
            }
            
            [tbkItemCell.imageView setImageWithURL: [NSURL URLWithString: [NSString stringWithFormat:@"%@%@", model.picUrl, imagePostfix]] placeholderImage: [UIImage imageNamed:@"default_avatar_img"]];
            tbkItemCell.titleLabel.text = model.title;
            
            if ([model.price isEqualToString: model.promotionPrice]) {
                tbkItemCell.priceLabel.text = [NSString stringWithFormat:@"<font size=12>￥</font> %.2f", [model.price floatValue]];
                [tbkItemCell.delPriceLabel setStrikeThroughEnabled:false];
                tbkItemCell.delPriceLabel.text = nil;
            } else {
                tbkItemCell.priceLabel.text = [NSString stringWithFormat:@"<font size=12>￥</font> %.2f", [model.promotionPrice floatValue]];
                [tbkItemCell.delPriceLabel setStrikeThroughEnabled:true];
                tbkItemCell.delPriceLabel.text = [NSString stringWithFormat:@"￥%.2f", [model.price floatValue]];
            }
            
            CGSize constraintSize= CGSizeMake(tbkItemCell.priceLabel.viewWidth, MAXFLOAT);
            CGSize expectedSize = [tbkItemCell.priceLabel.text sizeWithFont:tbkItemCell.priceLabel.font constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
            tbkItemCell.delPriceLabel.left = tbkItemCell.priceLabel.left + expectedSize.width + 6;
            
            if ([_isTmall isEqualToString:@"true"]) {
                UIImage *img = [UIImage imageNamed:@"tmall_icon.png"];
                [tbkItemCell.creditImg setFrame:CGRectMake(320 - 15 - 5, 94 + 5, 12, 12)];
                [tbkItemCell.creditImg setImage:img];
            }
            
            tbkItemCell.saveLabel.text = [NSString stringWithFormat: @"<font size=12 color='#499d00'>★ %@</font>", model.commissionDesc];
            
            tbkItemCell.volumeLabel.text = [NSString stringWithFormat:@"最近售出：%d 件", [model.volume unsignedIntValue]];
        } else {
            cell = [tableView dequeueReusableCellWithIdentifier: moreCellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:moreCellIdentifier];
                cell.backgroundColor = [UIColor clearColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                UILabel * label = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, 320, 50)];
                [label setText:@"点击或上拉加载更多..."];
                [label setTextAlignment: NSTextAlignmentCenter];
                [label setTextColor: [UIColor lightGrayColor]];
                [label setFont: [UIFont systemFontOfSize:16]];
                [label setTag: kMoreCellItemTags];
                
                [cell addSubview:label];
            }
            
            UILabel * label = (UILabel *)[cell viewWithTag:kMoreCellItemTags];
            if (_requestReturned) {
                [label setText: @"点击或上拉加载更多..."];
            } else {
                [label setText: @"亲，没有了哦~"];
            }
        }
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView)
    {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.selected = false;
        
        if ([_dataList count] > indexPath.row) {
            [MobClick event:kTaobaoItemClicks];
            
            MITbkItemModel * model = (MITbkItemModel *)self.dataList[[indexPath row]];
            if ([[MIMainUser getInstance] checkLoginInfo]) {
                [MINavigator openTbViewControllerWithNumiid:model.numIid desc:@"商品详情"];
            } else {
                UIAlertView *alertView = [[UIAlertView alloc] initWithLoginCancelAction:^{
                    [MINavigator openTbViewControllerWithNumiid:model.numIid desc:@"商品详情"];
                }];
                [alertView show];
            }
        } else {
            if (_requestReturned) {
                UILabel * label = (UILabel *)[cell viewWithTag:kMoreCellItemTags];
                [label setText: @"正在加载..."];
                [self loadMoreTableViewDataSource];
            } 
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.recomTableView)
    {
        return 206.5;
    }
    else
    {
        if ([_dataList count] > indexPath.row) {
            return 120;
        } else {
            return 50;
        }
    }
}
//刷新产品的cell
- (void)updateCellView:(MITuanItemView *)view tuanModel:(id)model
{
    view.labelImageView.hidden = YES;
    [view.indicatorView startAnimating];

    MIBrandRecomModel *recomModel = (MIBrandRecomModel *)model;
    view.item = recomModel;
    
    NSMutableString *imgUrl = [NSMutableString stringWithString:recomModel.img];
    [imgUrl appendString:@"_310x310.jpg"];
    [view.itemImage setImageWithURL:[NSURL URLWithString:imgUrl]];
    
    double nowInterval = [[NSDate date] timeIntervalSince1970] + [MIConfig globalConfig].timeOffset;
    double interval = recomModel.startTime.doubleValue - nowInterval;
    if (interval > 0) {
        view.viewsInfo.textColor = [MIUtility colorWithHex:0x8dbb1a];
        view.viewsInfo.text = [[NSDate dateWithTimeIntervalSince1970:recomModel.startTime.doubleValue] stringForTimeTips2];
    } else {
        view.viewsInfo.backgroundColor = [UIColor clearColor];
        view.viewsInfo.frame = CGRectMake(70, 176, 75, 20);
        view.viewsInfo.textAlignment = NSTextAlignmentRight;
        double nowInterval = [[NSDate date] timeIntervalSince1970] + [MIConfig globalConfig].timeOffset;
        if (recomModel.endTime.doubleValue <= nowInterval) {
            view.viewsInfo.text = @"已结束";
            view.viewsInfo.textColor = [UIColor grayColor];
            view.statusImage.hidden = NO;
            view.statusImage.image = [UIImage imageNamed:@"ic_timeout"];
        } else {
            if (recomModel.status.integerValue != 1) {
                //商品已售空
                view.viewsInfo.text = @"抢光了";
                view.viewsInfo.textColor = [UIColor grayColor];
                view.statusImage.hidden = NO;
                view.statusImage.image = [UIImage imageNamed:@"ic_sellout"];
            } else {
                view.statusImage.hidden = YES;
                view.viewsInfo.text = [NSString stringWithFormat:@"%.1f折",recomModel.discount.floatValue /10.0];
                view.viewsInfo.textColor = [UIColor lightGrayColor];
            }
        }
    }
    
    NSInteger price = recomModel.price.integerValue % 100;
    NSString *decimal;
    if (price < 10) {
        decimal = [[NSString alloc] initWithFormat:@"%d0",price];
    } else {
        decimal = [[NSString alloc] initWithFormat:@"%d",price];
    }
    
    view.price.text = [[NSString alloc] initWithFormat:@"<font size=12.0> ￥</font><font size=24.0>%d</font><font size=14.0>.%@</font>", recomModel.price.integerValue / 100, decimal];
    view.price.textAlignment = NSTextAlignmentLeft;
    NSString *desc = [recomModel.title stringByReplacingOccurrencesOfString:@"【" withString:@"["];
    desc = [desc stringByReplacingOccurrencesOfString:@"，" withString:@","];
    view.description.text = [desc stringByReplacingOccurrencesOfString:@"】" withString:@"]"];
}

#pragma mark - UIScrollViewDelegate Methods
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (_page == kMaxPage) {
        return;
    }
    
    //上拉刷新
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.bounds;
    CGSize size = scrollView.contentSize;
    UIEdgeInsets inset = scrollView.contentInset;
    float y = offset.y + bounds.size.height - inset.bottom;
    if((y > size.height + 60) && _requestReturned) {
        UITableViewCell *cell = [_tableView cellForRowAtIndexPath: [NSIndexPath indexPathForRow: [_dataList count] inSection:0]];
        UILabel * label = (UILabel *)[cell viewWithTag:kMoreCellItemTags];
        if (label) {
            [label setText: @"正在加载..."];
        }
        [self loadMoreTableViewDataSource];
    }
}

- (void) loadMoreTableViewDataSource
{
    MILog(@"loadMoreTableViewDataSource");
    if (!_requestReturned) {
        return;
    }
    _requestReturned = NO;
    
    [_request setPage: ++_page];
    [_request setPageSize:kPageSize];
    [_request sendQuery];
    
    __weak typeof(self) weakSelf = self;
    _request.onCompletion = ^(MITbkItemGetModel * model) {
        if ([model.tbkItems count] > 0) {
            for (MITbkItemModel * tbkItem in model.tbkItems) {
                [weakSelf.dataList addObject:tbkItem];
            }
        }
        
        if ([model.tbkItems count] == kPageSize) {
            weakSelf.requestReturned = YES;
        } 

        [weakSelf.tableView reloadData];
        weakSelf.tableView.alpha = 1;
    };
    _request.onError = ^(MKNetworkOperation* completedOperation, NSError *error) {
        weakSelf.requestReturned = YES;
    };
}

- (void)openTbViewControllerWithNumiid:(NSString *)iid
{
    NSString *desc = [NSString stringWithFormat:@"找到商品id=%@", iid];
    [self setOverlayStatus:EOverlayStatusError labelText:desc];
    [MINavigator openTbViewControllerWithNumiid:iid desc:@"淘宝"];
}
@end
