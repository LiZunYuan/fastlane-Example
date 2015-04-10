//
//  MITomorrowViewController.h
//  MISpring
//
//  Created by 曲俊囡 on 14-6-17.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MIBaseViewController.h"
#import "MITuanSegmentView.h"



typedef enum _Tuan_Tab_Index{
    TUAN_TAB_TEN = 0,
    TUAN_TAB_YOUPIN,
    TUAN_TAB_BRAND,
} TuanTabIndex;

@interface MITomorrowViewController : MIBaseViewController
<MITuanSegmentViewDelegate>
{
    MITuanSegmentView *_segmentView;
}

@property (nonatomic, strong) MITuanSegmentView *segmentView;
@property (nonatomic, assign) NSInteger currentIndex;


@end
