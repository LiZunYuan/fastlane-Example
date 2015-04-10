//
//  MITuanItemsCell.m
//  MISpring
//
//  Created by 曲俊囡 on 14-5-14.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MITuanItemsCell.h"

@implementation MITuanItemsCell

@synthesize itemView1;
@synthesize itemView2;

- (id) initWithreuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        itemView1 = [[MITuanItemView alloc] initWithFrame:CGRectMake(8, 8, 148, 196)];
        [self addSubview: itemView1];
        
        itemView2 = [[MITuanItemView alloc] initWithFrame:CGRectMake(itemView1.right + 8, itemView1.top, itemView1.viewWidth, itemView1.viewHeight)];
        [self addSubview: itemView2];
    }
    
    return self;
}

@end
