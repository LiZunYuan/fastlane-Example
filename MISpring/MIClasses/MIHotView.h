//
//  MIHotView.h
//  MISpring
//
//  Created by 贺晨超 on 13-10-15.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MGBox.h"

@interface MIHotView : MGBox<UIScrollViewDelegate>

@property (nonatomic, strong) UIView * hotView;
@property (nonatomic, assign) int hotItemNum;

@end
