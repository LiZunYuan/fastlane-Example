//
//  UIAlertView+Blocks.h
//  Shibui
//
//  Created by Jiva DeVoe on 12/28/10.
//  Copyright 2010 Random Ideas, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MIButtonItem.h"

typedef void (^onAction)();

@interface UIAlertView (Blocks)

-(id)initWithTitle:(NSString *)inTitle message:(NSString *)inMessage cancelButtonItem:(MIButtonItem *)inCancelButtonItem otherButtonItems:(MIButtonItem *)inOtherButtonItems, ... NS_REQUIRES_NIL_TERMINATION;
-(id)initWithLoginAction:(onAction)action;
-(id)initWithLoginRebateAction:(onAction)action;
-(id)initWithMessage:(NSString *)message;
-(id)initWithGradeViewController:(UIViewController *)viewController;

//- (NSInteger)addButtonItem:(MIButtonItem *)item;

@end
