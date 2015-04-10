//
//  BBMainAdsView.h
//  BeiBeiAPP
//
//  Created by yujian on 14-10-16.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MIBadgeTimeView.h"

@interface MIMainAdsView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *leftAdsImageView;
@property (weak, nonatomic) IBOutlet UIImageView *rightTopImageView;
@property (weak, nonatomic) IBOutlet UIImageView *buttonLeftImageView;
@property (weak, nonatomic) IBOutlet UIImageView *buttonRightImageView;
@property (nonatomic, strong) MIBadgeTimeView *badgeTimeView;

- (void)loadData:(NSArray *)dataArray;

@end
