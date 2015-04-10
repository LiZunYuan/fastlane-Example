//
//  MIFunctionViewController.h
//  MISpring
//
//  Created by Yujian Xu on 13-6-26.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIBaseViewController.h"

@interface MIFunctionViewController : MIBaseViewController<UIScrollViewDelegate>
{
    UIScrollView *_scrollView;
}

@property (nonatomic, strong) NSMutableArray *pics;

@end
