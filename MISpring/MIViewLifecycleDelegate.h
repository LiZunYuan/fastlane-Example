//
//  MIViewLifecycleDelegate.h
//  MISpring
//
//  Created by yujian on 14-12-11.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MIViewLifecycleDelegate <NSObject>

@optional

- (void)willAppearView;
- (void)willDisappearView;
- (void)didAppearView;
- (void)didDisappearView;

@end
