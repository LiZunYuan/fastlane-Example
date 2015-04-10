//
//  MILimitTuanViewController.h
//  MISpring
//
//  Created by husor on 15-3-30.
//  Copyright (c) 2015年 Husor Inc. All rights reserved.
//

#import "MIBaseViewController.h"
#import "MITuanActivityGetRequest.h"

@interface MILimitTuanViewController : MIBaseViewController
@property (nonatomic, strong)UIImageView *countDownImg;
@property (nonatomic, strong)UILabel *countDownTipLabel;
@property (nonatomic, strong)UILabel *countDownLabel;
@property (nonatomic, strong)UIScrollView *scrollView;
@property (nonatomic, strong)UIPageControl *pageControl;
@property (nonatomic, strong)MITuanActivityGetRequest *request;
@property (nonatomic, strong)NSString *data;
@property (nonatomic, strong) NSMutableArray *modelArray;
@property (nonatomic, strong) NSTimer *limitTimer;
@property (nonatomic, strong) NSNumber *startTime;
@property (nonatomic, strong) NSNumber *endTime;
@end
