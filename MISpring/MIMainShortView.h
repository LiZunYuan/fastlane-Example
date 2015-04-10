//
//  MIMainShortView.h
//  MISpring
//
//  Created by 曲俊囡 on 14-7-19.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MIMainShortView : UIView

@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, strong) NSMutableArray *titles;

@property(nonatomic, strong) NSMutableArray * dataArray;

- (void)loadData:(NSArray *)data;

@end
