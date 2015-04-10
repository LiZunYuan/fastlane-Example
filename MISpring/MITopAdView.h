//
//  BBTopAdView.h
//  BeiBeiAPP
//
//  Created by yujian on 14-10-21.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MITopAdView : UIView

@property (nonatomic, strong) NSArray *adsArray;
@property (nonatomic, strong) NSString *clickEventLabel;

- (void)loadAds;

@end
