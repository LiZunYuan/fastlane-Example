//
//  MIMyOrderViewController.h
//  MISpring
//
//  Created by 徐 裕健 on 14/10/21.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MISegmentView.h"

@interface MIMyOrderViewController : MIWebViewController<MISegmentViewDelegate>

@property(nonatomic, strong) MISegmentView *segmentView;

@end
