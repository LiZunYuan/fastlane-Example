//
//  SVTopScrollView.h
//  SlideView
//
//  Created by Chen Yaoqiang on 13-12-27.
//  Copyright (c) 2013年 Chen Yaoqiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MIScreenSelectedDelegate.h"


@interface SVTopScrollView : UIScrollView <UIScrollViewDelegate,MIScreenSelectedDelegate>
{
    NSArray *catArray;
    NSInteger userSelectedChannelID;        //点击按钮选择名字ID
    NSInteger scrollViewSelectedChannelID;  //滑动列表选择名字ID

    
    UIImageView *shadowImageView;   //选中阴影
}

@property (nonatomic, assign) id<MIScreenSelectedDelegate> screenDelegate;
@property (nonatomic, retain) NSArray *catArray; //存misvtopobject对象,

@property(nonatomic,retain)NSMutableArray *buttonOriginXArray;
@property(nonatomic,retain)NSMutableArray *buttonWithArray;
@property (nonatomic, assign) NSInteger scrollViewSelectedChannelID;

- (id)init;
/**
 *  加载顶部标签
 */
- (void)initWithNameButtons;
/**
 *  滑动撤销选中按钮
 */
- (void)setButtonUnSelect;
/**
 *  滑动选择按钮
 */
- (void)setButtonSelect;


@end
