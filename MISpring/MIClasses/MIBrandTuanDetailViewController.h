//
//  MIBrandTuanDetailViewController.h
//  MISpring
//
//  Created by 曲俊囡 on 13-12-6.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIBaseViewController.h"
#import "MIItemModel.h"
#import "MITemaiDetailGetRequest.h"
#import "MIUserFavorItemAddRequest.h"
#import "MIUserFavorItemAddModel.h"
#import "MIUserFavorItemDeleteRequest.h"
#import "MIUserFavorItemDeleteModel.h"
#import "MIUserFavorViewController.h"


@interface MIBrandTuanDetailViewController : MIBaseViewController

@property (nonatomic, strong) MIItemModel *item;
@property (nonatomic, copy) NSString *iid;
@property (nonatomic, copy) NSString *cat;
@property (nonatomic, strong) MITemaiDetailGetRequest *request;

@property (nonatomic, strong) UIImage *placeholderImage;
@property (nonatomic, strong) NSArray *recommendArray;
@property (nonatomic, copy) NSString *brandDes;

@property(nonatomic, strong) UIView *bgView1;
@property(nonatomic, strong) UIView *bottomToolBar;
@property(nonatomic, strong) UILabel *leftTimeLabel;
@property(nonatomic,strong) RTLabel *customerLabel;
@property(nonatomic, strong) NSTimer *itemTimer;
@property(nonatomic,strong) RTLabel *customerLabel2;
@property(nonatomic,strong)UILabel *PurchaseLabel;
@property(nonatomic, strong) NSNumber *startTime;


- (id) initWithItem: (MIItemModel *) model placeholderImage:(UIImage *)placeholder;
-(void)startTimer;
-(void)stopTimer;

@end
