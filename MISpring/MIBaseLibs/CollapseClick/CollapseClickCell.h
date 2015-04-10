//
//  CollapseClickCell.h
//  CollapseClick
//
//  Created by Ben Gordon on 2/28/13.
//  Copyright (c) 2013 Ben Gordon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollapseClickArrow.h"

#define kCCHeaderHeight 40

@interface CollapseClickCell : UIView

// Header
@property (strong, nonatomic) UIView *titleView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIButton *titleButton;
@property (strong, nonatomic) CollapseClickArrow *titleArrow;

// Body
@property (strong, nonatomic) UIView *contentView;

// Properties
@property (nonatomic, assign) BOOL isClicked;
@property (nonatomic, assign) int index;

// Init
+ (CollapseClickCell *)newCollapseClickCellWithTitle:(NSString *)title width:(int)width index:(int)index content:(UIView *)content;

@end
