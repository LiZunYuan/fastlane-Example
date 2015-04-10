//
//  BBEditTableView.h
//  BeiBeiAPP
//
//  Created by yujian on 14-11-25.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MIReFreshTableView.h"

@interface MIEditTableView : MIReFreshTableView

@property (nonatomic, strong) NSMutableArray *selectItemsArray;

- (void)showDeleteBtn;
- (void)hiddenDeleteBtn;
- (void)saveFavorToLocal;

@end
