//
//  MIDeleteUILabel.m
//  MISpring
//
//  Created by lsave on 13-3-20.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIDeleteUILabel.h"

@implementation MIDeleteUILabel

@synthesize strikeThroughEnabled = _strikeThroughEnabled;

- (void)drawTextInRect:(CGRect)rect{
    [super drawTextInRect:rect];
    
    CGSize textSize = [[self text] sizeWithFont:[self font]];
    CGFloat strikeWidth = textSize.width + 2;
    CGRect lineRect;
    
    if ([self textAlignment] == UITextAlignmentRight) {
        lineRect = CGRectMake(rect.size.width - strikeWidth, rect.size.height/2, strikeWidth, 0.6);
    } else if ([self textAlignment] == UITextAlignmentCenter) {
        lineRect = CGRectMake(rect.size.width/2 - strikeWidth/2, rect.size.height/2, strikeWidth, 0.6);
    } else {
        lineRect = CGRectMake(0, rect.size.height/2, strikeWidth, 0.6);
    }
    
    if (_strikeThroughEnabled) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetRGBFillColor(context, 0.5, 0.5, 0.5, 0.75);
        CGContextFillRect(context, lineRect);
    }
}

- (void)setStrikeThroughEnabled:(BOOL)strikeThroughEnabled {
    
    _strikeThroughEnabled = strikeThroughEnabled;
    
    NSString *tempText = [self.text copy];
    self.text = @"";
    self.text = tempText;
}

@end
