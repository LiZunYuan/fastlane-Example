//
//  MIAdsAlertView.h
//  MISpring
//
//  Created by yujian on 14-12-24.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MIAdsAlertViewDelegate <NSObject>

@optional

- (void)closeAdsAlertView;
- (void)clickAdsView;

@end

@interface MIAdsAlertView : UIView

@property (nonatomic, weak) id<MIAdsAlertViewDelegate> delegate;

- (void)setAdsImageViewUrl:(NSURL *)url;

@end
