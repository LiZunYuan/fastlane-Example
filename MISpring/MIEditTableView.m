//
//  BBEditTableView.m
//  BeiBeiAPP
//
//  Created by yujian on 14-11-25.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MIEditTableView.h"
#import "MIFavorItemModel.h"
#import "MIBrandItemModel.h"
#import "MIFavorTableView.h"
#import "MIAppDelegate.h"

@interface MIEditTableView()
{
    UIButton *_deleteBtn;
}

@end

@implementation MIEditTableView

//完成加载时调用的方法
- (void)finishLoadTableViewData:(NSInteger)currentPage dataSource:(NSArray *)dataSource totalCount:(NSNumber *)totalCount
{
    [super finishLoadTableViewData:currentPage dataSource:dataSource totalCount:totalCount];
    if (self.modelArray.count != 0)
    {
        [self saveFavorToLocal];
    }
    if(self.selectItemsArray && self.selectItemsArray.count > 0)
    {
        [self.selectItemsArray removeAllObjects];
    }
    
}

- (void)saveFavorToLocal
{
    NSMutableArray *brandFavorArray = [[NSMutableArray alloc] init];
    NSMutableArray *itemFavorArray = [[NSMutableArray alloc] init];
    NSTimeInterval nowInterval = [[NSDate date] timeIntervalSince1970] + [MIConfig globalConfig].timeOffset;
    NSInteger smallTime = -1;
    NSInteger itemSmallTime = -1;
    for (int i = 0; i < self.modelArray.count; ++i)
    {
        if ([self isKindOfClass:[MIFavorTableView class]])
        {
            MIFavorItemModel *model = [self.modelArray objectAtIndex:i];
            if (model.type.integerValue == 3)
            {
                if (![itemFavorArray containsObject:model.brandId])
                {
                    [itemFavorArray addObject:model.brandId];
                    if (model.startTime.integerValue > nowInterval && (itemSmallTime > model.startTime.integerValue || itemSmallTime == -1))
                    {
                        itemSmallTime = model.startTime.integerValue;
                    }
                }
            }
            else
            {
                if (![itemFavorArray containsObject:model.tuanId])
                {
                    [itemFavorArray addObject:model.tuanId];
                    if (model.startTime.integerValue > nowInterval && (itemSmallTime > model.startTime.integerValue || itemSmallTime == -1))
                    {
                        itemSmallTime = model.startTime.integerValue;
                    }
                }
            }
        }
        else
        {
            MIBrandItemModel *model = [self.modelArray objectAtIndex:i];
            if (![brandFavorArray containsObject:model.aid])
            {
                [brandFavorArray addObject:model.aid];
                if (model.startTime.integerValue > nowInterval && (smallTime > model.startTime.integerValue || smallTime == -1))
                {
                    smallTime = model.startTime.integerValue;
                }
            }
        }
    }
    NSNumber *alertTime = [[NSUserDefaults standardUserDefaults] objectForKey: kBrandFavorBeginTimeDefaults];
    NSNumber *itemAlertTime = [[NSUserDefaults standardUserDefaults] objectForKey:kItemFavorBeginTimeDefaults];
    if (smallTime != -1 && (alertTime.integerValue > smallTime || alertTime == nil || alertTime.integerValue <= nowInterval))
    {
        [MIUtility setLocalNotificationWithType:APP_LOCAL_NOTIFY_ACTION_MARTSHOW_START_ALARM alertBody:@"你添加开抢提醒的专场已经开抢了" at:smallTime];
        [[NSUserDefaults standardUserDefaults] setObject:@(smallTime) forKey:kBrandFavorBeginTimeDefaults];
    }
    else if(itemSmallTime != -1 && (itemAlertTime.integerValue > itemSmallTime || itemAlertTime == nil || itemAlertTime.integerValue <= nowInterval))
    {
        [MIUtility setLocalNotificationWithType:APP_LOCAL_NOTIFY_ACTION_PRODUCT_START_ALARM alertBody:@"你添加开抢提醒的单品已经开抢了" at:itemSmallTime];
        [[NSUserDefaults standardUserDefaults] setObject:@(itemSmallTime) forKey:kBrandFavorBeginTimeDefaults];
    }
    else if(self.modelArray.count == 0)
    {
        [MIUtility delLocalNotificationByType:APP_LOCAL_NOTIFY_ACTION_MARTSHOW_START_ALARM];
        [MIUtility delLocalNotificationByType:APP_LOCAL_NOTIFY_ACTION_PRODUCT_START_ALARM];
    }
    [[NSUserDefaults standardUserDefaults] setObject:brandFavorArray forKey:kBrandFavorListDefaults];
    [[NSUserDefaults standardUserDefaults] setObject:itemFavorArray forKey:kItemFavorListDefaults];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)hiddenDeleteBtn
{
    [UIView animateWithDuration:0.3 animations:^{
        _deleteBtn.top = self.viewHeight;
    }];
}

- (void)showDeleteBtn
{
    if (_deleteBtn == nil)
    {
        _deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.left, self.viewHeight, self.viewWidth, 40)];
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _deleteBtn.viewWidth, 1)];
        line.backgroundColor = [MIUtility colorWithHex:0xe5e5e5];
        [_deleteBtn addSubview:line];
        _deleteBtn.backgroundColor = [UIColor whiteColor];
        [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
        [_deleteBtn setTitleColor:[MIUtility colorWithHex:0xff3d00] forState:UIControlStateNormal];
        [_deleteBtn addTarget:self action:@selector(deleteItem:) forControlEvents:UIControlEventTouchUpInside];
        [self.superview addSubview:_deleteBtn];
    }
    [UIView animateWithDuration:0.3 animations:^{
        _deleteBtn.bottom = self.viewHeight;
    }];
}

- (void)deleteItem:(id)sender
{
    
}

@end
