//
//  MITuanDetailViewController.h
//  MISpring
//
//  Created by 徐 裕健 on 13-10-30.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIBaseViewController.h"
#import "MITemaiDetailGetRequest.h"
#import "MITemaiDetailGetModel.h"
#import "MITuanItemModel.h"
#import "MIAppDelegate.h"
#import "MIUserFavorItemAddRequest.h"
#import "MIUserFavorItemAddModel.h"
#import "MIUserFavorItemDeleteRequest.h"
#import "MIUserFavorItemDeleteModel.h"
#import "MIUserFavorViewController.h"


@interface MITuanDetailViewController : MIBaseViewController

@property(nonatomic, copy) NSString *iid;
@property(nonatomic, copy) NSString *cat;
@property(nonatomic, strong) UIImage *placeholderImage;
@property(nonatomic, strong) NSString *shuoStr;
@property(nonatomic, strong) NSArray *relatesArr;
@property(nonatomic, strong) MITuanItemModel *item;
@property(nonatomic, strong) MITemaiDetailGetRequest *detailGetRequest;
@property(nonatomic, strong) UIView *bgView1;
@property(nonatomic, strong) UIView *bottomToolBar;
@property(nonatomic, strong) UILabel *leftTimeLabel;
@property(nonatomic,strong) RTLabel *customerLabel;
@property(nonatomic, strong) NSTimer *itemTimer;
@property(nonatomic,strong) RTLabel *customerLabel2;
@property(nonatomic,strong) UILabel *PurchaseLabel;
@property(nonatomic, strong) NSNumber *startTime;

- (id) initWithItem: (MITuanItemModel *) model placeholderImage:(UIImage *)placeholder;
-(void)startTimer;
-(void)stopTimer;

@end
