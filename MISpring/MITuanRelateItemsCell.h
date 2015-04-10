//
//  ;
//  MISpring
//
//  Created by yujian on 14-12-17.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSInteger
{
    TuanItemType,
    BrandItemType,
}TuanBrandType;

@interface MITuanRelateItemsCell : UITableViewCell

@property(nonatomic, strong) NSArray * tuanItems;
@property(nonatomic, strong) NSMutableArray * images;
@property(nonatomic, strong) NSMutableArray * prices;
@property(nonatomic, strong) NSMutableArray * priceOris;
@property(nonatomic, strong) NSMutableArray * temaiImages;
@property(nonatomic, assign) TuanBrandType type;
@property(nonatomic, strong) UILabel *titleLabel;

- (id) initWithReuseIdentifier:(NSString *)reuseIdentifier;

@end
