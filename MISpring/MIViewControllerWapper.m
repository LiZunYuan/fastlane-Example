//
//  MIViewControllerWapper.m
//  MISpring
//
//  Created by husor on 15-1-22.
//  Copyright (c) 2015年 Husor Inc. All rights reserved.
//

#import "MIViewControllerWapper.h"

@implementation MIViewControllerWapper

-(void)load
{
    if (self.hadLoaded == NO) {
        self.viewController.view.frame = self.bounds;
        [self addSubview:self.viewController.view];
    }
    else{
        [self.viewController viewWillAppear:YES];
        [self.viewController viewDidAppear:YES];
    }
    
    self.hadLoaded = YES;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
