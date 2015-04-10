//
//  MIScreenView.m
//  MISpring
//
//  Created by 曲俊囡 on 14-5-16.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MIScreenView.h"
#import "MITuanTenCatModel.h"
#import "MIZhiCatModel.h"
#import "MITuanBrandCatModel.h"
#import "MIBeibeiCatModel.h"

//一行有3或4个button的情况
#define  ScreenButtonNumber 3
#define  ScreenButtonWidth ((SCREEN_WIDTH - (ScreenButtonNumber - 1))/ScreenButtonNumber)
#define  ScreenButtonHeight  (ScreenButtonNumber == 3 ? 35 : 38)


@implementation MIScreenView

- (id)initWithArray:(NSArray *)cats
{
    self = [super init];
    if (self) {
        // Initialization code
        [self reloadContenWithCats:cats];
    }
    return self;
}

- (void)reloadContenWithCats:(NSArray *)cats
{
    float height = 0.0;
    [self removeAllSubviews];
    self.backgroundColor = [MIUtility colorWithHex:0xf2f2f2];
    for (NSInteger i = 0; i < cats.count; i++)
    {
        MIScreenbutton *screenButton = [[MIScreenbutton alloc] initWithFrame:CGRectMake(i % ScreenButtonNumber *(ScreenButtonWidth), i/ScreenButtonNumber * (ScreenButtonHeight), ScreenButtonWidth, ScreenButtonHeight)];
        
        NSString *cat = [cats objectAtIndex:i];
        [screenButton setTitle:cat forState:UIControlStateNormal];
        if (_type == MIZhiCatType) {
            if (i == 1)
            {
                [screenButton setTitleColor:[MIUtility colorWithHex:0xF94B4B] forState:UIControlStateNormal];
            }
            if (i == 2)
            {
                [screenButton setTitleColor:[MIUtility colorWithHex:0x1995F2] forState:UIControlStateNormal];
            }
        }
        screenButton.tag = i + 100;
        [screenButton addTarget:self action:@selector(screenCategory:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:screenButton];
        height = i/ScreenButtonNumber * (ScreenButtonHeight) + ScreenButtonHeight;
        if (0 == i)
        {
            screenButton.isSelected = YES;
            [screenButton reLoadButton];
        }
    }
    self.frame = CGRectMake(0, 0, PHONE_SCREEN_SIZE.width, height);
    if (cats.count %ScreenButtonNumber)
    {
        for (NSInteger i = cats.count %ScreenButtonNumber; i < ScreenButtonNumber; i++)
        {
            MIScreenbutton *screenButton = [[MIScreenbutton alloc] initWithFrame:CGRectMake(i*(ScreenButtonWidth), height - ScreenButtonHeight, ScreenButtonWidth, ScreenButtonHeight)];
            screenButton.backgroundColor = [UIColor whiteColor];
            screenButton.enabled = NO;
            [self addSubview:screenButton];
        }
    }
}

- (void)screenCategory:(MIScreenbutton *)sender
{
    if (!sender.isSelected) {
        for (MIScreenbutton *button in sender.superview.subviews)
        {
            button.isSelected = NO;
            [button reLoadButton];
        }
        sender.isSelected = YES;
        [sender reLoadButton];
        if (_delegate)
        {
//            if ([_delegate respondsToSelector:@selector(selectedCatId:catName:)]) {
//                [_delegate selectedCatId:sender.catId catName:sender.catName];
//            }
            
            if ([_delegate respondsToSelector:@selector(selectedIndex:)]) {
                [_delegate selectedIndex:(sender.tag - 100)];
            }
        }
    } else {
        if (_delegate && [_delegate respondsToSelector:@selector(selectedSelf)])
        {
            [_delegate selectedSelf];
        }
    }
}

//同步选中按钮
- (void)synButtonSelectWithIndex:(NSInteger)index
{
    for (MIScreenbutton *button in self.subviews)
    {
        button.isSelected = NO;
        [button reLoadButton];
    }
    
    MIScreenbutton *button = (MIScreenbutton *)[self viewWithTag:(index + 100)];
    button.isSelected = YES;
//    button.backgroundColor = [MIUtility colorWithHex:0xeeeeee];
    [button reLoadButton];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
