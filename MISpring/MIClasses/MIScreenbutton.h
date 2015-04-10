//
//  MIScreenbutton.h
//  MISpring
//
//  Created by 曲俊囡 on 14-5-16.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MIScreenbutton : UIButton

@property (nonatomic, strong) NSString *catId;
@property (nonatomic, strong) NSString *catName;
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, strong) UIView *line;

- (void)reLoadButton;

@end
