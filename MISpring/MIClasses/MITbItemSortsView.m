//
//  MITbItemSortsView.m
//  MISpring
//
//  Created by 贺晨超 on 13-9-16.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MITbItemSortsView.h"

@implementation MITbItemSortsView
@synthesize defaultButton;
@synthesize volumeButton;
@synthesize priceButton;
@synthesize creditButton;
@synthesize priceSort;
@synthesize rebateSort;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _sortKey = @"default";
        _currentTag = 0;
        
        defaultButton = [UIButton buttonWithType:UIButtonTypeCustom];
        defaultButton.tag = 0;
        defaultButton.frame = CGRectMake(10, 2, 75, 36);
        defaultButton.adjustsImageWhenHighlighted = NO;
        defaultButton.selected = YES;
        [defaultButton setImage:[UIImage imageNamed:@"taobao_search_left_selected"] forState:UIControlStateNormal];
        [defaultButton setTitle:@"默认" forState:UIControlStateNormal];
        [defaultButton setTitleColor:[MIUtility colorWithHex:0x888888] forState:UIControlStateNormal];
        [defaultButton setTitleColor:[MIUtility colorWithHex:0x000000] forState:UIControlStateSelected];
        [defaultButton.titleLabel setFont:[UIFont fontWithName:@"Arial" size:16]];
        [defaultButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [defaultButton addTarget:self action:@selector(toggleDefaultAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:defaultButton];
        
        volumeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        volumeButton.tag = 1;
        volumeButton.frame = CGRectMake(defaultButton.right, 2, 75, 36);
        volumeButton.adjustsImageWhenHighlighted = NO;
        [volumeButton setImage:[UIImage imageNamed:@"taobao_search_right_normal"] forState:UIControlStateNormal];
        [volumeButton setTitle:@"销量" forState:UIControlStateNormal];
        [volumeButton setTitleColor:[MIUtility colorWithHex:0x888888] forState:UIControlStateNormal];
        [volumeButton setTitleColor:[MIUtility colorWithHex:0x000000] forState:UIControlStateSelected];
        [volumeButton.titleLabel setFont:[UIFont fontWithName:@"Arial" size:16]];
        [volumeButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [volumeButton addTarget:self action:@selector(toggleVolumeAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:volumeButton];
        
        priceSort = @"priceasc";
        priceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        priceButton.tag = 2;
        priceButton.frame = CGRectMake(volumeButton.right, 2, 75, 36);
        priceButton.adjustsImageWhenHighlighted = NO;
        [priceButton setImage:[UIImage imageNamed:@"taobao_search_middle_normal"] forState:UIControlStateNormal];
        [priceButton setTitle:@"价格" forState:UIControlStateNormal];
        [priceButton setTitleColor:[MIUtility colorWithHex:0x888888] forState:UIControlStateNormal];
        [priceButton setTitleColor:[MIUtility colorWithHex:0x000000] forState:UIControlStateSelected];
        [priceButton.titleLabel setFont:[UIFont fontWithName:@"Arial" size:16]];
        [priceButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [priceButton addTarget:self action:@selector(togglePriceAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:priceButton];

        creditButton = [UIButton buttonWithType:UIButtonTypeCustom];
        creditButton.tag = 4;
        creditButton.frame = CGRectMake(priceButton.right, 2, 75, 36);
        creditButton.adjustsImageWhenHighlighted = NO;
        [creditButton setTitle:@"信誉" forState:UIControlStateNormal];
        [creditButton setTitleColor:[MIUtility colorWithHex:0x888888] forState:UIControlStateNormal];
        [creditButton setTitleColor:[MIUtility colorWithHex:0x000000] forState:UIControlStateSelected];
        [creditButton.titleLabel setFont:[UIFont fontWithName:@"Arial" size:16]];
        [creditButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [creditButton setImage:[UIImage imageNamed:@"taobao_search_right_normal"] forState:UIControlStateNormal];
        [creditButton addTarget:self action:@selector(toggleCreditAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:creditButton];
        
        
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 36);
        self.backgroundColor = [UIColor whiteColor];
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0,1);
        self.layer.shadowRadius = 0.8;
        self.layer.shadowOpacity = 0.25;
    }
    return self;
}

- (void)toggleDefaultAction:(UIButton *)sender
{
    if (sender.tag == _currentTag) {
        return;
    }
    
    _sortKey = @"default";
    _currentTag = sender.tag;
    creditButton.selected = NO;
    volumeButton.selected = NO;
    priceButton.selected = NO;
    defaultButton.selected = YES;
    
    [creditButton setImage:[UIImage imageNamed:@"taobao_search_right_normal"] forState:UIControlStateNormal];
    [volumeButton setImage:[UIImage imageNamed:@"taobao_search_right_normal"] forState:UIControlStateNormal];
    [priceButton setImage:[UIImage imageNamed:@"taobao_search_middle_normal"] forState:UIControlStateNormal];
    [defaultButton setImage:[UIImage imageNamed:@"taobao_search_left_selected"] forState:UIControlStateNormal];
    
    MI_CALL_DELEGATE_WITH_ARG(self.delegate, @selector(didSelectTbItemSortsKey:), _sortKey);
}

- (void)toggleVolumeAction:(UIButton *)sender
{
    if (sender.tag == _currentTag) {
        return;
    }
    
    _sortKey = @"volume";
    _currentTag = sender.tag;
    
    creditButton.selected = NO;
    defaultButton.selected = NO;
    priceButton.selected = NO;
    volumeButton.selected = YES;
    [creditButton setImage:[UIImage imageNamed:@"taobao_search_right_normal"] forState:UIControlStateNormal];
    [priceButton setImage:[UIImage imageNamed:@"taobao_search_middle_normal"] forState:UIControlStateNormal];
    [defaultButton setImage:[UIImage imageNamed:@"taobao_search_left_normal"] forState:UIControlStateNormal];
    [volumeButton setImage:[UIImage imageNamed:@"taobao_search_right_selected"] forState:UIControlStateNormal];
    
    MI_CALL_DELEGATE_WITH_ARG(self.delegate, @selector(didSelectTbItemSortsKey:), _sortKey);
}

- (void)togglePriceAction:(UIButton *)sender
{
    creditButton.selected = NO;
    volumeButton.selected = NO;
    defaultButton.selected = NO;
    priceButton.selected = YES;
    [creditButton setImage:[UIImage imageNamed:@"taobao_search_right_normal"] forState:UIControlStateNormal];
    [volumeButton setImage:[UIImage imageNamed:@"taobao_search_right_normal"] forState:UIControlStateNormal];
    [defaultButton setImage:[UIImage imageNamed:@"taobao_search_left_normal"] forState:UIControlStateNormal];
    
    if (sender.tag == _currentTag) {
        //当前已选择价格，则反状态
        if( [priceSort isEqualToString:@"pricedesc"] ){
            [priceButton setImage:[UIImage imageNamed:@"taobao_search_middle_up_selected"] forState:UIControlStateNormal];
            priceSort = @"priceasc";
        }else{
            [priceButton setImage:[UIImage imageNamed:@"taobao_search_middle_down_selected"] forState:UIControlStateNormal];
            priceSort = @"pricedesc";
        }
    } else {
        if( [priceSort isEqualToString:@"pricedesc"] ){
            [priceButton setImage:[UIImage imageNamed:@"taobao_search_middle_down_selected"] forState:UIControlStateNormal];
        }else{
            [priceButton setImage:[UIImage imageNamed:@"taobao_search_middle_up_selected"] forState:UIControlStateNormal];
        }
    }
    
    _sortKey = priceSort;
    _currentTag = sender.tag;
    MI_CALL_DELEGATE_WITH_ARG(self.delegate, @selector(didSelectTbItemSortsKey:), _sortKey);
}

- (void)toggleCreditAction:(UIButton *)sender
{
    if (sender.tag == _currentTag) {
        return;
    }
    
    _sortKey = @"credit";
    _currentTag = sender.tag;
    defaultButton.selected = NO;
    volumeButton.selected = NO;
    priceButton.selected = NO;
    creditButton.selected = YES;
    [volumeButton setImage:[UIImage imageNamed:@"taobao_search_right_normal"] forState:UIControlStateNormal];
    [priceButton setImage:[UIImage imageNamed:@"taobao_search_middle_normal"] forState:UIControlStateNormal];
    [defaultButton setImage:[UIImage imageNamed:@"taobao_search_left_normal"] forState:UIControlStateNormal];
    [creditButton setImage:[UIImage imageNamed:@"taobao_search_right_selected"] forState:UIControlStateNormal];
    MI_CALL_DELEGATE_WITH_ARG(self.delegate, @selector(didSelectTbItemSortsKey:), _sortKey);
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
