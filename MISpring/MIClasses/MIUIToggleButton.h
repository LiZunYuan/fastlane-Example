//
//  MIUIToggleButton.h
//  MISpring
//
//  Created by lsave on 13-3-22.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MIUIToggleButton : UIButton

@property(nonatomic, strong) NSString * group;
@property(nonatomic, strong) NSString * value;

-(void) setGroup:(NSString *)group andValue: (NSString *) value;

@end
