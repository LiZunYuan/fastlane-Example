//
//  MINavigationBarTitleButtonView.h
//  MISpring
//
//  Created by 曲俊囡 on 15/3/30.
//  Copyright (c) 2015年 Husor Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

//typedef void(^ShowScreenViewBlock)(BOOL isShowScreen);

@interface MINavigationBarTitleButtonView : UIView

@property (nonatomic, assign) BOOL hasShowScreenView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *screenImageView;
@property (nonatomic, copy) void (^showScreenViewBlock)(BOOL isShowScreen);

- (void)setBarTitle: (NSString *) title textSize:(CGFloat) size;

@end
