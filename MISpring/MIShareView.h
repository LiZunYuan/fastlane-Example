//
//  MIShareView.h
//  MISpring
//
//  Created by 曲俊囡 on 14-9-11.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^MIShareBlock)(NSInteger index);

@interface MIShareView : UIView

@property (nonatomic, strong) UIView *alphaView;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) NSMutableArray *eventArray;
@property (nonatomic, strong) NSMutableArray *handleArray;
@property (nonatomic, copy) void (^cancelBlock)();

- (NSInteger)addButtonWithDictionary:(NSDictionary *)dic withBlock:(MIShareBlock)block;
- (void)loadData;

@end
