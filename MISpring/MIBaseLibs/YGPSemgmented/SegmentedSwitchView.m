//
//  SegmentedSwitchView.m
//  YGPSegmentedSwitch
//
//  Created by yang on 13-6-27.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "SegmentedSwitchView.h"

//按钮空隙
#define BUTTONGAP 20
//按钮长度
#define BUTTONWIDTH 59
//按钮宽度
#define BUTTONHEIGHT 30
//滑条CONTENTSIZEX
#define CONTENTSIZEX SCREEN_WIDTH

@implementation SegmentedSwitchView

@synthesize titleArray;
@synthesize delegate=_delegate;

@synthesize scrollView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddRect(path, NULL, self.bounds);
        self.layer.shadowPath = path;
        CGPathCloseSubpath(path);
        CGPathRelease(path);
        
        self.clipsToBounds = NO;
        self.backgroundColor = [UIColor whiteColor];
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0,1);
        self.layer.shadowRadius = 0.8;
        self.layer.shadowOpacity = 0.25;
        
        scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        scrollView.pagingEnabled = NO;
        scrollView.scrollEnabled = YES;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        [self addSubview:scrollView];
    }
    return self;
}

-(void) reloadContentTitle:(NSArray*)title
{
    [scrollView removeAllSubviews];
    
    self.titleArray = title;
    
    //初始化button
    [self initWithButton];
}

//初始化框架数据
-(void) initContentTitle:(NSArray*)title
{
    [scrollView removeAllSubviews];
    selectedTag = 0;

    self.titleArray = title;
    
    //初始化button
    [self initWithButton];
    
    [self setSelectedIndex:0];
}

//初始化button
-(void)initWithButton
{
    CGFloat contentSize = 0;
    CGFloat x = 0;
    selectedTag = 100;
    
    if (self.titleArray != nil) {
        for (NSInteger i = 0; i < [self.titleArray count]; i++)
        {
            UIButton *segmentedButton = [UIButton buttonWithType:UIButtonTypeCustom];
            segmentedButton.tag=i+100;
            
            CGSize sz = [[NSString stringWithFormat:@"%@", titleArray[i]] sizeWithFont:segmentedButton.titleLabel.font];
            [segmentedButton setTitle:[NSString stringWithFormat:@"%@", titleArray[i]] forState:UIControlStateNormal];
            [segmentedButton setFrame:CGRectMake(BUTTONGAP + x, 3, sz.width, 30)];
            [segmentedButton setTitle:[NSString stringWithFormat:@"%@", titleArray[i]] forState:UIControlStateNormal];
            [segmentedButton setTitleColor:[MIUtility colorWithHex:0xBFBFBF] forState:UIControlStateNormal];
            [segmentedButton setTitleColor:[MIUtility colorWithHex:0xFF7B52] forState:UIControlStateHighlighted];
            [segmentedButton setTitleColor:[MIUtility colorWithHex:0xFF7B52] forState:UIControlStateSelected];
            [segmentedButton addTarget:self action:@selector(onButtonSelect:) forControlEvents:UIControlEventTouchUpInside];
            segmentedButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
            
            [scrollView addSubview:segmentedButton];
            
            if (i == 0)
            {
                segmentedButton.selected=YES;
                selectedTag = segmentedButton.tag;
            }
            
            contentSize += segmentedButton.viewWidth + BUTTONGAP;
            x += segmentedButton.viewWidth + BUTTONGAP;
        }
        
        scrollView.contentSize = CGSizeMake(contentSize + BUTTONGAP, self.viewHeight);
        scrollView.contentOffset = CGPointZero;
    }
}

//点击button调用方法
-(void)onButtonSelect:(UIButton*)sender
{
    if (sender.tag == selectedTag) {
        return;
    }
    
    //取消当前选择
    UIButton * lastSelectedBtn = (UIButton*)[self viewWithTag:selectedTag];
    lastSelectedBtn.selected=NO;
    selectedTag = sender.tag;
    sender.selected=YES;
    [self setSelectedIndex:(sender.tag - 100)];
    [scrollView scrollRectToVisible:sender.frame animated:YES];
}

//选择index
- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    if ([_delegate respondsToSelector:@selector(segmentedViewController:touchedAtIndex:)])
        [_delegate segmentedViewController:self touchedAtIndex:selectedIndex];
}

-(NSInteger)initselectedSegmentIndex
{
    //初始化为（0）
    return 0;
    
}

- (void) backToIndex: (NSInteger) index
{
    if (titleArray == nil) {
        return;
    }
    
    //取消当前选择
    NSInteger tag = 100 + index;
    if (tag != selectedTag) {
        UIButton * lastSelectedBtn = (UIButton*)[self viewWithTag:selectedTag];
        lastSelectedBtn.selected=NO;
        selectedTag = tag;
    }
    
    UIButton * selectedBtn = (UIButton*)[self viewWithTag:selectedTag];
    selectedBtn.selected = YES;
    [scrollView scrollRectToVisible:selectedBtn.frame animated:YES];
}

@end
