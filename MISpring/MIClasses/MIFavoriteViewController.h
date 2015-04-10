//
//  MIFavoriteViewController.h
//  MISpring
//
//  Created by 曲俊囡 on 14-5-14.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MIBaseViewController.h"
#import "MIMallUpdateRequest.h"

@class MGBox, MGScrollView;

@interface MIFavoriteViewController : MIBaseViewController<UIGestureRecognizerDelegate, UIScrollViewDelegate>
{
    BOOL _isEditing;
}

@property (nonatomic, assign) BOOL isEditing;
@property (nonatomic, strong) UIButton *editBtn;
@property (nonatomic, strong) MGScrollView *scroller;
@property (nonatomic, strong) MGBox *favsGrid;
@property (nonatomic, strong) MIMallUpdateRequest *updateMallRequest;
@property (nonatomic, strong) NSMutableArray *favsArray;


@end
