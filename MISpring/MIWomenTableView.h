//
//  MIWomenTableView.h
//  MISpring
//
//  Created by 曲俊囡 on 15/3/18.
//  Copyright (c) 2015年 Husor Inc. All rights reserved.
//

#import "MIBaseTableView.h"
#import "MIWomenShortView.h"

@interface MIWomenTableView : MIBaseTableView

@property (nonatomic, assign) BOOL isShowShortCuts;
@property (nonatomic, strong) MIWomenShortView *shortView;

@end
