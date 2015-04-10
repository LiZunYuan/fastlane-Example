//
//  MIWomenViewController.h
//  MISpring
//
//  Created by 曲俊囡 on 15/3/26.
//  Copyright (c) 2015年 Husor Inc. All rights reserved.
//

#import "MIBaseViewController.h"
#import "MIWomenTableView.h"
#import "MIScreenSelectedDelegate.h"

@interface MIWomenViewController : MIBaseViewController<MIScreenSelectedDelegate>
{
    NSInteger _currentPage;
    NSInteger _tuanTenPageSize;
    BOOL _hasMore;
    BOOL _isShowScreen;
}

@property (nonatomic, copy) NSString *cat;
@property (nonatomic, copy) NSString *catName;
@property (nonatomic, strong) MIWomenTableView *womenTableView;

@end
