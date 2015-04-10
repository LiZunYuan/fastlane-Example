//
//  SegmentedSwitchView.h
//  YGPSegmentedSwitch
//
//  Created by yang on 13-6-27.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SegmentedSwitchView;
@protocol SegmentedSwitchViewDelegate <NSObject>
@optional
- (void)segmentedViewController:(SegmentedSwitchView *)segmentedControl touchedAtIndex:(NSUInteger)index;

@end

@interface SegmentedSwitchView : UIView

{     
     NSInteger    selectedTag;              //选择tag

}
@property (weak, nonatomic) id<SegmentedSwitchViewDelegate>delegate;

@property (strong, nonatomic) NSArray  * titleArray;             //按钮title
@property (strong, nonatomic) UIScrollView    * scrollView;         //滚动视图

- (id)initWithFrame:(CGRect)frame;

/*
 初始化方法
 title 传入button的title（NSArray）
 */
-(void) initContentTitle:(NSArray*)title;
-(void) reloadContentTitle:(NSArray*)title;

//初始化选择indx （0）
/*由于技术原因在初始选择时请调用次方法
 此方法初始值为0*/
-(NSInteger)initselectedSegmentIndex;
- (void)setSelectedIndex:(NSInteger)selectedIndex;
- (void)backToIndex:(NSInteger)selectedIndex;

@end
