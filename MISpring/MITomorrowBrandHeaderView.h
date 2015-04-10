//
//  MITomorrowBrandHeaderView.h
//  MISpring
//
//  Created by yujian on 14-12-19.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    TodayType,
    TomorrowType,
}BrandHeaderType;

@protocol MITomorrowBrandHeaderViewDelegate <NSObject>

- (void)refreshRemindTag:(BOOL)isRemindBrand;

@end

@interface MITomorrowBrandHeaderView : UIView

@property (nonatomic, assign) BOOL isRemindBrand;
@property (nonatomic, weak) id<MITomorrowBrandHeaderViewDelegate> delegate;
@property (nonatomic, assign) BrandHeaderType type;
@property (nonatomic, strong) NSNumber *startTime;
@property (nonatomic, strong) NSNumber *endTime;

- (void)setCurBeginTime:(NSNumber *)beginTime;

- (void)startTimer;
- (void)stopTimer;
@end
