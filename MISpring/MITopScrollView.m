//
//  MITopScrollView.m
//  MISpring
//
//  Created by husor on 14-11-10.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MITopScrollView.h"
#define SpaceWhite  8

@interface MITopScrollView()
{
    NSMutableArray *_titleBtnArray;
    UIView      *_selectLineView;
    UIButton    *_currentSelectedBtn;
}
@end

@implementation MITopScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _titleBtnArray = [[NSMutableArray alloc] initWithCapacity:11];
        _selectLineView = [[UIView alloc] init];
        _selectLineView.backgroundColor = [MIUtility colorWithHex:0xff5500];
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
        [btn setTitleColor:[MIUtility colorWithHex:0x666666] forState:UIControlStateNormal];
        btn.frame = CGRectMake(lastWidth, 0, size.width + SpaceWhite + SpaceWhite, self.viewHeight);
        lastWidth += size.width + SpaceWhite + SpaceWhite;
        btn.tag = 10000+i;
        [btn addTarget:self action:@selector(selectTitleBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_titleBtnArray addObject:btn];
        [self addSubview:btn];
        
        if (i == 0)
        {
            _selectLineView.frame = CGRectMake(btn.frame.origin.x + SpaceWhite, btn.frame.size.height - 3, btn.frame.size.width - SpaceWhite - SpaceWhite, 2);
            _currentSelectedBtn = btn;
            [_currentSelectedBtn setTitleColor:[MIUtility colorWithHex:0xff5500] forState:UIControlStateNormal];
            [self addSubview:_selectLineView];
        }
    }
    self.contentSize = CGSizeMake(lastWidth, self.viewHeight);
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, self.viewHeight - 0.5, lastWidth, 0.5)];
    line.backgroundColor = [MIUtility colorWithHex:0xe4e4e4];
    [self addSubview:line];
}

- (void)selectTitleBtn:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    _isScrolling = YES;
    [UIView animateWithDuration:0.3 animations:^{
        _selectLineView.frame = CGRectMake(btn.frame.origin.x + SpaceWhite, btn.frame.size.height - 3, btn.frame.size.width - SpaceWhite - SpaceWhite, 2);
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
    if (_isScrolling == NO && _titleArray.count > index) {
        UIButton *btn = [_titleBtnArray objectAtIndex:index];
        _isScrolling = YES;
        [UIView animateWithDuration:0.3 animations:^{
            _selectLineView.frame = CGRectMake(btn.frame.origin.x + SpaceWhite, btn.frame.size.height - 3, btn.frame.size.width - SpaceWhite - SpaceWhite, 2);
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
        else if(toIndex == 0 && self.contentOffset.x > 0)
        {
            [self setContentOffset:CGPointZero animated:YES];
//            [self scrollRectToVisible:button.frame animated:YES];
        }
    }
    
    [_currentSelectedBtn setTitleColor:[MIUtility colorWithHex:0x666666] forState:UIControlStateNormal];
    [button setTitleColor:[MIUtility colorWithHex:0xff5500] forState:UIControlStateNormal];
    _currentSelectedBtn = button;
    _currentPage = button.tag - 10000;
}

@end
