//
//  MITeachingsViewController.h
//  MISpring
//
//  Created by Yujian Xu on 13-4-14.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIBaseViewController.h"

@interface MITeachingsViewController : MIBaseViewController<UIScrollViewDelegate>
{
    UIScrollView *_scrollView;
}

@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSMutableArray *pics;

@end
