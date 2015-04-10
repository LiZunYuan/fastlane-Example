//
//  MITuanTopScrollView.m
//  MISpring
//
//  Created by husor on 14-12-16.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MITuanTopScrollView.h"
#define SpaceWhite  8
@interface MITuanTopScrollView()
{
    NSMutableArray *_titleBtnArray;
    UIImageView      *_arrow;
    UIButton    *_currentSelectedBtn;
}
@end
@implementation MITuanTopScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _titleBtnArray = [[NSMutableArray alloc] initWithCapacity:11];
        _arrow = [[UIImageView alloc]init];
        _arrow.image =[UIImage imageNamed:@"Up_arrow"];
        _arrow.bounds = CGRectMake(0, 0, 4, 4);
        _isScrolling = NO;
    }
    return self;
}

- (void)setTitleArray:(NSMutableArray *)titleArray
{
    _isScrolling = NO;
    _titleArray = titleArray;
    
    [self setContentOffset:CGPointZero];
    [_titleBtnArray removeAllObjects];
    [self removeAllSubviews];
    
    NSInteger lastWidth = 0;
    for (NSInteger i = 0; i < titleArray.count; i++)
    {
        NSString *title = [titleArray objectAtIndex:i];
        CGSize size = [title sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(self.viewWidth/2, self.viewHeight)];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = [UIColor clearColor];
        btn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [btn setTitle:title  forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.frame = CGRectMake(lastWidth, 0, size.width + SpaceWhite + SpaceWhite, self.viewHeight - 4);
        lastWidth += size.width + SpaceWhite + SpaceWhite;
        btn.tag = 10000+i;
        [btn addTarget:self action:@selector(selectTitleBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_titleBtnArray addObject:btn];
        [self addSubview:btn];
        
        
        if (i == 0)
        {
            _arrow.frame = CGRectMake(btn.centerX - 2, btn.viewHeight - 2, 4, 4);
            _currentSelectedBtn = btn;
            _currentSelectedBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            [_currentSelectedBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self addSubview:_arrow];
        }
    }
    self.contentSize = CGSizeMake(lastWidth, self.viewHeight);
}

- (void)selectTitleBtn:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    _isScrolling = YES;
    [UIView animateWithDuration:0.3 animations:^{
        _arrow.centerX = btn.centerX;
    }completion:^(BOOL finished) {
        _isScrolling = NO;
        if (finished) {
            
            if (_topScrollViewDelegate && [_topScrollViewDelegate respondsToSelector:@selector(selectedIndex:)])
            {
                [_topScrollViewDelegate selectedIndex:btn.tag - 10000];
            }
            
        }
    }];
    
    [self selectButtonInScrollView:btn];
}

- (void)selectIndexInScrollView:(NSInteger)index
{
    if (_isScrolling == NO && _titleBtnArray.count > index) {
        UIButton *btn = [_titleBtnArray objectAtIndex:index];
        _isScrolling = YES;
        [UIView animateWithDuration:0.3 animations:^{
            _arrow.centerX = btn.centerX;
        }completion:^(BOOL finished) {
            _isScrolling = NO;
        }];
        [self selectButtonInScrollView:btn];
    }
}

- (void)selectButtonInScrollView:(UIButton *)button
{
    NSInteger toIndex = button.tag - 10000;
    if (_currentPage < toIndex)
    {
        if (_titleBtnArray.count > toIndex + 1)
        {
            UIButton *nextPlusBtn = [_titleBtnArray objectAtIndex:toIndex + 1];
            if (self.contentOffset.x > button.right)
            {
                [self scrollRectToVisible:button.frame animated:YES];
            }
            else
            {
                [self scrollRectToVisible:nextPlusBtn.frame animated:YES];
            }
        }
        else if(button.right > self.viewWidth)
        {
            [self scrollRectToVisible:button.frame animated:YES];
        }
    }
    else
    {
        if (toIndex - 1 >= 0 && _titleBtnArray.count > toIndex - 1)
        {
            UIButton *nextPlusBtn = [_titleBtnArray objectAtIndex:toIndex - 1];
            if (self.contentOffset.x + self.viewWidth < button.right)
            {
                [self scrollRectToVisible:button.frame animated:YES];
            }
            else
            {
                [self scrollRectToVisible:nextPlusBtn.frame animated:YES];
            }
        }
        else if(button.left <= self.left)
        {
            [self scrollRectToVisible:button.frame animated:YES];
        }
    }
    
    [_currentSelectedBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _currentSelectedBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    _currentSelectedBtn = button;
    _currentPage = button.tag - 10000;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
