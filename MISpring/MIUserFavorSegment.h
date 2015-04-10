//
//  BBUserFavorSegment.h
//  BeiBeiAPP
//
//  Created by yujian on 14-11-19.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MIUserFavorSegmentDelegate <NSObject>

- (void)segmentSelectedItemIndex:(NSInteger)index;

@end

@interface MIUserFavorSegment : UIView

@property (nonatomic, strong) NSArray *segmentTitleArray;
@property (nonatomic, weak) id<MIUserFavorSegmentDelegate> delegate;
@property (nonatomic, assign) NSInteger currentIndex;

- (void)selectSegmentIndex:(NSInteger)index;

- (void)freshSegment;

@end
