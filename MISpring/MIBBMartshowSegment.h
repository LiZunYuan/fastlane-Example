//
//  MIBBMartshowSegment.h
//  MISpring
//
//  Created by husor on 14-10-16.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MIBBMartsShowSegmentStatus.h"
typedef enum : NSInteger {
    DownArrowType = 0,
    UpArrowType1,
    UpArrowType2,
    RoundArrowType
}SegmentSubViewType;

@interface MIBBSegmentSubview : UIView
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *kuang;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, assign) SegmentSubViewType type;
@property (nonatomic, assign) BBSelectedState status;
@property (nonatomic, strong) UIView *hLine;
@end

@interface MIBBMartshowSegment : UIView

@property (nonatomic, assign) NSInteger segmentIndexCount;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *segmentTypeArray;
@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, strong) UIColor *titleColor;

@property (nonatomic, copy) void (^selectedBlock)(MIBBMartsShowSegmentStatus *status);
- (void)initWithSubViews;
- (void)setSelectedItems:(NSArray *)itemsIndexArray;

@end
