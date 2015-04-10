//
//  UIAlertView+Blocks.m
//  Shibui
//
//  Created by Jiva DeVoe on 12/28/10.
//  Copyright 2010 Random Ideas, LLC. All rights reserved.
//

#import "UIAlertView+Blocks.h"
#import "MIFeedbackViewController.h"
#import <objc/runtime.h>

static NSString *MI_BUTTON_ASS_KEY = @"com.mizhe.BUTTONS";

@implementation UIAlertView (Blocks)

-(id)initWithTitle:(NSString *)inTitle message:(NSString *)inMessage cancelButtonItem:(MIButtonItem *)inCancelButtonItem otherButtonItems:(MIButtonItem *)inOtherButtonItems, ... 
{
    if((self = [self initWithTitle:inTitle message:inMessage delegate:self cancelButtonTitle:inCancelButtonItem.label otherButtonTitles:nil]))
    {
        NSMutableArray *buttonsArray = [NSMutableArray array];
        
        MIButtonItem *eachItem;
        va_list argumentList;
        if (inOtherButtonItems)                     
        {                                  
            [buttonsArray addObject: inOtherButtonItems];
            va_start(argumentList, inOtherButtonItems);       
            while((eachItem = va_arg(argumentList, MIButtonItem *))) 
            {
                [buttonsArray addObject: eachItem];            
            }
            va_end(argumentList);
        }    
        
        for(MIButtonItem *item in buttonsArray)
        {
            [self addButtonWithTitle:item.label];
        }
        
        if(inCancelButtonItem)
            [buttonsArray insertObject:inCancelButtonItem atIndex:0];
        
        objc_setAssociatedObject(self, (__bridge const void *)MI_BUTTON_ASS_KEY, buttonsArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        [self setDelegate:self];
    }
    return self;
}

-(id)initWithLoginRebateAction:(onAction)action
{
    MIButtonItem *cancelItem = [MIButtonItem itemWithLabel:@"跳过"];
    cancelItem.action = action;
    MIButtonItem *affirmItem = [MIButtonItem itemWithLabel:@"登录"];
    affirmItem.action = ^{
        [MINavigator openLoginViewController];
    };

    return [self initWithTitle:@"提示" message:@"亲，登录后去购物才有返利哦~" cancelButtonItem:cancelItem otherButtonItems:affirmItem, nil];
}

-(id)initWithLoginAction:(onAction)action
{
    MIButtonItem *cancelItem = [MIButtonItem itemWithLabel:@"跳过"];
    cancelItem.action = action;
    MIButtonItem *affirmItem = [MIButtonItem itemWithLabel:@"登录"];
    affirmItem.action = ^{
        [MINavigator openLoginViewController];
    };
    
    return [self initWithTitle:@"提示" message:@"亲，请先登录哦~" cancelButtonItem:cancelItem otherButtonItems:affirmItem, nil];
}

-(id)initWithMessage:(NSString *)message
{
    MIButtonItem *affirmItem = [MIButtonItem itemWithLabel:@"确定"];
    affirmItem.action = nil;
    
    return [self initWithTitle:@"提示" message:message cancelButtonItem:nil otherButtonItems:affirmItem, nil];
}

-(id)initWithGradeViewController:(UIViewController *)viewController
{
    MIButtonItem *cancelItem = [MIButtonItem itemWithLabel:@"残忍地拒绝"];
    cancelItem.action = ^{
        [MobClick event:kAppReviewed label:@"拒绝"];
    };
    MIButtonItem *goodItem = [MIButtonItem itemWithLabel:@"喜欢，好评表白一下！"];
    goodItem.action = ^{
        [MobClick event:kAppReviewed label:@"喜欢"];

        if (IOS_VERSION >= 7) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[MIConfig globalConfig].appStoreURL]];
        } else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[MIConfig globalConfig].appStoreReviewURL]];
        }
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:[NSString stringWithFormat:@"shouldShowGradeAlertView%@",
                                                                  [MIConfig globalConfig].version]];
        [[NSUserDefaults standardUserDefaults] synchronize];
    };
    MIButtonItem *badItem = [MIButtonItem itemWithLabel:@"不喜欢，告诉米姑娘！"];
    badItem.action = ^{
        [MobClick event:kAppReviewed label:@"不喜欢"];

        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:[NSString stringWithFormat:@"shouldShowGradeAlertView%@",
                                                                  [MIConfig globalConfig].version]];
        [[NSUserDefaults standardUserDefaults] synchronize];
        MIFeedbackViewController *vc = [[MIFeedbackViewController alloc] init];
        [[MINavigator navigator] openPushViewController:vc animated:YES];
    };


    return [self initWithTitle:@"喜欢米折吗？" message:nil cancelButtonItem:cancelItem otherButtonItems:goodItem, badItem, nil];
}
//- (NSInteger)addButtonItem:(MIButtonItem *)item
//{	
//    NSMutableArray *buttonsArray = objc_getAssociatedObject(self, (__bridge const void *)MI_BUTTON_ASS_KEY);	
//	
//	NSInteger buttonIndex = [self addButtonWithTitle:item.label];
//	[buttonsArray addObject:item];
//	
//	return buttonIndex;
//}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // If the button index is -1 it means we were dismissed with no selection
    if (buttonIndex >= 0)
    {
        NSArray *buttonsArray = objc_getAssociatedObject(self, (__bridge const void *)MI_BUTTON_ASS_KEY);
        MIButtonItem *item = [buttonsArray objectAtIndex:buttonIndex];
        if(item.action)
            item.action();
    }
    
    objc_setAssociatedObject(self, (__bridge const void *)MI_BUTTON_ASS_KEY, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
