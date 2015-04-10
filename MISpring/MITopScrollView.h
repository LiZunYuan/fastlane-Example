//
//  MITopScrollView.h
//  MISpring
//
//  Created by husor on 14-11-10.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MITopScrollViewDelegate <NSObject>

- (void)selectedIndex:(NSInteger)index;

@end

@interface MITopScrollView : UIScrollView<UIScrollViewDelegate>
@property (nonatomic, weak) id<MITopScrollViewDelegate> topScrollViewDelegate;
@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) BOOL isScrolling;

- (void)selectIndexInScrollView:(NSInteger)index;

@end

