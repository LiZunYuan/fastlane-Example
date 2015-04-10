//
//  MITuanBuyButton.h
//  MISpring
//
//  Created by 曲俊囡 on 15/3/27.
//  Copyright (c) 2015年 Husor Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    TuanBuyButtonNormalType,
    TuanBuyButtonSelloutType,
    TuanBuyButtonWillSellType,
}TuanBuyButtonType;


@interface MITuanBuyButton : UIView
@property (nonatomic, strong) UILabel *topLabel;
@property (nonatomic, strong) UILabel *buttonLabel;

@property (nonatomic, assign) NSInteger percent;
@property (nonatomic, assign) TuanBuyButtonType type;

@end
