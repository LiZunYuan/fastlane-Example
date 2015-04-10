//
//  MITomorrowBrandItemView.h
//  MISpring
//
//  Created by husor on 14-12-18.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MIBrandItemModel.h"

@interface MITomorrowBrandItemView : UIButton

@property (nonatomic,strong)UIImageView *brandLogo;// 品牌logo
@property (nonatomic,strong)UILabel *brandTitle;//品牌专场名
@property (nonatomic,strong)UILabel *discountLabel;//折扣
@property (nonatomic,strong)UIView *line;
@property (nonatomic,strong)UIImageView *itemImgView;
@property (nonatomic,strong)MIBrandItemModel *brandModel;
@property (nonatomic,strong)UILabel *tipLabel;

- (void)actionClicked:(id)sender;

@end
