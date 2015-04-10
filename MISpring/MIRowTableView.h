//
//  MIRowTableView.h
//  MISpring
//
//  Created by 曲俊囡 on 15/3/27.
//  Copyright (c) 2015年 Husor Inc. All rights reserved.
//

#import "MIRefreshBaseTableView.h"
#import "MIPageBaseRequest.h"
#import "MITuanHotGetModel.h"
#import "MITuanActivityGetModel.h"
#import "MITuanItemModel.h"

@interface MIRowTableView : MIRefreshBaseTableView<MIRefreshBaseTableViewDelegate>


- (void)willAppearView;
- (void)willDisappearView;
- (void)cancelRequest;

@property (nonatomic, strong) MIPageBaseRequest *request;
@property (nonatomic, strong) MITuanHotGetModel *hotGetModel;
@property (nonatomic, strong) MITuanActivityGetModel *activityGetModel;

- (void)finishHotLoadTableViewData:(MITuanHotGetModel *)model;
- (void)finishActivityLoadTableViewData:(MITuanActivityGetModel *)model;

- (void)goToProductViewController:(MITuanItemModel *)model;



@end
