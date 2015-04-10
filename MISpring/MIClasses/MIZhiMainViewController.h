//
//  MICategoryViewController.h
//  MISpring
//
//  Created by XU YUJIAN on 13-1-25.
//  Copyright (c) 2013年 Husor Inc.. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "MIZhiItemsGetRequest.h"
#import "MIScreenView.h"
#import "MIZhiHotGetRequest.h"
#import "MIZhiActivitiesGetRequest.h"
#import "MIScreenSelectedDelegate.h"
#import "SVTopScrollView.h"


@interface MIZhiMainViewController : MIBaseViewController<MIScreenSelectedDelegate>{
    BOOL _hasMore;
    BOOL _isShowScreen;

    NSInteger _currentIndex;
    NSString *_tag;
}
@property (nonatomic, assign) BOOL hasMore;
@property (nonatomic, strong) MIScreenView *screenView;
@property (nonatomic, strong) UIView *shadowView;
@property (nonatomic, strong) SVTopScrollView *topScrollView;

@property (nonatomic, strong) MIZhiItemsGetRequest *request;
@property (nonatomic, strong) MIZhiHotGetRequest *hotRequest;
@property (nonatomic, strong) MIZhiActivitiesGetRequest *activityRequest;
@property (nonatomic, strong) NSMutableArray *zhiItems;
@property (nonatomic, strong) NSMutableArray *datasCates;
@property (nonatomic, strong) NSMutableArray *datasCateIds;
@property (nonatomic, strong) NSMutableArray *datasCateNames;
@property (nonatomic, copy) NSString *cat;

@property (nonatomic, assign) CGFloat lastscrollViewOffset;
@property (nonatomic, strong) UIImageView *goTopImageView;

- (id)initWithTag:(NSString *)tag;

@end
