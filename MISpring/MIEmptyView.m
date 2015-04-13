//
//  MIEmptyView.m
//  MISpring
//
//  Created by yujian on 14-12-18.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MIEmptyView.h"
#import "MITomorrowViewController.h"

@implementation MIEmptyView

- (void)awakeFromNib
{
    [self.platformButton whiteBackgroundOriageTexAndBorder];
    self.backgroundColor = [MIUtility colorWithHex:0xf2f2f2];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self layoutIfNeeded];
    if (self.type == FavorEmptyType)
    {
        self.image.image = [UIImage imageNamed:@"bg_sale1"];
        self.label.text = @"添加你喜欢的东东，开抢前会提醒哦";
        [self.platformButton setTitle:@"逛逛明日预告" forState:UIControlStateNormal];
//        self.image.frame = CGRectMake(0, 0, 580/2, 363/2);
        self.image.viewWidth = SCREEN_WIDTH * 290 / 320;
        self.image.viewHeight = SCREEN_WIDTH * 181 / 320;
        self.image.top = (self.viewHeight - self.image.viewHeight - self.label.viewHeight - self.platformButton.viewHeight)/2;
        self.image.centerX = self.viewWidth/2;
        self.label.top = self.image.bottom;
        self.platformButton.top = self.label.bottom;
    }
    else if (self.type == BrandFavorEmptyType)
    {
        self.image.image = [UIImage imageNamed:@"bg_sale2"];
        self.label.text = @"添加你喜欢的东东，开抢前会提醒哦";
        [self.platformButton setTitle:@"逛逛明日预告" forState:UIControlStateNormal];
        
        self.image.viewWidth = SCREEN_WIDTH * 278 / 320;
        self.image.viewHeight = SCREEN_WIDTH * 233 / 320;
//        self.image.frame = CGRectMake(0, 0, 556/2, 466/2);
        self.image.top = (self.viewHeight - self.image.viewHeight - self.label.viewHeight - self.platformButton.viewHeight)/2;
        self.image.centerX = self.viewWidth/2;
        self.label.top = self.image.bottom;
        self.platformButton.top = self.label.bottom;
    }
    
}

- (IBAction)goToPaltformAction:(id)sender {
    if (self.type == FavorEmptyType || self.type == BrandFavorEmptyType) {
        MITomorrowViewController *controller = [[MITomorrowViewController alloc] init];
        [[MINavigator navigator] openPushViewController:controller animated:YES];
    }
}

@end
