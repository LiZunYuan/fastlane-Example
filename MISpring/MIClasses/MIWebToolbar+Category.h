//
//  MIWebToolbar+Category.h
//  MISpring
//
//  Created by Yujian Xu on 13-6-26.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIWebToolbar.h"

@interface MIWebToolbar (Category)

- (UIBarButtonItem*)itemWithTag:(NSInteger)tag;

- (void)replaceItemWithTag:(NSInteger)tag withItem:(UIBarButtonItem*)item;

@end