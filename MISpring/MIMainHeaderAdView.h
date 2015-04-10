//
//  MIMainHeaderAdView.h
//  MISpring
//
//  Created by husor on 15-3-24.
//  Copyright (c) 2015年 Husor Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MIMainHeaderAdView : UIView
{
        NSInteger   _imageHeight;
}
@property (nonatomic, strong) NSArray *adsArray;
@property (nonatomic, strong) NSString *eventType;

- (void)loadData:(NSArray *)dataArray;
@end
