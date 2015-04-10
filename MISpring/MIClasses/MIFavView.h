//
//  MIFavView.h
//  MISpring
//
//  Created by 贺晨超 on 13-10-9.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MGBox.h"
#import "MIFavsModel.h"

@interface MIFavView : MGBox

@property (nonatomic, strong) UIPageControl * pageControl;

+ (MIFavView *)addFavBox;
+ (MIFavView *)boxWithWithTag:(NSInteger)tag data:(MIFavsModel *)model;
@end