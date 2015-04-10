//
//  MITbShortcutView.h
//  MiZheHD
//
//  Created by 徐 裕健 on 13-8-2.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MITbShortcutView : UIView

@property(nonatomic, strong) NSMutableArray *titles;
@property(nonatomic, strong) NSMutableArray *images;
@property(nonatomic, strong) NSMutableArray * urlArray;
@property(nonatomic, strong) NSArray * shortcutArrayDict;

- (void)loadData:(NSArray *)data;

@end
