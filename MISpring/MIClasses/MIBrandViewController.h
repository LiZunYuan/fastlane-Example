//
//  MIBrandViewController.h
//  MISpring
//
//  Created by 曲俊囡 on 13-12-6.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIBaseViewController.h"
#import "MITuanBrandDetailGetRequest.h"
#import "MITuanBrandDetailGetModel.h"
#import "MIBrandRecModel.h"
#import "MIUserFavorBrandAddRequest.h"
#import "MIUserFavorBrandDeleteRequest.h"
#import "MIUserFavorBrandAddModel.h"
#import "MIUserFavorBrandDeleteModel.h"

@interface MIBrandViewController : MIBaseViewController
{
    NSInteger _pageSize;
    BOOL _hasMore;
}
@property (nonatomic, strong) MITuanBrandDetailGetRequest *request;
@property (nonatomic, strong) MITuanBrandDetailGetModel *brandModel;
@property (nonatomic, strong) MIUserFavorBrandAddRequest *brandAddRequest;
@property (nonatomic, strong) MIUserFavorBrandDeleteRequest *brandDeleteRequest;

@property (nonatomic, strong) NSMutableArray *tuanArray;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSString *numIid;
@property (nonatomic, copy) NSString *cat;
@property (nonatomic, assign) NSInteger aid;
@property (nonatomic, assign) NSInteger origin;
@property (nonatomic, assign) CGFloat lastscrollViewOffset;
@property (nonatomic, strong) NSMutableArray *brandFavorArray;
@property (nonatomic, assign) double startTime;

- (id)initWithAid:(NSInteger)aid;

@end
