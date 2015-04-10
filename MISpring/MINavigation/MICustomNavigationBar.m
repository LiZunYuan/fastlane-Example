//
//  MINavigationBar.m
//  MiZheHD
//
//  Created by 徐 裕健 on 13-7-18.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MICustomNavigationBar.h"

@implementation MICustomNavigationBar
@synthesize disableRoundedCorner;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        // Default clipsToBounds is YES, will clip off the shadow, so we disable it.
        self.clipsToBounds = NO;
        
        //导航条下方加阴影
        [self dropShadowWithOffset:CGSizeMake(0, 0.6)
                            radius:0.6
                             color:[UIColor blackColor]
                           opacity:0.3];
      //  [self setNavigationBarWithImageKey:@"navigator_bar_bg"];
        self.backgroundColor = [MIUtility colorWithHex:0xf9f9f9];
//        UIView *splitLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.viewHeight, self.viewWidth, 0.6)];
//        splitLine.backgroundColor = [MIUtility colorWithHex:0xdddddd];
//        [self addSubview:splitLine];
    }
    return self;
}

- (void)setBarTitleLabelFrame:(CGRect)frame
{
    _titleLabel.frame = frame;
}

- (void)setBarTitle:(NSString *)title
{
    [self setBarTitle:title textSize:18.0];
}

// 设置导航条标题
- (void)setBarTitle: (NSString *) title textSize:(CGFloat) size
{
    if (_titleLabel) {
        [_titleLabel removeFromSuperview];
    }
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:size];
    titleLabel.text = title;
    titleLabel.textColor = [MIUtility colorWithHex:0x333333];
    titleLabel.frame = CGRectMake(80, self.viewHeight - PHONE_NAVIGATION_BAR_ITEM_HEIGHT, SCREEN_WIDTH/2, PHONE_NAVIGATION_BAR_ITEM_HEIGHT);
    titleLabel.centerX = SCREEN_WIDTH/2;
    titleLabel.textAlignment = UITextAlignmentCenter;
    titleLabel.adjustsFontSizeToFitWidth = YES;
    titleLabel.minimumFontSize = (size - 2);
    [self addSubview:titleLabel];
    _titleLabel = titleLabel;
}

- (void)setBarTitleImage:(NSString *)imageName
{
    if (_titleLabel) {
        [_titleLabel removeFromSuperview];
    }
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 58.5, 18)];
    imageView.image = [UIImage imageNamed:imageName];
    imageView.centerX = SCREEN_WIDTH/2;
    imageView.centerY = (IOS7_STATUS_BAR_HEGHT + self.viewHeight)/2;
    [self addSubview:imageView];
}

- (void)setBarTitle: (NSString *) title textSize:(CGFloat) size textColor:(UIColor *)color
{
    if (_titleLabel) {
        [_titleLabel removeFromSuperview];
    }
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:size];
    titleLabel.text = title;
    titleLabel.textColor = color;
    titleLabel.frame = CGRectMake(80, self.viewHeight - PHONE_NAVIGATION_BAR_ITEM_HEIGHT, SCREEN_WIDTH/2, PHONE_NAVIGATION_BAR_ITEM_HEIGHT);
    titleLabel.centerX = SCREEN_WIDTH/2;
    titleLabel.textAlignment = UITextAlignmentCenter;
    titleLabel.adjustsFontSizeToFitWidth = YES;
    titleLabel.minimumFontSize = (size - 2);
    [self addSubview:titleLabel];
    _titleLabel = titleLabel;
}

// 设置导航条左标题
- (void)setBarLeftTitle: (NSString *) title textSize:(CGFloat) size
{
    if (_leftLabel) {
        [_leftLabel removeFromSuperview];
    }
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:size];
    titleLabel.text = title;
    titleLabel.textColor = [MIUtility colorWithHex:0x333333];
    titleLabel.frame = CGRectMake(30, self.viewHeight - PHONE_NAVIGATION_BAR_ITEM_HEIGHT, SCREEN_WIDTH / 2, PHONE_NAVIGATION_BAR_ITEM_HEIGHT);
    titleLabel.adjustsFontSizeToFitWidth = YES;
    titleLabel.minimumFontSize = (size - 2);
    [self addSubview:titleLabel];
    _leftLabel = titleLabel;
}

// 设置导航条左按钮
- (void)setBarLeftButtonItem:(id)target selector:(SEL)sel imageKey:(NSString *)image
{
    if (_leftButton) {
        [_leftButton removeFromSuperview];
    }
    
    UIImage *normalImage = [UIImage imageNamed:image];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, self.viewHeight - PHONE_NAVIGATION_BAR_ITEM_HEIGHT, 48, PHONE_NAVIGATION_BAR_ITEM_HEIGHT)];
    [button setImage:normalImage forState:UIControlStateNormal];
	[button addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    _leftButton = button;
}

