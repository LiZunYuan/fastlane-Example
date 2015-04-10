//
//  MITbIndexView.h
//  MISpring
//
//  Created by lsave on 13-4-1.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MITbIndexView : UIView<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) UITableView * tableView;
@property(nonatomic, strong) NSMutableArray * dataKeys;
@property(nonatomic, strong) NSMutableDictionary * dataDict;

- (void)reloadData;

@end
