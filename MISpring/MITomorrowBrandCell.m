//
//  MITomorrowBrandCell.m
//  MISpring
//
//  Created by husor on 14-12-18.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MITomorrowBrandCell.h"

@implementation MITomorrowBrandCell

@synthesize itemView1;
@synthesize itemView2;

-(id)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        itemView1 = [[MITomorrowBrandItemView alloc] initWithFrame:CGRectMake(8, 8, (SCREEN_WIDTH - 24) / 2, 206)];
        [self addSubview: itemView1];
        
        itemView2 = [[MITomorrowBrandItemView alloc] initWithFrame:CGRectMake(itemView1.right + 8, itemView1.top, itemView1.viewWidth, itemView1.viewHeight)];
        [self addSubview: itemView2];
    }
    
    return self;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
