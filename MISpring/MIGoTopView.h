//
//  MIGoTopView.h
//  MISpring
//
//  Created by yujian on 14-12-29.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MIGoTopViewDelegate <NSObject>

- (void)goTopViewClicked;

@end

@interface MIGoTopView : UIView

@property (nonatomic, weak) id<MIGoTopViewDelegate> delegate;

@end
