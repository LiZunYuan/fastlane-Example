//
//  MINavigationBar.m
//  MISpring
//
//  Created by Yujian Xu on 13-3-11.
//  Copyright (c) 2013年 Husor Inc.. All rights reserved.
//

#import "MINavigationBar.h"
#import "MIUtility.h"

@implementation UINavigationBar (UINavigationBarCategory)

// 这里由类别改成继承方式，主要是在5.0以下版本，调用短信，邮件等系统界面时，需在调用原来的绘制方法，
// 但是类别实现不能满足这一需求，所以改为继承，这里重写此方法实现
+ (Class)class
{
    return NSClassFromString(@"MINavigationBar");
}

@end

@implementation MINavigationBar
@synthesize bgImage = _bgImage;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		self.barStyle = UIBarStyleBlack;        
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];

    if (self.bgImage != nil) {
        [self.bgImage drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        self.tintColor = [UIColor colorWithPatternImage:self.bgImage];
    }
    
//    [self drawRoundedCorner:CGPointMake(0, 0) withRadius:5 withTransformation:CGAffineTransformMakeRotation(0)];
//    [self drawRoundedCorner:CGPointMake(0, -self.frame.size.width) withRadius:5 withTransformation:CGAffineTransformMakeRotation((90) * M_PI/180)];

}
//
//
//
//// 绘制圆角
//- (void) drawRoundedCorner: (CGPoint)point withRadius:(CGFloat)radius withTransformation:(CGAffineTransform)transform {
//    // create the path. has to be done this way to allow use of the transform
//    CGMutablePathRef path = CGPathCreateMutable();
//    CGPathMoveToPoint(path, &transform, point.x, point.y);
//    CGPathAddLineToPoint(path, &transform, point.x, point.y + radius);
//    CGPathAddArc(path, &transform, point.x + radius, point.y + radius, radius, (180) * M_PI/180, (-90) * M_PI/180, 0);
//    CGPathAddLineToPoint(path, &transform, point.x, point.y);
//    
//    // fill the path to create the illusion that the corner is rounded
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextAddPath(context, path);
//    CGContextSetFillColorWithColor(context, [[UIColor blackColor] CGColor]);
//    CGContextFillPath(context);
//    
//    // appropriate memory management
//    CGPathRelease(path);
//}

// 设置导航条背景图片
- (void)setNavigationBarWithImageKey:(NSString *)imageKey{
    if (imageKey) {
        self.bgImage = [[UIImage imageNamed:imageKey] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        [self setNeedsDisplay];
    }
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

    // Default clipsToBounds is YES, will clip off the shadow, so we disable it.
    self.clipsToBounds = NO;
}

// 设置导航条标题
- (void)setNaviTitle: (NSString *) title textSize:(CGFloat) size
{
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    titleLabel.shadowOffset = CGSizeMake(0, -1);
    titleLabel.font = [UIFont boldSystemFontOfSize:size];
    titleLabel.text = title;
    titleLabel.textColor = [UIColor whiteColor];
    [titleLabel sizeToFit];

    self.topItem.titleView = titleLabel;
    self.topItem.titleView.alpha = 0;

    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration: 0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];

    self.topItem.titleView.alpha = 1;
    [UIView commitAnimations];
}

@end
