//
//  MIMallSuggestsView.h
//  MISpring
//
//  Created by Yujian Xu on 13-4-11.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MIMALL_SUGGEST_MAX_NUMBER 19
#define MIMALL_SUGGEST_TABLECELL_HEIGHT 80.0

@interface MIMallSuggestsView : UIView<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSArray * hotMalls;

- (void)loadData:(NSArray *) malls;

@end
