//
//  MIBrandItemView.h
//  MISpring
//
//  Created by husor on 14-12-12.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MIBrandItemModel.h"
//#import "MIFavorDeleteView.h"

@interface MIBrandTuanItemView : UIButton

@property (nonatomic, assign) BOOL isEditing;
//@property (nonatomic, strong) MIFavorDeleteView *deleteView;
//@property (nonatomic, strong) UIImageView *emptyBacImageView;
//@property (nonatomic, strong) UILabel *tipLabel;

@property (nonatomic,strong)UIImageView *brandLogo;// 品牌logo
@property (nonatomic,strong)UILabel *brandTitle;//品牌专场名
@property (nonatomic,strong)UILabel *discountLabel;//折扣
@property (nonatomic,strong)UIImageView *itemImgView;
@property (nonatomic,strong)MIBrandItemModel *brandModel;
@property (nonatomic,strong)UIImageView *temaiImgView;

- (void)actionClicked:(id)sender;
@end
