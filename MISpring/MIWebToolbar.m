//
//  MIWebToolbar.m
//  MISpring
//
//  Created by weihao on 14-12-1.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MIWebToolbar.h"

@implementation MIWebToolbar

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void) drawRect:(CGRect)rect
{
}

- (id)initWithFrame:(CGRect)aRect {
    if ((self = [super initWithFrame:aRect])) {
        self.opaque = NO;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.75];
        self.clearsContextBeforeDrawing = YES;
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIBarButtonItem*)itemWithTag:(NSInteger)tag {
    for (UIBarButtonItem* button in self.items) {
        if (button.tag == tag) {
            return button;
        }
    }
    return nil;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)replaceItemWithTag:(NSInteger)tag withItem:(UIBarButtonItem*)item {
    NSInteger buttonIndex = 0;
    for (UIBarButtonItem* button in self.items) {
        if (button.tag == tag) {
            NSMutableArray* newItems = [NSMutableArray arrayWithArray:self.items];
            [newItems replaceObjectAtIndex:buttonIndex withObject:item];
            self.items = newItems;
            break;
        }
        ++buttonIndex;
    }
}



@end
