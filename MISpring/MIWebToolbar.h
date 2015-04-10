//
//  MIWebToolbar.h
//  MISpring
//
//  Created by weihao on 14-12-1.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MIWebToolbar : UIToolbar

- (UIBarButtonItem*)itemWithTag:(NSInteger)tag;

- (void)replaceItemWithTag:(NSInteger)tag withItem:(UIBarButtonItem*)item;

@end