- (void)setBarCloseTextButtonItem:(id)target selector:(SEL)sel title:(NSString *)title
{
    if (_closeButton) {
        [_closeButton removeFromSuperview];
    }
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(40, (self.viewHeight - PHONE_NAVIGATION_BAR_ITEM_HEIGHT), 40, PHONE_NAVIGATION_BAR_ITEM_HEIGHT)];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[MIUtility colorWithHex:0x333333] forState:UIControlStateNormal];
    [button addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    _closeButton = button;
}

- (void)setBarRightButtonItem:(id)target selector:(SEL)sel imageKey:(NSString *)image
{
    if (_rightButton) {
        [_rightButton removeFromSuperview];
    }
    
    UIImage *normalImage = [UIImage imageNamed:image];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 100, self.viewHeight - PHONE_NAVIGATION_BAR_ITEM_HEIGHT, 100, PHONE_NAVIGATION_BAR_ITEM_HEIGHT)];
    [button setImage:normalImage forState:UIControlStateNormal];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0.0, 50.0, 0.0, 0.0)];
    button.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [button setTitleColor:[MIUtility colorWithHex:0x333333] forState:UIControlStateNormal];
	[button addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    _rightButton = button;
}

- (void)setBarRightTextButtonItem:(id)target selector:(SEL)sel title:(NSString *)title
{
    if (_rightButton) {
        [_rightButton removeFromSuperview];
    }
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 60, (self.viewHeight - PHONE_NAVIGATION_BAR_ITEM_HEIGHT), 60, PHONE_NAVIGATION_BAR_ITEM_HEIGHT)];
    CGSize size = [title sizeWithFont:button.titleLabel.font];
    button.frame = CGRectMake(SCREEN_WIDTH - size.width - 16, (self.viewHeight - PHONE_NAVIGATION_BAR_ITEM_HEIGHT), size.width + 16, PHONE_NAVIGATION_BAR_ITEM_HEIGHT);

    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [button setTitleColor:MICommitButtonBackground forState:UIControlStateNormal];
    [button addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    _rightButton = button;
}

// 设置导航条背景图片
- (void)setNavigationBarWithImageKey:(NSString *)imageKey{
    if (IOS_VERSION < 7.0) {
        self.bgImage = [[UIImage imageNamed:imageKey] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        self.backgroundColor = [UIColor colorWithPatternImage:self.bgImage];
    } else {
        self.backgroundColor = [MIUtility colorWithHex:0xffa000];
    }

    [self setNeedsDisplay];
}

- (void)clearNavigationBarImage{
    self.bgImage = nil;
}

- (void)dropShadowWithOffset:(CGSize)offset
                      radius:(CGFloat)radius
                       color:(UIColor *)color
                     opacity:(CGFloat)opacity
{
    // Creating shadow path for better performance
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, self.bounds);
    self.layer.shadowPath = path;
    CGPathCloseSubpath(path);
    CGPathRelease(path);
    
    self.layer.shadowColor = color.CGColor;
    self.layer.shadowOffset = offset;
    self.layer.shadowRadius = radius;
    self.layer.shadowOpacity = opacity;
}

- (void)drawRect:(CGRect)rect {
    if (self.bgImage == nil) {
        [super drawRect:rect];
    } else {
        [self.bgImage drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        self.backgroundColor = [UIColor colorWithPatternImage:self.bgImage];
    }
    
    if (IOS_VERSION < 7.0) {
        [self drawRoundedCorner:CGPointMake(0, 0) withRadius:5 withTransformation:CGAffineTransformMakeRotation(0)];
        [self drawRoundedCorner:CGPointMake(0, -self.frame.size.width) withRadius:5 withTransformation:CGAffineTransformMakeRotation((90) * M_PI/180)];
    }
}

// 绘制圆角
- (void) drawRoundedCorner: (CGPoint)point withRadius:(CGFloat)radius withTransformation:(CGAffineTransform)transform {
    // create the path. has to be done this way to allow use of the transform
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, &transform, point.x, point.y);
    CGPathAddLineToPoint(path, &transform, point.x, point.y + radius);
    CGPathAddArc(path, &transform, point.x + radius, point.y + radius, radius, (180) * M_PI/180, (-90) * M_PI/180, 0);
    CGPathAddLineToPoint(path, &transform, point.x, point.y);
    
    // fill the path to create the illusion that the corner is rounded
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextAddPath(context, path);
    CGContextSetFillColorWithColor(context, [[UIColor blackColor] CGColor]);
    CGContextFillPath(context);
    
    // appropriate memory management
    CGPathRelease(path);
}

@end
