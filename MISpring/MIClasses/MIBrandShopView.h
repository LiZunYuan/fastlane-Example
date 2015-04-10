//
//  MIBrandShopView.h
//  MISpring
//
//  Created by 曲俊囡 on 13-12-6.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MIBrandItemModel.h"

@interface MIBrandShopView : UIView

@property (nonatomic, strong) NSString *relateId;
@property (nonatomic, strong) NSString *nick;
@property (nonatomic, strong) UIImageView *shopImageView;
@property (nonatomic, strong) UIImageView *timeImageView;
@property (nonatomic, strong) UILabel *shopNameLabel;
@property (nonatomic, strong) UILabel *shopTimeLabel;
@property (nonatomic, strong) NSTimer *shopTimer;
@property (nonatomic, strong) NSString *shopEndTime;

- (id) initWithFrame:(CGRect)frame;
- (void)startTimer;
- (void)stopTimer;

@end
