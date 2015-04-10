//
//  BBUserFavorSegment.m
//  BeiBeiAPP
//
//  Created by yujian on 14-11-19.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MIUserFavorSegment.h"

@interface MIUserFavorSegment()
{
    NSMutableArray *_cusBtnArray;
    UIView *_lineView;
}

@end

@implementation MIUserFavorSegment

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _cusBtnArray = [[NSMutableArray alloc] initWithCapacity:2];
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)freshSegment
{
    [_cusBtnArray removeAllObjects];
    [self removeAllSubviews];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.viewHeight - 2, self.viewWidth / self.segmentTitleArray.count, 2)];
    _lineView.backgroundColor = [MIUtility colorWithHex:0xff3d00];
    
    for (int i = 0; i < self.segmentTitleArray.count; i++)
    {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i * self.viewWidth/self.segmentTitleArray.count, 0,self.viewWidth/self.segmentTitleArray.count, self.viewHeight)];
        [button setTitle:[self.segmentTitleArray objectAtIndex:i] forState:UIControlStateNormal];
        [button setTitleColor:[MIUtility colorWithHex:0x333333] forState:UIControlStateNormal];
        [button setTitleColor:[MIUtility colorWithHex:0xff3d00]  forState:UIControlStateSelected];
        [button.titleLabel setFont:[UIFont fontWithName:@"Arial" size:14.0]];
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 0.0)];
        button.tag = i + 10000;
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        if (i == 0) {
            _lineView.left = button.left;
            button.selected = YES;
        }
        
        [_cusBtnArray addObject:button];
    }
    [self addSubview:_lineView];
}

- (void)selectSegmentIndex:(NSInteger)index
{
    if (index < _cusBtnArray.count)
    {
        UIButton *btn = [_cusBtnArray objectAtIndex:index];
        [self buttonAction:btn];
    }
}

- (void)buttonAction:(id)sender
{
    UIButton *curbtn = (UIButton *)sender;
    if (_lineView.left != curbtn.left)
    {
        curbtn.selected = YES;
        [UIView animateWithDuration:0.3 animations:^{
            _lineView.left = curbtn.left;
        }];
    }
    
    NSInteger tag = curbtn.tag - 10000;
    self.currentIndex = tag;
    for (int i = 0; i < _cusBtnArray.count; i++)
    {
        if (i != tag)
        {
            UIButton *btn = [_cusBtnArray objectAtIndex:i];
            btn.selected = NO;
        }
    }
    if (_delegate && [_delegate respondsToSelector:@selector(segmentSelectedItemIndex:)])
    {
        [_delegate segmentSelectedItemIndex:tag];
    }
}

@end
