//
//  MITbkItemsViewController.h
//  MISpring
//
//  Created by lsave on 13-3-18.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MITbFilterViewController.h"
#import "MITbItemSortsView.h"
#import "MIOrderNoteView.h"
#import "MITbkItemGetRequest.h"
#import "MITuanBrandItemRecomGetRequest.h"
#import "MITuanBrandItemRecomGetModel.h"


@interface MITbkItemsViewController : MIBaseViewController <MITbItemSortsViewDelegate, MITaobaoFilterViewControllerDelegate>

@property(nonatomic, assign) BOOL bHasNOmore;
@property(nonatomic, assign) BOOL requestReturned;
@property(nonatomic, strong) NSString * keywords;
@property(nonatomic, strong) NSString * numiid;
@property(nonatomic, strong) NSString * sort;
@property(nonatomic, strong) NSString * isTmall;
@property(nonatomic, assign) NSUInteger page;
@property(nonatomic, strong) MITbkItemGetRequest * request;
@property(nonatomic, strong) UITableView * tableView;
@property(nonatomic, strong) NSMutableArray * dataList;
@property(nonatomic, strong) MITbFilterViewController * filterView;

@property(nonatomic, strong) NSString * minPrice;
@property(nonatomic, strong) NSString * maxPrice;

@property(nonatomic, strong) MITbItemSortsView *sortSwitchView;

@property (nonatomic, strong) MITuanBrandItemRecomGetRequest *brandItemRecomRequest;
@property (nonatomic, strong) NSMutableArray *brandrecomArray;

@property (nonatomic, strong) UITableView *recomTableView;

@end
