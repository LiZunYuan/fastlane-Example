//
//  MIWomenTableView.m
//  MISpring
//
//  Created by 曲俊囡 on 15/3/18.
//  Copyright (c) 2015年 Husor Inc. All rights reserved.
//

#import "MIWomenTableView.h"
#import "MIAdService.h"
#import "MITuanItemsCell.h"

@interface MIWomenTableView ()
{
    BOOL _hasLoadAds;       // 是否加载了广告数据
    BOOL _hasLoadFirstPage;     // 是否加载了第一页数据
}


@property (nonatomic, strong) NSArray *shortCuts;
@property (nonatomic, strong) UIView *headerView;


@end

@implementation MIWomenTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _isShowShortCuts = YES;
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, PHONE_SCREEN_SIZE.width, 0)];
        _shortView = [[MIWomenShortView alloc] initWithFrame:CGRectMake(0, 8, PHONE_SCREEN_SIZE.width, 0)];
        [_headerView addSubview:_shortView];
        
        self.tableView.backgroundColor = MINormalBackgroundColor;
    }
    return self;
}

- (void)willAppearView
{
    [super willAppearView];
    if (_isShowShortCuts)
    {
        [self loadMainAdsView];
    }
}

- (void)loadMainAdsView
{
    __weak typeof(self) weakSelf = self;
    [[MIAdService sharedManager] loadAdWithType:@[@(Nvzhuang_Cat_Shortcuts)] block:^(MIAdsModel *model) {
        if (model.nvzhuangCatShortcuts.count <= 8)
        {
            _shortCuts = model.nvzhuangCatShortcuts;
        }
        else
        {
            NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:8];
            for (int i = 0; i < 8; i++)
            {
                [array addObject:[model.nvzhuangCatShortcuts objectAtIndex:i]];
            }
            _shortCuts = array;
        }
        [weakSelf loadAds];
        _hasLoadAds = YES;
        // 已经加载了首页数据，但还未显示，则改变overlay的状态
        if (_hasLoadFirstPage && self.overlayView.status != EOverlayStatusRemove) {
            [weakSelf.overlayView setOverlayStatus:EOverlayStatusRemove labelText:nil];
        }
        [weakSelf.tableView reloadData];
    }];
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
        if (_isShowShortCuts)
        {
            if (temaiModel.page.integerValue != 1 || _hasLoadAds) {
                [self.tableView reloadData];
            } else {
                // 广告数据未回来，继续伪造正在请求中
                [self.overlayView setOverlayStatus:EOverlayStatusLoading labelText:nil];
            }
        }
        else
        {
            if (self.modelArray.count > 0) {
                [self.overlayView setOverlayStatus:EOverlayStatusRemove labelText:nil];
            }
            
            [self.tableView reloadData];
        }
        
    }
}

- (void)loadAds
{
    if (_shortCuts.count > 0)
    {
        if (![_shortCuts isEqual:self.shortView.data])
        {
            [self.shortView loadData:_shortCuts];
        }
        UIView *header = _headerView;
        header.viewHeight = self.shortView.viewHeight + 8;
        [header addSubview:self.shortView];
        self.tableView.tableHeaderView = header;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
