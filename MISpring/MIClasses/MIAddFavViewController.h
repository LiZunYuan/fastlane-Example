//
//  MIAddFavViewController.h
//  MISpring
//
//  Created by 贺晨超 on 13-10-9.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIBaseViewController.h"
//#import "MIFavSegmentView.h"
#import "MIMallGetRequest.h"
#import "MIMallGetModel.h"
#import "MIFavsModel.h"

@interface MIAddFavViewController : MIBaseViewController<UISearchBarDelegate, UISearchDisplayDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UISearchDisplayController *searchDisplay;
@property (nonatomic, strong) UILabel *searchNote;
@property (nonatomic, strong) MIMallGetRequest *mallSearchRequest;
@property (nonatomic, assign) BOOL hasMore;
@property (nonatomic, assign) BOOL loading;
@property (nonatomic, assign) NSInteger mallCount;
@property (nonatomic, strong) NSMutableArray *mallData;

@end
