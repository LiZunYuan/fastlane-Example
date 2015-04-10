//
//  MIRebateMainViewController.h
//  MISpring
//
//  Created by XU YUJIAN on 13-1-25.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MITbSearchViewController.h"
#import "MIMallReloadRequest.h"
#import "MITbShortcutView.h"
#import "MIMallSuggestsView.h"
//#import "MIRebateHeaderView.h"

@interface MIRebateMainViewController : MIBaseViewController <UISearchBarDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) MITbShortcutView *tbShortcutView;
//@property (nonatomic, strong) MIRebateHeaderView *headerView;

@property (nonatomic, strong) MIMallSuggestsView *mallSuggestsView;
@property (nonatomic, strong) MIMallReloadRequest * reloadMobileMallsRequest;
@property (nonatomic, strong) NSMutableArray * hotMalls;

@end
