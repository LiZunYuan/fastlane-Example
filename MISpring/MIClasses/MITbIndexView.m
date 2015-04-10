//
//  MITbIndexView.m
//  MISpring
//
//  Created by lsave on 13-4-1.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MITbIndexView.h"
#import "MITbQucikEnterTableViewCell.h"
#import "MITbCatTableViewCell.h"
#import "MIConfig.h"

@implementation MITbIndexView

@synthesize tableView = _tableView;
@synthesize dataKeys = _dataKeys;
@synthesize dataDict = _dataDict;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _tableView = [[UITableView alloc] initWithFrame: CGRectMake(0, 0, frame.size.width, frame.size.height)];
        
        //移除Separator
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_tableView setBackgroundColor: [UIColor clearColor]];
        
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        [self addSubview: _tableView];
    }
    return self;
}

- (void)reloadData
{
    NSString *taobaoDataPath = [[MIMainUser documentPath] stringByAppendingPathComponent:@"taobao.local.data"];
    NSData *data = [NSData dataWithContentsOfFile:taobaoDataPath];
    if (data) {
        NSMutableDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        if (dict) {
            self.dataKeys = [dict objectForKey:@"keys"];
            [dict removeObjectForKey:@"keys"];
            self.dataDict = dict;
        }

        [self.tableView reloadData];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataDict count] + 1;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row > 0) {
        MITbCatTableViewCell * _cell = (MITbCatTableViewCell *) cell;
        NSString * catDesc = _dataKeys[indexPath.row - 1];
        [_cell setCatName: catDesc];
        [_cell setTags: [_dataDict objectForKey: catDesc]];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *quickEnterCellIdentifier = @"QuickCell";
    static NSString *catsCellIdentifier = @"CatsCell";

    NSUInteger row = indexPath.row;
    UITableViewCell *cell = nil;
    if (row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier: quickEnterCellIdentifier];
        if (cell == nil) {
            cell = [[MITbQucikEnterTableViewCell alloc]
                    initWithStyle:UITableViewCellStyleValue1
                    reuseIdentifier:quickEnterCellIdentifier];
			cell.backgroundColor = [UIColor clearColor];
        }
        
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier: catsCellIdentifier];
        if (cell == nil) {
            cell = [[MITbCatTableViewCell alloc]
                    initWithStyle:UITableViewCellStyleValue1
                    reuseIdentifier:catsCellIdentifier];
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = false;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 95;
    } else if (indexPath.row == [_dataDict count]) {
        return 200;
    } else {
        return 190;
    }
}

@end
