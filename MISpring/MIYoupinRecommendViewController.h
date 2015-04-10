//
//  MIYoupinRecommendViewController.h
//  MISpring
//
//  Created by husor on 15-3-26.
//  Copyright (c) 2015年 Husor Inc. All rights reserved.
//

#import "MIBaseViewController.h"
#import "MITuanActivityGetRequest.h"
#import  "MIYoupinHeaderView.h"
#import "MIGoTopView.h"

@interface MIYoupinRecommendViewController : MIBaseViewController<MIGoTopViewDelegate,EGORefreshTableHeaderDelegate>
{
    NSInteger _pageSize;
    BOOL _hasMore;
    NSInteger _currentPage;
    NSInteger _lastscrollViewOffset;
}

@property (nonatomic, copy)NSString *data;
@property (nonatomic, strong)MITuanActivityGetRequest *request;
@property (nonatomic, strong)NSMutableArray *tuanItems;
@property (nonatomic, strong)NSMutableArray *previousTuanItems;
@property (nonatomic, assign) BOOL hasMore;
@property (nonatomic, strong) EGORefreshTableHeaderView *refreshTableView;
@property (nonatomic, strong) MIGoTopView *goTopView;
@property (nonatomic, strong) UITableView *tableView;




@end
