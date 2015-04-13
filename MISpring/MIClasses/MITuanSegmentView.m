//
//  MITuanSegmentView.m
//  MISpring
//
//  Created by Yujian Xu on 13-3-24.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MITuanSegmentView.h"
#define   OffsetX   5.0
#define ButtonWidth    (100.0 * SCREEN_WIDTH/320.0)

@implementation MITuanSegmentView

@synthesize leftButton = _leftButton;
@synthesize rightButton = _rightButton;
@synthesize middleButton = _middleButton;
@synthesize delegate = _delegate;

- (void)buttonAction:(UIButton *)sender{
    if ([sender isEqual:self.leftButton]) {
        [self setSelectTabIndex:0];
    }
    else if ([sender isEqual:self.middleButton]) {
        [self setSelectTabIndex:1];
    }
    else if ([sender isEqual:self.rightButton]) {
        [self setSelectTabIndex:2];
    }
    [MobClick event:kTuanTabsClicks label:sender.titleLabel.text];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        _leftButton = [[UIButton alloc]initWithFrame:CGRectMake(OffsetX, 0, ButtonWidth, frame.size.height)];
        [_leftButton setTitle:@"10元购" forState:UIControlStateNormal];
        _leftButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_leftButton setTitleColor:[MIUtility colorWithHex:0x666666] forState:UIControlStateNormal];
        [_leftButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_leftButton];
        
        _middleButton = [[UIButton alloc]initWithFrame:CGRectMake(_leftButton.right + OffsetX, 0, ButtonWidth, frame.size.height)];
        [_middleButton setTitle:@"优品惠" forState:UIControlStateNormal];
        _middleButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_middleButton setTitleColor:[MIUtility colorWithHex:0x666666] forState:UIControlStateNormal];
        [_middleButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_middleButton];

        _rightButton = [[UIButton alloc] initWithFrame:CGRectMake(_middleButton.right + OffsetX, 0, ButtonWidth, frame.size.height)];
        [_rightButton setTitle:@"品牌特卖" forState:UIControlStateNormal];
        _rightButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_rightButton setTitleColor:[MIUtility colorWithHex:0x666666] forState:UIControlStateNormal];
        [_rightButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_rightButton];
        
        shadowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(OffsetX, frame.size.height - 38, ButtonWidth, 38)];
        [shadowImageView setImage:[UIImage imageNamed:@"bg_catbar_item"]];
        [self addSubview:shadowImageView];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 39.5, PHONE_SCREEN_SIZE.width, 0.5)];
        line.backgroundColor = [MIUtility colorWithHex:0xe4e4e4];
        [self addSubview:line];
    }
    return self;
}

- (void)setSelectTabIndex:(NSInteger)index{
    if (index == 0) {
        [_leftButton setTitleColor:[MIUtility colorWithHex:0xff5500] forState:UIControlStateNormal];
        [_middleButton setTitleColor:[MIUtility colorWithHex:0x666666] forState:UIControlStateNormal];
        [_rightButton setTitleColor:[MIUtility colorWithHex:0x666666] forState:UIControlStateNormal];
        [self.leftButton setEnabled:NO];
        [self.middleButton setEnabled:YES];
        [self.rightButton setEnabled:YES];
    }
    else if(index == 1){
        [_leftButton setTitleColor:[MIUtility colorWithHex:0x666666] forState:UIControlStateNormal];
        [_middleButton setTitleColor:[MIUtility colorWithHex:0xff5500] forState:UIControlStateNormal];
        [_rightButton setTitleColor:[MIUtility colorWithHex:0x666666] forState:UIControlStateNormal];
        [self.leftButton setEnabled:YES];
        [self.middleButton setEnabled:NO];
        [self.rightButton setEnabled:YES];
    }
    else if(index == 2){
        [_leftButton setTitleColor:[MIUtility colorWithHex:0x666666] forState:UIControlStateNormal];
        [_middleButton setTitleColor:[MIUtility colorWithHex:0x666666] forState:UIControlStateNormal];
        [_rightButton setTitleColor:[MIUtility colorWithHex:0xff5500] forState:UIControlStateNormal];
        [self.leftButton setEnabled:YES];
        [self.middleButton setEnabled:YES];
        [self.rightButton setEnabled:NO];
    }
    [UIView animateWithDuration:0.25 animations:^{
        [shadowImageView setFrame:CGRectMake(OffsetX * (index + 1) + index * ButtonWidth, 2, ButtonWidth, 38)];
    } completion:^(BOOL finished) {
        if (finished) {
            if (self.delegate != nil && [self.delegate respondsToSelector:@selector(segmentView:didSelectIndex:)]) {
                [self.delegate segmentView:self didSelectIndex:index];
            }
        }
    }];
}
@end
