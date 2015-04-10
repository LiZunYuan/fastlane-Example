//
//  BBBadgeTimeView.m
//  BeiBeiAPP
//
//  Created by yujian on 14-10-17.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MIBadgeTimeView.h"

@interface MIBadgeTimeView()

@property (nonatomic, strong) NSMutableArray *timeLabelArray;

@end

@implementation MIBadgeTimeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _hourBadgeView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.viewHeight, self.viewHeight)];
        _hourBadgeView.text = @"02";
        _hourBadgeView.textColor = [UIColor whiteColor];
        _hourBadgeView.textAlignment = UITextAlignmentCenter;
        _hourBadgeView.clipsToBounds = YES;
        _hourBadgeView.layer.masksToBounds = YES;
        _hourBadgeView.layer.cornerRadius = self.viewHeight/2;
        _hourBadgeView.backgroundColor = [MIUtility colorWithHex:0x6a6a6a];
        _hourBadgeView.font = [UIFont systemFontOfSize:12.0];
        [self addSubview:_hourBadgeView];
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 5, self.viewHeight)];
        label1.backgroundColor = [UIColor clearColor];
        label1.text = @":";
        label1.textColor = [MIUtility colorWithHex:0x6a6a6a];
        label1.left = _hourBadgeView.right;
        [self addSubview:label1];
        
        _miniteBadgeView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.viewHeight, self.viewHeight)];
        _miniteBadgeView.text = @"22";
        _miniteBadgeView.clipsToBounds = YES;
        _miniteBadgeView.textColor = [UIColor whiteColor];
        _miniteBadgeView.textAlignment = UITextAlignmentCenter;
        _miniteBadgeView.layer.masksToBounds = YES;
        _miniteBadgeView.layer.cornerRadius = self.viewHeight/2;
        _miniteBadgeView.backgroundColor = [MIUtility colorWithHex:0x6a6a6a];
        _miniteBadgeView.font = [UIFont systemFontOfSize:12.0];
        _miniteBadgeView.left = label1.right;
        [self addSubview:_miniteBadgeView];
        
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 5, self.viewHeight)];
        label2.backgroundColor = [UIColor clearColor];
        label2.text = @":";
        label2.textColor = [MIUtility colorWithHex:0x6a6a6a];
        label2.left = _miniteBadgeView.right;
        [self addSubview:label2];
        
        _secondBadgeView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.viewHeight, self.viewHeight)];
        _secondBadgeView.text = @"22";
        _secondBadgeView.left = label2.right;
        _secondBadgeView.textColor = [UIColor whiteColor];
        _secondBadgeView.textAlignment = UITextAlignmentCenter;
        _secondBadgeView.clipsToBounds = YES;
        _secondBadgeView.layer.masksToBounds = YES;
        _secondBadgeView.layer.cornerRadius = self.viewHeight/2;
        _secondBadgeView.font = [UIFont systemFontOfSize:12.0];
        _secondBadgeView.backgroundColor = [MIUtility colorWithHex:0x6a6a6a];
        [self addSubview:_secondBadgeView];
    }
    return self;
}

@end
