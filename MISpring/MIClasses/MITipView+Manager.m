//
//  MITipView+Manager.m
//  MiZheHD
//
//  Created by 遇 见 on 8/16/13.
//  Copyright 2013 Husor Inc. All rights reserved.
//

#import "MITipView+Manager.h"

#define IS_SHOW_CONTENTOPERATE_TIP @"IS_SHOW_CONTENTOPERATE_TIP"
#define IS_SHOW_MELIST_TIP @"IS_SHOW_MELIST_TIP"

@implementation MITipView (Manager)

// 显示最右栏内容区提示
+ (void)showContentOperateTipInView:(UIView *)inView tipKey:(NSString *)tip imgKey:(NSString *)img type:(MITipType)type{
    NSUserDefaults * standardUserDefaults = [NSUserDefaults standardUserDefaults];

    NSString *tipValue = [standardUserDefaults objectForKey:tip];
    if ([standardUserDefaults boolForKey:tip] || (tipValue && [tip isEqualToString:tipValue])) {
        return;
    }
    
    [standardUserDefaults setObject:tip forKey:tip];
    [standardUserDefaults synchronize];

    UIImage *tipImage = [UIImage imageNamed:img];
    float imgViewWidth = tipImage.size.width;
    float imgViewHeight = tipImage.size.height;
    CGRect inRect = CGRectMake((CGRectGetWidth(inView.bounds) - imgViewWidth)/2,
                               (CGRectGetHeight(inView.bounds) - imgViewHeight)/2,
                               imgViewWidth,
                               imgViewHeight);
    
    [MITipView showTipWithType:type useImage:tipImage atRect:inRect inView:inView];
}

+ (void)showAlertTipWithKey:(NSString *)tip message:(NSString *)msg
{
    NSUserDefaults * standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSString *tipValue = [standardUserDefaults objectForKey:tip];
    if ([standardUserDefaults boolForKey:tip] || (tipValue && [tip isEqualToString:tipValue])) {
        return;
    }
    
    [standardUserDefaults setObject:tip forKey:tip];
    [standardUserDefaults synchronize];

    MIButtonItem *affirmItem = [MIButtonItem itemWithLabel:@"知道了"];
    affirmItem.action = nil;
    
    UIAlertView *alertTip = [[UIAlertView alloc] initWithTitle:@"升级说明"
                                                              message:msg
                                                     cancelButtonItem:nil
                                                     otherButtonItems:affirmItem, nil];
    [alertTip show];
}

@end
