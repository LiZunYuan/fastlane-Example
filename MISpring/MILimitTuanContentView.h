//
//  MILimitTuanContentView.h
//  MISpring
//
//  Created by husor on 15-3-30.
//  Copyright (c) 2015年 Husor Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MIlimitTuanView.h"
#import "MITuanItemModel.h"
#import "MIHotRecommendView.h"

@interface MILimitTuanContentView : UIView
@property (nonatomic, strong)UIImageView *imageView;
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)MILimitTuanView *tuanView;
@property (nonatomic, strong)MITuanItemModel *model;

@end
