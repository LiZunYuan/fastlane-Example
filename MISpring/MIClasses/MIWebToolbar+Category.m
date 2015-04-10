//
//  MIWebToolbar+Category.m
//  MISpring
//
//  Created by Yujian Xu on 13-6-26.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIWebToolbar+Category.h"


@implementation MIWebToolbar (Category)


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
