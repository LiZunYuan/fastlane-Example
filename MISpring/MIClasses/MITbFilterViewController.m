//
//  MITbFilterViewController.m
//  MISpring
//
//  Created by 贺晨超 on 13-9-22.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MITbFilterViewController.h"

@implementation MITbFilterViewController

@synthesize isTmallSwitch;
@synthesize minPriceTextField;
@synthesize maxPriceTextField;
@synthesize isTmall = _isTmall;
@synthesize minPrice = _minPrice;
@synthesize maxPrice = _maxPrice;
@synthesize delegate = _delegate;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationBar setBarTitle:@"筛选" textSize:20.0];

    UIView * isTmallView = [[UIView alloc] init];
    isTmallView.frame = CGRectMake(10, 10 + self.navigationBarHeight, 300, 40);
    isTmallView.backgroundColor = [UIColor whiteColor];
    isTmallView.layer.cornerRadius = 5.0;
    
    UIView * priceView = [[UIView alloc] init];
    priceView.frame = CGRectMake(10, 60 + self.navigationBarHeight, 300, 90);
    priceView.backgroundColor = [UIColor whiteColor];
    priceView.layer.cornerRadius = 5.0;
    
    UILabel * isTmallTitleLabel = [[UILabel alloc] init];
    isTmallTitleLabel.frame = CGRectMake(10, 7, 130, 26);
    isTmallTitleLabel.text = @"只显示天猫";
    isTmallTitleLabel.textColor = [UIColor darkGrayColor];
    isTmallTitleLabel.backgroundColor = [UIColor clearColor];
    
    UILabel * minPriceTitleLabel = [[UILabel alloc] init];
    minPriceTitleLabel.frame = CGRectMake(10, 10, 130, 26);
    minPriceTitleLabel.text = @"最低价格";
    minPriceTitleLabel.textColor = [UIColor darkGrayColor];
    minPriceTitleLabel.backgroundColor = [UIColor clearColor];
    
    UILabel * maxPriceTitleLabel = [[UILabel alloc] init];
    maxPriceTitleLabel.frame = CGRectMake(10, 52, 130, 26);
    maxPriceTitleLabel.text = @"最高价格";
    maxPriceTitleLabel.textColor = [UIColor darkGrayColor];
    maxPriceTitleLabel.backgroundColor = [UIColor clearColor];
    
    isTmallSwitch = [[UISwitch alloc] init];
    isTmallSwitch.frame = CGRectMake(210, 7, 0, 0);
    
    UIImage *fieldBg = [[UIImage imageNamed:@"text_input_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    
    UITextField * minPriceField = [[UITextField alloc] init];
    minPriceField.frame = CGRectMake(145, 7, 145, 36);
    minPriceField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    minPriceField.background = fieldBg;
    minPriceField.tag = 2001;
    minPriceField.keyboardType = UIKeyboardTypeNumberPad;
    minPriceField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 36)];
    minPriceField.leftViewMode = UITextFieldViewModeAlways;
    minPriceField.rightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 36)];
    minPriceField.rightViewMode = UITextFieldViewModeAlways;
    minPriceField.returnKeyType = UIReturnKeyNext;
    minPriceField.delegate = self;
    minPriceTextField = minPriceField;
    
    UITextField * maxPriceField = [[UITextField alloc] init];
    maxPriceField.frame = CGRectMake(145, 48, 145, 36);
    maxPriceField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    maxPriceField.background = fieldBg;
    maxPriceField.tag = 2002;
    maxPriceField.keyboardType = UIKeyboardTypeNumberPad;
    maxPriceField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 36)];
    maxPriceField.leftViewMode = UITextFieldViewModeAlways;
    maxPriceField.rightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 36)];
    maxPriceField.rightViewMode = UITextFieldViewModeAlways;
    maxPriceField.returnKeyType = UIReturnKeyNext;
    maxPriceField.delegate = self;
    maxPriceTextField = maxPriceField;
    
    UIButton * confirmButton = [[UIButton alloc] initWithFrame: CGRectMake(10, 160 + self.navigationBarHeight, 300, 36)];
    UIImage *buttonImage = [[UIImage imageNamed:@"redButton.png"]
                            resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    UIImage *buttonImageHighlight = [[UIImage imageNamed:@"redButtonHighlight.png"]
                                     resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    
    [confirmButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [confirmButton setBackgroundImage:buttonImageHighlight forState:UIControlStateHighlighted];
    [confirmButton setBackgroundImage:buttonImageHighlight forState:UIControlStateSelected];
    [confirmButton setTitle: @"完成" forState:UIControlStateNormal];
    [confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmButton setTitleShadowColor:[UIColor colorWithRed:0.53 green:0.19 blue:0.07 alpha:1] forState:UIControlStateSelected];
    [confirmButton.titleLabel setShadowOffset:CGSizeMake(0, -0.5)];
    confirmButton.titleLabel.font = [UIFont systemFontOfSize: 15];
    [confirmButton setShowsTouchWhenHighlighted:YES];
    [confirmButton addTarget:self action:@selector(confirmButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [isTmallView addSubview:isTmallTitleLabel];
    [isTmallView addSubview:isTmallSwitch];
    [self.view addSubview:isTmallView];
    
    [priceView addSubview:minPriceTitleLabel];
    [priceView addSubview:minPriceField];
    [priceView addSubview:maxPriceTitleLabel];
    [priceView addSubview:maxPriceField];
    [self.view addSubview:priceView];
    [self.view addSubview:confirmButton];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)confirmButtonClicked:(UIButton *)sender
{
    _minPrice = (minPriceTextField.text != nil) ? minPriceTextField.text : @"0";
    _maxPrice = (maxPriceTextField.text != nil) ? maxPriceTextField.text : @"99999999";
    _isTmall = isTmallSwitch.on ? @"true" : @"false";
    
    NSMutableArray *_filterInfo = [[NSMutableArray alloc] initWithCapacity:3];
    [_filterInfo addObject:_isTmall];
    [_filterInfo addObject:_minPrice];
    [_filterInfo addObject:_maxPrice];
    
    [self miPopToPreviousViewController];
    MI_CALL_DELEGATE_WITH_ARG(self.delegate, @selector(searchFilterUIViewDidCancel:), _filterInfo);
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.location >= 6)
        return NO; // return NO to not change text
    return YES;
}

@end
