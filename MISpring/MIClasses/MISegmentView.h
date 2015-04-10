//
//  MISegmentView.h
//  MISpring
//
//  Created by 贺晨超 on 13-10-10.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MISegmentView;
@protocol MISegmentViewDelegate <NSObject>
- (void)segmentView:(MISegmentView *)segmentView didSelectIndex:(NSInteger)index;
@end

@interface MISegmentView : UIView
{
    UIButton *_leftButton;
    UIButton *_rightButton;
    NSInteger _currentIndex;
}

- (void)setSelectTabIndex:(NSInteger)index;
- (void)switchTabIndex:(NSInteger)index;

@property (nonatomic, weak) id<MISegmentViewDelegate> delegate;

@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightButton;

@end
