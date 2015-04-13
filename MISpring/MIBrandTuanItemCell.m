//
//  MIBrandTuanItemCell.m
//  MISpring
//
//  Created by husor on 14-12-12.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MIBrandTuanItemCell.h"

#define BrandTuanCellItemWidth  (SCREEN_WIDTH * 148 / 320)


@implementation MIBrandTuanItemCell

@synthesize itemView1;
@synthesize itemView2;

-(id)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        itemView1 = [[MIBrandTuanItemView alloc] initWithFrame:CGRectMake(8, 8, BrandTuanCellItemWidth, BrandTuanCellItemWidth + 40)];
        [self addSubview: itemView1];
        
        itemView2 = [[MIBrandTuanItemView alloc] initWithFrame:CGRectMake(itemView1.right + 8, itemView1.top, itemView1.viewWidth, itemView1.viewHeight)];
        [self addSubview: itemView2];
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
