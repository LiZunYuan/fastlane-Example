//
//  MITaobaoTutorialsViewController.h
//  MISpring
//
//  Created by Yujian Xu on 13-6-22.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIBaseViewController.h"

@interface MITaobaoTutorialsViewController : MIBaseViewController<UIScrollViewDelegate>
{
    UIScrollView *_scrollView;
}

@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSMutableArray *pics;

@end
