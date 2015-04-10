//
//  MITuanTopScrollView.h
//  MISpring
//
//  Created by husor on 14-12-16.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MITuanTopScrollViewDelegate <NSObject>

- (void)selectedIndex:(NSInteger)index;

@end

@interface MITuanTopScrollView : UIScrollView<UIScrollViewDelegate>
@property (nonatomic, weak) id<MITuanTopScrollViewDelegate> topScrollViewDelegate;
@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) BOOL isScrolling;

- (void)selectIndexInScrollView:(NSInteger)index;

@end
