//
//  BBFavorTableView.m
//  BeiBeiAPP
//
//  Created by yujian on 14-11-19.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MIFavorTableView.h"
#import "MIFavorDoubleItemTableViewCell.h"
#import "MIFavorItemModel.h"
#import "MIBrandTuanDetailViewController.h"
#import "MITuanDetailViewController.h"

@interface MIFavorTableView()

@end

@implementation MIFavorTableView

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (SCREEN_WIDTH - 24) / 2 + 48 + 8;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //子类重载
    NSInteger rows;
    if (self.modelArray.count%2 == 0) {
        rows = self.modelArray.count/2;
    } else {
        rows = self.modelArray.count/2 + 1;
    }
    
    if (self.hasMore == NO) {
        return rows;
    } else {
        //加1是因为要显示加载更多row
        return rows + 1;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    if (cell)
    {
        return cell;
    }
    
    static NSString *doubleCellIdentify = @"doubleCellIdentify";
    
    MIFavorDoubleItemTableViewCell *doubleItemCell = [tableView dequeueReusableCellWithIdentifier:doubleCellIdentify];
    if (!doubleItemCell)
    {
        doubleItemCell = [[MIFavorDoubleItemTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:doubleCellIdentify];
    }
    doubleItemCell.itemView1.isEditing = self.isEditing;
    UITapGestureRecognizer *ges1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectItem:)];
    [doubleItemCell.itemView1.deleteView addGestureRecognizer:ges1];
    
    UITapGestureRecognizer *ges2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectItem:)];
    [doubleItemCell.itemView2.deleteView addGestureRecognizer:ges2];
    doubleItemCell.itemView2.isEditing = self.isEditing;
    for (NSInteger i = indexPath.row *2; i < (indexPath.row + 1)*2; i ++) {
        __weak typeof(self) weakSelf = self;
        if (i < self.modelArray.count)
        {
            doubleItemCell.itemView2.emptyBacImageView.hidden = YES;
            MIFavorItemModel *model = (MIFavorItemModel *)[self.modelArray objectAtIndex:i];
            if (i == indexPath.row *2) {
                doubleItemCell.itemView1.hidden = NO;
                doubleItemCell.itemView1.deleteView.tag = i + 10000;
                [doubleItemCell.itemView1 setSelectedBlock:^{
                    [weakSelf goToNextPage:model];
                }];
                if([self.selectItemsArray containsObject:model])
                {
                    doubleItemCell.itemView1.deleteView.image = [UIImage imageNamed:@"ic_favorite_checked"];
                }
                else
                {
                    doubleItemCell.itemView1.deleteView.image = [UIImage imageNamed:@"ic_favorite_check"];
                }
                [doubleItemCell updateCellView:doubleItemCell.itemView1 tuanModel:model];
            } else {
                doubleItemCell.itemView2.hidden = NO;
                doubleItemCell.itemView2.deleteView.tag = i + 10000;
                [doubleItemCell.itemView2 setSelectedBlock:^{
                    [weakSelf goToNextPage:model];
                }];
                if([self.selectItemsArray containsObject:model])
                {
                    doubleItemCell.itemView2.deleteView.image = [UIImage imageNamed:@"ic_favorite_checked"];
                }
                else
                {
                    doubleItemCell.itemView2.deleteView.image = [UIImage imageNamed:@"ic_favorite_check"];
                }
                [doubleItemCell updateCellView:doubleItemCell.itemView2 tuanModel:model];
            }
        }
        else
        {
            if (i == indexPath.row *2) {
                doubleItemCell.itemView1.emptyBacImageView.hidden = YES;
            } else {
                doubleItemCell.itemView2.tipLabel.hidden = YES;
                doubleItemCell.itemView2.emptyBacImageView.hidden = NO;
            }
        }
    }
    return doubleItemCell;

}

- (void)goToNextPage:(MIFavorItemModel *)model
{
    if (!self.isEditing)
    {
        //商品已经开始销售下才可以购买
        if (model.type.integerValue == MIBrand) {
            MIBrandTuanDetailViewController *vc = [[MIBrandTuanDetailViewController alloc] initWithItem:nil placeholderImage:nil];
            [vc.request setType:model.type.integerValue];
            [vc.request setTid:model.brandId.integerValue];
            [[MINavigator navigator] openPushViewController:vc animated:YES];
        }
        else
        {
            MITuanDetailViewController *vc = [[MITuanDetailViewController alloc] initWithItem:nil  placeholderImage:nil];
            [vc.detailGetRequest setType:model.type.integerValue];
            [vc.detailGetRequest setTid:model.tuanId.integerValue];
            [[MINavigator navigator] openPushViewController:vc animated:YES];
        }
    }
}

- (void)selectItem:(UIGestureRecognizer *)ges
{
    UIImageView *view = (UIImageView *)ges.view;
    if (self.modelArray.count > view.tag - 10000) {
        MIFavorItemModel *model = [self.modelArray objectAtIndex:view.tag - 10000];
        if (self.selectItemsArray == nil)
        {
            self.selectItemsArray = [[NSMutableArray alloc] init];
            [self.selectItemsArray addObject:model];
            [view setImage:[UIImage imageNamed:@"ic_favorite_checked"]];
        }
        else if([self.selectItemsArray containsObject:model])
        {
            [self.selectItemsArray removeObject:model];
            [view setImage:[UIImage imageNamed:@"ic_favorite_check"]];
        }
        else
        {
            [self.selectItemsArray addObject:model];
            [view setImage:[UIImage imageNamed:@"ic_favorite_checked"]];
        }
    }
}

- (void)deleteItem:(id)sender
{
    if (self.selectItemsArray.count > 0)
    {
        NSMutableString *ids = [[NSMutableString alloc] init];
        for (int i = 0; i < self.selectItemsArray.count; ++i)
        {
            MIFavorItemModel *model = [self.selectItemsArray objectAtIndex:i];
            if (i == 0)
            {
                [ids appendFormat:@"%@",model.tuanId];
            }
            else
            {
                [ids appendFormat:@",%@",model.tuanId];
            }
        }
        
        if (ids && self.freshDelegate && [self.freshDelegate respondsToSelector:@selector(deletePage:)])
        {
            [self.freshDelegate deletePage:ids];
        }
        
        [self.modelArray removeObjectsInArray:self.selectItemsArray];
        [self saveFavorToLocal];
        [self reloadData];
        if (self.modelArray.count == 0)
        {
            self.alpha = 0;
        }
        else
        {
            self.alpha = 1;
        }
    }
    else
    {
        [self showSimpleHUD:@"请选择要删除的商品" afterDelay:0.5];
    }
}

@end
