//
//  MITaskDetailCell.m
//  MISpring
//
//  Created by 曲俊囡 on 14-5-26.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MITaskDetailCell.h"

@implementation MITaskDetailCell

- (void)awakeFromNib
{
    // Initialization code
    self.bgView.layer.cornerRadius = 4;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
