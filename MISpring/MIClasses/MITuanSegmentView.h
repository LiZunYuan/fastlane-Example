//
//  MITuanSegmentView.h
//  MISpring
//
//  Created by Yujian Xu on 13-3-24.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MITuanSegmentView;
@protocol MITuanSegmentViewDelegate <NSObject>
- (void)segmentView:(MITuanSegmentView *)segmentView didSelectIndex:(NSInteger)index;
@end

@interface MITuanSegmentView : UIView <UIGestureRecognizerDelegate>{

    UIButton *_leftButton;
    UIButton *_rightButton;
    UIButton *_middleButton;
    NSInteger _currentIndex;
    UIImageView *shadowImageView;   //选中阴影
}

- (void)setSelectTabIndex:(NSInteger)index;

@property (nonatomic, weak) id<MITuanSegmentViewDelegate> delegate;

@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) UIButton *middleButton;

@end