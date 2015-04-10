//
//  MIViewControllerWapper.h
//  MISpring
//
//  Created by husor on 15-1-22.
//  Copyright (c) 2015年 Husor Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MIViewControllerWapper : UIView
@property (nonatomic, strong) MIBaseViewController *viewController;
@property (nonatomic, assign) BOOL hadLoaded;
-(void) load;
@end
