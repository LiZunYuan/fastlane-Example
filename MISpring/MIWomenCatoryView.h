//
//  MIWomenCatoryView.h
//  MISpring
//
//  Created by 曲俊囡 on 15/3/30.
//  Copyright (c) 2015年 Husor Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MIScreenSelectedDelegate.h"

@interface MIWomenCatoryView : UIView<MIScreenSelectedDelegate>

@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, strong) NSMutableArray *titles;
@property (nonatomic, strong) NSMutableArray *buttons;

@property(nonatomic, strong) NSMutableArray * dataArray;

@property (nonatomic, assign) id<MIScreenSelectedDelegate> delegate;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, copy) NSString *catName;

- (void) showSelectedCategory;
- (id)initWithArray:(NSArray *)cats;
- (void)reloadContenWithCats:(NSArray *)cats;

@end
