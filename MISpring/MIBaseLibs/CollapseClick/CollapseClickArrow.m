//
//  CollapseClickIcon.m
//  CollapseClick
//
//  Created by Ben Gordon on 3/17/13.
//  Copyright (c) 2013 Ben Gordon. All rights reserved.
//

#import "CollapseClickArrow.h"

@implementation CollapseClickArrow

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.arrowColor = [UIColor whiteColor];
        [self setBackgroundColor:[UIColor redColor]];
    }
    return self;
}

-(void)drawWithColor:(UIColor *)color {
    self.arrowColor = color;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    UIBezierPath *arrow = [UIBezierPath bezierPath];
    [self.arrowColor setFill];
//    arrow to right
//    [arrow moveToPoint:CGPointMake(self.frame.size.width, self.frame.size.height/2)];
//    [arrow addLineToPoint:CGPointMake(0, self.frame.size.height)];
//    [arrow addLineToPoint:CGPointMake(0, 0)];
//    [arrow addLineToPoint:CGPointMake(self.frame.size.width, self.frame.size.height/2)];
//    complex arrow to right
//    [arrow moveToPoint:CGPointMake(self.frame.size.width * 0.2, self.frame.size.height * 0.2)];
//    [arrow addLineToPoint:CGPointMake(self.frame.size.width * 0.4, 0)];
//    [arrow addLineToPoint:CGPointMake(self.frame.size.width * 0.8, self.frame.size.height / 2)];
//    [arrow addLineToPoint:CGPointMake(self.frame.size.width * 0.4, self.frame.size.height)];
//    [arrow addLineToPoint:CGPointMake(self.frame.size.width * 0.2, self.frame.size.height * 0.8)];
//    [arrow addLineToPoint:CGPointMake(self.frame.size.width * 0.4, self.frame.size.height/2)];
    
    [arrow moveToPoint:CGPointMake(0, 0)];
    [arrow addLineToPoint:CGPointMake(self.frame.size.width, 0)];
    [arrow addLineToPoint:CGPointMake(self.frame.size.width * 0.5, self.frame.size.height)];
    [arrow addLineToPoint:CGPointMake(0, 0)];
    
    [arrow fill];
}


@end
