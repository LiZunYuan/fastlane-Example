//
//  MIWomenShortView.h
//  MISpring
//
//  Created by 曲俊囡 on 15/3/18.
//  Copyright (c) 2015年 Husor Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MIWomenShortView : UIView

@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, strong) NSMutableArray *titles;

@property(nonatomic, strong) NSMutableArray * dataArray;

- (void)loadData:(NSArray *)data;

@end
