//
//  MIScreenSelectedDelegate.h
//  MISpring
//
//  Created by 曲俊囡 on 14-7-17.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MIScreenSelectedDelegate <NSObject>

@optional
//- (void)selectedCatId:(NSString *)catId catName:(NSString *)catName;
- (void)selectedIndex:(NSInteger)index;
- (void)selectedSelf;

@end
