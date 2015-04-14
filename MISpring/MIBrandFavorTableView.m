//
//  BBEventFavorTableView.m
//  BeiBeiAPP
//
//  Created by yujian on 14-11-24.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MIBrandFavorTableView.h"
//#import "BBMartshowViewController.h"
//#import "BBMsItemModel.h"
//#import "BBMartshowModel.h"
#import "MIFavorDeleteView.h"
#import "MIBrandItemModel.h"
#import "MIMartshowFavorTableViewCell.h"
//#import "MIFavorDeleteView.h"

@interface MIBrandFavorTableView()


@end

@implementation MIBrandFavorTableView


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (SCREEN_WIDTH - 24) / 2 + 41 + 8;
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
    
    MIMartshowFavorTableViewCell *doubleCell = [tableView dequeueReusableCellWithIdentifier:@"MIMartshowDoubleDisplayCellIdentify"];
    if (!doubleCell)
    {
        doubleCell = [[MIMartshowFavorTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MIMartshowDoubleDisplayCellIdentify"];
        UITapGestureRecognizer *ges1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectItem:)];
        [doubleCell.itemView1.deleteView addGestureRecognizer:ges1];
        
        UITapGestureRecognizer *ges2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectItem:)];
        [doubleCell.itemView2.deleteView addGestureRecognizer:ges2];
    }
    doubleCell.itemView1.isEditing = self.isEditing;
    doubleCell.itemView2.isEditing = self.isEditing;
    for (NSInteger i = indexPath.row *2; i < (indexPath.row + 1)*2; i ++)
    {
        if (i < self.modelArray.count)
        {
            MIBrandItemModel *model = (MIBrandItemModel *)[self.modelArray objectAtIndex:i];
            doubleCell.itemView2.emptyBacImageView.hidden = YES;
            if (i == indexPath.row *2) {
                doubleCell.itemView1.hidden = NO;
                doubleCell.itemView1.deleteView.tag = i + 10000;
                [doubleCell updateCellView:doubleCell.itemView1 favorModel:model];
                if([self.selectItemsArray containsObject:model])
                {
                    doubleCell.itemView1.deleteView.deleteImageView.image = [UIImage imageNamed:@"ic_favorite_checked"];
                }
                else
                {
                    doubleCell.itemView1.deleteView.deleteImageView.image = [UIImage imageNamed:@"ic_favorite_check"];
                }

            } else {
                doubleCell.itemView2.hidden = NO;
                doubleCell.itemView2.deleteView.tag = i + 10000;
                [doubleCell updateCellView:doubleCell.itemView2 favorModel:model];
                if([self.selectItemsArray containsObject:model])
                {
                    doubleCell.itemView2.deleteView.deleteImageView.image = [UIImage imageNamed:@"ic_favorite_checked"];
                }
                else
                {
                    doubleCell.itemView2.deleteView.deleteImageView.image = [UIImage imageNamed:@"ic_favorite_check"];
                }

            }
            
            
        }
        else
        {
            if (i == indexPath.row *2) {
                doubleCell.itemView1.emptyBacImageView.hidden = YES;
            } else {
                doubleCell.itemView2.emptyBacImageView.hidden = NO;
                doubleCell.itemView2.tipLabel.hidden = YES;
            }

        }
    
    }
    return doubleCell;
}

- (void)selectItem:(UIGestureRecognizer *)ges
{
    MIFavorDeleteView *view = (MIFavorDeleteView *)ges.view;
    if (self.modelArray.count > view.tag - 10000)
    {
        MIBrandItemModel *model = [self.modelArray objectAtIndex:view.tag - 10000];
        if (self.selectItemsArray == nil)
        {
            self.selectItemsArray = [[NSMutableArray alloc] init];
            [self.selectItemsArray addObject:model];
            [view.deleteImageView setImage:[UIImage imageNamed:@"ic_favorite_checked"]];
        }
        else if([self.selectItemsArray containsObject:model])
        {
            [self.selectItemsArray removeObject:model];
            [view.deleteImageView setImage:[UIImage imageNamed:@"ic_favorite_check"]];
        }
        else
        {
            [self.selectItemsArray addObject:model];
            [view.deleteImageView setImage:[UIImage imageNamed:@"ic_favorite_checked"]];
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
            MIBrandItemModel *model = [self.selectItemsArray objectAtIndex:i];
            if (i == 0)
            {
                [ids appendFormat:@"%@",model.aid];
            }
            else
            {
                [ids appendFormat:@",%@",model.aid];
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
        [self showSimpleHUD:@"请选择要删除的专场" afterDelay:0.5];
    }

}

@end
