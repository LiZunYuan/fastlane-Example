//
//  MISegmentView.m
//  MISpring
//
//  Created by 贺晨超 on 13-10-10.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MISegmentView.h"

@implementation MISegmentView

@synthesize leftButton = _leftButton;
@synthesize rightButton = _rightButton;
@synthesize delegate = _delegate;

- (void)buttonAction:(UIButton *)sender{
    if ([sender isEqual:self.leftButton]) {
        [self setSelectTabIndex:0];
    } else if ([sender isEqual:self.rightButton]) {
        [self setSelectTabIndex:1];
    }
    
    [MobClick event:kOrderTabsClicks label:sender.titleLabel.text];
}

- (id)init
{
    self = [super initWithFrame:CGRectMake(0, 0, 160, 29)];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        CGFloat offsetX = 0.0;
        CGFloat offsetY = 0.0;
        CGFloat buttonWidth = 80.0;
        UIImage *leftImage = [[UIImage imageNamed:@"segmented-bg-left"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 4.0, 0.0, 0.0)];
        UIImage *leftImageHL = [[UIImage imageNamed:@"segmented-bg-pressed-left"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 4.0, 0.0, 0.0)];
        UIImage *rightImage = [[UIImage imageNamed:@"segmented-bg-right"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, 4.0)];
        UIImage *rightImageHL = [[UIImage imageNamed:@"segmented-bg-pressed-right"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, 4.0)];
        
        _leftButton = [[UIButton alloc]initWithFrame:CGRectMake(offsetX, offsetY, buttonWidth, leftImageHL.size.height)];
        _leftButton.tag = 1001;
        [_leftButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
        [_leftButton.titleLabel setFont:[UIFont fontWithName:@"Arial" size:14.0]];
        [_leftButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 0.0)];
        
        [_leftButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_leftButton setBackgroundImage:leftImage forState:UIControlStateNormal];
        [_leftButton setBackgroundImage:leftImage forState:UIControlStateHighlighted];
        [_leftButton setBackgroundImage:leftImageHL forState:UIControlStateDisabled];
        [self addSubview:_leftButton];
        
        _rightButton = [[UIButton alloc] initWithFrame:CGRectMake(buttonWidth + offsetX, offsetY, buttonWidth, rightImageHL.size.height)];
        _rightButton.tag = 1002;
        [_rightButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
        [_rightButton.titleLabel setFont:[UIFont fontWithName:@"Arial" size:14.0]];
        [_rightButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 0.0)];
        
        [_rightButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_rightButton setBackgroundImage:rightImage forState:UIControlStateNormal];
        [_rightButton setBackgroundImage:rightImage forState:UIControlStateHighlighted];
        
        [_rightButton setBackgroundImage:rightImageHL forState:UIControlStateDisabled];
        [self addSubview:_rightButton];
        
        [self setSelectTabIndex:0];
    }
    return self;
}

- (void)setSelectTabIndex:(NSInteger)index{
    
    if (index == 0) {
        [self.leftButton setEnabled:NO];
        [self.rightButton setEnabled:YES];
    } else if(index == 1){
        [self.leftButton setEnabled:YES];
        [self.rightButton setEnabled:NO];
    }
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(segmentView:didSelectIndex:)]) {
        [self.delegate segmentView:self didSelectIndex:index];
    }
}

- (void)switchTabIndex:(NSInteger)index{
    
    if (index == 0) {
        [self.leftButton setEnabled:NO];
        [self.rightButton setEnabled:YES];
    } else if(index == 1){
        [self.leftButton setEnabled:YES];
        [self.rightButton setEnabled:NO];
    }
}

@end
