//
//  MIBBMarqueeView.m
//  MISpring
//
//  Created by husor on 14-10-16.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MIBBMarqueeView.h"

@implementation MIBBMarqueeView
@synthesize lable = _lable;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.userInteractionEnabled = NO;
        self.delegate = self;
        self.lable = [[UILabel alloc] init];
        self.lable.backgroundColor = [UIColor clearColor];
        self.lable.font = [UIFont systemFontOfSize:14.0];
        self.lable.textColor = [MIUtility colorWithHex:0x383838];
        self.contentSize = CGSizeMake(SCREEN_WIDTH*100, frame.size.height);
        [self addSubview:self.lable];
    }
    return self;
}

- (void)setLabelText:(NSString *)text
{
    CGSize size = [text sizeWithFont:self.lable.font constrainedToSize:CGSizeMake(SCREEN_WIDTH*10, self.frame.size.height)];
    self.lable.frame = CGRectMake(self.frame.size.width, 0, size.width, size.height);
    self.lable.text = text;
}

#pragma UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self stopTimer];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self startTimer];
}

#pragma Timer

- (void)startTimer {
    if (self.lable.frame.size.width <= self.frame.size.width)
    {
        self.lable.frame = CGRectMake(0, 0, self.lable.viewWidth, self.lable.viewHeight);
        return;
    }
    if (timer_)
        [self stopTimer];
    
    timer_ = [NSTimer timerWithTimeInterval:0.02 target:self selector:@selector(advanceFrame) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer_  forMode:NSDefaultRunLoopMode];
}

- (void)stopTimer {
    if (timer_) {
        [timer_ invalidate];
        timer_ = nil;
    }
}
/**
 设计一下scrollview移动的逻辑
 */
-(void)advanceFrame{
    if (self.contentOffset.x >= self.lable.size.width + self.frame.size.width)
    {
        self.contentOffset = CGPointZero;
    }
    self.contentOffset = CGPointMake(self.contentOffset.x + 1, self.contentOffset.y);
}
- (void)repeatScrollText
{
    [self scrollRectToVisible:CGRectMake(0, 0, self.viewWidth, self.viewHeight) animated:YES];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
