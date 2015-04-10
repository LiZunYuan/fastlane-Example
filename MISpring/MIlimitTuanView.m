//
//  MIlimitTuanView.m
//  MISpring
//
//  Created by husor on 15-3-30.
//  Copyright (c) 2015年 Husor Inc. All rights reserved.
//

#import "MIlimitTuanView.h"

@implementation MILimitTuanView


-(void)layoutSubviews
{
    _freeDeliveryLabel.textColor = [MIUtility colorWithHex:0xffffff];
    _priceLabel.textColor = [MIUtility colorWithHex:0x333333];
    _priceOriLabel.textColor = [MIUtility colorWithHex:0x999999];
    _purchaseBgView.layer.cornerRadius = 2;
    _purchaseBgView.layer.borderWidth = 1;
    _purchaseBgView.clipsToBounds = YES;
    _customerLabel.textColor = [MIUtility colorWithHex:0x666666];
    _goBuyLabel.textColor = [MIUtility colorWithHex:0xffffff];
    _rmbLabel.textColor = [MIUtility colorWithHex:0x333333];
    _rmb.textColor = [MIUtility colorWithHex:0x999999];
    _purchaseBgView.right = self.viewWidth - 8;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
